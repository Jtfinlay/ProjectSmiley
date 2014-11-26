function features = preprocess(image, feature_count)
	% PREPROCESS takes an image and produces a vector with
	% found features. Takes an expected number of features
	% as well

	features = struct('width', 0,
		'height', 0,
		'pixels', 0,
		'midpoint', zeros(1,2),
		'x', 0,
		'y', 0);

	% This is stupid, but it's the best way I found to initialize structs
	% in octave.
	features(feature_count).x = [];

	% 1. Threshold the image
	img = rgb2gray(image);
	img = im2bw(img, graythresh(img));

	% 2. Find boundaries
	[B,L] = bwboundaries(img);
	B(1,:) = [];

	% 3. Extract features
	for k=1:min(numel(B), feature_count),
		[features(k).width, features(k).height] = calcDim(B{k});
		features(k).y = min(B{k}(:,1));
		features(k).x = min(B{k}(:,2));
		features(k).pixels = calcSize(B{k},L);
		[features(k).midpoint(1), features(k).midpoint(2)] = calcMedian(B{k}, L);
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
	height = max(bounds(:,1))-min(bounds(:,1));
	width = max(bounds(:,2))-min(bounds(:,2));
end

function pixels = calcSize(bounds, labels)
	label = labels(bounds(1,1), bounds(1,2));
	pixels = sum(sum(labels == label));
end

function [x,y] = calcMedian(bounds, labels)
	label = labels(bounds(1,1), bounds(1,2));
	x = findWeightCentre(sum(labels==label));
	y = findWeightCentre(sum(labels'==label));
end

function index = findWeightCentre(array)
	values = zeros(size(array));
	for k=2:(length(array)-1),
		values(k) = sum(array(1:k-1))-sum(array(k+1:end));
	end
	[tmp, index] = min(abs(values(2:end-1)));
end
