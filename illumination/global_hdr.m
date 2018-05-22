clear all;
close all;

exposure_min = 1;
exposure_max = 255;

metafile = {'img_evaltests/dataset2/segment4meta.png'};
[img_h,img_w] = size(imread( cell2mat(metafile)));

files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png', 'img_evaltests/dataset2/segment_cropped (3).png',...  
         'img_evaltests/dataset2/segment_cropped (4).png', 'img_evaltests/dataset2/segment_cropped (5).png'}; 

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
    subplot(3,1,1),imshow(rgb);
    
    %% compare with segmented approach
for i = 1:5 
      path = cell2mat(files(i)); 
      img = imread(path); 

      expTimes{i} = zeros(size(img));
      expNormalized{i} = zeros(size(img));
      expTimes{i}(:) = mean(img(:)); 
      expNormalized{i} = expTimes{i}./expTimes{i}(1);
      
      segwidth = 1;
      segheight = 1;
      for j = 1:segwidth:img_w
          for k = 1:segheight:img_h
          if(j>=img_w-segwidth)
              if(k>=img_h-segheight)
                  block = img(k:img_h,j:img_w);
                  expTimes{i}(k:img_h,j:img_w)= mean(block(:)); 
                  %expNormalized{i}(k:75,j:302) = expTimes{i}(k:75,j:302)./double(expTimes{i}(1,1));
              else
                  block = img(k:k+segheight,j:img_w);
                  expTimes{i}(k:k+segheight,j:img_w)= mean(block(:)); 
                  %expNormalized{i}(k:k+segheight,j:302) = expTimes{i}(k:k+segheight,j:302)./double(expTimes{i}(1,1));
              end
          else
              if(k>=img_h-segheight)
                block = img(k:img_h,j:j+segwidth);
                expTimes{i}(k:img_h,j:j+segwidth)= mean(block(:)); 
                %expNormalized{i}(k:75,j:j+segwidth) = expTimes{i}(k:75,j:j+segwidth)./double(expTimes{i}(1,1));
              else
                block = img(k:k+segheight,j:j+segwidth);
                expTimes{i}(k:k+segheight,j:j+segwidth)= mean(block(:)); 
                %expNormalized{i}(k:k+segheight,j:j+segwidth) = expTimes{i}(k:k+segheight,j:j+segwidth)./double(expTimes{i}(1,1));
              end
          end
          end
      end
      
      expNormalized{i} = expTimes{i}./expTimes{i}(1);
end 
    
 hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
rgb = tonemap(hdr);  
subplot(3,1,2),imshow(rgb);

subplot(3,1,3),imshow(imadjust(rgb));
