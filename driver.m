pkg load all
source('./image_transformations.m');

global class_names = {':)',':-)',':(', ':-(', ':D', ':-D', ':|', ':-|', ':P', ':-P', ':O', ':-O',
'8)', '8-)','8(', '8-(', '8D', '8-D', '8|', '8-|', '8P', '8-P', '8O', '8-O',
';)', ';-)', ';(', ';-(', ';D', ';-D', ';|', ';-|', ';P', ';-P', ';O', ';-O'};


% Image info struct
function img = new_image(image, class, name)
   img = struct('img',image,... %octaves normal representation of an image
		'class', class,... %class name i.e. :) or whatever
		'name', name);  % the modifications done to the image 
				% along with its original file name and  
				% incidences (this is for debugging only)
end


% Parse class index from filename
function index = getClassIndex(fileName)
 index =  str2num(regexprep (fileName, '\D+', '$1 '));
end

% Loads all images from each file. Performs transformations to images.
%
% NOTE: Loads a lot of data into memory at once. May not want this as helper
% function.
function images = get_all_images(file_id)
	global class_names;
	images = [];
	files = dir(strcat('Data/', file_id, '*.png'));
	names = {files.name}';
	for i=1:size(names,1)
		class_index = getClassIndex(names{i});
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


to = time();
disp('Loading all images. This could take several minutes.');
fflush(stdout);
images = get_all_images('Training');
disp('Loading complete! Extracting features. This will take forever.');
fflush(stdout);

pause;
h = waitbar(0, 'Extracting features');
fid = fopen('nn_data.csv', 'w');
for i=1:length(images)
	features = preprocess(images(i).img, 6);
	line = [];
	
	for fi=1:size(features,2),
		line(end+1) = features(fi).width;
		line(end+1) = features(fi).height;
		line(end+1) = features(fi).pixels;
		line(end+1) = features(fi).x;
		line(end+1) = features(fi).y;
		line(end+1) = features(fi).midpoint(1);
		line(end+1) = features(fi).midpoint(2);
	endfor

	% Was previously flattening. I think it's slower than iteration, but
	% I can't find any decent docs online about it. Assuming octave is 
	% implemented poorly, iteration might copy the data one less time.

	%line = [line, reshape(images(i).img(:,:,1)', [], 1)']; 

	for li=1:size(images(i).img,1),
		line = [line, images(i).img(li,:)];
	endfor
	line(end+1) = find(ismember(class_names, images(i).class));
	csvwrite(fid, line);
	waitbar((i/length(images)), h, strcat('Extracting: ',num2str(100*i/length(images)),'%'));
end
close(h);
fclose(fid);

disp('Preprocessing complete! Input data can be found in nn_data.csv.');

tf = time();
disp(strcat('This only took ', num2str(tf-to), ' ms!'));
