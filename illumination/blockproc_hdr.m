close all
clear all

files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png', 'img_evaltests/dataset2/segment_cropped (3).png',... 
         'img_evaltests/dataset2/segment_cropped (4).png', 'img_evaltests/dataset2/segment_cropped (5).png'};
expTimes = [0.0333, 0.1000, 0.3333, 0.6250, 1.3000];
images = {};

for i = 1:5
    path = cell2mat(files(i));
    images{i} = imread(path);
    img = images{i};
	expTimes(i) = mean(img(:));
end

montage(files)
hdr = makehdr_mod(files,images,'RelativeExposure',expTimes./expTimes(1));
figure;
imshow(hdr)
rgb = tonemap(hdr);
figure;
imshow(rgb)