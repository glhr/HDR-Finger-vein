close all;
clear all;

showsegments('img_evaltests/1.png',4);
%subtractillumination(imread('img_evaltests/dehazed.png'),1);

function showsegments(imgpath,divisions_vertical)
    img = imread(imgpath);
    %img = img(200:800,150:1500);
    [nrows, ncols, dim] = size(img);
    imgrange = [0 255];
    plot_nrows = 4;

    segments = [];
    reconstructed_img = [];
    figure
    for n = 1:divisions_vertical
        segments(:,:,:,n) = img(:,((n-1)*floor(ncols/divisions_vertical))   +1:n*floor(ncols/divisions_vertical),:);
        subplot(plot_nrows,divisions_vertical,n), imshow(segments(:,:,:,n),imgrange);
        reconstructed_img = horzcat(reconstructed_img, segments(:,:,:,n));
    end
    

    for n = 1:divisions_vertical
        [details_weight(:,:,:,n) score_weight(n) details_thresh(:,:,:,n) score_thresh(n)] = subtractillumination(segments(:,:,:,n),0);

        [Gx(:,:,:,n) Gy(:,:,:,n)] = gradient(segments(:,:,:,n),0);
        
        subplot(plot_nrows,divisions_vertical,n+divisions_vertical)
            imshow(details_weight(:,:,:,n),[0 255]),title(sprintf('Detail level: %i', score_weight(n)));
        subplot(plot_nrows,divisions_vertical,n+2*divisions_vertical)
            imshow(details_thresh(:,:,:,n),[0 255]),title(sprintf('Detail level: %i', score_thresh(n))); 
        subplot(plot_nrows,divisions_vertical,n+3*divisions_vertical)
            imshowpair(Gx(:,:,:,n), Gy(:,:,:,n), 'montage');
    end
    
    


    %figure
    %imshow(reconstructed_img,imgrange);
end   % end of function

function [Gx, Gy] = gradient(img,plot)

    radius = 10;
    J1 = fspecial('average', radius);
    img_filtered = imfilter(img,J1,'replicate');
    [Gx, Gy] = imgradient(img_filtered,'prewitt');
    %[Gx, Gy] = imgradient(I,'central');
    
    if(plot)
        figure;
        subplot(1,2,1),imshow(img_filtered,[0 255]);
        subplot(1,2,2),imshowpair(Gx, Gy, 'montage');
    end

end

function [output_weight, detail_weight, output_thresh, detail_thresh] = subtractillumination(img,plot)
    imgneg = uint8(255*mat2gray(imcomplement(img)));
    filter = fspecial('average', 20);
    background_illum = imfilter(imgneg,filter,'replicate');
    output = imsubtract(imgneg,background_illum);
    output_eq = imadjust(output);    
    output_eq(output_eq < 100) = 0;
    
    filter2 = fspecial('average', 5);
    output_filtered = imfilter(output_eq,filter2,'replicate');
    
    output_weight = output_eq;
    detail_weight = sum(output_weight(:));
    
    output_thresh = imadjust(uint8(output_filtered>80));
    detail_thresh = sum(output_thresh(:));

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

