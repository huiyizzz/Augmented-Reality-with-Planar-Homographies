clear all;
close all;

I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png');
hp_img = imread('../data/hp_cover.jpg');
%%
if ndims(I1) == 3
    img1 = rgb2gray(I1);
else
    img1=I1;
end
if ndims(I2) == 3
    img2 = rgb2gray(I2);
else
    img2=I2;
end
%% Detect features in both images
points1 = detectFASTFeatures(img1);
points2 = detectFASTFeatures(img2);
%% Obtain descriptors for the computed feature locations
[desc1, locs1] = computeBrief(I1, points1.Location);
[desc2, locs2] = computeBrief(I2, points2.Location);

%% Match features using the descriptors
pairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10.0);
locs1 = locs1(pairs(:,1),:);
locs2 = locs2(pairs(:,2),:);
figure;
showMatchedFeatures(I1,I2,locs1, locs2, 'montage');
%%
x1 = locs1;
x2 = locs2;
centroid1 = mean(x1);
centroid2 = mean(x2);
x1 = x1-centroid1;
x2 = x2-centroid2;

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
avg_distance1 = mean(hypot(x1(:,1),x1(:,2)));
avg_distance2 = mean(hypot(x2(:,1),x2(:,2)));
s1 = sqrt(2)/avg_distance1;
s2 = sqrt(2)/avg_distance2;
x1 = x1*s1;
x2 = x2*s2;

%% similarity transform 1
T1 = [s1, 0, -centroid1(1); 0, s1, -centroid1(2); 0, 0, 1];

%% similarity transform 2
T2 = [s2, 0, -centroid2(1); 0, s2, -centroid2(2); 0, 0, 1];

%% Compute Homography
H2to1 = computeH(x1, x2);

%% Denormalization
H2to1 = T1\H2to1*T2;
