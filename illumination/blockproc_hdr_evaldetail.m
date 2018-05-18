close all
clear all

files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png',...
        'img_evaltests/dataset2/segment_cropped (3).png', 'img_evaltests/dataset2/segment_cropped (4).png',...
        'img_evaltests/dataset2/segment_cropped (5).png'};

%files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png'};
metafile = {'img_evaltests/dataset2/segment4meta.png'};
expTimes = [];
n_segments = 10;
images = cell(n_segments,numel(files));

global exposure_min exposure_max
exposure_min = 1;
exposure_max = 255;

global  background_filter_radius gradient_filter_radius suppress_detail_thresh ...
        detailweight_filter_radius edge_width
background_filter_radius = 20;
gradient_filter_radius = [2 6];
detailweight_filter_radius = [2 6];
suppress_detail_thresh = [50 225];
edge_width = 4;
detail_thresh = 60;

for i = 1:numel(files)
    path = cell2mat(files(i));
    img = imread(path);
    segments = segmentimg(img,n_segments);
    %filter = fspecial('average', [22 11]);

    for j=1:n_segments
        images{j,i} = segments{j};
        %background_illum{j,i} = imfilter(segments{j},filter,'replicate');
        %exposures{j}(i) = mean(background_illum{j,i}(:));
        exposures{j}(i) = mean(images{j,i}(:));
    end
	
end

for i = 1:numel(files)
    path = cell2mat(files(i));
    img = imread(path);
    details_weighted = subtractillumination(img,2);
    segments = segmentimg(details_weighted,n_segments);
    %filter = fspecial('average', [22 11]);

    for j=1:n_segments
        detailimg{j,i} = segments{j};
        detailscore{j}(i) = sum(detailimg{j,i}(:));
    end
	
end

montage(files)


%%plot HDR output for each segments
%figure;
for i=1:n_segments
    exp_normalized{i} = detailscore{i}./detailscore{1}(1);
    hdr{i} = makehdr_mod(metafile,images(i,:),'RelativeExposure',exp_normalized{i},...
        'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
    %figure, imshow(hdr); %was just curious what it looks like
    
    %subplot(1,n_segments,i);
    %imshow(rgb{i});
end

hdrresult = reconstructimg(hdr);
rgb = tonemap(hdrresult);
figure;
imshow(rgb);
hdr_global();

function hdr_global()
global exposure_min exposure_max
    files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png',...
        'img_evaltests/dataset2/segment_cropped (3).png','img_evaltests/dataset2/segment_cropped (4).png',...
        'img_evaltests/dataset2/segment_cropped (5).png'}; 
    expTimes = [0.0333, 0.1000, 0.3333, 0.6250, 1.3000]; 
 
    for i = 1:5 
        path = cell2mat(files(i)); 
        img = imread(path); 
      expTimes(i) = mean(img(:)); 
    end 
 
    %montage(files) 
    hdr = makehdr(files,'RelativeExposure',expTimes./expTimes(1),...
        'MinimumLimit',exposure_min,'MaximumLimit',exposure_max);
    rgb = tonemap(hdr); 
    figure; 
    subplot(2,1,1),imshow(rgb);
end

function output = segmentimg(img,divisions_vertical)
    output = cell(1,divisions_vertical);
    [nrows, ncols, dim] = size(img);
    for n = 1:divisions_vertical
        output{n} = img(:,((n-1)*floor(ncols/divisions_vertical))...
                            +1:n*floor(ncols/divisions_vertical),:);
    end
    imwrite(output{1},'img_evaltests/dataset2/segment4meta.png');
end

function output = reconstructimg(segments)
   output = [];
   for n = 1:numel(segments)
       output = horzcat(output, segments{n});
   end
end

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
    
    output_weight = output_eq;
    output_thresh = output_eq;

    if(plot == 2) % plot everything
        figure;
        subplot(3,2,1),imshow(img,[0 255]);
            title(sprintf("Original image"));
        subplot(3,2,2),imshow(imgneg,[0 255]);
            title(sprintf("Negative image"));
        subplot(3,2,3),imshow(background_illum,[0 255]);
            title(sprintf("Background illumination estimated\n by applying average filter"));
        subplot(3,2,4),imshow(output_weight,[0 255]),
            title(sprintf("After subtracting background\n illumination from negative image"));
        subplot(3,2,5),imshow(output_filtered,[0 255]),
            title(sprintf("After averaging"));
        subplot(3,2,6),imshow(output_thresh,[0 255]),
            title(sprintf("After applying thresholding"));
    elseif(plot == 1) % only plot essentials
        figure;
        subplot(2,1,1),imshow(img,[0 255]);
        subplot(2,1,2),imshow(output_weight,[0 255]);
    end
    
end