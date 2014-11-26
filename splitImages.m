function images = splitImages(file)
% Splits our data into individual images and returns a 13x10 cell.
% This is not dynamic and only works on images exactly like
% the ones already in /Data. Might not even work on all of them :(

% numbers obtained from messing around 
% in the gold standard of image editing: Microsoft Paint
% (top-bottom) % rows == 0, (left-right) % columns == 0
rows = 13;
columns = 10;
top = 180;
bottom = top + 2990;
left = 12;
right = left + 2460;
crop = 30;

img = imread(file);
cropped = img(top:bottom-1, left:right-1, :);
images = cell(rows, columns);
height = size(cropped,1)/rows;
width = size(cropped,2)/columns;

for i=1:rows
  for j=1:columns
    tmp = cropped(((i-1)*height)+1:(i*height),((j-1)*width)+1:(j*width),:);
    images(i,j) = tmp(crop:(end-crop),crop:(end-crop), :);
  end
end