function driver

  img = imread('smile.png');
  img = rgb2gray(img);
  img = im2bw(img, graythresh(img));

  preprocess(img);

end
