function i = randimage(x, y)
a=rand([x y]);
i = im2uint8(a);
imshow(i);
imwrite(i, 'rand8bit.tif');
end


