close all
clear all
addpath('code_miura');
dataset = 'dataset4';

for i = 2:0.2:3 
    sigma = i;
    for j=1:21
        [img, output, pattern] = miura_usage(strcat('img_evaltests/',dataset,'/segment_cropped (',num2str(j),').png'),4000,6,9,sigma,1);
        % figure(1)
        % subplot(3,1,1)
        %   imshow(img,[])
        %   title('Original captured image')
        % subplot(3,1,2)
        %   imshow(output)
        %   title('Maximum curvature method')  
        % subplot(3,1,3)
        %   imshow(output)
        %   title('Repeated line tracking method')

        imwrite(pattern,strcat('img_evaltests/',dataset,'/maxcurve_ldr',num2str(j),'_',num2str(sigma),'.png'));

        % [img2, maxcurve2, repeatedline2] = miura_usage('cropped_3.png',3000, 1, 21);
        % subplot(3,2,2)
        %   imshow(img2,[])
        %   title('Original captured image')
        % subplot(3,2,4)
        %   imshow(maxcurve2)
        %   title('Maximum curvature method')  
        % subplot(3,2,6)
        %   imshow(repeatedline2)
        %   title('Repeated line tracking method')
    end

end