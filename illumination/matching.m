refdataset = 'dataset5';
inputdataset = 'dataset4';

% ref = imread(strcat('img_evaltests/dataset4/combinedpattern_3.png'));
% input = imread(strcat('img_evaltests/dataset1/combinedpattern_3.png'));


ref = imread(strcat('img_evaltests\dataset5\maxcurve_hdr_[1 1]_movmean_2.8_imadjust.png'));
input = imread(strcat('img_evaltests\dataset5\maxcurve_hdr_[1 1]_movmean_2.8_histeq.png'));

score = miura_match(input, ref, 20, 20);