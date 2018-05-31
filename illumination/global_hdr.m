clear all;
close all;

metafile = {'img_evaltests/dataset4/segment4meta.png'};
[img_h,img_w] = size(imread( cell2mat(metafile)));

files = {
        'img_evaltests/dataset4/segment (21).png_cropped.png', ...
        'img_evaltests/dataset4/segment (20).png_cropped.png', ...
        'img_evaltests/dataset4/segment (19).png_cropped.png', ...
        'img_evaltests/dataset4/segment (18).png_cropped.png', ...
        'img_evaltests/dataset4/segment (17).png_cropped.png', ...
        'img_evaltests/dataset4/segment (16).png_cropped.png', ...
        'img_evaltests/dataset4/segment (15).png_cropped.png', ...
        'img_evaltests/dataset4/segment (14).png_cropped.png', ...
        'img_evaltests/dataset4/segment (13).png_cropped.png', ...
        'img_evaltests/dataset4/segment (12).png_cropped.png', ...
        'img_evaltests/dataset4/segment (11).png_cropped.png', ...
        'img_evaltests/dataset4/segment (10).png_cropped.png', ...
         'img_evaltests/dataset4/segment (9).png_cropped.png', ...
         'img_evaltests/dataset4/segment (8).png_cropped.png', ...
         'img_evaltests/dataset4/segment (7).png_cropped.png', ...
         'img_evaltests/dataset4/segment (6).png_cropped.png', ...
         'img_evaltests/dataset4/segment (5).png_cropped.png', ...
         'img_evaltests/dataset4/segment (4).png_cropped.png', ...
         'img_evaltests/dataset4/segment (3).png_cropped.png', ...
         'img_evaltests/dataset4/segment (2).png_cropped.png', ...
         'img_evaltests/dataset4/segment (1).png_cropped.png', ...
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
rgb = tonemap(hdr); 
figure; 
subplot(2,1,1),imshow(rgb);
    
%% compare with segmented approach
% for i = 1:5 
%       path = cell2mat(files(i)); 
%       img = imread(path); 
% 
%       expTimes{i} = zeros(size(img));
%       expNormalized{i} = zeros(size(img));
%       
%       segwidth = 1;
%       segheight = 75;
%       for j = 1:segwidth:img_w
%           for k = 1:segheight:img_h
%           if(j>=img_w-segwidth)
%               if(k>=img_h-segheight)
%                   block = img(k:img_h,j:img_w);
%                   expTimes{i}(k:img_h,j:img_w)= mean(block(:)); 
%                   %expNormalized{i}(k:75,j:302) = expTimes{i}(k:75,j:302)./double(expTimes{i}(1,1));
%               else
%                   block = img(k:k+segheight,j:img_w);
%                   expTimes{i}(k:k+segheight,j:img_w)= mean(block(:)); 
%                   %expNormalized{i}(k:k+segheight,j:302) = expTimes{i}(k:k+segheight,j:302)./double(expTimes{i}(1,1));
%               end
%           else
%               if(k>=img_h-segheight)
%                 block = img(k:img_h,j:j+segwidth);
%                 expTimes{i}(k:img_h,j:j+segwidth)= mean(block(:)); 
%                 %expNormalized{i}(k:75,j:j+segwidth) = expTimes{i}(k:75,j:j+segwidth)./double(expTimes{i}(1,1));
%               else
%                 block = img(k:k+segheight,j:j+segwidth);
%                 expTimes{i}(k:k+segheight,j:j+segwidth)= mean(block(:)); 
%                 %expNormalized{i}(k:k+segheight,j:j+segwidth) = expTimes{i}(k:k+segheight,j:j+segwidth)./double(expTimes{i}(1,1));
%               end
%           end
%           end
%       end
%       
%       expNormalized{i} = expTimes{i}./double(expTimes{i}(1));
% end 
    
%hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
%rgb = tonemap(hdr);  
%subplot(3,1,2),imshow(rgb);

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
rgb = tonemap(hdr);  
%subplot(2,1,2),imshow(rgb);

%% compare with moving average approach

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path); 
    %expTimes(i) = mean(img(:)); 
    %expTimes{i} = img;
    expTimes{i}=zeros(size(img));
    expTimes{i}= movmean(img,[1 5]);
    expNormalized{i} = expTimes{i}./expTimes{i}(1);
end 

hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
rgb = tonemap(hdr);  
subplot(2,1,2),imshow(rgb);

figure;
path = cell2mat(files(1)); 
img = imread(path); 
imshow(imadjust(img));
