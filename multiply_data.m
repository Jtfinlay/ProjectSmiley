pkg load all


function img = new_img(image, manipulation)
   img = struct('img',image,'mod', manipulation);   
return
end

function print_imgs(images)
	for j = 1:size(images,2)
		imwrite(images(j).img, sprintf("./output/%s.png", images(j).mod));
	end
return
end

%input: an array of images.
%output: an larger array of images with each rotation from 0 to 345 degrees using 15 degree increments 
% it may be important to note this set includes the original
function rotated = all_rotations(images)
	index = 1;
	for j = 1:size(images,2)
	for deg = 0:pi/6:(2*pi - pi/6)
		R = [cos(deg) sin(deg); -sin(deg) cos(deg)];
		rotated(index++) = new_img(imperspectivewarp(images(j).img, R, :, "loose", 255), sprintf("%s_rot%f",images(j).mod, deg));
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
		flipped(index++) = new_img(imperspectivewarp(images(j).img, R, :, "loose", 255), sprintf("%s_flip",images(j).mod));
	end
return
end

%input: an array of images.
%output: an larger array of images with each rotation from 0 to 345 degrees using 15 degree increments 
% it may be important to note this set includes the original
function skewed = all_skews(images)
	index = 1;
	for j = 1:size(images,2)
		R = [cos(0) sin(0.785); -sin(0) cos(0)];
		skewed(index++) = new_img(imperspectivewarp(images(j).img, R, :, "loose", 255), sprintf("%s_Hskew%f",images(j).mod));

		R = [cos(0) sin(0); -sin(0.785) cos(0)];
		skewed(index++) = new_img(imperspectivewarp(images(j).img, R, :, "loose", 255), sprintf("%s_Vskew%f",images(j).mod));
		
	end
return
end

%input: an array of images.
%output: an larger array of images. For each image there is the original, a wide one and a skinny one.
function streched = all_streches(images)
	index = 1;
	for j = 1:size(images,2)
		streched(index++) = images(j);
		
		R = diag([0.5, 1, 1]);
		streched(index++) = new_img(imperspectivewarp(images(j).img, R, :, "loose", 255), sprintf("%s_skinny",images(j).mod));
		
		R = diag([1, 0.5, 1]);
		streched(index++) = new_img(imperspectivewarp(images(j).img, R, :, "loose", 255), sprintf("%s_wide",images(j).mod));
	end
return
end
  
%http://octave.sourceforge.net/image/function/imperspectivewarp.html

img = imread ("./smile.png");
images = all_streches(all_flips(all_skews(all_rotations([new_img(img,"orignial")]))));
print_imgs(images);

