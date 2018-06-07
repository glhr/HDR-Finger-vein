
function output = qualitymetrics(img)
    glcm = graycomatrix(img,'NumLevels',256,'GrayLimits',[],'Symmetric',true);
    stats = graycoprops(glcm);
    
    
     output(7) = stats.Contrast;
     output(8) = stats.Homogeneity;
     output(9) = stats.Energy;
     output(10) = stats.Correlation;
     
     output(1) = contrast(img);
     output(2) = mean2(img);
     output(3) = std2(img);
     output(4) = entropy(img);
     output(5) = sum(img(:));


     
%     output(2) = mean2(img);
%     output(3) = std2(img);
%     output(4) = entropy(img);
end


function output = contrast(img)
    output = max(img(:)) - min(img(:));
end