clear all; clc;
base_dir = 'L:/Biometrics/FingerVein/Peking_University/1018/';
%img_en = im2double(imread('0005_3_111122-124534.png')); % Enrolled
%img_cp = im2double(imread('0010_3_111123-161148.png')); % Captured
%img_cp = im2double(imread('0006_3_111122-124942.png')); % Registred
%img_cp = im2double(imread('0005_6_111122-124728.png')); % Registred
img_en = im2double(imread(strcat(base_dir,'346/1.bmp')));
img_cp = im2double(imread(strcat(base_dir,'346/5.bmp')));
%img_cp = im2double(imread(strcat(base_dir,'10309/1.bmp')));
%img_en = img_en(:,20:450);
%img_cp = img_cp(:,20:450);
%img_cp = imrotate(img_en,2,'crop'); % <-- LET OP  !!

[~,edges] = finger_region(img_en,'mask',40);
locr_en = img_en(max(edges(1,:)):min(edges(2,:)),:);
%locr_en = imresize(locr_en,[60 150]);   
locr_en = imresize(locr_en,[64 200]);


[~,edges] = finger_region(img_cp,'mask',40);
locr_rg = img_cp(max(edges(1,:)):min(edges(2,:)),:);
%locr_rg = imresize(locr_rg,[60 150]);
locr_rg = imresize(locr_rg,[64 200]);

%% Find bifurcations
ws = 40;
[bifs_en,thin_en] = lee_bifs(locr_en,ws);
[bifs_rg,thin_rg] = lee_bifs(locr_rg,ws);
fprintf('Found %d bifurcations in enrolled image.\n', size(bifs_en,1));
fprintf('Found %d bifurcations in registred image.\n', size(bifs_rg,1));

figure('Name','Bifurcations found');
green = cat(3, zeros(size(locr_en)), ones(size(locr_en)), zeros(size(locr_en)));
subplot(2,1,1)
  imshow(locr_en,[]);
  hold on;
  hGreen = imshow(green);
  set(hGreen, 'AlphaData', 0.2*thin_en)
  plot(bifs_en(:,1),bifs_en(:,2),'o');
  hold off;
subplot(2,1,2)
  imshow(locr_rg,[]);
  hold on;
  hGreen = imshow(green);
  set(hGreen, 'AlphaData', 0.2*thin_rg)
  plot(bifs_rg(:,1),bifs_rg(:,2),'o');
  hold off;

%%
% Align image based on found bifucations  
out = lee_align(locr_rg,bifs_en,bifs_rg);

[codeA,ccvA] = lee_lbp(locr_en,0.015);
[codeB,ccvB] = lee_lbp(out,0.015);
lee_hd(codeA,ccvA,codeB,ccvB)

%% Debugging images
figure('Name','Codes & Masks');
subplot(2,3,1)
  imshow(locr_rg,[])
  title('Input image')
subplot(2,3,4)
  imshow(out,[])
  title('Tranformed image');
subplot(2,3,2)
  imshow(codeA,[])
  title('Code of enrolled')
subplot(2,3,5)
  imshow(codeB,[])
  title('Code of registred image');
subplot(2,3,3)
  imshow(ccvA,[])
  title('Mask of enrolled')  
subplot(2,3,6)
  imshow(ccvB,[])
  title('Mask of registred image');  