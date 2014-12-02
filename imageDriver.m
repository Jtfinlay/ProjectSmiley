pkg load all
source('./image_transformations.m');
% I had asked if we want to pair more data to our images. I was just told how the images where loaded
% Which I guess means no one cares if I add more data to the images
% So currently I am using my simple struct which is define as below
%If there is any problem with this feel free to change it or ask me to.
function img = new_image(image, class, name)
   img = struct('img',image,... %octaves normal representation of an image
		'class', class,... %class name i.e. :) or whatever
		'name', name);  % the modifications done to the image 
						% along with its original file name and  
						% incidences (this is for debugging only)		
end


function index = getClassIndex(fileName)
 index =  str2num(regexprep (fileName, '\D+', '$1 '));
end

%loads all images from each file, then does all transformations to them
%this may load a lot of data into memory at once and so maybe it wasn't smart 
%to make this a helper function but we will see
function images = get_all_images()
	class_names = {':)',':-)',':(', ':-(', ':D', ':-D', ':|', ':-|', ':P', ':-P', ':O', ':-O', 
					'8)', '8-)','8(', '8-(', '8D', '8-D', '8|', '8-|', '8P', '8-P', '8O', '8-O', 
					';)', ';-)', ';(', ';-(', ';D', ';-D', ';|', ';-|', ';P', ';-P', ';O', ';-O'};
	images = [];
	files = dir("Data/*.png");
	names = {files.name};
	for i=1:size(names,1)
		class_index = getClassIndex(names(i){1});
		original_images = splitImages(strcat("Data/", names{i}));
		for j=1:size(original_images,1)
			for k=1:size(original_images,2)
				current_image = new_image(original_images{j,k}, class_names{class_index}, sprintf("%s_%d_%d", names{i}, j,k)); %Create new image
				transformed_images = all_training_transformations([current_image]);%get a this image and all of its transformations
				images = [ images, transformed_images];%concat to main list
			end
		end
	end
end


images = get_all_images();
%for i=1:size(images, 2)
	%preprocessImage(images(i).img);
	%learnImage() or whatever
%end




