clear rpi;
clear cam;
clear LED_driver;
clear all;
close all;
clc;

%% Connect to Raspberry Pi Board, Address, User, Password
rpi = raspi('192.168.1.103', 'pi', 'raspberry'); 

% Create cameraobject and set camera options
cam = cameraboard(rpi, 'Resolution','1920x1080', 'Quality', 100);
cam.Rotation=180;
cam.Brightness=52;
cam.Contrast = 90;
cam.Sharpness = 0;
cam.Saturation = 0;
cam.ExposureMode= 'night';
cam.ExposureCompensation= 0;
%cam.ColorEffects = [128 128];
cam.AWBMode = 'auto';
cam.MeteringMode = 'average';
cam.ROI = [0.04 0.1 0.81 0.8];
%Available exposure modes: 'off', 'auto', 'night', 'nightpreview', 'backlight', 'spotlight', 'sports', 'snow', 'beach', 'verylong', 'fixedfps', 'antishake', 'fireworks'

%% Set I2C speed and connect with the LED driver
disableI2C(rpi)
enableI2C(rpi,400000)
buses = char(rpi.AvailableI2CBuses);
busspeed = rpi.I2CBusSpeed;
address = char(scanI2CBus(rpi, buses));
LED_driver = i2cdev(rpi,buses,address);

%% Led positions 
led_pos = zeros(8,2);
led_pos(:,2) = [540, 540, 540, 540, 540, 540, 540, 540]; % y
led_pos(:,1) = [140, 380, 620, 860, 1100, 1340, 1580, 1820]; % x
r = 60; %Measuring radius for grayvalue

% the thresholds
    grey_thr=[115,125,130,130,130,130,125,115];
    grey_dev=0.2;   

%See if camera is working
for i = 1:2
    img = snapshot(cam);
    img2 = rgb2gray(img);
    imagesc(img2);
    colormap('gray');
    drawnow;
end
 
%% Adjusting LEDs
  done = false;
  pwm = [400 400 400 400 400 400 400 400];
  pwm_step_size = 10;
  max_pwm = 1024;
  iter = 60;
    while ~done
        iter = iter-1;
        frame = rgb2gray(snapshot(cam));
        imagesc(frame);
        colormap('gray');
        drawnow;
        for j = 1:8  
        %fprintf('Adjusting LED: %d ...', j);
        p(:,:,j) = frame(led_pos(j,2) - r:led_pos(j,2) + r, led_pos(j,1) - r:led_pos(j,1) + r);
        mgi(j) = mean2(p(:,:,j));
        stds(j) = std2(p(:,:,j));
           if mgi(j) < grey_thr(j)
                %To dark
                pwm(j) = pwm(j) + pwm_step_size;
                if pwm(j) > max_pwm
                    pwm(j) = max_pwm;
                end
           else
                %To light
                pwm(j) = pwm(j) - pwm_step_size;
                if pwm(j) < 0
                    pwm(j) = 0;
                end
           end
           setLed(LED_driver, j+7, pwm(j)); 
           pause(1/100);
        end
        if iter == 0
            done = true;
            TurnOffLed(LED_driver)
        end
    end
fprintf(' done !\n');
output = read(LED_driver,3);
dt = datestr(now, 'yymmdd-HHMMSS');
imwrite(frame, strcat('demo_', dt, '.png'), 'bitdepth', 8);

img3=im2double(imresize(frame,[340 638]));
mask_height=4; % Height of the mask
mask_width=20; % Width of the mask
[fvr, edges] = lee_region(img3,mask_height,mask_width);

% Create a nice image for showing the edges
edge_img = zeros(size(img3));
edge_img(edges(1,:) + size(img3,1)*[0:size(img3,2)-1]) = 1;
edge_img(edges(2,:) + size(img3,1)*[0:size(img3,2)-1]) = 1;

rgb = zeros([size(img3) 3]);
rgb(:,:,1) = (img3 - img3.*edge_img) + edge_img;
rgb(:,:,2) = (img3 - img3.*edge_img);
rgb(:,:,3) = (img3 - img3.*edge_img);

% Show the original, detected region and edges in one figure
% subplot(3,3,1)
%   imagesc(img3)
%   colormap('gray');
%   title('Original image')
% subplot(3,3,2)
%   imagesc(fvr)
%   colormap('gray');
%   title('Finger region')
% subplot(3,3,3)
%   imagesc(rgb)
%   title('Finger edges')
  
%% Image for report

[imgn,fvrn,rot,tr] = huang_normalise(img3,fvr,edges);
fit_line = zeros(size(img3));
for i=1:size(img3,2)
    y = -1*tand(rot)*i - tr + size(img3,1)/2;
    fit_line(round(y),i) = 1;
end

rgb = zeros([size(img3) 3]);
rgb(:,:,1) = (img3 - img3.*edge_img) + edge_img;
rgb(:,:,2) = (img3 - img3.*fit_line) + fit_line;
rgb(:,:,3) = img3;
imagesc(rgb)


%%setLed turn the LED on channel on with the value. byte1 are 8 top bits of value and byte2 are the 8 lower bits of value.  
function setLed(LED_driver, channel, value)
    if (channel > 7 && channel < 16)
        if (value > 0 && value < 1024)
            byte1 = bitshift(value,-8);
            byte2 = bitand(value, 255);
            write(LED_driver, [channel byte1 byte2]);
        end
    end
end
%%
function TurnOffLed(LED_driver)
    write(LED_driver, [16 0 0]);
end
