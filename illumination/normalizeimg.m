global dataset
dataset = 'dataset6';

for i = 1:16
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
        if(strcmp(dataset,'dataset5') || strcmp(dataset,'dataset4'))
            output = img(250:360,218:640);
        elseif(strcmp(dataset,'dataset6') )
            output = img(265:365,218:640);
        elseif(strcmp(dataset,'dataset7') )
            output = img(245:355,218:640);
        end
        output = imresize(output, [100 NaN]);
        imwrite(output,strcat(path,'segment_cropped (',num2str(i),').png'));
    else
        output = img;
    end
end

