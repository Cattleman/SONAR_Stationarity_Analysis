function [art_net, IsACreationIter] = apply_art(art_net,event)
%APPLY_ART : Do a ArtNet Iteration
%   Detailed explanation goes here

art_net.IteractionIndex = art_net.IteractionIndex+1;

if FindClosestNeuron(art_net,event) == -1
    % create new neuron
    art_net = CreateNewNeuron(art_net, event);
    IsACreationIter = true;
else
    % update a neuron
    art_net = UpdateNeuron(art_net, FindClosestNeuron(art_net,event), event);
    IsACreationIter = false;
end

art_net = CheckForgetNeurons(art_net);

end

function [closest_neuron] = FindClosestNeuron(art_net,event)

closest_neuron = -1;

if strcmp(art_net.training.perf_function,'norm1')
    dist = zeros(art_net.NumActNeurons,1);
    for i = 1:art_net.NumActNeurons
        dist(i) = norm(art_net.PtActNeurons(i,:)-event,1);
    end
    
    if min(dist) < art_net.training.similarity_radius
        closest_neuron = find(dist == min(dist));
    end
end

if strcmp(art_net.training.perf_function,'norm2')
    dist = zeros(art_net.NumActNeurons,1);
    for i = 1:art_net.NumActNeurons
        dist(i) = norm(art_net.PtActNeurons(i,:)-event,2);
    end
    
    if min(dist) < art_net.training.similarity_radius
        closest_neuron = find(dist == min(dist));
    end
end

if strcmp(art_net.training.perf_function,'fro')
    dist = zeros(art_net.NumActNeurons,1);
    for i = 1:art_net.NumActNeurons
        dist(i) = norm(art_net.PtActNeurons(i,:)-event,'fro');
    end
    
    if min(dist) < art_net.training.similarity_radius
        closest_neuron = find(dist == min(dist));
    end
end


end


function [art_net] = CreateNewNeuron(art_net, event)
if art_net.training.ShowIter
    fprintf('Id: %i - Creating a Neuron\n',art_net.IteractionIndex);
end
art_net.NumActNeurons = art_net.NumActNeurons+1;
art_net.PtActNeurons  = [art_net.PtActNeurons; event];
art_net.LastActIter   = [art_net.LastActIter; art_net.IteractionIndex];
end

function [art_net] = UpdateNeuron(art_net, neuron_id, event)
if art_net.training.ShowIter
    fprintf('Id: %i - Update %i Neuron\n',art_net.IteractionIndex,neuron_id);
end
old_pt = art_net.PtActNeurons(neuron_id,:);
new_pt = (1-art_net.training.eta)*old_pt+art_net.training.eta*event;
art_net.PtActNeurons(neuron_id,:) = new_pt;
art_net.LastActIter(neuron_id)   = art_net.IteractionIndex;
end

function [art_net] = CheckForgetNeurons(art_net)

NumOfRemovedNeurons = 0;
RemoveIndexes = [];

for i = 1:art_net.NumActNeurons
    if (art_net.IteractionIndex - art_net.LastActIter(i)) > art_net.NumMaxIterToForget % forget
        if art_net.training.ShowIter
            fprintf('Id: %i - Forgetting %i Neuron\n',art_net.IteractionIndex,i);
        end
        NumOfRemovedNeurons = NumOfRemovedNeurons+1;
        
        art_net.NumInactNeurons = art_net.NumInactNeurons+1;
        art_net.PtInactNeurons  = [art_net.PtInactNeurons; art_net.PtActNeurons(i,:)];
        
        RemoveIndexes = [RemoveIndexes; i]; 
    end
end

art_net.PtActNeurons(RemoveIndexes,:) = [];
art_net.LastActIter(RemoveIndexes) = [];
        

art_net.NumActNeurons = art_net.NumActNeurons - NumOfRemovedNeurons;
end