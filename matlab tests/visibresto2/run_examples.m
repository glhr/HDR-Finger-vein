clear all
% Gray level example of visibility restoration
% img = imread('../cropped_4.png');
% img = imresize(img,0.25); 
% im = im2double(img);
% sv=2*floor(max(size(im))/25)+1;
% % ICCV'2009 paper result (NBPC)
% res=nbpc(im,40,0.9,0.5,1,1.0);
% figure;imshow([im, res],[0,1]);
% % IV'2010 paper result (NBPC+PA)
% res2=nbpcpa(im,40,0.9,0.5,1,1.0,70,200);
% figure;imshow([im, res2],[0,1]);

clear all
% Color example of visibility restoration
img = imread('../cropped_4.png');
img = imresize(img,0.25); 
im = im2double(img);
sv=2*floor(max(size(im))/50)+1;
% ICCV'2009 paper result (NBPC)
res=nbpc(im,40,0.8,0.5,1,1.3);
figure;imshow([im, res],[0,1]);
% IV'2010 paper result (NBPC+PA)
res2=nbpcpa(im,40,0.8,0.5,1,1.3,205,300);
figure;imshow([im, res2],[0,1]);
imwrite(res2,'dehazed.png')




