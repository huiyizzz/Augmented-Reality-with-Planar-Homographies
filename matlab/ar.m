% Q3.3.1
clear all;
close all;

cv_img = imread('../data/cv_cover.jpg');
book = loadVid('../data/book.mov');
source = loadVid('../data/ar_source.mov');
video = VideoWriter('../results/ar.avi');
open(video);

for f = 1:length(source)
    disp(f);
    book_img = book(f).cdata;
    [locs1, locs2] = matchPics(cv_img, book_img);

    try
        [bestH2to1, ~, ~] = computeH_ransac(locs1, locs2);
        prev_H2to1 = bestH2to1;
    catch
        bestH2to1 = prev_H2to1;
    end

    source_img = source(f).cdata;
    source_img = source_img(50:310,210:430,:);
    scaled_cource_img = imresize(source_img, [size(cv_img,1) size(cv_img,2)]);

    img = compositeH(inv(bestH2to1), scaled_cource_img, book_img);
    writeVideo(video, img);
end

close(video)