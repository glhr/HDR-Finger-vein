close all
clear all

files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png', 'img_evaltests/dataset2/segment_cropped (3).png',... 
         'img_evaltests/dataset2/segment_cropped (4).png', 'img_evaltests/dataset2/segment_cropped (5).png'};

%files = {'img_evaltests/dataset2/segment_cropped (1).png', 'img_evaltests/dataset2/segment_cropped (2).png'};
metafile = {'img_evaltests/dataset2/segment4meta.png','img_evaltests/dataset2/segment4meta.png'};
expTimes = [];
n_segments = 4;
images = cell(n_segments,numel(files));

for i = 1:numel(files)
    path = cell2mat(files(i));
    img = imread(path);
    segments = segmentimg(img,n_segments);
    
    for j=1:n_segments
        images{j,i} = segments{j};
        exposures{j}(i) = mean(images{j,i}(:));
    end
	
end

montage(files)


%%plot HDR output for each segments
figure;
for i=1:n_segments
    exp_normalized{i} = exposures{i}./exposures{i}(1);
    hdr{i} = makehdr_mod(metafile,images(i,:),'RelativeExposure',exp_normalized{i});
    %figure, imshow(hdr); %was just curious what it looks like
    rgb{i} = tonemap(hdr{i});
    subplot(1,n_segments,i);
    imshow(rgb{i});
end

function output = segmentimg(img,divisions_vertical)
    output = cell(1,divisions_vertical);
    [nrows, ncols, dim] = size(img);
    for n = 1:divisions_vertical
        output{n} = img(:,((n-1)*floor(ncols/divisions_vertical))   +1:n*floor(ncols/divisions_vertical),:);
    end
    imwrite(output{1},'img_evaltests/dataset2/segment4meta.png');
end