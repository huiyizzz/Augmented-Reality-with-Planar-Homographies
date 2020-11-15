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
plot(points1.selectStrongest(50));
%% Obtain descriptors for the computed feature locations
[desc1, locs1] = computeBrief(I1, points1.Location);
[desc2, locs2] = computeBrief(I2, points2.Location);

%% Match features using the descriptors
pairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10.0);
locs1 = locs1(pairs(:,1),:);
locs2 = locs2(pairs(:,2),:);
figure;
showMatchedFeatures(I1,I2,locs1, locs2, 'montage');
