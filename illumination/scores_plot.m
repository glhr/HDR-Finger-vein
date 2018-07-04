close all;

impostor = scores{:,'impostorscores'};
same = scores{:,'samefingerscore'};

cmap = hsv(2);

histogram(impostor,0:0.005:0.5,'facecolor',cmap(1,:),'facealpha',.5,'edgecolor','none');
hold on
histogram(same,0:0.005:0.5,'facecolor',cmap(2,:),'facealpha',.5,'edgecolor','none');
