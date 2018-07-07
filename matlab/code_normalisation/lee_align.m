function out = lee_align(locr,bifs_en,bifs_rg)
% Parameters:
%  locr - Stretched and sub-sampled localized region
%  bifs_en - Positions of bifurcations in the enrolled image 
%  bifs_rg - Positions of bifurcations in the registred image 

if(size(bifs_en,1) < 3 || size(bifs_rg,1) < 3)
    fprintf('Not enough bifurcation points found.\n');
    return;
end

% Determine number of possible permutations
perms_en = nchoosek(1:size(bifs_en,1),3);
perms_rg = nchoosek(1:size(bifs_rg,1),3);

a_min =  0.469; a_max = 1.405;
b_min = -0.478; b_max = 0.478;
d_min = -0.478; d_max = 0.478;
e_min =  0.469; e_max = 1.405;
c_min = -117.707; c_max = 121.707;
f_min = -76.254; f_max = 80.254;

t_min = [[a_min;b_min;c_min],[d_min;e_min;f_min],[0;0;1]];
t_max = [[a_max;b_max;c_max],[d_max;e_max;f_max],[0;0;1]];

amd = zeros(0,3);
for i=1:size(perms_en,1)
    X = [bifs_en(perms_en(i,1),:);bifs_en(perms_en(i,2),:);bifs_en(perms_en(i,3),:)];
    for j=1:size(perms_rg,1)
        U = [bifs_rg(perms_rg(j,1),:);bifs_rg(perms_rg(j,2),:);bifs_rg(perms_rg(j,3),:)];
        
        % Check for collinearity
        if(cond([U,[1;1;1]]) < 1e5 && cond([X,[1;1;1]]) < 1e5)
            T = maketform('affine',U,X);
            t = T.tdata.T;
            % Are parametres in specified range ?
            if(sum(sum(t>=t_min & t<=t_max)) == 9)
                [x,y] = tformfwd(T, bifs_rg(:,1), bifs_rg(:,2));
                bif_cp_t = [x,y];
                D = pdist2(bif_cp_t,bifs_en);
                amd(end+1,:) = [i,j,mean(min(D))];
            end
        end
    end
end

%%
if isempty(amd)
    fprintf('No suitable set of affine coefficients found.\n')
    out = [];
else
[~,I] = min(amd(:,3));
X = [bifs_en(perms_en(amd(I,1),1),:);bifs_en(perms_en(amd(I,1),2),:);bifs_en(perms_en(amd(I,1),3),:)];
U = [bifs_rg(perms_rg(amd(I,2),1),:);bifs_rg(perms_rg(amd(I,2),2),:);bifs_rg(perms_rg(amd(I,2),3),:)];
T = maketform('affine',U,X);

out = imtransform(locr,T,'XData',[1 size(locr,2)],'YData',[1 size(locr,1)]);
end