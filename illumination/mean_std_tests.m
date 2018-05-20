close all
clear all

files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png',...
        'img_evaltests/dataset2/segment_cropped (3).png', 'img_evaltests/dataset2/segment_cropped (4).png',...
        'img_evaltests/dataset2/segment_cropped (5).png'};

for i = 1:numel(files)
    path = cell2mat(files(i));
    img = imread(path);
    std = std2(img);
    mean = mean2(img);
    subplot(numel(files),1,i),imshow(img);
    title(sprintf("mean: %i, std: %i",mean,std));
end