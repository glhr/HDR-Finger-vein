clear all;
% paper split
img = imread('4.png');
[nrows, ncols, dim] = size(img);
% Get the slices colums wise split equally
divisions_vertical = 6;
segments = [];
reconstructed_img = [];
figure
for n = 1:divisions_vertical
    segments(:,:,:,n) = img(:,((n-1)*ncols/divisions_vertical)   +1:n*ncols/divisions_vertical,:);
    subplot(1,divisions_vertical,n), imshow(segments(:,:,:,n),[]);
    reconstructed_img = horzcat(reconstructed_img, segments(:,:,:,n));
end


figure
imshow(reconstructed_img, []);