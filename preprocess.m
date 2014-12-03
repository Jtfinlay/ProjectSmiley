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
	% NOTE: Please tell me if you find a better way. This is disgusting.
	for i=1:feature_count,
		features(i).width = 0;
		features(i).height = 0;
		features(i).x = 0;
		features(i).y = 0;
		features(i).pixels = 0;
		features(i).midpoint = [0, 0];
	end

	% 1. Threshold the image
	% This is now taken care of with pr16
%	img = rgb2gray(image);
%	img = im2bw(image, graythresh(image));

	% 2. Find boundaries
	[B,L] = bwboundaries(image);
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
