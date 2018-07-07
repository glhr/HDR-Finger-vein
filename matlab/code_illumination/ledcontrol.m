clear all;
close all;
clc;

%% Connect to Raspberry Pi Board, Address, User, Password
rpi = raspi('192.168.1.103', 'pi', 'raspberry'); 
%rpi = raspi('130.89.237.20', 'pi', 'raspberry');

%% Set I2C speed and connect with the LED driver
disableI2C(rpi)
enableI2C(rpi,400000)
buses = char(rpi.AvailableI2CBuses);
busspeed = rpi.I2CBusSpeed;
address = char(scanI2CBus(rpi, buses));
LED_driver = i2cdev(rpi,buses,address);

TurnOffLed(LED_driver);

pwms = [1 0 1 0 2 0 1 0];

%% Test different levels of homogeneous illumination
while(1)
for pwm = 0:100:1000
    for j = 1:8
        setLed(LED_driver, j+7, pwms(j)*pwm);
        %imagesc(frame);
        %colormap('gray');
        %drawnow;
    end
    pause(1);
end
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
