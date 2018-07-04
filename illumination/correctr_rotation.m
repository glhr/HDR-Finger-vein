folder = 'img_evaltests\matching\';
file1 = 'dataset15';
file2 = 'dataset17';
fixed = imread(strcat(folder,file1,'_maxcurve.png'));
moving = imread(strcat(folder,file2,'_maxcurve.png'));
moving2 = imread(strcat(folder,file2,'_repline.png'));

tformEstimate = imregcorr(moving,fixed,'transformtype','rigid');

Rfixed = imref2d(size(fixed));
movingReg1 = imwarp(moving,tformEstimate,'OutputView',Rfixed);
movingReg2 = imwarp(moving2,tformEstimate,'OutputView',Rfixed);

imshowpair(fixed,movingReg1,'montage')
imwrite(movingReg1,strcat(folder,file2,'_maxcurve.png'));
imwrite(movingReg2,strcat(folder,file2,'_repline.png'));


