function d = Thresh(x)
q=quantile(quantile(x, 0.90), 0.90)
d= x > q;
imshow(d);