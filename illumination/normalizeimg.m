path = 'img_evaltests/dataset2/segment (6).png';
resizeimg(path);

function output = resizeimg(imgpath)
global resolution
    img = imread(imgpath);
    [height, width, dim] = size(img);
    resolution = width;
    if (height == 1080 && width == 1920)
        fprintf('Input image size: 1080 x 1920\n');
        output = img(380:680,240:1450);
        output = imresize(output, [75 NaN]);
        imwrite(output,strcat(imgpath,'cropped.png'));
    elseif(height == 600 && width == 800)
        fprintf('Input image size: 600 x 800\n');
        output = img(260:335,175:575);
        %output = imresize(output, [75 NaN]);
    else
        output = img;
    end
end