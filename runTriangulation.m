images = imagesg();
image1 = zeros(2,56);
image2 = zeros(2,56);
%close all;
for i =1:56
    image1(:,i) = images(1,:,i);
    image2(:,i) = images(5,:,i);
end
%tranformation of 5th camera w.r.to 1st camera
t = [50,0,0];
tx = [0,-t(3),t(2);t(3),0,-t(1);-t(2),t(1),0];
%rotation matrix
r = rm(0,180,0);
k = [100,0,50;0,100,100;0,0,1];
%fundamental matrix
F = inv(k')*tx*r*inv(k);
p1 = [25,0,0]';
p5 = [-25,0,0]';
h1 = [rm(0,90,0)];
%h1 = [rm(0,0,0)];
h5 = [rm(0,-90,0)];
%h5 = [rm(0,-180,0)];
t1 = [-rm(0,90,0)*p1];
%t1 = [0;0;0];
t5 = [-rm(0,-90,0)*p5];
%t5 = [0;0;50];
%Camera matrices
htm1 = [h1,t1];
htm5 = [h5,t5];
append = [0,0,1]';
p1 = [k]*htm1;
p2 = [k]*htm5;
reconstructed = [];
for i=1:56
    x1 = image1(:,i);
    x2 = image2(:,i);
    m = zeros(4,4);
    m(1,:) = -(x1(1)*p1(3,:))+p1(1,:);
    m(2,:) = (x1(2)*p1(3,:))-p1(2,:);
    m(3,:) = -(x2(1)*p2(3,:))+p2(1,:);
    m(4,:) = (x2(2)*p2(3,:))-p2(2,:);
    [u,s,v] = svd(m);
    tmp = v(:,4)
    b = tmp(1:3)/tmp(4);
    reconstructed = [reconstructed,b];
end
pw = generateCube(4,4);
close all;
figure();
scatter3(reconstructed(1,:),reconstructed(2,:),reconstructed(3,:),'filled');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
title('Reconstructed Cube')
legend('Sample point on the surface of the cube');
reprojectionerror = 0;
for i =1:56
    reprojectionerror = reprojectionerror+sqrt((pw(1,i)-reconstructed(1,i))*(pw(1,i)-reconstructed(1,i))+(pw(2,i)-reconstructed(2,i))*(pw(2,i)-reconstructed(2,i))+(pw(3,i)-reconstructed(3,i))*(pw(3,i)-reconstructed(3,i)));
end
reprojectionerror