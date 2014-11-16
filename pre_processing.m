function features = preprocess(image)
  % PREPROCESS takes an image and produces a vector with
  % found features

  imshow(image);
  fprintf('Showing image. Paused\n');

  img = rg2gray(image);
  img = im2bw(img, graythresh(img));

  imshow(img);
  fprintf('Showing 2-pixel image. Paused\n');





end
