%% defines the window(s) to be used for the moving mean filter
%% if multiple windows are defined, the HDR algorithm will be run for each of them

function windows = getWindows()
    %windows = {[1 1],[1 2], [2 2], [1 3], [3 3], [4 4], [1 4], [1 5], [2 5], [3 5], [4 5], [5 5], [1 10], [10 10], [1 75], [75 1]};
    windows = {[7 7]};
    %windows = {[2 2], [5 5], [7 7], [20 20],[10 2], [2 10]};
end

