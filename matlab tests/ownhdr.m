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

img1 = imread('resized_2.png');
img2 = imread('resized_3.png');
img3 = (img1./2 + img2./2);
figure(2)
imshow(img3)