for i = 1:21
path = strcat('img_evaltests/dataset4/segment (',num2str(i),').png');
resizeimg(path);
end

function output = resizeimg(imgpath)
global resolution
    img = imread(imgpath);
    [height, width, dim] = size(img);
    resolution = width;
    if (height == 1080 && width == 1920)
        fprintf('Input image size: 1080 x 1920\n');
        output = img(380:680,240:1450);
        output = imresize(output, [75 NaN]);
        imwrite(output,strcat(imgpath,'_cropped.png'));
    elseif(height == 600 && width == 800)
        fprintf('Input image size: 600 x 800\n');
        output = img(250:360,218:640);
        output = imresize(output, [75 NaN]);
        imwrite(output,strcat(imgpath,'_cropped.png'));
    else
        output = img;
    end
end

