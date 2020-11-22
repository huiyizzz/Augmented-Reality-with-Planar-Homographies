function [locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!
%% Convert images to grayscale, if necessary
gray_I1 = I1;
gray_I2 = I2;
if ndims(gray_I1) == 3
    gray_I1 = rgb2gray(I1);
end
if ndims(gray_I2) == 3
    gray_I2 = rgb2gray(I2);
end
%% Detect features in both images
points1 = detectFASTFeatures(gray_I1);
points2 = detectFASTFeatures(gray_I2);
%% Obtain descriptors for the computed feature locations
[desc1, locs1] = computeBrief(gray_I1, points1.Location);
[desc2, locs2] = computeBrief(gray_I2, points2.Location);
%% Match features using the descriptors
pairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10.0, 'MaxRatio',0.7);
locs1 = locs1(pairs(:,1),:);
locs2 = locs2(pairs(:,2),:);
% figure;
% showMatchedFeatures(I1, I2, locs1, locs2, 'montage');
end
