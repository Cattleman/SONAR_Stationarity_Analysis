function [pcds,net,trn_desc, sp_valid] = pcd_extractor(inputs, targets, num_pcds, trn_params, verbose)
%PCD_EXTRATOR Extract PCD (principal components of discrimination) from data
%   Extract PCD with a Neural Network Train.
%   
%   inputs: Vector of Inputs (rows: features, columns: events)
%   targets: Vector of Targets (rows: targets, columns: events)
%   trn_params: struct with NN train Parameters
%               trn_params.itrain: train indexes
%               trn_params.itest: test indexes
%               trn_params.ivalid: validation indexes
%               trn_params.train_fnc: train function
%               trn_params.perf_fnc: performance function
%               trn_params.act_fnc: activation function
%               trn_params.n_epoch: number of epochs
%   verbose: flag to show training in commmand line

if nargin < 4
    error('pcd_extractor: Invalid Number of Arguments\n');
end

if nargin < 5   
    verbose  = true;
end

if size(inputs,2) < size(inputs,1)
    inputs = inputs';
end

if size(targets,2) < size(targets,1)
    targets = targets';
end

if length(targets) ~= length(inputs)
    error('pcd_extractor: Input and Target have different lengths\n');
end

if verbose,
    fprintf('\n \nFunction pcd_extrator\n');
    fprintf('nargin: %i\n', nargin);
    fprintf('Size Input: %i lin %i col\n', size(inputs,1), size(inputs,2));
    fprintf('Size Target: %i lin %i col\n', size(targets,1), size(targets,2));
    fprintf('Size iTrain: %i lin %i col\n', size(trn_params.itrain,1), size(trn_params.itrain,2));
    fprintf('Size iTest: %i lin %i col\n', size(trn_params.itest,1), size(trn_params.itest,2));
    fprintf('Size iValid: %i lin %i col\n', size(trn_params.ivalid,1), size(trn_params.ivalid,2));
    fprintf('Train Fnc: %s\n', trn_params.train_fnc);
    fprintf('perf_fnc: %s\n', trn_params.perf_fnc);
    fprintf('act_fnc: %s\n', trn_params.act_fnc{1});
    fprintf('Epochs: %i\n', trn_params.n_epochs);
    fprintf('\n \n');
end

datapath = getenv('OUTPUTDATAPATH');

if(~exist(sprintf('%s/mat/pcd/pcd_net_%i_inputs_%i_numpcds_%i_outputs.mat',datapath,size(inputs,1),num_pcds,size(targets,1)),'file'))
    fprintf('Creating New PCD Net\n');
    net =  createPCDNN(inputs, targets, num_pcds, trn_params);
    save(sprintf('%s/mat/pcd/pcd_net_%i_inputs_%i_numpcds_%i_outputs.mat',datapath,size(inputs,1),num_pcds,size(targets,1)),'net');
else
    load(sprintf('%s/mat/pcd/pcd_net_%i_inputs_%i_numpcds_%i_outputs.mat',datapath,size(inputs,1),num_pcds,size(targets,1)));
end

net = init(net);
pcds = [];
sp_valid = [];

trn_desc = [];
% changing connections: hidden to output
for i=1:num_pcds
    if verbose, fprintf('pcd_extractor: Getting PCD %i\n',i); end
    %net.LW
    if verbose, fprintf('pcd_extractor: Changing connections for Neuron %i',i); end
    net.layerConnect(size(inputs,1)+num_pcds+1,size(inputs,1)+i) = 1; % connect new neuron from hidden to output
    if verbose, fprintf(' - Done\n'); end
    
    if verbose, fprintf('pcd_extractor: Randomizing Weight for neuron %i',i); end
    net.LW{size(inputs,1)+num_pcds+1,size(inputs,1)+i}= randn(1,1); % just to initialize weigths
    if verbose, fprintf(' - Done\n'); end
    
    if verbose, fprintf('pcd_extractor: Train Proccess\n',i); end
    [net, trn_desc{i}] = train(net,inputs,targets);
    
    
    % freezing weights
    % input to hidden
    if verbose, fprintf('pcd_extrator: Freezing Weights\n'); end
    net.layerWeights{size(inputs,1)+i,i}.learn = 0;
    % hidden to output
    %net.layerWeights{size(inputs,1)+num_pcds+1,size(inputs,1)+i}.learn = 0;
    fprintf('\n');
    %net.LW
    aux = [];
    for j = 1:size(inputs,1)
        aux = [aux; net.LW{size(inputs,1)+i,j}];
    end
    pcds = [pcds aux];
    
    %pcds_energy = [pcds_energy; net.LW{size(inputs,1)+num_pcds+1,size(inputs,1)+i}]; 
    
    fprintf('pcd_extractor: Validation Set Analysis\n');
    % Calcular SP
    sp_valid(i) = computeSP(targets(:,trn_params.ivalid),sim(net,inputs(:,trn_params.ivalid)));
end


end

