function [SP] = SPGen(vEf)
%SPGEN Summary of this function goes here
%   Detailed explanation goes here
arit_mean = 0;
geo_mean = 1;

for i = 1:length(vEf)
    arit_mean = arit_mean + vEf(i);
    geo_mean = geo_mean*vEf(i);
end

arit_mean = arit_mean/length(vEf);
geo_mean = (geo_mean)^(1/length(vEf));
SP = sqrt(arit_mean*geo_mean);
end

