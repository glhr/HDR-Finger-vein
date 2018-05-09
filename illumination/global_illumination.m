clear all;
close all;
clc;

addpath code_fingerROI

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

%% Led positions 
led_pos = zeros(8,2);
led_pos(:,2) = [300 300 300 300 300 300 300 300];
led_pos(:,1) = [100 310 420 530 640 750 860 970];
%led_pos(:,2) = [540, 540, 540, 540, 540, 540, 540, 540]; % y
%led_pos(:,1) = [140, 380, 620, 860, 1100, 1340, 1580, 1820]; % x

r = 40; %Measuring radius for grayvalue
grey_thr=120;
   
%See if camera is working
% for i = 1:2
%     img = snapshot(cam);
%     img = rgb2gray(img);
%     img = img(220:820,10:1700);
%     imagesc(img);
%     colormap('gray');
%     drawnow;
% end
 
figure('pos',[20 20 1600 600]);
%% Adjusting LEDs
done = false;
pwm = [800 1 1 1 1 1 1 1];

        
pwm_step_size = 10;
max_pwm = 1023;
iter = 60;
maxcount = 0;
mincount = 0;

while ~done
    iter = iter-1;
    frame = rgb2gray(snapshot(cam));
    frame = frame(230:830,20:1680);
    imagesc(frame);
    colormap('gray');
    drawnow;

    mgi = mean2(frame(:,:));
    stds = std2(frame(:,:));
    for j = 1:8  
    setLed(LED_driver, j+7, pwm(j));
    end

    fprintf('\nThreshold: %i\t | MGI: %.1f\t\t | STD %.1f\t\t', grey_thr, mgi, stds);

       if mgi < (grey_thr-5)
            %Too dark
            fprintf('--> too dark, increasing PWM');
            pwm = pwm + 20;
            if pwm >= max_pwm
                fprintf(' (setting PWM to max)');
                maxcount = maxcount+1;
            end

       elseif mgi > (grey_thr+5)
            fprintf('--> too light, decreasing PWM');
            pwm = pwm - 20;

            if pwm <= 0
                pwm = 0;
                fprintf(' (setting PWM to min)');
                mincount = mincount + 1;
            end

       else
           fprintf('--> illumination is fine');
       end
       if (maxcount > 1)
           done = true;
       end
       if (mincount > 1)
           done = true;
       end

    end
    if iter == 0
        done = true;
    end

TurnOffLed(LED_driver)
fprintf(' done calibrating !\n');



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
