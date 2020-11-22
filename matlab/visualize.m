clear all;
close all;

cv_img = imread('../data/cv_cover.jpg');
desk_img = imread('../data/cv_desk.png');
hp_img = imread('../data/hp_cover.jpg');

%% Match features using the descriptors
[locs1, locs2] = matchPics(cv_img, desk_img);
figure;
showMatchedFeatures(cv_img, desk_img, locs1, locs2, 'montage');

%% visualize computeH
H2to1 = computeH(locs1, locs2);
n = randperm(size(locs2,1),10);
pre_x1 = [];
for i = 1:10
     temp = H2to1*[locs2(n(i),:)'; 1];
     pre_x1 = [pre_x1;(temp/temp(3))'];
end
figure;
showMatchedFeatures(cv_img, desk_img, pre_x1(:,1:2), locs2(n, :), 'montage');

%% visualize computeH_norm
H2to1 = computeH_norm(locs1, locs2);
n = randperm(size(locs2,1),10);
pre_x1 = [];
for i = 1:10
     temp = H2to1*[locs2(n(i),:)'; 1];
     pre_x1 = [pre_x1;(temp/temp(3))'];
end
figure;
showMatchedFeatures(cv_img, desk_img, pre_x1(:,1:2), locs2(n, :), 'montage');

%% visualize computeH_ransac
[bestH2to1, inliers, best_n] = computeH_ransac(locs1, locs2);
figure;
showMatchedFeatures(cv_img, desk_img, locs1(best_n, :), locs2(best_n, :), 'montage');
pre_x1 = [];
n = find(inliers==1);
x2_inliers = locs2(n, :);
for i = 1:length(x2_inliers)
     temp = bestH2to1*[x2_inliers(i,:)'; 1];
     pre_x1 = [pre_x1;(temp/temp(3))'];
end
figure;
showMatchedFeatures(cv_img, desk_img, pre_x1(:,1:2), x2_inliers, 'montage');