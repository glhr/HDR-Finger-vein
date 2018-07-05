clear all;
close all;
img = imread('img_evaltests/dataset17/segment (1).png');

img = img(180:400,200:660);

img = img(:,:,1);
%img3=im2double(imresize(img,[340 NaN]));
img3=im2double(img);
mask_height=2; % Height of the mask
mask_width=2; % Width of the mask
[fvr, edges] = lee_region(img3,mask_height,mask_width);

% Create a nice image for showing the edges
edge_img = zeros(size(img3));
edge_img(edges(1,:) + size(img3,1)*(0:size(img3,2)-1)) = 1;
edge_img(edges(2,:) + size(img3,1)*(0:size(img3,2)-1)) = 1;

rgb = zeros([size(img3) 3]);
rgb(:,:,1) = (img3 - img3.*edge_img) + edge_img;
rgb(:,:,2) = (img3 - img3.*edge_img);
rgb(:,:,3) = (img3 - img3.*edge_img);
figure;
imshow(rgb)


%% Image for report

[imgn,fvrn,rot,tr] = huang_normalise(img3,fvr,edges);
fit_line = zeros(size(img3));
for i=1:size(img3,2)
    y = -1*tand(rot)*i - tr + size(img3,1)/2;
    fit_line(round(y),i) = 1;
end

rgb = zeros([size(img3) 3]);
rgb(:,:,1) = (img3 - img3.*edge_img) + edge_img;
rgb(:,:,2) = (img3 - img3.*fit_line) + fit_line;
rgb(:,:,3) = img3;
figure;
imshowpair(rgb,imgn,'montage');