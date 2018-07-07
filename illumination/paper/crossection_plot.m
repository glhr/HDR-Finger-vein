close all
clear all
I = imread('results/hdrimpl/global_tonemap.png');
[row , column, dim] = size(I);
imshow(I)
[x , ~] = ginput(1)
x = uint8(x);
figure;
plot(1:row , I(:, x))

