function [bifs,thinned] = lee_bifs(locr,ws)
% Parameters:
%  locr - Stretched and sub-sampled localized region
%  ws - Window size used for adaptive thresholding

% First some binary operations
la = adaptive_threshold(locr,ws,0);
bw = bwmorph(la,'clean');
bw = bwmorph(bw,'fill');
bw = bwmorph(bw,'open');
thinned = bwmorph(bw,'thin',Inf);

% Find the bifurcations in the thinned image
bifs = bwmorph(thinned,'branchpoints');
[y,x] = find(bifs);
bifs = [x,y];

