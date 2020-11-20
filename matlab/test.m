clear all;
close all;

I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png');
hp_img = imread('../data/hp_cover.jpg');
gray_I1 = I1;
gray_I2 = I2;
if ndims(gray_I1) == 3
    gray_I1 = rgb2gray(I1);
end
if ndims(gray_I2) == 3
    gray_I2 = rgb2gray(I2);
end
points1 = detectFASTFeatures(gray_I1);
points2 = detectFASTFeatures(gray_I2);
[desc1, locs1] = computeBrief(gray_I1, points1.Location);
[desc2, locs2] = computeBrief(gray_I2, points2.Location);
pairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10.0, 'MaxRatio',0.68);
locs1 = locs1(pairs(:,1),:);
locs2 = locs2(pairs(:,2),:);
%% Match features using the descriptors
figure;
showMatchedFeatures(I1,I2,locs1, locs2, 'montage');
%% computeH
H2to1 = computeH(locs1, locs2);
x2 = [];
for i = 1:size(locs1,1)
     temp = H2to1*[locs1(i,:)'; 1];
     x2 = [x2;(temp/temp(3))'];
end
figure;
showMatchedFeatures(I1,I2, locs1, x2(:,1:2), 'montage');

%% computeH_norm
H2to12 = computeH_norm(locs1, locs2);
x2 = [];
for i = 1:size(locs1,1)
     temp = H2to12*[locs1(i,:)'; 1];
     x2 = [x2;(temp/temp(3))'];
end
figure;
showMatchedFeatures(I1,I2, locs1, x2(:,1:2), 'montage');

%%
[bestH2to1, inliers] = computeH_ransac( locs1, locs2);
x2 = [];
for i = 1:size(locs1,1)
     temp = bestH2to1*[locs1(i,:)'; 1];
     x2 = [x2;(temp/temp(3))'];
end
figure;
%showMatchedFeatures(I1,I2, locs1(1,:), x2(1,1:2), 'montage');
showMatchedFeatures(I1,I2, locs1, x2(:,1:2), 'montage');

%%
max_count = 0;
inliers = [];
threshold = 0.5;
bestH2to1 = [];
best_n = [];
for iteration = 1:10000
    n = randperm(size(locs1,1),4);
    H = computeH_norm(locs1(n, :), locs2(n, :));
    temp_inliers = zeros(size(locs1,1),1);
    
    for i = 1:size(locs1,1)
        temp = H*[locs1(i,:)'; 1];
        temp = temp/temp(3);
        d = sqrt((temp(1)-locs2(i,1))^2+(temp(2)-locs2(i,2))^2);
        if d<=threshold
            temp_inliers(i) = 1;
        end   
    end
    total = length(find(temp_inliers==1));
    if total>=max_count
        best_n = n;
        max_count = total;
        inliers = temp_inliers;
        bestH2to1 = H;      
    end
end
figure;
showMatchedFeatures(I1,I2, locs1(best_n, :), locs2(best_n, :), 'montage');