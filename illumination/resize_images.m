clear all;
clc;
filename = 'demo_180212-172616_cutout.png';
originalImage = imread(filename);
resi= imresize(originalImage, (1/3.1) );
imwrite(resi, strcat('resized_',filename), 'bitdepth', 8);