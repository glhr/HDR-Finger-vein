close all;
clear all;

%showsegments('img_evaltests/segment_2.png',4);
%subtractillumination(imread('img_evaltests/dehazed.png'),1);
global divisions_vertical n_images scorematrix segments reconstructed_img output_gradient output_merge

divisions_vertical = 20;
n_images = 5;
scorematrix = zeros([divisions_vertical, n_images]);

segments = [];
reconstructed_img = [];

for n = 1:n_images
    input = normalizeimg(strcat('img_evaltests/segment_',num2str(n),'.png'));
    %input = normalizeimg(strcat('img_evaltests/dehazed.png'));
    showsegments(input,n);
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
   global divisions_vertical reconstructed_img segments
   for n = 1:divisions_vertical
        reconstructed_img = horzcat(reconstructed_img, segments(:,:,:,n,selector(n)));
   end
   figure;
   imshow(reconstructed_img,[0 255]);
end

function showsegments(img,imgnum)
    global segments scorematrix divisions_vertical output_gradient output_merge
    %img = img(200:800,150:1500);
    
    imgrange = [0 255];
    plot_nrows = 4;

    figure
    
    segments(:,:,:,:,imgnum) = segmentimg(img,divisions_vertical);
    
    for n = 1:divisions_vertical
        subplot(plot_nrows,divisions_vertical,n), imshow(segments(:,:,:,n,imgnum),imgrange);
    end
    

    for n = 1:divisions_vertical
        [details_weight(:,:,:,n), score_weight(n), details_thresh(:,:,:,n), score_thresh(n), detail_merge] = subtractillumination(segments(:,:,:,n,imgnum),0);

        scorematrix(n,imgnum) = score_thresh(n);
        
        
        subplot(plot_nrows,divisions_vertical,n+divisions_vertical)
            imshowpair(details_weight(:,:,:,n),details_thresh(:,:,:,n),'montage'),title(sprintf('Detail level: %i | %i', score_weight(n), score_thresh(n)));
        subplot(plot_nrows,divisions_vertical,n+2*divisions_vertical)
            gradients = [output_gradient(:,:,:,1),output_gradient(:,:,:,2);
                output_gradient(:,:,:,3),output_gradient(:,:,:,4)];
            imshow(gradients,[0 255]);
        subplot(plot_nrows,divisions_vertical,n+3*divisions_vertical)
            imshow(output_merge),title(sprintf('Detail level: %i', detail_merge));
    end
    
    


    %figure
    %imshow(reconstructed_img,imgrange);
end   % end of function

function output = segmentimg(img,divisions_vertical)
    [nrows, ncols, dim] = size(img);
    for n = 1:divisions_vertical
        output(:,:,:,n) = img(:,((n-1)*floor(ncols/divisions_vertical))   +1:n*floor(ncols/divisions_vertical),:);
    end
end

function output = normalizeimg(imgpath)
    img = imread(imgpath);
    [height, width, dim] = size(img);
    if (height == 1080 && width == 1920)
        fprintf('Input image size: 1080 x 1920\n');
        output = img(380:680,240:1450);
        output = imresize(output, [75 NaN]);
    else
        output = img;
    end
end

function [Gmag, Gdir, Gx, Gy, edges] = gradient(img,plot)

    radius = 10;
    J1 = fspecial('average', [3 10]);
    img_filtered = imfilter(img,J1,'replicate');
    [Gmag, Gdir] = imgradient(img_filtered,'prewit');
    [Gx, Gy] = imgradientxy(img_filtered,'prewit');
    
    edges = edge(img,'roberts');
    %[Gx, Gy] = imgradient(I,'central');
    
    if(plot)
        figure;
        subplot(1,2,1),imshow(img_filtered,[0 255]);
        subplot(1,2,2),imshowpair(Gx, Gy, 'montage');
    end

end

function [output_weight, detail_weight, output_thresh, detail_thresh, detail_merge] = subtractillumination(img,plot)

    global output_gradient output_merge
    [Gmag, Gdir, Gx, Gy, edge] = gradient(img,0);
    
    imgneg = uint8(255*mat2gray(imcomplement(img)));
    filter = fspecial('average', 20);
    background_illum = imfilter(imgneg,filter,'replicate');
    output = imsubtract(imgneg,background_illum);
    output_eq = imadjust(output);    
    output_eq(output_eq < 100) = 0;
    
    %remove saturated regions from detail map
    output_eq(img < 30) = 0;
    output_eq(img > 230) = 0;
    
    filter2 = fspecial('average', [3 10]);
    output_filtered = imfilter(output_eq,filter2,'replicate');
    
    output_weight = output_eq;
    detail_weight = sum(output_weight(:));
    
    output_thresh = imadjust(uint8(output_filtered>80));
    detail_thresh = sum(output_thresh(:));
   
    %Gx = uint8(Gx);
    %output_gradient(:,:,:,2) = immultiply(Gx,imcomplement(output_weight));
    
    output_reduced = imadjust(output_filtered,[0 1], [0.2 1]);
    Gy = uint8(255*mat2gray(Gy));
    Gx = uint8(255*mat2gray(Gx));
    Gmag = uint8(255*mat2gray(Gmag));
    Gdir = uint8(255*mat2gray(Gdir));
    output_gradient(:,:,:,2) = Gy;
    output_gradient(:,:,:,1) = Gx;
    output_gradient(:,:,:,3) = Gmag;
    output_gradient(:,:,:,4) = Gdir;
    output_merge = immultiply(uint16(imcomplement(imadjust(Gmag))), uint16(output_reduced));
    output_merge = uint8(255*mat2gray(output_merge));
    output_merge = immultiply(uint16(output_merge), uint16(Gx));

    detail_merge = sum(output_merge(:));

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

