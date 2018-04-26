files = {'2.png', '3.png'};

figure(1)
title('Original images')
subplot(3,2,1);                    
imhist(imread('resized_1.png'))
subplot(3,2,2);
imshow('resized_1.png')
subplot(3,2,3);
imhist(imread('resized_2.png'))
subplot(3,2,4);
imshow('resized_2.png')
subplot(3,2,5);
imhist(imread('resized_3.png'))
subplot(3,2,6);
imshow('resized_3.png')



figure(2)
hdr = makehdr(files,'MinimumLimit',1,'MaximumLimit',255,'RelativeExposure',[2,1]);
rgb = tonemap(hdr);
subplot(3,2,1);
imhist(rgb)
subplot(3,2,2);
imshow(rgb)

hdr = makehdr(files,'MinimumLimit',10,'MaximumLimit',255,'RelativeExposure',[2,1]);
rgb = tonemap(hdr);
subplot(3,2,3);
imhist(rgb)
subplot(3,2,4);
imshow(rgb)
imwrite(rgb,'hdr.png');

hdr = makehdr(files,'MinimumLimit',30,'MaximumLimit',255,'RelativeExposure',[2,1]);
rgb = tonemap(hdr);
subplot(3,2,5);
imhist(rgb)
subplot(3,2,6);
imshow(rgb)

% figure(3)
% I = imread('hdr.png');
% J = adapthisteq(I,'clipLimit',0.01,'Distribution','rayleigh');
% imshowpair(I,J,'montage');
% title('Original Image (left) and Contrast Enhanced Image (right)')


