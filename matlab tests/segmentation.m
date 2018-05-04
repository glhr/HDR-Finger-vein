clear all;
% paper split
img = imread('4.png');
%imshow(img, []);
[nrows, ncols, dim] = size(img);
% Get the slices colums wise split equally
divisions_vertical = 4;
segments1 = [];
figure
for n = 1:divisions_vertical
    segments(:,:,:,n) = img(:,((n-1)*ncols/divisions_vertical)   +1:n*ncols/divisions_vertical,:);
    subplot(1,divisions_vertical,n), imshow(segments(:,:,:,n),[]);
end

reconstructed_img = [segments(:,:,:,1) segments(:,:,:,2) segments(:,:,:,3) segments(:,:,:,4)];
figure
imshow(reconstructed_img, []);