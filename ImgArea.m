function [count, area, intensity] = ImgArea(x, y)
dat=regionprops(y, x, 'MeanIntensity', 'Area');
count=length(dat);
intensity=mean([dat(1:count).MeanIntensity]);
area=mean([dat(1:count).Area]);
end