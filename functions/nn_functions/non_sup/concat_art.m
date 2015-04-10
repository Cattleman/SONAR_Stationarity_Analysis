function [ art_net ] = concat_art(art_net1, art_net2)
%CONCAT_ART Summary of this function goes here
%   Detailed explanation goes here
if (~isstruct(art_net1) || ~isstruct(art_net2))
    error('One of this inputs is not a ART NET');
end

art_net = new_art(art_net1);

art_net.IteractionIndex = 0;

art_net.NumActNeurons = art_net.NumActNeurons + art_net2.NumActNeurons;
art_net.PtActNeurons  = [art_net.PtActNeurons; art_net2.PtActNeurons];
art_net.LastActIter   = zeros(art_net.NumActNeurons,1);
art_net.NumInactNeurons = art_net.NumInactNeurons + art_net2.NumInactNeurons;
art_net.PtInactNeurons  = [art_net.PtInactNeurons; art_net2.PtInactNeurons];
    

end

