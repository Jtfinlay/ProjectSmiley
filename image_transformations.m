%This file uses imperspectivewarp to make multiple different transformations on images
%http://octave.sourceforge.net/image/function/imperspectivewarp.html

%input: an array of images.
%output: an larger array of images with each rotation from 0 to 345 degrees using 15 degree increments 
% it may be important to note this set includes the original
function rotated = all_rotations(images)
	index = 1;
	for j = 1:size(images,2)
	for deg = 0:pi/6:(2*pi - pi/6)
		R = [cos(deg) sin(deg); -sin(deg) cos(deg)];
		rotated(index++) = new_image(imperspectivewarp(images(j).img, R, :, "loose", 255), images.class, sprintf("%s_rot%f",images(j).name, deg));
	end
	end
return
end

%input: an array of images.
%output: an larger array of images with the original and a flipped one. 
%Since I know I am rotating them all I am just flipping once as all other 
%possible flips will be taken care of by the rotation
function flipped = all_flips(images)
	index = 1;
	for j = 1:size(images,2)
		flipped(index++) = images(j);
		R = diag([-1, 1, 1]);
		flipped(index++) = new_image(imperspectivewarp(images(j).img, R, :, "loose", 255), images.class, sprintf("%s_flip",images(j).name));
	end
return
end

%input: an array of images.
%output: an larger array of images with two different skews and the original
% it may be important to note this set includes the original
function skewed = all_skews(images)
	index = 1;
	for j = 1:size(images,2)
		R = [cos(0) sin(0.785); -sin(0) cos(0)];
		skewed(index++) = new_image(imperspectivewarp(images(j).img, R, :, "loose", 255), images.class, sprintf("%s_Hskew%f",images(j).name));

		R = [cos(0) sin(0); -sin(0.785) cos(0)];
		skewed(index++) = new_image(imperspectivewarp(images(j).img, R, :, "loose", 255), images.class, sprintf("%s_Vskew%f",images(j).name));
		
	end
return
end

%input: an array of images.
%output: an larger array of images. For each image there is the original, a wide one and a skinny one.
function streched = all_stretches(images)
	index = 1;
	for j = 1:size(images,2)
		streched(index++) = images(j);
		
		R = diag([0.5, 1, 1]);
		streched(index++) = new_image(imperspectivewarp(images(j).img, R, :, "loose", 255), images.class, sprintf("%s_skinny",images(j).name));
		
		R = diag([1, 0.5, 1]);
		streched(index++) = new_image(imperspectivewarp(images(j).img, R, :, "loose", 255), images.class, sprintf("%s_wide",images(j).name));
	end
return
end

function transformations = all_training_transformations(images)
	transformations = all_stretches(all_flips(all_skews(images)));
return
end
  
function transformations = all_testing_transformations(images)
	transformations = all_training_transformations(all_rotations(images));
return
end


