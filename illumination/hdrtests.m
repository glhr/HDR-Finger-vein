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

% if(plot)
%     figure;
%     montage(files,'Size', [NaN 1]);
% end

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

% if(plot)
%     montage(files) 
% end

%hdr_global = makehdr(files,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);

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

%% 
expTimes = [];
expNormalized = [];
windows = getWindows();

for j = 1:numel(windows)
    for i = 1:numel(files) 
        path = cell2mat(files(i)); 
        img = imread(path); 
        %expTimes(i) = mean(img(:)); 
        %expTimes{i} = img;

        window = windows{j};
        %padwindow = window.*10;
        %paddedimg = padarray(img,padwindow,'symmetric','both');
        %background = movmean(paddedimg,window);
        [h w] = size(img);
        %background = background(padwindow(1)+1:h-padwindow(1),padwindow(2)+1:w-padwindow(2),:);
        fullimg = imread(strcat('img_evaltests/',dataset,'/segment_norm (',num2str(i),').png'));
        background = movmean(fullimg,window);
        %background = background(250:360,218:640);
        %background = imresize(background, [75 NaN]);
        background = background(55:160,50:410);
        %background = cropimg(dataset,background);
         expTimes(i)= mean(img(:));
        expNormalized(i) = (expTimes(i) / expTimes(1));
        if(i == 1)
            hdr = single(img) ./ background;
        else
            hdr = hdr + (single(img) ./ background) ./ expNormalized(i);
        end
    end 
    
    hdr = hdr ./ numel(files);

    %hdr = makehdr_mod_cell(metafile,images,'RelativeExposure',expNormalized,'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
    
    
    
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


