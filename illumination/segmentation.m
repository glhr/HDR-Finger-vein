close all;
clear all;

%showsegments('img_evaltests/segment_1.png');
subtractillumination(imread('img_evaltests/dehazed.png'),1);

function showsegments(imgpath)
    img = imread(imgpath);
    img = img(200:800,150:1500);
    [nrows, ncols, dim] = size(img);
    imgrange = [0 255];
    plot_nrows = 4;

    divisions_vertical = 4;
    segments = [];
    reconstructed_img = [];
    figure
    for n = 1:divisions_vertical
        segments(:,:,:,n) = img(:,((n-1)*floor(ncols/divisions_vertical))   +1:n*floor(ncols/divisions_vertical),:);
        subplot(plot_nrows,divisions_vertical,n), imshow(segments(:,:,:,n),imgrange);
        reconstructed_img = horzcat(reconstructed_img, segments(:,:,:,n));
    end

    for n = 1:divisions_vertical
         I = segments(:,:,:,n);
         radius = 10;
         J1 = fspecial('disk', radius);
         segments(:,:,:,n) = imfilter(I,J1,'replicate');
         subplot(plot_nrows,divisions_vertical,n+divisions_vertical),imshow(segments(:,:,:,n),imgrange);
    end

    for n = 1:divisions_vertical
        I = segments(:,:,:,n);
        [Gx, Gy] = imgradient(I,'prewitt');
        thresh = Gy>30;
        subplot(plot_nrows,divisions_vertical,n+2*divisions_vertical),imshowpair(thresh, Gy, 'montage');
        %[Gx, Gy] = imgradient(I,'central');
        %subplot(3,divisions_vertical,n),imshowpair(Gx, Gy, 'montage');
    end

    %figure
    %imshow(reconstructed_img,imgrange);
end   % end of function

function [output, detail] = subtractillumination(img,plot)
    imgneg = imcomplement(img);
    filter = fspecial('average', 20);
    %filter = fspecial('average', 100);
    background_illum = imfilter(imgneg,filter,'replicate');
    output = imsubtract(imgneg,background_illum);
    output_eq = imadjust(output);
    output_eq(output_eq < 100) = 0;
    output = output_eq;
    detail = sum(output_eq(:));

    if(plot == 2) % plot everything
        figure;
        subplot(2,2,1),imshow(img,[0 255]);
        subplot(2,2,2),imshow(imgneg,[0 255]);
        subplot(2,2,3),imshow(background_illum,[0 255]);
        subplot(2,2,4),imshow(output,[0 255]),title(sprintf('Detail level: %i', detail));
    elseif(plot == 1) % only plot essentials
        figure;
        subplot(2,1,1),imshow(img,[0 255]);
        subplot(2,1,2),imshow(output,[0 255]),title(sprintf('Detail level: %i', detail));
    end
    
end

