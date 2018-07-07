close all;
new = imread('C:\Users\Gebruiker\Documents\werk\MOD12\code\HDR-Finger-vein\illumination\img_evaltests\qualityeval\new16.png');
old = imread('C:\Users\Gebruiker\Documents\werk\MOD12\code\HDR-Finger-vein\illumination\img_evaltests\qualityeval\oldcropped.png');

dh = 52;
dw = 52;
new_crop = new(53-dh:53 + dh,180-dw:180+dw);


hdr_crop = hdr(53-dh:53 + dh,180-dw:180+dw);


hdrg_crop = hdr_global(53-dh:53 + dh,180-dw:180+dw);


old_crop = old(58-dh:58 + dh,223-dw:223+dw);
imshow([old_crop new_crop hdrg_crop hdr_crop ]);

qualitymetrics(old,old_crop)
qualitymetrics(new,new_crop)
qualitymetrics(hdr_global,hdrg_crop)
qualitymetrics(hdr,double(hdr_crop))

figure;
histogram(reshape(old, [], 1),'BinLimits',[0 255]);
 figure;
histogram(reshape(new, [], 1),'BinLimits',[0 255]);
 figure;
histogram(reshape(hdr_global, [], 1),'BinLimits',[0 255]);
 figure;
histogram(reshape(hdr, [], 1),'BinLimits',[0 2]);
