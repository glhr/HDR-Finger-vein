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
      expTimes{i}(:)= mean(img(:)); 
    end 
    
    for i = 1:numel(files) 
      expNormalized{i} = expTimes{i}./expTimes{i}(1);
    end 
 
    %montage(files) 
    hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
    rgb = tonemap(hdr); 
    figure; 
    subplot(2,1,1),imshow(rgb);
    
    %% compare with segmented approach
for i = 1:5 
      path = cell2mat(files(i)); 
      img = imread(path); 

      expTimes{i} = zeros(size(img));
      expNormalized{i} = zeros(size(img));
      expTimes{i}(:) = mean(img(:)); 
      expNormalized{i} = expTimes{i}./expTimes{i}(1);
      
      segwidth = 1;
      for j = 1:segwidth:302 
          if(j>=302-segwidth)
              block = img(:,j:302);
              expTimes{i}(:,j:302)= mean(block(:)); 
              expNormalized{i}(:,j:302) = expTimes{i}(:,j:302)./double(expTimes{i}(1,1));
          else
              block = img(:,j:j+segwidth);
              expTimes{i}(:,j:j+segwidth)= mean(block(:)); 
              expNormalized{i}(:,j:j+segwidth) = expTimes{i}(:,j:j+segwidth)./double(expTimes{i}(1,1));
          end
      end
end 
    
 hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
rgb = tonemap(hdr);  
subplot(2,1,2),imshow(rgb);