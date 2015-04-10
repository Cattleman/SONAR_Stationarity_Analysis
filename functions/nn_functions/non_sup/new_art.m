function [art_net] = new_art(old_art_net)
%NEW_ART Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0 % criar uma nova rede art
    % Active Neurons
    art_net.IteractionIndex = 0;  % Iteraction Index (Interger)
    art_net.NumActNeurons   = 0;  % Number of active neurons (Interger)
    art_net.PtActNeurons    = []; % Center Points of active neurons (Vector) line: neuron_id column: inputs
    art_net.RadActNeurons   = []; % Radius of active neurons (Vector)
    art_net.LastActIter     = []; % Last Actualization Iteration (Vector)
    
    % Inactive Neurons
    art_net.NumInactNeurons   = 0; % Number of inactive neurons
    art_net.PtInactNeurons    = []; % Center Points of inactive neurons
    art_net.RadInactNeurons   = []; % Radius of inactive neurons
        
    %Learning Parameters
    art_net.training.eta = 0.1; % learning ratio
    art_net.training.similarity_radius = 0.1;
    art_net.training.ShowIter = true; % Show Iteraction (Boolean)
    art_net.training.perf_function = 'norm1'; % performance function: 'norm1' - Norm1 Distance
                                              %                       'norm2'- Norm2 Distance
                                              %                       'fro'- Frobenius Distance
    art_net.IsACreationIter = false; % Is A Creation Iteration? (Boolean)  
    
    % Stop Criteria
    art_net.MinVar = 1e-4; % similar of min grad NN
    art_net.NumMaxIterNoCreation = 50; % Number of Iteraction without Neuron Creation
    art_net.NumMaxIterToForget = 10; % Number of Iteraction to Forget a Neuron
    
    %art_net = class(art_net,'ArtNet');
end

if nargin == 1 % copiar a rede antiga para a rede nova
    if isstruct(old_art_net)
        art_net = old_art_net;
    end
end

if nargin > 1
    error('Impossible to export ART Net');
end
end

