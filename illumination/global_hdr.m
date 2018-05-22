clear all;
close all;

exposure_min = 1;
exposure_max = 255;

files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png', 'img_evaltests/dataset2/segment_cropped (3).png',...  
         'img_evaltests/dataset2/segment_cropped (4).png', 'img_evaltests/dataset2/segment_cropped (5).png'}; 
    metafile = {'img_evaltests/dataset2/segment4meta.png'};
    %expTimes = [0.0333, 0.1000, 0.3333, 0.6250, 1.3000]; 
    expTimes = cell(1,numel(files));
    expNormalized = cell(1,numel(files));
    images = cell(1,numel(files));
    for i = 1:5 
        path = cell2mat(files(i)); 
        img = imread(path); 
        images{i} = img;
      %expTimes(i) = mean(img(:)); 
      %expTimes{i} = img;
      expTimes{i}=zeros(size(img));
      expTimes{i}(:)=mean(img(:)); 
    end 
    
    for i = 1:numel(files) 
      expNormalized{i} = expTimes{i}./expTimes{i}(1);
    end 
 
    %montage(files) 
    hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
    rgb = tonemap(hdr); 
    figure; 
    subplot(2,1,1),imshow(rgb);