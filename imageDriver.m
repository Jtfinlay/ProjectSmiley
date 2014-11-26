
files = dir("Data/*.jpg");
names = {files.name}';

for i=1:size(names,1)
	images = splitImages(strcat("Data/", names{i}));
	% Next step is James' or Steven's?
	for j=1:size(images,1)
		for k=1:size(images,2)
			img = images{j,k};
			% Do something with img
		end
	end
end
