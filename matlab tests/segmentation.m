clear all;

img = imread('cropped_4.png');
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
imshow(reconstructed_img,imgrange);