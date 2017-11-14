%HW4 Sanjana Srinivasan
%% 

%GB comments:
1a 100
1b 100
1c 100
1d 25 Incorrect plot and with no explanation of the result as the question asks. The plot provided in the code produces a graph with the mean along the x-axis and and standard deviation on the y-axis. To address the question, there should have been two plots. One with mean intensity as a function of the circle size and the second with standard deviation values as a function of circle size. 
2a 100 It appears your final output avi is saturated. On paper, your directions are fine, but I am curious to know whether you altered the LUT to increase the brightness in channel 2?
2b. 70  Currently the script normalizes intensities for each channel along the time domain. It does not calculate the max intensity across the Z direction for a single time point and channel. To do so, you need to iterate through Z positions (6 positions) for each channel and time point. 
3a. 50 In a max intensity projection you want to grab the max intensity in the xy plane across all Z sections from a single time point. It appears you are iterating the loop (k) 19 times, which is the time domain and not the Zdomain (6 ). Additionally It does not appear that you are retaining the highest intensity pixels once iterating. 
3b 100
3c 100
3d 100
3e 100
4a. 100
4b. 100
 Overall = 88

% Problem 1. 

% 1. Write a function to generate an 8-bit image of size 1024x1024 with a random value 
% of the intensity in each pixel. Call your image rand8bit.tif. 
image1=randimage(1024, 1024);
% 2. Write a function that takes an integer value as input and outputs a
% 1024x1024 binary image mask containing 20 circles of that size in random
% locations
image2=randomcircle(4);
% 3. Write a function that takes the image from (1) and the binary mask
% from (2) and returns a vector of mean intensities of each circle (hint: use regionprops).
%
mean_intensity=MeanInt(image2, image1);
% 4. Plot the mean and standard deviation of the values in your output
% vector as a function of circle size. Explain your results. 
mat_mean=[];
mat_sd=[];
for i=1:50:1000
    image=randomcircle(i);
    mean_int=MeanInt(image, image1);
    sd=std(mean_int);
    mat_mean=[mat_mean mean(mean_int)];
    mat_sd=[mat_sd sd];
end

plot(mat_mean, mat_sd, 'r.','MarkerSize', 10);
xlabel('Mean', 'FontSize', 10);
ylabel('Standard Deviation', 'FontSize', 10);
   
    

%

%Problem 2. Here is some data showing an NFKB reporter in ovarian cancer
%cells. 
%https://www.dropbox.com/sh/2dnyzq8800npke8/AABoG3TI6v7yTcL_bOnKTzyja?dl=0
%There are two files, each of which have multiple timepoints, z
%slices and channels. One channel marks the cell nuclei and the other
%contains the reporter which moves into the nucleus when the pathway is
%active. 
%
%Part 1. Use Fiji to import both data files, take maximum intensity
%projections in the z direction, concatentate the files, display both
%channels together with appropriate look up tables, and save the result as
%a movie in .avi format. Put comments in this file explaining the commands
%you used and save your .avi file in your repository (low quality ok for
%space). 

% nfkbmovie1 = Image ->Stacks -> Z project -> Max intensity
% nfkbmovie2 = Image ->Stacks -> Z project -> Max intensity
% Concat Stacks = Image -> Stacks -> Tools -> Concatenate
% Combined Channels = Image -> Color -> Merge Channels
% Concat Stacks -> Image -> Look up Tables -> Red/Green


%Part 2. Perform the same operations as in part 1 but use MATLAB code. You don't
%need to save the result in your repository, just the code that produces
%it. 

reader1=bfGetReader('nfkb_movie1.tif');
reader2=bfGetReader('nfkb_movie2.tif');
image1_time=reader1.getSizeT;
image_chan=reader.getSizeC;
image2_time=reader2.getSizeT;

zplane=reader2.getSizeZ; %same value of 6 for both reader1 and reader2

v=VideoWriter('hw4q2.tif');
open(v);
for i=1:image1_time 
    iplane1=reader1.getIndex(zplane-1,0,i-1)+1;
    img1=bfGetPlane(reader1, iplane1);
    iplane2=reader1.getIndex(zplane-1,1,i-1)+1;
    img2=bfGetPlane(reader1, iplane2);
    catim1=cat(3, imadjust(img1), imadjust(img2), zeros(size(img1)));
    imdoub=im2double(catim1);
    imbright=uint16((2^16-1)*(imdoub./max(max(imdoub))));
    imwrite(imbright,'hw4q2.tif','WriteMode','append');
    writeVideo(v,im2double(imbright));
end
for i=1:image2_time 
    iplane1=reader2.getIndex(zplane-1,0,i-1)+1;
    img1=bfGetPlane(reader2, iplane1);
    iplane2=reader2.getIndex(zplane-1,1,i-1)+1;
    img2=bfGetPlane(reader2, iplane2);
    catim1=cat(3, imadjust(img1), imadjust(img2), zeros(size(img1)));
    imdoub2=im2double(catim1);
    imbright2=uint16((2^16-1)*(imdoub2./max(max(imdoub2))));
    imwrite(imbright2,'hw4q2.tif','WriteMode','append')
    writeVideo(v,im2double(imbright2));
end
close(v);


%%

% Problem 3. 
% Continue with the data from part 2
% 
% 1. Use your MATLAB code from Problem 2, Part 2  to generate a maximum
% intensity projection image of the first channel of the first time point
% of movie 1. 

iplane3_1=reader1.getIndex(zplane-1,0,1-1)+1;
img3_1=bfGetPlane(reader1, iplane3_1);
im3_1doub=im2double(img3_1);
imbright3_1=uint16((2^16-1)*(im3_1doub./max(max(im3_1doub))));

% 2. Write a function which performs smoothing and background subtraction
% on an image and apply it to the image from (1). Any necessary parameters
% (e.g. smoothing radius) should be inputs to the function. Choose them
% appropriately when calling the function.

[im_sm, im_bg, im_sub] = Smooth(imbright3_1, 4, 2, 100);


% 3. Write  a function which automatically determines a threshold  and
% thresholds an image to make a binary mask. Apply this to your output
% image from 2. 
sub_mask=Thresh(im_sub);
% 4. Write a function that "cleans up" this binary mask - i.e. no small
% dots, or holes in nuclei. It should line up as closely as possible with
% what you perceive to be the nuclei in your image. 
clean_img=CleanNoise(sub_mask);

% 5. Write a function that uses your image from (2) and your mask from 
% (4) to get a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1. 
[count, area, intensity] = ImgArea(im_sub, clean_img);


% 6. Apply your function from (2) to make a smoothed, background subtracted
% image from channel 2 that corresponds to the image we have been using
% from channel 1 (that is the max intensity projection from the same time point). Apply your
% function from 5 to get the mean intensity of the cells in this channel. 

iplane3_6=reader1.getIndex(1-1,2-1,1-1)+1;
img3_1=bfGetPlane(reader1, iplane3_6);

for i = 2:zplane
    iplane_temp=reader1.getIndex(i-1, 2-1, 1-1)+1;
    img_temp=bfGetPlane(reader1, iplane_temp);
    img3_1=max(img3_1, img_temp);
end
    
im_smooth=Smooth(img3_1, 4, 2, 100);
im36_mask=Thresh(im_smooth);

[count36, area36, intensity36] = ImgArea(im_smooth, im36_mask);


%%
% Problem 4. 

% 1. Write a loop that calls your functions from Problem 3 to produce binary masks
% for every time point in the two movies. Save a movie of the binary masks.
% 
reader1=bfGetReader('nfkb_movie1.tif');
reader2=bfGetReader('nfkb_movie2.tif');
image1_time=reader1.getSizeT;
image2_time=reader2.getSizeT;

v4=VideoWriter('hw4q4.avi');
open(v4);

for k = 1:image1_time
    iplane4=reader1.getIndex(1-1,1-1,k-1)+1;
    img3_1=bfGetPlane(reader1, iplane4);

    for i = 2:reader1.getSizeZ
        iplane_temp=reader1.getIndex(i-1, 2-1, k-1)+1;
        img_temp=bfGetPlane(reader1, iplane_temp);
        img3_1=max(img3_1, img_temp);
    end
    im_smooth=Smooth(img3_1, 4, 2, 100);
    im4_mask=Thresh(im_smooth);
    writeVideo(v4, im2double(im4_mask));
end

for k = 1:image2_time
    iplane4_im2=reader2.getIndex(1-1,1-1,k-1)+1;
    img4_im2=bfGetPlane(reader2, iplane4_im2);

    for i = 2:reader2.getSizeZ
        iplane_temp=reader2.getIndex(i-1, 2-1, k-1)+1;
        img_temp=bfGetPlane(reader2, iplane_temp);
        img4_im2=max(img4_im2, img_temp);
    end
    im_smooth2=Smooth(img4_im2, 4, 2, 100);
    im4_mask2=Thresh(im_smooth2);
    writeVideo(v4, im2double(im4_mask2));
end
close(v4);


% 2. Use a loop to call your function from problem 3, part 5 on each one of
% these masks and the corresponding images and 
% get the number of cells and the mean intensities in both
% channels as a function of time. Make plots of these with time on the
% x-axis and either number of cells or intensity on the y-axis. 
reader1=bfGetReader('nfkb_movie1.tif');
reader2=bfGetReader('nfkb_movie2.tif');
image1_time=reader1.getSizeT;
image2_time=reader2.getSizeT;

l =1;
iplane3_6=reader1.getIndex(1-1,2-1,1-1)+1;
img3_1=bfGetPlane(reader1, iplane3_6);

for j = 1:reader1.getSizeT
    iplane42 = reader1.getIndex(1-1,1-1,j-1)+1;
    img42 = bfGetPlane(reader1,iplane42);
    iplane42_ch2 = reader1.getIndex(1-1,2-1,j-1)+1;
    img42_ch2 = bfGetPlane(reader1,iplane42_ch2);
    
    temp_im1=im2double(img42);
    im42_smooth=Smooth(temp_im1, 4, 2, 100);
    im42_mask=Thresh(im42_smooth);
    im42_clean=CleanNoise(im42_mask);
    [count42, area42, intensity42] = ImgArea(im42_smooth, im42_mask);
    

    
    temp_im2=im2double(img42_ch2);
    im42_ch2smooth=Smooth(temp_im2, 4, 2, 100);
    im42_ch2mask=Thresh(im42_ch2smooth);
    im42_ch2clean=CleanNoise(im42_ch2mask);
    [count42_2, area42_2, intensity42_2] = ImgArea(im42_ch2smooth, im42_ch2mask);
    
    cells_1(1,l) = count42;
    cells_1(2,l) = count42_2;  
    meanint_1(1,i) = intensity42;
    meanint_1(2,i) = intensity42_2;
    l = l+1;
    
end
for j = 1:reader2.getSizeT
    iplane_t2 = reader2.getIndex(1-1,1-1,j-1)+1;
    img_t2 = bfGetPlane(reader2,iplane_t2);
    iplanet2_ch2 = reader2.getIndex(1-1,2-1,j-1)+1;
    imgt2_ch2 = bfGetPlane(reader2,iplanet2_ch2);
    
    temp_t2=im2double(img_t2);
    imt2_smooth=Smooth(temp_t2, 4, 2, 100);
    imt2_mask=Thresh(imt2_smooth);
    imt2_clean=CleanNoise(imt2_mask);
    [countt2, areat2, intensityt2] = ImgArea(imt2_smooth, imt2_mask);
    

    
    tempt2_im2=im2double(imgt2_ch2);
    imt2_ch2smooth=Smooth(tempt2_im2, 4, 2, 100);
    imt2_ch2mask=Thresh(imt2_ch2smooth);
    imt2_ch2clean=CleanNoise(imt2_ch2mask);
    [countt2_2, areat2_2, intensityt2_2] = ImgArea(imt2_ch2smooth, imt2_ch2mask);
    
    cells_1(1,l) = countt2;
    cells_1(2,l) = countt2_2;  
    meanint_1(1,l) = intensityt2;
    meanint_1(2,l) = intensityt2_2;
    l = l+1;
end

figure;
plot(1:l-1,meanint_1(1,:));
hold on;
plot(1:l-1,meanint_1(2,:));
xlabel('Time');
ylabel('Mean Intensity');

figure;

plot(1:l-1,cells_1(1,:));
hold on;
plot(1:l-1,cells_1(2,:));

xlabel('Time');
ylabel('Number of Cells');

