% Your solution to Q2.1.5 goes here!
clear all;
close all;

%% Read the image and convert to grayscale, if necessary
cv_img = imread('../data/cv_cover.jpg');
if ndims(cv_img) == 3
    cv_img = rgb2gray(cv_img);
end
%% get matched result
matches1 = [];
for i = 0:36
    %% Rotate image
    rotated_img = imrotate(cv_img, 10*i);
    %% Extract features and match
    [locs1, locs2] = matchPics(cv_img, rotated_img);
    if i==3 || i==6 || i==9
        figure;
        showMatchedFeatures(cv_img,rotated_img, locs1, locs2, 'montage');
    end
    %% Update histogram
    matches1 = [matches1 size(locs1,1)];
end
%% Display histogram
figure;
bar(0:10:360, matches1);
xlabel('Rotation of Degree')
ylabel('Number of Matched Features')
title('The Plot of Histogram with BRIEF Descriptor')
%% Using detectSURFFeatures and extractFeatures
points = detectSURFFeatures(cv_img);
[desc1, locs1] = extractFeatures(cv_img, points.Location, 'Method', 'SURF');
matches2 = [];
for i = 0:36
    rotated_img = imrotate(cv_img, 10*i);    
    rotated_points = detectSURFFeatures(rotated_img);
    [desc2, locs2] = extractFeatures(rotated_img, rotated_points.Location, 'Method', 'SURF');
    pairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10.0, 'MaxRatio',0.68);
    locs1 = locs1(pairs(:,1),:);
    locs2 = locs2(pairs(:,2),:);
    if i==3 || i==6 || i==9
        figure;
        showMatchedFeatures(cv_img,rotated_img,locs1, locs2, 'montage');
    end
    matches2 = [matches2 size(locs1,1)];
end
%%  Display histogram
figure;
bar(0:10:360, matches2);
xlabel('Rotation of Degree')
ylabel('Number of Matched Features')
title('The Plot of Histogram with SURF Detector')