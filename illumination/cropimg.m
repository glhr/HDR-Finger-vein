function output = cropimg(dataset, img)
        if(strcmp(dataset,'dataset5') || strcmp(dataset,'dataset4'))
            output = img(250:350,218:640);
        elseif(strcmp(dataset,'dataset6') )
            output = img(265:365,218:640);
        elseif(strcmp(dataset,'dataset7'))
            output = img(245:345,218:640);
        elseif(strcmp(dataset,'dataset8') )
            output = img(265:365,218:640);
        elseif(strcmp(dataset,'dataset9') )
            output = img(240:340,218:640);
        elseif(strcmp(dataset,'dataset11') )
            output = img(238:338,218:640);
        elseif(strcmp(dataset,'dataset13') || strcmp(dataset,'dataset15'))
            output = img(249:349,218:640);
        elseif(strcmp(dataset,'dataset12') || strcmp(dataset,'dataset14') || strcmp(dataset,'dataset16'))
            output = img(260:360,218:640);
        elseif(strcmp(dataset,'dataset17'))
            output = img(240:340,218:640);
        elseif(strcmp(dataset,'dataset18'))
            output = img(249:349,218:640);
        else
            output = img(265:365,218:640);
        end
        output = imresize(output, [100 NaN]);
end