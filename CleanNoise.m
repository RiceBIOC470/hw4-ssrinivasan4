function e = CleanNoise(x)
e=imopen(x, strel('disk', 8));
imshow(e);
end