refdataset = 'dataset5';
inputdataset = 'dataset4';

% ref = imread(strcat('img_evaltests/dataset4/combinedpattern_3.png'));
% input = imread(strcat('img_evaltests/dataset1/combinedpattern_3.png'));

folder = 'img_evaltests\matching\';

pairs = ["dataset7",    "dataset11",    "match"     ;
        "dataset9",     "dataset11",    "imposter"  ;
        
    ];

npairs = size(pairs);
for i = 1:1:npairs
    file1 = pairs(i,1);
    file2 = pairs(i,2);
    
    ref = imread(strcat(folder,char(file1),'.png'));
    input = imread(strcat(folder,char(file2),'.png'));

    score = miura_match(input, ref, 30, 30)
end


% figure;
% imshowpair(ref,input,'montage');