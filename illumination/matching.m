close all;
clear all;

folder = 'img_evaltests\matching_ldr\';


pairs = [   
%             4,      5,      1       ;
%             4,      6,      1       ;
%             4,      7,      0       ;
%             4,      8,      1       ;
%             4,      9,      0       ;
%             4,      10,     1       ;
%             4,      11,     0       ;
%             4,      12,     0       ;
%             4,      13,      0       ;
%             4,      14,      0       ;
%             4,      15,      0       ;
%             4,      16,      0       ;
%             4,      17,      0       ;
%             
%             5,      6,      1       ;
%             5,      7,      0       ;
%             5,      8,      1       ;
%             5,      9,      0       ;
%             5,      10,     1       ;
%             5,      11,     0       ;
%             5,      12,     0       ;
%             5,      13,      0       ;
%             5,      14,      0       ;
%             5,      15,      0       ;
%             5,      16,      0       ;
%             5,      17,      0       ;
            
            6,      7,      0       ;
            6,      8,      1       ;
            6,      9,      0       ;
            6,      10,     1       ;
            6,      11,     0       ;
            6,      12,     0       ;
            6,      13,      0       ;
            6,      14,      0       ;
            6,      15,      0       ;
            6,      16,      0       ;
            6,      17,      0       ;
             
            7,      8,      0       ;
            7,      9,      1       ;
            7,      10,     0       ;
            7,      11,     1       ;
            7,      12,     0       ;
            7,      13,      0       ;
            7,      14,      0       ;
            7,      15,      0       ;
            7,      16,      0       ;
            7,      17,      0       ;

            8,      9,      0       ;
            8,      10,     1       ;
            8,      11,     0       ;
            8,      12,     0       ;
            8,      13,      0       ;
            8,      14,      0       ;
            8,      15,      0       ;
            8,      16,      0       ;
            8,      17,      0       ;
            
            9,      10,     0       ;
            9,      11,     1       ;
            9,      12,     0       ;
            9,      13,      0       ;
            9,      14,      0       ;
            9,      15,      0       ;
            9,      16,      0       ;
            9,      17,      0       ;
            
            10,      11,     0       ;
            10,      12,     0       ;
            10,      13,      0       ;
            10,      14,      0       ;
            10,      15,      0       ;
            10,      16,      0       ;
            10,      17,      0       ;
            
            11,      12,     0       ;
            11,      13,      0       ;
            11,      14,      0       ;
            11,      15,      0       ;
            11,      16,      0       ;
            11,      17,      0       ;
            
            12,      13,      0       ;
            12,      14,      1       ;
            12,      15,      0       ;
            12,      16,      1       ;
            12,      17,      0       ;
            
            13,      14,      0       ;
            13,      15,      1       ;
            13,      16,      0       ;
            13,      17,      1       ;
            
            14,      15,      0       ;
            14,      16,      1       ;
            14,      17,      0       ;
            
            15,      16,      0       ;
            15,      17,      1       ;
            
            16,      17,      0       ;
        
    ];

imposterscores_maxcurve = [];
matchscores_maxcurve = [];
imposterscores_repline = [];
matchscores_repline = [];

algo = 'maxcurve';

npairs = size(pairs);
for i = 1:1:npairs
    file1 = pairs(i,1);
    file2 = pairs(i,2);
    
    ref1 = imread(strcat(folder,'dataset',num2str(file1),'_maxcurve.png'));
    input1 = imread(strcat(folder,'dataset',num2str(file2),'_maxcurve.png'));
    
    ref2 = imread(strcat(folder,'dataset',num2str(file1),'_repline.png'));
    input2 = imread(strcat(folder,'dataset',num2str(file2),'_repline.png'));

    score_maxcurve = miura_match(input1, ref1, 30, 30);
    score_repline = miura_match(input2, ref2, 30, 30);
    
    if(pairs(i,3) == 0)
        imposterscores_maxcurve = [imposterscores_maxcurve score_maxcurve];
        imposterscores_repline = [imposterscores_repline score_repline];
        %sprintf('IMPOSTER\t %0.5f \t %i vs %i \n',score,file1,file2);
    elseif(pairs(i,3) == 1)
        matchscores_maxcurve = [matchscores_maxcurve score_maxcurve];
        matchscores_repline = [matchscores_repline score_repline];
        fprintf('MATCH\t %0.5f (maxcurve) / %0.5f (repline) \t %i vs %i\n',score_maxcurve,score_repline,file1,file2);
    end
    
    
end

cmap = hsv(2);
figure;
subplot(2,1,1);

histogram(imposterscores_maxcurve,0:0.005:0.5,'facecolor',cmap(1,:),'facealpha',.5,'edgecolor','none');
hold on
histogram(matchscores_maxcurve,0:0.005:0.5,'facecolor',cmap(2,:),'facealpha',.5,'edgecolor','none');
title('Maximum curve, sigma = 3')
subplot(2,1,2);

histogram(imposterscores_repline,0:0.005:0.5,'facecolor',cmap(1,:),'facealpha',.5,'edgecolor','none');
hold on
histogram(matchscores_repline,0:0.005:0.5,'facecolor',cmap(2,:),'facealpha',.5,'edgecolor','none');
title('Repeated line tracking, r = 1, W = 9')

% figure;
% imshowpair(ref,input,'montage');