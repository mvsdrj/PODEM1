x=56;
%{
prompt = 'Enter input Path to the first Image:';
Imagelocation1=input(prompt,'s');
if exist(Imagelocation1, 'file') ~= 2
    ME = MException('MATLAB:load:couldNotReadFile', ...
        'Unable to read file %s: No such file or directory.',Imagelocation1);
    throw(ME)
end
prompt = 'Enter input Path to the second Image:';
Imagelocation2=input(prompt,'s');
if exist(Imagelocation2, 'file') ~= 2
    ME = MException('MATLAB:load:couldNotReadFile', ...
        'Unable to read file %s: No such file or directory.',Imagelocation2);
    throw(ME)
end
a = imread(Imagelocation1);
b = imread(Imagelocation2);
a = rgb2gray(a);
a = im2double(a);
b = rgb2gray(b);
b = im2double(b);
points1 = detectHarrisFeatures(a);
points2 = detectHarrisFeatures(b);
[features1,valid_points1] = extractFeatures(a,points1);
[features2,valid_points2] = extractFeatures(b,points2);
indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:)
figure; showMatchedFeatures(a,b,matchedPoints1,matchedPoints2);
[x,y] = size(indexPairs);
pc1 = zeros(2,x);%points w.r.to camera1 i.e, image1 coordinates
pc2 = zeros(2,x);%points w.r.to camera2 i.e, image2 coordinates
%}
image_pts = images();
pc1 = zeros(2,56);
pc2 = zeros(2,56);
for i=1:56
    pc1(:,i) = image_pts(1,:,i);
    pc2(:,i) = image_pts(2,:,i);
end
for i=1:x
    pc1(:,i) = image_pts(1,:,i);
    pc2(:,i) = image_pts(2,:,i);
end
n = 100;
min = 57;
optimumF=0;
inliersbest=[]
% Ransac loop - 100 iterations
while n>0
    ar = zeros(1,8);
    %Select 8 distinct random integers in the range of 1 to 56
    ar(1)=randi(56);
    l=2;
    while l<=8
       f=0;
       tmp = randi(56);
       for i=1:l
           if ar(i)==tmp
               f=1;
               break;
           end
       end
       if f==0
           ar(l) = tmp;
           l=l+1;
       end
    end
    m1 = zeros(2,8);
    m2 = zeros(2,8);
    for i=1:8
        m1(:,i) = pc1(:,ar(i));
        m2(:,i) = pc2(:,ar(i));
    end
    tm1 = transformation(m1);
    tm2 = transformation(m2);
    ones = zeros(1,8)+1;
    m1 = tm1*[m1;ones];
    m2 = tm2*[m2;ones];
    F = estimateFundamentalMatrix(m1,m2);
    F = tm2'*F*tm1;
    inlierscurrent = []
    outliers=0;
    for i= 1:56
        x1 = [pc1(:,i);1];
        x2 = [pc2(:,i);1];
        g = x1'*F*x2;
        if abs(g)>0.02
            outliers = outliers+1;
        else
            inlierscurrent = [inlierscurrent,i];
        end
    end
    outliers
    if outliers<min
        min = outliers;
        optimumF = F;
        inliersbest = inlierscurrent;
    end
    n = n-1;
end
min
optimumF
%Refining the best F estimate using the maximal set of inliers
[a,b] = size(inliersbest);
m1 = zeros(2,b);
m2 = zeros(2,b);
