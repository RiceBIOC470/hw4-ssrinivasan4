function img_bw = randomcircle(x)
im = false([1024 1024]);
rand_pt=randperm(numel(im), 20);
im(rand_pt)=1;
img_bw=(imdilate(im, strel('disk', x)));
end