clear all;
close all;

metafile = {'img_evaltests/dataset5/segment4meta.png'};
[img_h,img_w] = size(imread( cell2mat(metafile)));

files = {
        'img_evaltests/dataset5/segment_cropped (23).png', ...
        'img_evaltests/dataset5/segment_cropped (22).png', ...
        'img_evaltests/dataset5/segment_cropped (21).png', ...
        'img_evaltests/dataset5/segment_cropped (20).png', ...
        'img_evaltests/dataset5/segment_cropped (19).png', ...
        'img_evaltests/dataset5/segment_cropped (18).png', ...
        'img_evaltests/dataset5/segment_cropped (17).png', ...
        'img_evaltests/dataset5/segment_cropped (16).png', ...
        'img_evaltests/dataset5/segment_cropped (15).png', ...
        'img_evaltests/dataset5/segment_cropped (14).png', ...
        'img_evaltests/dataset5/segment_cropped (13).png', ...
        'img_evaltests/dataset5/segment_cropped (12).png', ...
        'img_evaltests/dataset5/segment_cropped (11).png', ...
        'img_evaltests/dataset5/segment_cropped (10).png', ...
        'img_evaltests/dataset5/segment_cropped (9).png', ...
        'img_evaltests/dataset5/segment_cropped (8).png', ...
        'img_evaltests/dataset5/segment_cropped (7).png', ...
        'img_evaltests/dataset5/segment_cropped (6).png', ...
        'img_evaltests/dataset5/segment_cropped (5).png', ...
        'img_evaltests/dataset5/segment_cropped (4).png', ...
        'img_evaltests/dataset5/segment_cropped (3).png', ...
        'img_evaltests/dataset5/segment_cropped (2).png', ...
        'img_evaltests/dataset5/segment_cropped (1).png', ...
         }; 

% files = {
%         'img_evaltests/dataset1/segment_cropped (1).png', ...
%         'img_evaltests/dataset1/segment_cropped (2).png', ...
%         'img_evaltests/dataset1/segment_cropped (3).png',...  
%          'img_evaltests/dataset1/segment_cropped (4).png',...
%          %'img_evaltests/dataset1/segment_cropped (5).png'...
%          }; 

exposure_min = 1;
exposure_max = 255;
expTimes = cell(1,numel(files));
expNormalized = cell(1,numel(files));
images = cell(1,numel(files));

figure;
montage(files);


%% single scalar relative exposure value per image 

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path); 
    images{i} = img;
  %expTimes(i) = mean(img(:)); 
  %expTimes{i} = img;
  expTimes{i}=zeros(size(img));
  expTimes{i}(:)= mean(img(:)); 
  expNormalized{i} = expTimes{i}./expTimes{i}(1);
%   expNormalized{i} = expNormalized{i} .* expNormalized{i};
%   expNormalized{i} = expNormalized{i} .* expNormalized{i};
%   expNormalized{i} = expNormalized{i} .* expNormalized{i};
end 

%montage(files) 
hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
%hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized);
%rgb = localtonemap(hdr,'EnhanceContrast', 1); 
hdr_rgb = cat(3, hdr,hdr,hdr);
rgb = tonemap_mod(hdr_rgb);  
%rgb = uint8(255*mat2gray(hdr));
figure; 
subplot(2,1,1),imshow(rgb);
imwrite(rgb,'img_evaltests/dataset5/hdr_global.png');

%% compare with moving average approach

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path); 
    %expTimes(i) = mean(img(:)); 
    %expTimes{i} = img;
    expTimes{i}=zeros(size(img));
    expTimes{i}= movmean(img,75,1);
    expNormalized{i} = expTimes{i}./expTimes{i}(1);
end 

hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
hdr_rgb = cat(3, hdr,hdr,hdr);
rgb = tonemap_mod(hdr_rgb);  
%rgb = uint8(255*mat2gray(hdr));
%subplot(2,1,2),imshow(rgb);
imwrite(rgb,'img_evaltests/dataset5/hdr_75,1.png');

%% compare with moving average approach

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path); 
    %expTimes(i) = mean(img(:)); 
    %expTimes{i} = img;
    expTimes{i}=zeros(size(img));
    window = [2 5];
    expTimes{i}= movmean(img,window);
    expNormalized{i} = expTimes{i}./expTimes{i}(1);
end 

hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
hdr_rgb = cat(3, hdr,hdr,hdr);
rgb = tonemap_mod(hdr_rgb);  
%rgb = uint8(255*mat2gray(hdr));
subplot(2,1,2),imshow(rgb);
window = mat2str(window);
imwrite(rgb,strcat('img_evaltests/dataset5/hdr_',window,'.png'));

figure;
path = cell2mat(files(1)); 
img = imread(path); 
adjust = imadjust(img);
imshow(adjust);
imwrite(adjust,'img_evaltests/dataset5/imadjust_result.png');
