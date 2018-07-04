% Howto use the miura_* scripts.

function [img, overlay, pattern, scores] = miura_usage(hdr, iterations, r, W, sigma, method)

%img = imread(path);
%img = im2double(img(:,:,1)); % Read the image
img = hdr;
%img = imresize(img,0.75);               % Downscale image

% Get the valid region, this is a binary mask which indicates the region of 
% the finger. For quick testing it is possible to use something like:
% fvr = ones(size(img));
% The lee_region() function can be found here:
% http://www.mathworks.com/matlabcentral/fileexchange/35752-finger-region-localisation
%fvr = lee_region(img,4,40);    % Get finger region
fvr = ones(size(img));

if(method == 1)
    %% Extract veins using maximum curvature method
    %sigma = 2; % Parameter
    [v_max_curvature,k,score] = miura_max_curvature(img,fvr,sigma);
    scores = score;
    % Binarise the vein image
    md = median(v_max_curvature(v_max_curvature>0));
    %v_max_curvature_bin = v_max_curvature > md; 
    v_max_curvature_bin = v_max_curvature > 0; 
    % Overlay the extracted veins on the original image
    overlay_max_curvature = zeros([size(img) 3]);
    overlay_max_curvature(:,:,1) = img;
    overlay_max_curvature(:,:,2) = double(img) + 0.4*double(v_max_curvature_bin);
    overlay_max_curvature(:,:,3) = img;
    overlay = overlay_max_curvature;
    pattern = v_max_curvature_bin;

else
    %% Extract veins using repeated line tracking method
    max_iterations = iterations; % Parameters
    v_repeated_line = miura_repeated_line_tracking(img,fvr,max_iterations,r,W);

    % Binarise the vein image
    md = median(v_repeated_line(v_repeated_line>0));
    v_repeated_line_bin = v_repeated_line > md; 
    pattern = v_repeated_line_bin;

    %% Match
    %cw = 80; ch=30;
    % Note that the match score is between 0 and 0.5
    %score = miura_match(double(v_repeated_line_bin), double(v_max_curvature_bin), cw, ch);
    %fprintf('Match score: %6.4f %%\n', score);

    %% Visualise

    % Overlay the extracted veins on the original image
    overlay_repeated_line = zeros([size(img) 3]);
    overlay_repeated_line(:,:,1) = img;
    overlay_repeated_line(:,:,2) = img + 0.4*v_repeated_line_bin;
    overlay_repeated_line(:,:,3) = img;
    overlay = overlay_repeated_line;
end
% figure;
% subplot(3,2,1)
%   imshow(img,[])
%   title('Original captured image')
% subplot(3,2,2)
%   imshow(fvr)
%   title('Detected finger region')
% subplot(3,2,3)
%   imshow(v_max_curvature_bin)
%   title('Binarised veins extracted by maximum curvature method')
% subplot(3,2,4)
%   imshow(overlay_max_curvature)
%   title('Maximum curvature method')  
% subplot(3,2,5)
%   imshow(v_repeated_line_bin)
%   title('Binarised veins extracted by repeated line tracking method')
% subplot(3,2,6)
%   imshow(overlay_repeated_line)
%   title('Repeated line tracking method')

end

