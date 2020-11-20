function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = mean(x1);
centroid2 = mean(x2);

%% Shift the origin of the points to the centroid
shifted_x1 = x1 - centroid1;
shifted_x2 = x2 - centroid2;

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
avg_distance1 = mean(hypot(shifted_x1(:,1),shifted_x1(:,2)));
avg_distance2 = mean(hypot(shifted_x2(:,1),shifted_x2(:,2)));
s1 = sqrt(2) / avg_distance1;
s2 = sqrt(2) / avg_distance2;
Normalized_x1 = shifted_x1 * s1;
Normalized_x2 = shifted_x2 * s2;

%% similarity transform 1
T1 = [s1, 0, -centroid1(1)*s1; 0, s1, -centroid1(2)*s1; 0, 0, 1];

%% similarity transform 2
T2 = [s2, 0, -centroid2(1)*s2; 0, s2, -centroid2(2)*s2; 0, 0, 1];

%% Compute Homography
H = computeH(Normalized_x1, Normalized_x2);
%% Denormalization
H2to1 = T2\H*T1;
