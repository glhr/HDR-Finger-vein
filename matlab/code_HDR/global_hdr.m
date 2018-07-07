clear all;
close all;

ndatasets = 17;
matching_sigma = 2.5;
matching_window = '[5 5]';

plot = false;
tonemap_mode = 'matlab';

for d = 6:1:ndatasets
    dataset = strcat('dataset',num2str(d));
    
    metafile = {strcat('img_evaltests/',dataset,'/segment_cropped (1).png')};
    [img_h,img_w] = size(imread( cell2mat(metafile)));
    nimages = 16;
if(strcmp(dataset,'dataset5') || strcmp(dataset,'dataset4'))
    nimages = 21;
elseif(strcmp(dataset,'dataset12') || strcmp(dataset,'dataset13') || ...
        strcmp(dataset,'dataset14') || strcmp(dataset,'dataset15') || ...
        strcmp(dataset,'dataset16') || strcmp(dataset,'dataset17'))
    nimages = 15;
end

files = cell(1,nimages);
for n = 1:1:nimages
    files{n} = strcat('img_evaltests/',dataset,'/segment_cropped (',num2str(n),').png');
end

images = cell(1,numel(files));

if(plot)
    figure;
    montage(files,'Size', [NaN 1]);
end


%% single scalar relative exposure value per image 

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path);
    images{i} = img;
    expTimes(i)= mean(img(:));
    expNormalized(i) = (expTimes(i) / expTimes(1));
    weight = 1;

    if(i == 1)
        hdr_global = (single(img) .* weight);
    else
        hdr_global = hdr_global + (single(img) .* weight)./expNormalized(i);
    end
end 

% Average the values in the accumulator by the number of LDR images
% that contributed to each pixel to produce the HDR radiance map.
hdr_global = hdr_global ./ numel(files);

if(plot)
    montage(files) 
end

%RECOGNITION
    
 %for i = 3:0.25:3 
    sigma = matching_sigma;
    [img, output, pattern, scores] = miura_usage(hdr_global,1000,1,13,sigma,2);
    %imwrite(pattern,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/maxcurve',num2str(sigma),'_hdr_global_.png'));
    %imwrite(scores(:,:,1) > 0,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/scoresmaxcurve',num2str(sigma),'_hdr_global_.png'));
    imwrite(pattern,strcat('img_evaltests/matching_hdrglobal/',dataset,'_repline.png'));
    
    [img, output, pattern, scores] = miura_usage(hdr_global,1000,1,13,sigma,1);
    %imwrite(pattern,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/maxcurve',num2str(sigma),'_hdr_global_.png'));
    %imwrite(scores(:,:,1) > 0,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/scoresmaxcurve',num2str(sigma),'_hdr_global_.png'));
    imwrite(pattern,strcat('img_evaltests/matching_hdrglobal/',dataset,'_maxcurve.png'));
%end

tonemap_mode ='linear';
   rgb_global = uint8(255*mat2gray(hdr_global));
   imwrite(rgb_global,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/hdr_global.png'));
tonemap_mode ='matlab';
   rgb_global = tonemap(hdr_global,'NumberOfTiles',[10 10]);
   imwrite(rgb_global,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/hdr_global.png'));
end

if(plot)
    figure; 
    subplot(2,1,1),imshow(rgb_global,[]);
end


%% compare with moving average approach

windows = getWindows();

for j = 1:numel(windows)
    for i = 1:numel(files) 
path = cell2mat(files(i)); 
        img = imread(path); 
        window = windows{j};

        [h w] = size(img);
        fullimg = imread(strcat('img_evaltests/',dataset,'/segment_norm (',num2str(i),').png'));
        background = movmean(fullimg,window);
        background = background(55:160,50:410);

         expTimes(i)= mean(img(:));
        expNormalized(i) = (expTimes(i) / expTimes(1));
        if(i == 1)
            hdr = single(img) ./ background;
        else
            hdr = hdr + (single(img) ./ background) ./ expNormalized(i);
        end
    end
    
    hdr = hdr ./ numel(files);
    
    window = mat2str(window);
    tonemap_mode = 'linear';
        rgb = uint8(255*mat2gray(hdr));
        imwrite(rgb,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/hdr_',window,'_movmean.png'));
    tonemap_mode = 'matlab';
        rgb = tonemap(hdr,'NumberOfTiles',[10 10]);
        imwrite(rgb,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/hdr_',window,'_movmean.png'));
    
    if(plot)
        subplot(2,1,2),imshow(rgb,[]);  
    end
    
    
    
    
    %RECOGNITION
    
    %for i = 3:0.25:3 
        sigma = matching_sigma;
        [img, output, pattern, scores] = miura_usage(hdr,1000,1,13,sigma,1);
        %imwrite(pattern,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/maxcurve',num2str(sigma),'_hdr',window,'_.png'));
        %imwrite(scores(:,:,1) > 0,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/scoresmaxcurve',num2str(sigma),'_hdr',window,'_.png'));
        
        if(strcmp(window,matching_window))
            imwrite(pattern,strcat('img_evaltests/matching/',dataset,'_maxcurve',window,'.png'));
        end
        
        
        [img, output, pattern, scores] = miura_usage(hdr,1000,1,13,sigma,2);
        %imwrite(pattern,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/repline',num2str(sigma),'_hdr',window,'_.png'));
        %imwrite(scores(:,:,1) > 0,strcat('img_evaltests/',dataset,'/tonemap_',tonemap_mode,'/scoresmaxcurve',num2str(sigma),'_hdr',window,'_.png'));
        
        if(strcmp(window,matching_window))
            imwrite(pattern,strcat('img_evaltests/matching/',dataset,'_repline.png'));
        end
    %end

end



