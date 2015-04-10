function [ entropy ] = class_entropy(target, output)
%CLASS_ENTROPY Summary of this function goes here
%   Detailed explanation goes here

[C,CM,IND,PER] = confusion(target,output);

E = 0;

for i=1:size(CM,2) % number of original cat
    for j=1:size(CM,1) % number of target cat
        E = E - CM(i,j)*log2( CM(i,j)/sum(CM(:,j)) );
    end
end

entropy = (1/( sum(sum(CM) )*log2( size(CM,2) ) ))*E;

end

