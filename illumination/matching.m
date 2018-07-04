refdataset = 'dataset5';
inputdataset = 'dataset4';

% ref = imread(strcat('img_evaltests/dataset4/combinedpattern_3.png'));
% input = imread(strcat('img_evaltests/dataset1/combinedpattern_3.png'));

folder = 'img_evaltests\matching\';
file1 = '3left_dataset4';
file2 = '3right_dataset11';
ref = imread(strcat(folder,file1,'.png'));
input = imread(strcat(folder,file2,'.png'));

score = miura_match(input, ref, 30, 30)