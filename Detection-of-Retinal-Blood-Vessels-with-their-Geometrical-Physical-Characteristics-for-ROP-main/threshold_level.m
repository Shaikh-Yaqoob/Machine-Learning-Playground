function level = threshold_level(Image)

Image = im2uint8(Image(:));%image converted to unsigned integer 
[Histogram_count, Bin_Number]=imhist(Image); %calculates the histogram for the grayscale image I. The imhist function returns the histogram counts in counts and the bin locations in binLocations. The number of bins in the histogram is determined by the image type.

i=1;

Cumulative_sum = cumsum(Histogram_count);%taking cumulative sum using cumsum of histogram count
T(i) = (sum(Bin_Number.*Histogram_count))/Cumulative_sum(end); %sum of element wise multiplication of histogram count and bin number and divide it by cumulative sum index at the end

T(i)=round(T(i)); %rounding T 

Cumulative_sum_2 = cumsum(Histogram_count(1:T(i)));
MBT = sum(Bin_Number(1:T(i)).*Histogram_count(1:T(i)))/Cumulative_sum_2(end);

Cumulative_sum_3 = cumsum(Histogram_count(T(i):end));
MAT = sum(Bin_Number(T(i):end).*Histogram_count(T(i):end))/Cumulative_sum_3(end);

i=i+1;
T(i) = round( (MAT+MBT)/2);

while abs(T(i)-T(i-1))>=1

Cumulative_sum_2 = cumsum(Histogram_count(1:T(i)));
MBT = sum(Bin_Number(1:T(i)).*Histogram_count(1:T(i)))/Cumulative_sum_2(end);

Cumulative_sum_3 = cumsum(Histogram_count(T(i):end));
MAT = sum(Bin_Number(T(i):end).*Histogram_count(T(i):end))/Cumulative_sum_3(end);

i=i+1;
T(i) = round( (MAT+MBT)/2); % it is threshold we store it in variblle name threshold below

Threshold = T(i);

end

level = (Threshold - 1) / (Bin_Number(end) - 1); %finally, normalize the threshold 

end