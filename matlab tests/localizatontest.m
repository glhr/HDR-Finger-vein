clear all
figure(1)
img = imread('cropped_3.png');
cropped_img=img(50:500,:);
rows = sum(img,1);
[maxval,maxid] = max(rows);
imshow(img);
hold on
plot([maxid,maxid],[0,1080],'Color','r','LineWidth',2);

figure(2)
img = imread('cropped_4.png');
cropped_img=img(50:500,:);
rows = sum(img,1);
[maxval,maxid] = max(rows);
imshow(img);
hold on
plot([maxid,maxid],[0,1080],'Color','r','LineWidth',2);