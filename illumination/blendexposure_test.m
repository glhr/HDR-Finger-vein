close all;
clear all;

files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png', 'img_evaltests/dataset2/segment_cropped (3).png',... 
         'img_evaltests/dataset2/segment_cropped (4).png', 'img_evaltests/dataset2/segment_cropped (5).png'};

for i = 1:numel(files)
    path = cell2mat(files(i));
    img{i} = imread(path);
end


figure;
montage(files);

result = blendexposure(img{1},img{2},img{3},img{4},img{5},'contrast',1,...
    'saturation',0,'wellexposedness',0,'reduceStrongLight',false);
figure;
imshow(result);