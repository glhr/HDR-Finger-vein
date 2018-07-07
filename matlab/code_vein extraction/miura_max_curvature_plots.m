close all; 
sigma = 0.8;
fvr = ones(size(img));
[veins,k,Vt] = miura_max_curvature(rgb_global, fvr, sigma);

% figure('Name', 'Curvatures');
% subplot(2,2,1);
%   %imshow(log(k(:,:,1) + 1), []);
%   imshow(k(:,:,1), []);
%   title('Horizontal');
% subplot(2,2,2);
%   %imshow(log(k(:,:,2) + 1), []);
%   imshow(k(:,:,2) > 0, []);
%   title('Vertical');
% subplot(2,2,3);
%   %imshow(log(k(:,:,3) + 1), []);
%   imshow(k(:,:,3) > 0, []);
%   title('a');
% subplot(2,2,4);
%   %imshow(log(k(:,:,4) + 1), []);
%   imshow(k(:,:,4) > 0, []);
%   title('b');
  
figure('Name', 'Score');
imshow(Vt(:,:,1));

% %% HDR global
% 
% [veins,k,Vt] = miura_max_curvature(hdr_global, fvr, sigma);
%   
% figure('Name', 'Score HDR global');
% imshow(Vt(:,:,1));

%% nahuel

[veins,k,Vt] = miura_max_curvature(rgb, fvr, sigma);
 md = median(veins(veins>0));
  veins = veins > md;
figure('Name', 'nahuel');
imshow(Vt(:,:,1));
figure;
imshow(veins);