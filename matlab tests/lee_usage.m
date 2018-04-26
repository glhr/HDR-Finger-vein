% This script shows how the finger region and edges can be detected.

img = im2double(imread('2.png')); % Read image
%img = imresize(img, 0.5);              % Downscale image

mask_height=4; % Height of the mask
mask_width=20; % Width of the mask
[fvr, edges] = lee_region(img,mask_height,mask_width);

% Create a nice image for showing the edges
edge_img = zeros(size(img));
edge_img(edges(1,:) + size(img,1)*[0:size(img,2)-1]) = 1;
edge_img(edges(2,:) + size(img,1)*[0:size(img,2)-1]) = 1;

rgb = zeros([size(img) 3]);
rgb(:,:,1) = (img - img.*edge_img) + edge_img;
rgb(:,:,2) = (img - img.*edge_img);
rgb(:,:,3) = (img - img.*edge_img);

% Show the original, detected region and edges in one figure
figure;
subplot(3,1,1)
  imshow(img,[])
  title('Original image')
subplot(3,1,2)
  imshow(fvr)
  title('Finger region')
 subplot(3,1,3)
  imshow(rgb)
  title('Finger edges')
  
%% Image for report
[imgn,fvrn,rot,tr] = huang_normalise(img,fvr,edges);
fit_line = zeros(size(img));
for i=1:size(img,2)
    y = -1*tand(rot)*i - tr + size(img,1)/2;
    fit_line(round(y),i) = 1;
end

rgb = zeros([size(img) 3]);
rgb(:,:,1) = (img - img.*edge_img) + edge_img;
rgb(:,:,2) = (img - img.*fit_line) + fit_line;
rgb(:,:,3) = img;
figure; imshow(rgb)

