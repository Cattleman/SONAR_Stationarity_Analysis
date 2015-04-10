function [ purity ] = class_purity(target, output)
%CLASS_PURITY Summary of this function goes here
%   Detailed explanation goes here
%   purity = (1/n_events)*sum()

[C,CM,IND,PER] = confusion(target,output);

P = 0;
for i=1:length(CM)
    P = P + CM(i,i);
end

purity = P./sum(sum(CM));

end

