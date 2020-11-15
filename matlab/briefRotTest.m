% Your solution to Q2.1.5 goes here!
clear all;
close all;

%% Read the image and convert to grayscale, if necessary
cv_img = imread('../data/cv_cover.jpg');
if ndims(cv_img) == 3
    cv_img = rgb2gray(cv_img);
end
%% Compute the features and descriptors
points = detectFASTFeatures(cv_img);
[desc, locs] = computeBrief(cv_img, points.Location);
%% get matched result
matches = [];
for i = 0:36
    %% Rotate image
    rotated_img = imrotate(cv_img, 10*i);    
    %% Compute features and descriptors
    rotated_points = detectFASTFeatures(rotated_img);
    [rotated_desc, rotated_locs] = computeBrief(rotated_img, rotated_points.Location);
    %% Match features
    pairs = matchFeatures(desc, rotated_desc, 'MatchThreshold', 10.0, 'MaxRatio',0.68);
    if i==3 || i==6 || i==9
        locs1 = locs(pairs(:,1),:);
        locs2 = rotated_locs(pairs(:,2),:);
        figure;
        showMatchedFeatures(cv_img,rotated_img, locs1, locs2, 'montage');
    end
    %% Update histogram
    matches = [matches length(pairs)];
end

%% Display histogram
figure;
bar(0:10:360, matches);

%% Using another feature detector
points = detectSURFFeatures(cv_img);
[desc, locs] = extractFeatures(cv_img, points.Location, 'Method', 'SURF');
matches = [];
for i = 0:36
    rotated_img = imrotate(cv_img, 10*i);    
    rotated_points = detectSURFFeatures(rotated_img);
    [rotated_desc, rotated_locs] = extractFeatures(rotated_img, rotated_points.Location, 'Method', 'SURF');
    pairs = matchFeatures(desc, rotated_desc, 'MatchThreshold', 10.0, 'MaxRatio',0.68);
    if i==3 || i==6 || i==9
        locs1 = locs(pairs(:,1),:);
        locs2 = rotated_locs(pairs(:,2),:);
        figure;
        showMatchedFeatures(cv_img,rotated_img,locs1, locs2, 'montage');
    end
    matches = [matches length(pairs)];
end
%%
figure;
bar(0:10:360, matches);