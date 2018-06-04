close all
clear all
addpath('code_miura');
[img, maxcurve, repeatedline] = miura_usage('img_evaltests/dataset5/hdr_[1 5].png',4000,6,9);
figure(1)
subplot(3,1,1)
  imshow(img,[])
  title('Original captured image')
subplot(3,1,2)
  imshow(maxcurve)
  title('Maximum curvature method')  
subplot(3,1,3)
  imshow(repeatedline)
  title('Repeated line tracking method')
  
% [img2, maxcurve2, repeatedline2] = miura_usage('cropped_3.png',3000, 1, 21);
% subplot(3,2,2)
%   imshow(img2,[])
%   title('Original captured image')
% subplot(3,2,4)
%   imshow(maxcurve2)
%   title('Maximum curvature method')  
% subplot(3,2,6)
%   imshow(repeatedline2)
%   title('Repeated line tracking method')