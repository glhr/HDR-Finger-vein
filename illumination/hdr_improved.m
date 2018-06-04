clear all;
close all;

global background_filter_radius suppress_detail_thresh detailweight_filter_radius
global edge_width detail_thresh
background_filter_radius = [13 7];
detailweight_filter_radius = 4;
suppress_detail_thresh = [1 255];
edge_width = 1;
detail_thresh = 60;

metafile = {'img_evaltests/dataset4/segment4meta.png'};
[img_h,img_w] = size(imread( cell2mat(metafile)));


files = {
        'img_evaltests/dataset5/segment (1).png_cropped.png', ...
        'img_evaltests/dataset5/segment (5).png_cropped.png', ...
         'img_evaltests/dataset5/segment (10).png_cropped.png',...  
%         'img_evaltests/dataset5/segment (15).png_cropped.png',...
         %'img_evaltests/dataset1/segment_cropped (5).png'...
         }; 

exposure_min = 1;
exposure_max = 255;
expTimes = cell(1,numel(files));
expNormalized = cell(1,numel(files));
images = cell(1,numel(files));

figure;
montage(files);

%% gradient
% figure;
 path = cell2mat(files(1)); 
 img1 = imread(path);
  path = cell2mat(files(2)); 
 img2 = imread(path);
  path = cell2mat(files(3)); 
 img3 = imread(path);
% [Gmag, Gdir] = imgradient(img1,'prewitt');
% Gmag = uint8(255*mat2gray(Gmag));
% Gdir = uint8(255*mat2gray(Gdir));
% Gmag = imadjust(Gmag);
% Gdir = imadjust(Gdir);
% subplot(2,2,1),imshow(Gmag);
% subplot(2,2,2),imshow(Gdir);
% 
% [Gmag, Gdir] = imgradientxy(img1,'prewitt');
% Gmag = uint8(255*mat2gray(Gmag));
% Gdir = uint8(255*mat2gray(Gdir));
% Gmag = imadjust(Gmag);
% Gdir = imadjust(Gdir);
% subplot(2,2,3),imshow(Gmag);
% subplot(2,2,4),imshow(Gdir);

%% subtract illumination
%[veins_weight, veins_thresh] = subtractillumination(img1,2);

%% single scalar relative exposure value per image 

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path); 
    images{i} = img;
  %expTimes(i) = mean(img(:)); 
  %expTimes{i} = img;
  expTimes{i}=zeros(size(img));
  weight = double(img1);
  weightneg = double(imcomplement(img1));
  if(i == 1)
    %expTimes{i}= mean(img(:)).*weight; 
    expTimes{i}= weight.^2; 
  else
    %expTimes{i}= mean(img(:)).*weightneg; 
    expTimes{i}=  weightneg.^2; 
  end
  expNormalized{i} = expTimes{i}./expTimes{1}(1);
end 

%makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
rgb = hdr_custom(img1,images,expNormalized);
figure; 
subplot(3,1,1),imshow(rgb);
%imwrite(rgb,'img_evaltests/dataset5/hdrimproved.png');

%% single scalar relative exposure value per image 

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path); 
    images{i} = img;
  %expTimes(i) = mean(img(:)); 
  %expTimes{i} = img;
  expTimes{i}=zeros(size(img));
  weight = double(img1);
  weightneg = double(imcomplement(img1));
  if(i == 1)
    %expTimes{i}= mean(img(:)).*weight; 
    expTimes{i}= weight; 
  else
    %expTimes{i}= mean(img(:)).*weightneg; 
    expTimes{i}=  weightneg; 
  end
  expNormalized{i} = expTimes{i}./expTimes{1}(1);
end 

%hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
rgb = hdr_custom(img1,images,expNormalized);
subplot(3,1,2),imshow(rgb);
imwrite(rgb,'img_evaltests/dataset5/hdrimproved.png');

%% compare with multiplying img1 with itself
img116 = uint16(img1);
img216 = uint16(img2);
hdr2 = immultiply(img216,img116);
%rgb2 = uint16(255*mat2gray(hdr2));
subplot(3,1,3),imshow(hdr2);
%imwrite(hdr2,'img_evaltests/dataset5/hdrimproved.png');
 

function [output_weight, output_thresh] = subtractillumination(img,plot)
    global background_filter_radius suppress_detail_thresh detailweight_filter_radius
    global edge_width detail_thresh
    imgneg = uint8(255*mat2gray(imcomplement(img)));

    filter = fspecial('average', background_filter_radius);
    background_illum = imfilter(imgneg,filter,'replicate');
    output = imsubtract(imgneg,background_illum);
    output_eq = imadjust(output);    
    %output_eq(output_eq < 100) = 0;
    
    %remove saturated regions from detail map  
    output_eq(img < suppress_detail_thresh(1)) = 0;
    output_eq(img > suppress_detail_thresh(2)) = 0;
    output_eq(1:edge_width,:) = 0;
    output_eq((size(img,1)-edge_width):size(img,1),:) = 0;
    output_eq(:,1:edge_width) = 0;
    output_eq(:,(size(img,2)-edge_width):size(img,2)) = 0;
    
    filter2 = fspecial('average', detailweight_filter_radius);
    output_filtered = imfilter(output_eq,filter2,'replicate');
    
    output_weight = output_filtered;
    output_thresh = imadjust(uint8(output_filtered>detail_thresh));

    if(plot == 2) % plot everything
        figure;
        subplot(3,2,1),imshow(img,[0 255]); title(sprintf("Original image"));
        subplot(3,2,2),imshow(imgneg,[0 255]); title(sprintf("Negative image"));
        subplot(3,2,3),imshow(background_illum,[0 255]); title(sprintf("Background illumination estimated\n by applying average filter"));
        subplot(3,2,4),imshow(output_weight,[0 255]), title(sprintf("After subtracting background\n illumination from negative image"));
        subplot(3,2,5),imshow(output_filtered,[0 255]), title(sprintf("After averaging"));
        subplot(3,2,6),imshow(output_thresh,[0 255]), title(sprintf("After applying thresholding"));
    elseif(plot == 1) % only plot essentials
        figure;
        subplot(2,1,1),imshow(img,[0 255]);
        subplot(2,1,2),imshow(output_weight,[0 255]);
    end
    
end

function output = hdr_custom(img,images,expNormalized)
    hdr = zeros(size(img));
    for i = 1:numel(images) 
        hdr = hdr+(double(images{1}).*expNormalized{1});
    end
    hdr(hdr == Inf) = NaN;
    hdr(isnan(hdr)) = nanmax(hdr(:));
    %rgb = tonemap(hdr);
    output = uint8(255*mat2gray(hdr));
end