function [ bestH2to1, inliers, best_n] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.
%Q2.2.3
threshold = 1;
max_count = 0;
inliers = [];
bestH2to1 = [];
best_n = [];
for iteration = 1:2000
    n = randperm(size(locs1,1),4);
    H = computeH_norm(locs1(n, :), locs2(n, :));
    temp_inliers = zeros(size(locs1,1),1);
    for i = 1:size(locs2,1)
        temp = H*[locs2(i,:)'; 1];
        temp = temp/temp(3);
        distance = sqrt((temp(1)-locs1(i,1))^2+(temp(2)-locs1(i,2))^2);
        if distance<=threshold
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
end

