function glob = globals
  glob.getImgPath=@getImgPath;
  glob.getWindows=@getWindows;
  glob.writeImgs=@writeImgs;
end


function path = getImgPath(dataset,n_img,type)
  folder = 'img_evaltests/';
  if(strcmp(type,'segment'))
    path = strcat(folder,dataset,'/segment_cropped (',num2str(n_img),').png');
  elseif(strcmp(type,'full'))
    path = strcat(folder,dataset,'/segment (',num2str(n_img),').png');
  else
      path = strcat(folder,dataset,'/segment (',num2str(n_img),').png');
  end
end

function out = writeImgs()
    out = false;
end

function windows = getWindows()
    %windows = {[1 1],[1 2], [2 2], [1 3], [3 3], [4 4], [1 4], [1 5], [2 5], [3 5], [4 5], [5 5], [1 10], [10 10], [1 75], [75 1]};
    windows = {[7 7]};
    %windows = {[2 2], [5 5], [7 7], [20 20],[10 2], [2 10]};
end

