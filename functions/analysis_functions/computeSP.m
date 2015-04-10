function [SP] = computeSP(target,output)
%COMPUTESP Summary of this function goes here
%   Detailed explanation goes here

[a,b,c,d] = confusion(target,output);

eff_per_class = d(:,3);

arit_mean = sum(eff_per_class)/length(eff_per_class);
geo_mean = prod(eff_per_class)^(1/length(eff_per_class));

SP = sqrt(arit_mean*geo_mean);

end

