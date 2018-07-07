clear all;
close all;
dataset = 'dataset16';
window = [7 7];
windowstr = '[7 7]';

metafile = {strcat('img_evaltests/',dataset,'/segment_cropped (1).png')};
plot = true;
for n = 1:1:15
    files{n} = strcat('img_evaltests/',dataset,'/segment_cropped (',num2str(n),').png');
end

images = cell(1,numel(files));

if(plot)
    figure;
    montage(files,'Size', [NaN 1]);
end

%% Basic HDR using mean gray value as weight in reconstruction

for i = 1:numel(files) 
    path = cell2mat(files(i)); 
    img = imread(path);
    images{i} = img;
    expTimes(i)= mean(img(:));
    expNormalized(i) = (expTimes(i) / expTimes(1));
    weight = 1;

    hdr_global = hdr_global + (single(img) .* weight)./expNormalized(i);
end

% Average the values in the accumulator by the number of LDR images that contributed to each pixel to produce the HDR radiance map.
hdr_global = hdr_global ./ numel(files);

if(plot)
    montage(files) 
end

rgb_lin = uint8(255*mat2gray(hdr_global));
rgb_tonem = tonemap(hdr_global,'NumberOfTiles',[10 10]);  

if(plot)
    figure; 
    imshow(rgb_lin,[]);
    imwrite(rgb_lin,'results/hdrimpl/global_linear.png');
end

if(plot)
    figure; 
    imshow(rgb_tonem,[]);
    imwrite(rgb_tonem,'results/hdrimpl/global_tonemap.png');
end

%% HDR using moving mean filter as weight
% the list of moving mean filter windows to be tested is in the getWindows file
expTimes = [];
expNormalized = [];
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
        
        hdr = hdr + (single(img) ./ background) ./ expNormalized(i);
    end 
    
    hdr = hdr ./ numel(files);
      
    rgb_lin = uint8(255*mat2gray(hdr));
    rgb_tonem = tonemap(hdr);  
    windowstr = mat2str(window);
    if(plot)
        figure; 
        subplot(2,1,1);imshow(rgb_lin,[]);
        subplot(2,1,2);imshow(rgb_tonem,[]);
        imwrite(rgb_lin,strcat('results/hdrimpl/',windowstr,'_linear.png'));
        imwrite(rgb_tonem,strcat('results/hdrimpl/',windowstr,'_tonemap.png'));
        imwrite(tonemap(background),strcat('results/hdrimpl/',windowstr,'_background.png'));
    end
end


