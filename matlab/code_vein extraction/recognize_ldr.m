close all
clear all
addpath('code_miura');
dataset = 'dataset7';

%for i = 3.5:0.5:4 
    sigma = 2.5;
    %for j=1:16
    
    for d = 6:1:17
        dataset = strcat('dataset',num2str(d));
    
        j = 10;
        input = imread(strcat('img_evaltests/',dataset,'/segment_cropped (',num2str(j),').png'));
        [img, output, pattern] = miura_usage(input,1000,6,9,sigma,1);
        [img, output, pattern2] = miura_usage(input,1000,1,13,sigma,2);
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

        %imwrite(pattern,strcat('img_evaltests/',dataset,'/maxcurve_ldr',num2str(j),'_',num2str(sigma),'.png'));
        imwrite(pattern,strcat('img_evaltests/matching_ldr/',dataset,'_maxcurve.png'));
        imwrite(pattern2,strcat('img_evaltests/matching_ldr/',dataset,'_repline.png'));

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
    %end
    end

%end