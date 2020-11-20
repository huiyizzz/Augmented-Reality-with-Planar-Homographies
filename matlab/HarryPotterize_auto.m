%Q2.2.4
clear all;
close all;

cv_img = imread('../data/cv_cover.jpg');
desk_img = imread('../data/cv_desk.png');
hp_img = imread('../data/hp_cover.jpg');

%% Extract features and match
[locs1, locs2] = matchPics(cv_img, desk_img);
figure;
showMatchedFeatures(cv_img, desk_img, locs1, locs2, 'montage');
%% Compute homography using RANSAC
[bestH2to1, inliers, best_n] = computeH_ransac(locs1, locs2);
figure;
showMatchedFeatures(cv_img, desk_img, locs1(best_n, :), locs2(best_n, :), 'montage');

x2 = [];
n = find(inliers==1);
x1_inliers = locs1(n, :);
for i = 1:length(x1_inliers)
     temp = bestH2to1*[x1_inliers(i,:)'; 1];
     x2 = [x2;(temp/temp(3))'];
end
figure;
showMatchedFeatures(cv_img,desk_img, x1_inliers, x2(:,1:2), 'montage');
%% Scale harry potter image to template size
% Why is this is important?
scaled_hp_img = imresize(hp_img, [size(cv_img,1) size(cv_img,2)]);

%% Display warped image.
imshow(warpH(scaled_hp_img, bestH2to1, size(desk_img)));

%% Display composite image
imshow(compositeH(inv(bestH2to1), scaled_hp_img, desk_img));
%imshow(testH(inv(bestH2to1), scaled_hp_img, desk_img));
