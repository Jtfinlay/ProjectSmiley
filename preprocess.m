function features = preprocess(image)
  % PREPROCESS takes an image and produces a vector with
  % found features

  features = struct('width', {},
		'height', {},
		'pixels', {},
		'midpoint', zeros(1,2),
		'x', {},
		'y', {});

  % 1. Threshold the image
  img = rgb2gray(image);
  img = im2bw(img, graythresh(img));

  % 2. Find boundaries
  [B,L] = bwboundaries(img);

  % 3. Extract features
  for k=2:numel(B),
    [features(k-1).width, features(k-1).height] = calcDim(B{k});
    features(k-1).x = min(B{k}(:,1));
    features(k-1).y = min(B{k}(:,2));
    features(k-1).pixels = calcSize(B{k},L);
    [features(k-1).midpoint(1), features(k-1).midpoint(2)] = calcMedian(B{k}, L);
  endfor

end

function showImageBounds(img, B)
  figure; imshow(img); hold on;
  for k=2:numel(B),
    plot (B{k}(:,2), B{k}(:,1), 'r', 'linewidth', 2);
  endfor
  hold off
end

function [width, height] = calcDim(bounds)
  width = max(bounds(:,1))-min(bounds(:,1));
  height = max(bounds(:,2))-min(bounds(:,2));
end

function pixels = calcSize(bounds, labels)
  label = labels(bounds(1,1), bounds(1,2));
  pixels = sum(sum(labels == label));
end

function [x,y] = calcMedian(bounds, labels)
  label = labels(bounds(1,1), bounds(1,2));
  y = findWeightCentre(sum(labels==label));
  x = findWeightCentre(sum(labels'==label));
end

function index = findWeightCentre(array)
   values = zeros(size(array));
   for k=2:(length(array)-1),
     values(k) = sum(array(1:k-1))-sum(array(k+1:end));
   end
  [tmp, index] = min(abs(values(2:end-1)));
end
