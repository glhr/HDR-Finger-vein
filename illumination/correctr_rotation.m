folder = 'img_evaltests\matching\';
file1 = '2right_dataset15';
file2 = '2left_dataset16';
fixed = imread(strcat(folder,file1,'.png'));
moving = imread(strcat(folder,file2,'.png'));

tformEstimate = imregcorr(moving,fixed,'transformtype','rigid');

Rfixed = imref2d(size(fixed));
movingReg = imwarp(moving,tformEstimate,'OutputView',Rfixed);

imshowpair(fixed,movingReg,'montage')
imwrite(movingReg,strcat(folder,file2,'_rot.png'));


