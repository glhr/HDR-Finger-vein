clear all;
close all;
clc;

%% Connect to Raspberry Pi Board, Address, User, Password
%rpi = raspi('169.254.0.2', 'pi', 'raspberry'); 
rpi = raspi('130.89.237.20', 'pi', 'raspberry');

%% exposure settings
% fireworks -> good lighting but no detail
% spotlight -> way too dark

resolution = '800x600'; %'160x120', '320x240', '640x480', '800x600', '1024x768', '1280x720', '1920x1080'
exposure = 'night';
awb = 'auto';
metering = 'average';
exposure_comp = 0;
effect = 'negative';

%% Create cameraobject and set camera options
cam = cameraboard(rpi, 'Resolution',resolution, 'Quality', 100);
cam.Rotation = 180;
cam.Brightness = 52;
cam.Contrast = 90;
cam.Sharpness = 0;
cam.Saturation = 0;
cam.ExposureMode= exposure;
%'auto' (default) | 'night' | 'nightpreview' | 'backlight' | 'spotlight' | 'sports' | 'snow' | 'beach' | 'verylong' | 'fixedfps' | 'antishake' | 'fireworks'
cam.ExposureCompensation= 0;
%cam.ColorEffects = [128 128];
cam.AWBMode = awb;
%'auto (default) | 'off' | 'sun' | 'cloud' | 'shade' | 'tungsten' | 'fluorescent' | 'incandescent' | 'flash' | 'horizon'
cam.MeteringMode = metering;
%cam.ROI = [0.04 0.1 0.81 0.8];
cam.ROI = [0 0 1 1];

%% Set I2C speed and connect with the LED driver
disableI2C(rpi)
enableI2C(rpi,400000)
buses = char(rpi.AvailableI2CBuses);
busspeed = rpi.I2CBusSpeed;
address = char(scanI2CBus(rpi, buses));
LED_driver = i2cdev(rpi,buses,address);
 
%figure('pos',[20 20 1600 600]); %set aspect ratio and position of figure window

%TurnOffLed(LED_driver);

% Test effect of varying the intensity of a single LED at a time
% for j = 1:8
%     if(j>1)
%         setLed(LED_driver, j+6, 0);
%     end
%     for pwm = 0:100:1023
%         setLed(LED_driver, j+7, pwm);
%         frame = rgb2gray(snapshot(cam));
%         %imagesc(frame);
%         %colormap('gray');
%         %drawnow;
%         imwrite(frame, strcat('img_illum/black comparison/thumb_indiv_', num2str(j), '_',num2str(pwm),'_black.png'),'png', 'bitdepth', 8);
%     end
% end

TurnOffLed(LED_driver);

cam.MeteringMode = 'average';

%% Test different levels of homogeneous illumination
for pwm = 0:100:1023
    for j = 1:8
        setLed(LED_driver, j+7, pwm);
        frame = rgb2gray(snapshot(cam));
        %imagesc(frame);
        %colormap('gray');
        %drawnow;
    end
    imwrite(frame, strcat('img_illum/black comparison/thumb_global_',num2str(pwm),'_black_lowres_avg.png'), 'png','bitdepth', 8);
end

%% Done
TurnOffLed(LED_driver)

%% setLed turn the LED on channel on with the value.
%byte1 are 8 top bits of value and byte2 are the 8 lower bits of value.  
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

function TurnOffLed(LED_driver)
    write(LED_driver, [16 0 0]);
end
