clear all;
close all;

path = 'C:\Users\Gebruiker\Documents\werk\MOD12\code\HDR-Finger-vein\illumination\img_evaltests\dataset17\segment (10).png';
        img_norm = normalize(imread(path));
        img_cropped = img_norm(55:160,50:410);
        figure;
        imshow(img_cropped);
        %img_cropped = img_norm(55:160,25:440);
        %imwrite(img_norm,strcat('img_evaltests/',dataset,'/segment_norm (',num2str(n),').png'));
        %imwrite(img_cropped,strcat('img_evaltests/',dataset,'/segment_cropped (',num2str(n),').png'));

% for d = 6:1:17
%     dataset = strcat('dataset',num2str(d));
%     
%     nimages = 16;
%     if(strcmp(dataset,'dataset5') || strcmp(dataset,'dataset4'))
%         nimages = 21;
%     elseif(strcmp(dataset,'dataset12') || strcmp(dataset,'dataset13') || ...
%             strcmp(dataset,'dataset14') || strcmp(dataset,'dataset15') || ...
%             strcmp(dataset,'dataset16') || strcmp(dataset,'dataset18'))
%         nimages = 15;
%     end
% 
%     for n = 1:1:nimages
%         path = strcat('img_evaltests/',dataset,'/segment (',num2str(n),').png');
%         img_norm = normalize(imread(path));
%         img_cropped = img_norm(55:160,50:410);
%         %img_cropped = img_norm(55:160,25:440);
%         imwrite(img_norm,strcat('img_evaltests/',dataset,'/segment_norm (',num2str(n),').png'));
%         imwrite(img_cropped,strcat('img_evaltests/',dataset,'/segment_cropped (',num2str(n),').png'));
%     end
% end

function output = normalize(img)
    img = img(190:400,200:670);
    
    img = img(:,:,1);
    %img = imgaussfilt(img,5);


    %img3=im2double(imresize(img,[340 NaN]));
    img3=im2double(img);
    %mask_height=2; % Height of the mask
    %mask_width=2; % Width of the mask
    mask_height=2; % Height of the mask
    mask_width=2; % Width of the mask
    [fvr, edges] = lee_region(img3,mask_height,mask_width);

    % Create a nice image for showing the edges
    edge_img = zeros(size(img3));
    edge_img(edges(1,:) + size(img3,1)*(0:size(img3,2)-1)) = 1;
    edge_img(edges(2,:) + size(img3,1)*(0:size(img3,2)-1)) = 1;

    rgb = zeros([size(img3) 3]);
    rgb(:,:,1) = (img3 - img3.*edge_img) + edge_img;
    rgb(:,:,2) = (img3 - img3.*edge_img);
    rgb(:,:,3) = (img3 - img3.*edge_img);
    figure;
    imshow(rgb)

    %% Image for report

    [imgn,fvrn,rot,tr] = huang_normalise(img3,fvr,edges);
    fit_line = zeros(size(img3));
    for i=1:size(img3,2)
        y = -1*tand(rot)*i - tr + size(img3,1)/2;
        fit_line(round(y),i) = 1;
    end

    rgb = zeros([size(img3) 3]);
    rgb(:,:,1) = (img3 - img3.*edge_img) + edge_img;
    rgb(:,:,2) = (img3 - img3.*fit_line) + fit_line;
    rgb(:,:,3) = img3;
    figure;
    imshowpair(rgb,imgn,'montage');

    output = imgn;
end