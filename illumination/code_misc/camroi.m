clear all;
close all;
clc;

rpi = raspi('169.254.0.2', 'pi', 'raspberry');
cam = cameraboard(rpi, 'Resolution','1920x1080', 'Quality', 100);
cam.Rotation=180;
cam.Brightness=52;
cam.Contrast = 90;
cam.Sharpness = 0;
cam.Saturation = 0;
cam.ExposureMode= 'night';
cam.ExposureCompensation= 0;
cam.AWBMode = 'auto';
cam.MeteringMode = 'average';

figure(1);
roi = [0 0 1 1];
cam.ROI = [0 0 1 1];
for i = 1:10
    img = snapshot(cam);
end
subplot(211);
image(img);
drawnow;
rect = rectangle('Position',[1 1 320 240]);
rect.EdgeColor = 'red';
for i = 1:200
   img = snapshot(cam);
   if i > 20
      fc = (i - 5)*0.0025;
      roi(1:2) = [fc, fc];
      roi(3:end) = [1-fc, 1-fc];
      cam.ROI = roi;
      subplot(211);
      rect.Position = roi.*[320 240 320 240];
      drawnow;
      subplot(212);
      image(img);
      drawnow;
   end
end