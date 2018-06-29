function output = combine_veinpatterns(dataset,sigma)
%     ref1 = imread(strcat('img_evaltests/',dataset,'/maxcurve_hdr_[1 5]_movmean_',sigma,'.png'));
%     ref2 = imread(strcat('img_evaltests/',dataset,'/maxcurve_hdr_[1 3]_movmean_',sigma,'.png'));
%     ref3 = imread(strcat('img_evaltests/',dataset,'/maxcurve_hdr_[2 5]_movmean_',sigma,'.png'));
%     ref4 = imread(strcat('img_evaltests/',dataset,'/maxcurve_hdr_[1 1]_movmean_',sigma,'.png'));
%     ref5 = imread(strcat('img_evaltests/',dataset,'/maxcurve_hdr_[10 1]_movmean_',sigma,'.png'));
%     ref6 = imread(strcat('img_evaltests/',dataset,'/maxcurve_hdr_[10 10]_movmean_',sigma,'.png'));
    
    sum = 0;
    windows = getWindows();
    for i=1:numel(windows)
        window = mat2str(windows{i});
        sum = sum + imread(strcat('img_evaltests/',dataset,'/maxcurve_',window,'_',num2str(sigma),'.png'));
    end

    test = uint8(255*mat2gray(sum));
    test = test > 255/numel(windows);
    output = test;
    %imshow(test);
    imwrite(test,strcat('img_evaltests/',dataset,'/combinedpattern_',num2str(sigma),'.png'));

end