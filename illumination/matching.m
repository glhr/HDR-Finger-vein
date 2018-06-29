refdataset = 'dataset5';
inputdataset = 'dataset4';

ref = imread(strcat('img_evaltests/dataset4/combinedpattern_3.png'));
input = imread(strcat('img_evaltests/dataset1/combinedpattern_3.png'));

score = miura_match(input, ref, 20, 20);