close all;
clear all;

%showsegments('img_evaltests/segment_2.png',4);
%subtractillumination(imread('img_evaltests/dehazed.png'),1);
global divisions_vertical n_images scorematrix segments reconstructed_img resolution

divisions_vertical = 4;
n_images = 3;
scorematrix = zeros([divisions_vertical, n_images]);

segments = [];
reconstructed_img = [];

for n = 1:n_images
    %input = normalizeimg(strcat('img_evaltests/test2 (',num2str(n),').png'));
    input = normalizeimg(strcat('img_evaltests/dataset3/segment (',num2str(n),').png'));
    %input = normalizeimg(strcat('img_evaltests/1.png'));
    showsegments(input,n);
    %subplot(1,n_images,n), imshow(input);
end

selector = select_segments(scorematrix);
combineimages(selector);

function selector = select_segments(scorematrix)

    n_segments = size(scorematrix,1);
    maxindex = zeros([1,4]);
    for n=1:n_segments
        [maxscore, maxindex(n)] = max(scorematrix(n,:));
    end
    selector = maxindex;
end

function combineimages(selector)
   global divisions_vertical reconstructed_img reconstructed_img_proc segments segments_detail
   for n = 1:divisions_vertical
       segment = segments(:,:,:,n,selector(n));
       reconstructed_img = horzcat(reconstructed_img, segment);
   end
   for n = 1:divisions_vertical
       segment = segments(:,:,:,n,selector(n));

       segment = uint8(255*mat2gray(segment));
       %segment = localcontrast(segment, edgeThreshold, amount);
       %segment = histeq(segment,p);
       filter = fspecial('average', 60);
       background_illum = imfilter(segment,filter,'replicate');
       imin = double(min(background_illum(:)))/255
       imax = double(max(background_illum(:)))/255
       diff = (imax-imin)/10
       
       segment = imadjust(segment,[imin imax], [0 1]);
        reconstructed_img_proc = horzcat(reconstructed_img_proc, segment);
   end
   blur = imgaussfilt(reconstructed_img, [1 10]);
   figure;
   subplot(2,1,1),imshow(reconstructed_img,[0 255]);
   %subplot(2,1,2),imshow(normalizeimg(strcat('img_evaltests/segment_5.png')),[0 255]);
end

function showsegments(img,imgnum)
    global segments scorematrix divisions_vertical segments_detail
    %img = img(200:800,150:1500);
    
    imgrange = [0 255];
    plot_nrows = 6;
    

    %figure
    [details_weight, details_thresh] = subtractillumination(img,2);
    [Gmag, Gdir, Gx, Gy, edges] = gradient(img,0);
    %output_merge = mergefilters(details_weight, Gx, Gy, Gmag, Gdir);
    
    %% Plot results
%     figure
%     subplot(plot_nrows,divisions_vertical,1:divisions_vertical/2), imshow(details_weight,imgrange);
%     subplot(plot_nrows,divisions_vertical,divisions_vertical/2+1:divisions_vertical), imshow(details_thresh,imgrange);
%     gradients = [Gmag Gdir; Gx Gy];
%     subplot(plot_nrows,divisions_vertical,divisions_vertical+1:divisions_vertical+(divisions_vertical/2)), imshow(gradients,imgrange);
%      subplot(plot_nrows,divisions_vertical,divisions_vertical+(divisions_vertical/2)+1:divisions_vertical*2), imshow(edges,imgrange);
%     subplot(plot_nrows,divisions_vertical,2*divisions_vertical+1:divisions_vertical*3), imshow(output_merge,imgrange);
%      
    %figure;
    segments_detail(:,:,:,:,imgnum) = segmentimg(details_thresh,divisions_vertical);
    for n = 1:divisions_vertical
        %subplot(plot_nrows,divisions_vertical,n+2*divisions_vertical), imshow(segments(:,:,:,n,imgnum),imgrange);
        score = evaldetail(segments_detail(:,:,:,n,imgnum));
        %title(sprintf("%i",score));
        scorematrix(n,imgnum) = score;
    end
%     for n = 1:divisions_vertical
%         subplot(plot_nrows,divisions_vertical,n), imshow(segments(:,:,:,n,imgnum),imgrange);
%         title(sprintf("%i",evaldetail(segments(:,:,:,n,imgnum))));
%     end
%     segments(:,:,:,:,imgnum) = segmentimg(Gmag,divisions_vertical);
%     for n = 1:divisions_vertical
%         subplot(plot_nrows,divisions_vertical,n+divisions_vertical), imshow(segments(:,:,:,n,imgnum),imgrange);
%         title(sprintf("%i",evaldetail(segments(:,:,:,n,imgnum))));
%     end
%     segments(:,:,:,:,imgnum) = segmentimg(Gdir,divisions_vertical);
%     for n = 1:divisions_vertical
%         subplot(plot_nrows,divisions_vertical,n+2*divisions_vertical), imshow(segments(:,:,:,n,imgnum),imgrange);
%         title(sprintf("%i",evaldetail(segments(:,:,:,n,imgnum))));
%     end
%     
%     segments(:,:,:,:,imgnum) = segmentimg(Gx,divisions_vertical);
%     for n = 1:divisions_vertical
%         subplot(plot_nrows,divisions_vertical,n+3*divisions_vertical), imshow(segments(:,:,:,n,imgnum),imgrange);
%         title(sprintf("%i",evaldetail(segments(:,:,:,n,imgnum))));
%     end
%     segments(:,:,:,:,imgnum) = segmentimg(Gy,divisions_vertical);
%     for n = 1:divisions_vertical
%         subplot(plot_nrows,divisions_vertical,n+4*divisions_vertical);
%         imshow(segments(:,:,:,n,imgnum),imgrange);
%         %plot(segments(:,50,:,n,imgnum));
%         title(sprintf("%i",evaldetail(segments(:,:,:,n,imgnum))));
%     end
     segments(:,:,:,:,imgnum) = segmentimg(img,divisions_vertical);
%     for n = 1:divisions_vertical
%         subplot(plot_nrows,divisions_vertical,n+5*divisions_vertical), imshow(segments(:,:,:,n,imgnum),imgrange);
%         title(sprintf("%i",evaldetail(segments(:,:,:,n,imgnum))));
%     end
    
    
end   % end of function

function output = segmentimg(img,divisions_vertical)
    [nrows, ncols, dim] = size(img);
    for n = 1:divisions_vertical
        output(:,:,:,n) = img(:,((n-1)*floor(ncols/divisions_vertical))   +1:n*floor(ncols/divisions_vertical),:);
    end
end

function detail = evaldetail(img)
    detail = sum(img(:));
end

function output_merge = mergefilters(illum_subtract, Gx, Gy, Gmag, Gdir)

    output_reduced = imadjust(illum_subtract,[0 1], [0.2 0.5]);

    Gmag = imcomplement(Gmag);
    output_merge = imadjust(Gmag)+illum_subtract;
    output_merge = uint8(255*mat2gray(output_merge));
    %output_merge = immultiply(uint16(output_merge), uint16(Gx));
end

function output = normalizeimg(imgpath)
global resolution
    img = imread(imgpath);
    [height, width, dim] = size(img);
    resolution = width;
    if (height == 1080 && width == 1920)
        fprintf('Input image size: 1080 x 1920\n');
        output = img(380:680,240:1450);
        output = imresize(output, [75 NaN]);
    elseif(height == 600 && width == 800)
        fprintf('Input image size: 600 x 800\n');
        output = img(260:335,175:575);
        %output = imresize(output, [75 NaN]);
    else
        output = img;
    end
end

function [Gmag, Gdir, Gx, Gy, edges] = gradient(img,plot)
global resolution
    if(resolution == 1920)
        radius = [3 10];
    elseif(resolution == 800)
        radius = [2 6];
    end
    J1 = fspecial('average', radius);
    img_filtered = imfilter(img,J1,'replicate');
    [Gmag, Gdir] = imgradient(img_filtered,'prewit');
    [Gx, Gy] = imgradientxy(img_filtered,'prewit');
    
    
    %[Gx, Gy] = imgradient(I,'central');
    
    Gy = uint8(255*mat2gray(Gy));
    Gx = uint8(255*mat2gray(Gx));
    Gmag = uint8(255*mat2gray(Gmag));
    Gdir = uint8(255*mat2gray(Gdir));
    Gy = imcomplement(Gy);
    
    edges = edge(img,'roberts');
    edges = uint8(255*mat2gray(edges));
    if(plot)
        figure;
        subplot(1,2,1),imshow(img_filtered,[0 255]);
        subplot(1,2,2),imshowpair(Gx, Gy, 'montage');
    end

end

function [output_weight, output_thresh] = subtractillumination(img,plot)
    global resolution
    imgneg = uint8(255*mat2gray(imcomplement(img)));
    if(resolution == 1920)
        radius = [20 10];
    elseif(resolution == 800)
        radius = [30 15];
    end
    filter = fspecial('average', radius);
    background_illum = imfilter(imgneg,filter,'replicate');
    output = imsubtract(imgneg,background_illum);
    output_eq = imadjust(output);    
    %output_eq(output_eq < 100) = 0;
    
    %remove saturated regions from detail map
    if(resolution == 1920)
        thresh_low = 120;
        thresh_high = 210;
    elseif(resolution == 800)
        thresh_low = 50;
        thresh_high = 225;
    end
    
    output_eq(img < thresh_low) = 0;
    output_eq(img > thresh_high) = 0;
    
   if(resolution == 1920)
        radius = [3 10];
    elseif(resolution == 800)
        radius = [2 6];
    end
    
    filter2 = fspecial('average', radius);
    output_filtered = imfilter(output_eq,filter2,'replicate');
    
    output_weight = output_eq;
    output_thresh = imadjust(uint8(output_filtered>80));

    if(plot == 2) % plot everything
        figure;
        subplot(2,2,1),imshow(img,[0 255]); title(sprintf("Original image"));
        subplot(2,2,2),imshow(imgneg,[0 255]); title(sprintf("Negative image"));
        subplot(2,2,3),imshow(background_illum,[0 255]); title(sprintf("Background illumination estimated\n by applying average filter"));
        subplot(2,2,4),imshow(output_weight,[0 255]), title(sprintf("After subtracting background\n illumination from negative image"));
    elseif(plot == 1) % only plot essentials
        figure;
        subplot(2,1,1),imshow(img,[0 255]);
        subplot(2,1,2),imshow(output_weight,[0 255]);
    end
    
end

