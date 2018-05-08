close all;
clear all;

img_good = imread('img_evaltests/dehazed.png');
img_bad = imread('img_evaltests/shitty_dehazed.png');
%img = img(100:400,:);

figure;


radius = 5;
J1 = fspecial('disk', radius);
filtered_img_good = imfilter(img_good,J1,'replicate');
filtered_img_bad = imfilter(img_bad,J1,'replicate');


[Gx_good, Gy_good] = imgradient(filtered_img_good,'prewitt');
[Gx_bad, Gy_bad] = imgradient(filtered_img_bad,'prewitt');

subplot(3,2,1),imshow(img_good);
subplot(3,2,2),imshow(img_bad);
subplot(3,2,3),imshow(filtered_img_good);
subplot(3,2,4),imshow(filtered_img_bad);
subplot(3,2,5),imshowpair(Gx_good, Gy_good, 'montage');
subplot(3,2,6),imshowpair(Gx_bad, Gy_bad, 'montage');

figure
subplot(2,2,1),hist(Gx_good)
subplot(2,2,2),hist(Gy_good)
subplot(2,2,3),hist(Gx_bad)
subplot(2,2,4),hist(Gy_bad)