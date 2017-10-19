function x = MeanInt(im1, im2)
cell.prop=regionprops(im2, im1, 'MeanIntensity');
x=[cell.prop.MeanIntensity];
end