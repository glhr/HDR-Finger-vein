
function output = qualitymetrics(img)
    glcm = graycomatrix(img);
    stats = graycoprops(glcm);
    
    
     output(1) = stats.Contrast;
     output(2) = mean2(img);
     output(3) = std2(img);
     output(4) = entropy(img);
     output(5) = stats.Energy;
     output(6) = stats.Homogeneity;
     output(7) = stats.Correlation;

%     output(1) = contrast(img);
%     output(2) = mean2(img);
%     output(3) = std2(img);
%     output(4) = entropy(img);
end


function output = contrast(img)
    output = max(img(:)) - min(img(:));
end