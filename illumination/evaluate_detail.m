close all;
clear all;

img = imread('img_old/cropped_4.png');
img = img(100:400,:);
[nrows, ncols, dim] = size(img);
imgrange = [0 255];

figure;
subplot(3,1,1),imshow(img);

radius = 5;
J1 = fspecial('disk', radius);
filtered_img = imfilter(img,J1,'replicate');
subplot(3,1,2),imshow(filtered_img);

[Gx, Gy] = imgradient(filtered_img,'prewitt');
subplot(3,1,3),imshowpair(Gx, Gy, 'montage');