clear all;
clc;
close all;

%Variables:
captionFontSize = 14;

%Load image 
filename = 'resized_demo_180212-162529.png';
originalImage = imread(filename);
originalImage = rgb2gray(originalImage);
figure(1);
imshow(originalImage);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;
caption = sprintf('Original finger vein image');
title(caption, 'FontSize', captionFontSize);
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.

% Just for fun, let's get its histogram and display it.
[pixelCount, grayLevels] = imhist(originalImage);
figure(2);
bar(pixelCount);
filename2 = strcat( 'bar_', filename);
print(filename2, '-dpng');
title('Histogram of original image', 'FontSize', captionFontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
grid on;

%'NumLevels', 255, 'GrayLimits',[min(originalImage(:)) max(originalImage(:))],
[glcm SI]  = graycomatrix(originalImage,'NumLevels', 255, 'GrayLimits',[], 'offset', [2 0;0 2], 'symmetric', true);
stats = graycoprops(glcm);
Contrast=mean(stats.Contrast)
Correlation=mean(stats.Correlation)
Energy = mean(stats.Energy)
Homogeneity= mean(stats.Homogeneity)
meant =mean2(originalImage);
figure(3);
imshow(uint8(SI));

% % Threshold the image to get a binary image (only 0's and 1's) of class "logical."
% thresholdValue = 150;
% binaryImage = originalImage > thresholdValue;
% 
% 
% % Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
% binaryImage = imfill(binaryImage, 'holes');
% 
% % Show the threshold as a vertical red bar on the histogram.
% hold on;
% maxYValue = ylim;
% line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
% % Place a text label on the bar chart showing the threshold.
% annotationText = sprintf('Thresholded at %d gray levels', thresholdValue);
% % For text(), the x and y need to be of the data class "double" so let's cast both to double.
% text(double(thresholdValue + 5), double(0.5 * maxYValue(2)), annotationText, 'FontSize', 10, 'Color', [0 .5 0]);
% text(double(thresholdValue - 70), double(0.94 * maxYValue(2)), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
% text(double(thresholdValue + 50), double(0.94 * maxYValue(2)), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);
% 
% % Display the binary image.
% subplot(3, 3, 3);
% imshow(binaryImage); 
% title('Binary Image, obtained by thresholding', 'FontSize', captionFontSize); 
% 
% 
%     kern = [1 2 1; 0 0 0; -1 -2 -1];
%     h = conv2(originalImage,kern,'same');
%     v = conv2(originalImage,kern','same');
%     e = sqrt(h.*h + v.*v);
%     edgeImg = uint8((e > 140) * 240);
% % Display the binary image.
% subplot(3, 3, 4);
% imshow(edgeImg); 
% title('Binary Image, obtained by thresholding', 'FontSize', captionFontSize); 
% 
% 
img=im2double(originalImage);
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
subplot(3,3,7)
  imshow(img,[])
  title('Original image')
subplot(3,3,8)
  imshow(fvr)
  title('Finger region')
subplot(3,3,9)
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
