function output = qualitymetrics(img,crop)

    img = img(:,:,1);
    %img = imgaussfilt(img, 0.5);
    %crop = imgaussfilt(crop, 0.5);
%     D = 50;
%     offset = [-D D];
    glcm = graycomatrix(img,'Offset',[0 1], 'NumLevels',256,'GrayLimits',[]);
    %glcm = graycomatrix(img,'NumLevels',10,'GrayLimits',[0 255]);
    stats = graycoprops(glcm);
    
    glcm_crop = graycomatrix(crop,'NumLevels',256,'GrayLimits',[]);
    stats_crop = graycoprops(glcm_crop);
    
     output(7) = stats_crop.Contrast;
     output(8) = stats.Homogeneity;
     output(9) = stats_crop.Energy;
     output(10) = stats_crop.Correlation;
     
     output(1) = 0;
     output(2) = mean2(img);
     output(3) = std2(img);
     output(4) = entropy(uint8(255*mat2gray(img)));
     output(5) = 0;


     
%     output(2) = mean2(img);
%     output(3) = std2(img);
%     output(4) = entropy(img);
end


function output = contrast(img)
    output = max(img(:)) - min(img(:));
end