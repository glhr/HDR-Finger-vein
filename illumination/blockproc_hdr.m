close all
clear all

files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png', 'img_evaltests/dataset2/segment_cropped (3).png',... 
         'img_evaltests/dataset2/segment_cropped (4).png', 'img_evaltests/dataset2/segment_cropped (5).png'};

%files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png'};
metafile = {'img_evaltests/dataset2/segment4meta.png','img_evaltests/dataset2/segment4meta.png'};
expTimes = [];
images = {};
n_segments = 2;

for i = 1:numel(files)
    path = cell2mat(files(i));
    img = imread(path);
    segments = segmentimg(img,n_segments);
    images{i} = segments{1};
    img = images{i};
	expTimes(i) = mean(img(:));
end

montage(files)
hdr = makehdr_mod(metafile,images,'RelativeExposure',expTimes./expTimes(1));
%figure, imshow(hdr); %was just curious what it looks like
rgb = tonemap(hdr);
figure;
imshow(rgb)

function output = segmentimg(img,divisions_vertical)
    output = cell(1,divisions_vertical);
    [nrows, ncols, dim] = size(img);
    for n = 1:divisions_vertical
        output{n} = img(:,((n-1)*floor(ncols/divisions_vertical))   +1:n*floor(ncols/divisions_vertical),:);
    end
    imwrite(output{1},'img_evaltests/dataset2/segment4meta.png');
end