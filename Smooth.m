function [im_sm, im_bg, im_sub] = Smooth(w, x, y,z)
im_sm=imfilter(w, fspecial('gaussian', x,y));
im_bg=imopen(im_sm, strel('disk', z));
im_sub=imsubtract(im_sm, im_bg);
imshow(im_sub, []);
end