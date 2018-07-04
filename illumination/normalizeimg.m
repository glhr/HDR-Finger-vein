global dataset
dataset = 'dataset5';

nimages = 16;
if(strcmp(dataset,'dataset5') || strcmp(dataset,'dataset4'))
    nimages = 21;
elseif(strcmp(dataset,'dataset12') || strcmp(dataset,'dataset13') || ...
        strcmp(dataset,'dataset14') || strcmp(dataset,'dataset15') || ...
        strcmp(dataset,'dataset16') || strcmp(dataset,'dataset17'))
    nimages = 15;
end
    
for i = 1:nimages
%path = strcat('img_evaltests/dataset5/segment (',num2str(i),').png');
path = strcat('img_evaltests/',dataset,'/');
resizeimg(path,i);
end

function output = resizeimg(path,i)
global resolution dataset
    imgpath = strcat(path,'segment (',num2str(i),').png');
    img = imread(imgpath);
    [height, width, dim] = size(img);
    resolution = width;
    if (height == 1080 && width == 1920)
        fprintf('Input image size: 1080 x 1920\n');
        output = img(380:680,240:1450);
        output = imresize(output, [75 NaN]);
        imwrite(output,strcat(path,'segment_cropped (',num2str(i),').png'));
    elseif(height == 600 && width == 800)
        fprintf('Input image size: 600 x 800\n');
        output = cropimg(dataset,img);
        imwrite(output,strcat(path,'segment_cropped (',num2str(i),').png'));
    else
        output = img;
    end
end

