clear all;
close all;

%metafile = {'img_evaltests/dataset5/linetest.png'};

dataset = 'dataset5';
metafile = {strcat('img_evaltests/',dataset,'/segment_cropped (1).png')};
[img_h,img_w] = size(imread( cell2mat(metafile)));

files = {
        strcat('img_evaltests/',dataset,'/segment_cropped (1).png'), ...
        strcat('img_evaltests/',dataset,'/segment_cropped (2).png'), ...
        strcat('img_evaltests/',dataset,'/segment_cropped (3).png'),...  
        strcat('img_evaltests/',dataset,'/segment_cropped (4).png'),...
         strcat('img_evaltests/',dataset,'/segment_cropped (5).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (6).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (7).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (8).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (9).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (10).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (11).png'), ...
        strcat('img_evaltests/',dataset,'/segment_cropped (12).png'), ...
        strcat('img_evaltests/',dataset,'/segment_cropped (13).png'),...  
        strcat('img_evaltests/',dataset,'/segment_cropped (14).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (15).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (16).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (17).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (18).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (19).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (20).png'),...
        strcat('img_evaltests/',dataset,'/segment_cropped (21).png'),...
         %'img_evaltests/dataset1/segment_cropped (5).png'...
         }; 

% files = {
%         strcat('img_evaltests/',dataset,'/segment_cropped (1).png'), ...
%         strcat('img_evaltests/',dataset,'/segment_cropped (2).png'), ...
%         strcat('img_evaltests/',dataset,'/segment_cropped (3).png'),...  
%         strcat('img_evaltests/',dataset,'/segment_cropped (4).png'),...
%          %'img_evaltests/dataset1/segment_cropped (5).png'...
%          }; 

% files = {
%         'img_evaltests/dataset5/linetest_exp2.png', ...
%         'img_evaltests/dataset5/linetest_exp3.png', ...
%         'img_evaltests/dataset5/linetest_exp4.png', ...
%         };

exposure_min = 1;
exposure_max = 255;
expTimes = cell(1,numel(files));
expNormalized = cell(1,numel(files));
images = cell(1,numel(files));

figure;
montage(files,'Size', [NaN 1]);


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
hdr_global = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
%hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized);
%rgb = localtonemap(hdr,'EnhanceContrast', 1); 
%hdr_rgb = cat(3, hdr,hdr,hdr);
rgb_global = tonemap(hdr_global);  
rgb_global = uint8(255*mat2gray(hdr_global));
figure; 
subplot(2,1,1),imshow(rgb_global,[]);
imwrite(rgb_global,strcat('img_evaltests/',dataset,'/hdr_global.png'));

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
%hdr_rgb = cat(3, hdr,hdr,hdr);
%rgb = tonemap_mod(hdr);  
rgb = uint8(255*mat2gray(hdr));
%subplot(2,1,2),imshow(rgb);
imwrite(rgb,strcat('img_evaltests/',dataset,'/hdr_75,1.png'));

%% compare with moving average approach

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path); 
    %expTimes(i) = mean(img(:)); 
    %expTimes{i} = img;
    expTimes{i}=zeros(size(img));
    window = [2 5];
    expTimes{i}= movmean(img,window);
    %expTimes{i}= movsum(img,window);
    expNormalized{i} = expTimes{i}./expTimes{i}(1);
end 

hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
%hdr_rgb = cat(3, hdr,hdr,hdr);
rgb = tonemap(hdr);  
%rgb = uint8(255*mat2gray(hdr));
subplot(2,1,2),imshow(rgb,[]);
window = mat2str(window);
imwrite(rgb,strcat('img_evaltests/',dataset,'/hdr_',window,'_movmean.png'));

figure;
path = cell2mat(files(1)); 
img = imread(path); 
adjust = imadjust(img(:,:,1));
imshow(adjust);
imwrite(adjust,strcat('img_evaltests/',dataset,'/imadjust_result.png'));
