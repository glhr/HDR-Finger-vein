refdataset = 'dataset5';
inputdataset = 'dataset1';

template = imread(strcat('img_evaltests/dataset5/maxcurve_hdr_[1 5]_movmean_2.8.png'));
ref1 = imread(strcat('img_evaltests/',refdataset,'/maxcurve_hdr_[1 5]_movmean_2.8.png'));
ref2 = imread(strcat('img_evaltests/',refdataset,'/maxcurve_hdr_[1 3]_movmean_2.8.png'));
ref3 = imread(strcat('img_evaltests/',refdataset,'/maxcurve_hdr_[2 5]_movmean_2.8.png'));
ref4 = imread(strcat('img_evaltests/',refdataset,'/maxcurve_hdr_[1 1]_movmean_2.8.png'));
ref5 = imread(strcat('img_evaltests/',refdataset,'/maxcurve_hdr_[10 1]_movmean_2.8.png'));
ref6 = imread(strcat('img_evaltests/',refdataset,'/maxcurve_hdr_[10 10]_movmean_2.8.png'));

test = ref1 + ref2 + ref3 + ref4 + ref5 + ref6;
test = uint8(255*mat2gray(test));
test = test > 255/6;
imshow(test);

input = imread(strcat('img_evaltests/',inputdataset,'/maxcurve_hdr_[1 5]_movmean_2.8.png'));

score = miura_match(input, test, 20, 20);