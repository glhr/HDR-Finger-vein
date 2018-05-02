figure(1)
imshow('cropped_3.png');
rows = sum(img,1);
[maxval,maxid] = max(rows);
p1 = [1,maxid];
p2 = [558,maxid];
img = imread('cropped_3.png');
hold on
plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',2);

figure(2)

img = imread('cropped_4.png');
rows = sum(img,1);
[maxval,maxid] = max(rows);
p1 = [1,maxid];
p2 = [558,maxid];
imshow('cropped_4.png');
hold on
plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',2);