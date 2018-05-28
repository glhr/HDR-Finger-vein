
function output = qualitymetrics(img)
    output(1) = contrast(img);
    output(2) = mean2(img);
    output(3) = std2(img);
    output(4) = entropy(img);
end


function output = contrast(img)
    output = max(img(:)) - min(img(:));
end