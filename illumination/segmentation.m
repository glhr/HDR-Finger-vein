close all;
clear all;

img = imread('img_old/cropped_4.png');
[nrows, ncols, dim] = size(img);
imgrange = [0 255];

divisions_vertical = 4;
segments = [];
reconstructed_img = [];
figure
for n = 1:divisions_vertical
    segments(:,:,:,n) = img(:,((n-1)*floor(ncols/divisions_vertical))   +1:n*floor(ncols/divisions_vertical),:);
    subplot(1,divisions_vertical,n), imshow(segments(:,:,:,n),imgrange);
    reconstructed_img = horzcat(reconstructed_img, segments(:,:,:,n));
end

figure
for n = 1:divisions_vertical
     I = segments(:,:,:,n);
     radius = 10;
     J1 = fspecial('disk', radius);
     segments(:,:,:,n) = imfilter(I,J1,'replicate');
     subplot(1,divisions_vertical,n),imshow(segments(:,:,:,n),imgrange);
end

figure
for n = 1:divisions_vertical
    I = segments(:,:,:,n);
    [Gx, Gy] = imgradient(I,'prewitt');
    subplot(2,divisions_vertical,n),imshowpair(Gx, Gy, 'montage');
    [Gx, Gy] = imgradient(I,'central');
    subplot(2,divisions_vertical,n+divisions_vertical),imshowpair(Gx, Gy, 'montage');
end

%figure
%imshow(reconstructed_img,imgrange);