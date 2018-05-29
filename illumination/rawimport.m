row=608; col=800;
fin=fopen('test.raw','r');
I = fread(fin, col*row*3,'ubit24=>uint32');
I = reshape(I, col, row, []); 
B = uint8(bitand(bitshift(I,-00),uint32(255)));
G = uint8(bitand(bitshift(I,-08),uint32(255)));
R = uint8(bitand(bitshift(I,-16),uint32(255)));
I = cat(3,R,G,B);
Ifinal = flip(imrotate(I, -90),2);
figure;
subplot(2,1,1);
%imagesc(Ifinal);
imshow(Ifinal);
fclose(fin);

subplot(2,1,2);
img = imread('test.png');
imshow(img);
