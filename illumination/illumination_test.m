clear all;
close all;
clc;

%% Connect to Raspberry Pi Board, Address, User, Password
rpi = raspi('169.254.0.2', 'pi', 'raspberry'); 

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
%cam.ROI = [0.04 0.1 0.81 0.8];
cam.ROI = [0 0 1 1];
%Available exposure modes: 'off', 'auto', 'night', 'nightpreview', 'backlight', 'spotlight', 'sports', 'snow', 'beach', 'verylong', 'fixedfps', 'antishake', 'fireworks'

%% Set I2C speed and connect with the LED driver
disableI2C(rpi)
enableI2C(rpi,400000)
buses = char(rpi.AvailableI2CBuses);
busspeed = rpi.I2CBusSpeed;
address = char(scanI2CBus(rpi, buses));
LED_driver = i2cdev(rpi,buses,address);
 
figure('pos',[20 20 1600 600]);
%% Adjusting LEDs
  done = false;

for j = 1:8
    if(j>1)
        setLed(LED_driver, j+6, 0);
    end
    for pwm = 0:20:1023
        setLed(LED_driver, j+7, pwm);
        frame = rgb2gray(snapshot(cam));
        imagesc(frame);
        colormap('gray');
        drawnow;
        imwrite(frame, strcat('img_illum/indiv_', j, '_',pwm_,'.png'), 'bitdepth', 8);
    end
end

for pwm = 0:20:1023
    for j = 1:8
        setLed(LED_driver, j+7, pwm);
        frame = rgb2gray(snapshot(cam));
        imagesc(frame);
        colormap('gray');
        drawnow;
        imwrite(frame, strcat('img_illum/global_',pwm_,'.png'), 'bitdepth', 8);
    end
end

TurnOffLed(LED_driver)

%%setLed turn the LED on channel on with the value. byte1 are 8 top bits of value and byte2 are the 8 lower bits of value.  
function setLed(LED_driver, channel, value)
    if (channel > 7 && channel < 16)
        if (value < 0 && value < 1024)
            value = 0;
        elseif (value >= 1024)
            value = 1023;
        end
        byte1 = bitshift(value,-8);
        byte2 = bitand(value, 255);
        if(channel == 8)
            fprintf('\nChannel: %i\t\t | Value: %i\t\t | Bytes: %i %i ', channel, value, byte1, byte2);
        end
        write(LED_driver, [channel byte1 byte2]);
    end
end
%%
function TurnOffLed(LED_driver)
    write(LED_driver, [16 0 0]);
end
