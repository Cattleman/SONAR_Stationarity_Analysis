function [net] = createPCDNN(inputs, targets, num_pcds, trn_params, verbose)
%CREATEPCDNN Create a NN to extract PCDs
%   Output:  net - neural network object
%   
%   Inputs:
%          inputs: Vector of Inputs (rows: features, columns: events)
%          targets: Vector of Targets (rows: targets, columns: events)
%          trn_params: struct with NN train Parameters
%               trn_params.itrain: train indexes
%               trn_params.itest: test indexes
%               trn_params.ivalid: validation indexes
%               trn_params.train_fnc: train function
%               trn_params.perf_fnc: performance function
%               trn_params.act_fnc: activation function
%               trn_params.n_epoch: number of epochs
%               trn_params.top: neural network topology
%   verbose: flag to show training in commmand line
                        
if nargin < 4
    error('createPCDNN: Invalid Number of Arguments\n');
end

if nargin < 5   
    verbose  = true;
end


if verbose,
    fprintf('\n \nFunction createPCDNN\n');
    fprintf('nargin: %i\n', nargin);
    fprintf('Size Input: %i lin %i col\n', size(inputs,1), size(inputs,2));
    fprintf('Size Target: %i lin %i col\n', size(targets,1), size(targets,2));
    fprintf('Size iTrain: %i lin %i col\n', size(trn_params.itrain,1), size(trn_params.itrain,2));
    fprintf('Size iTest: %i lin %i col\n', size(trn_params.itest,1), size(trn_params.itest,2));
    fprintf('Size iValid: %i lin %i col\n', size(trn_params.ivalid,1), size(trn_params.ivalid,2));
    fprintf('Train Fnc: %s\n', trn_params.train_fnc);
    fprintf('Performance Fnc: %s\n', trn_params.perf_fnc);
    fprintf('Activation Fnc: %s\n', trn_params.act_fnc{1});
    fprintf('Epochs: %i\n', trn_params.n_epochs);
    fprintf('\n \n');
end

if verbose, fprintf('createPCDNN: Creating the Neural Network Object\n'); end
net = network;

if verbose, fprintf('createPCDNN: Creating Inputs Struct -  Number of Inputs: %i\n', size(inputs,1)); end
net.numInputs = size(inputs,1);
fprintf('createPCDNN: Number of Inputs -> %i\n',size(inputs,1))

if verbose, fprintf('createPCDNN: Creating Layers of NN -  Number of Layers: %i\n', size(inputs,1)+num_pcds+size(targets,1)); end
net.numLayers = size(inputs,1)+num_pcds+size(targets,1);
% number of layers: one layer for each inputs, max number of PCD will be size(inputs) and one for each output

%if verbose, fprintf('createPCDNN: Changing Layers Name'); end
%for i = 1:size(inputs,1)
%    net.layers{i}.name = sprintf('Input %i Buffer',i);
%end

%for i = 1:num_pcds
%    net.layers{size(inputs,1)+i}.name = sprintf('PCD %i Layer',i);
%end

%for i = 1:size(targets,1)
%    net.layers{2*size(inputs,1)+i}.name = sprintf('Output %i Layer',i);
%end



if verbose, fprintf('createPCDNN: Creating Output Struct - Number of Outputs: %i\n', size(targets,1)); end
%numOutputs = size(targets,1);

if verbose, fprintf('createPCDNN: Creating Inputs Connections\n'); end
for i = 1:size(inputs,1)
    if verbose, fprintf('Creating neuron %i input connection \n', i); end
    net.inputConnect(i,i) = 1;
end
% the ith input will only be connected with the ith layer

if verbose, fprintf('createPCDNN: Creating Output Connections\n'); end
net.outputConnect = [zeros(size(inputs,1)+num_pcds,1)' ones(size(targets,1),1)'];
% output connections: only last layer should have connection with output.

if verbose, fprintf('createPCDNN: Creating inter-layer Connections\n'); end
%input layer to hidden
for i=1:size(inputs,1)
    for j=1:num_pcds
        net.layerConnect(size(inputs,1)+j,i) = 1;
    end
end

 % hidden to output
 for i=1:num_pcds
     for j=1:size(targets,1)
         net.layerConnect(size(inputs,1)+num_pcds+j,size(inputs,1)+i) = 1;
     end
 end

if verbose, fprintf('createPCDNN: Getting to NN inputs examples\n'); end
for i = 1:size(inputs,1)
    net.inputs{i}.exampleInput = inputs(i,1);
end

if verbose, fprintf('createPCDNN: Removing Input pre-processing functions\n'); end
for i = 1:size(inputs,1)
    net.inputs{i}.processFcns = {};
end

if verbose, fprintf('createPCDNN: Removing Output pos-processing functions\n'); end
for i = 1:size(targets,1)
    net.outputs{i}.processFcns = {};
end


if verbose, fprintf('createPCDNN: Setting Input Layers Prop.\n'); end
for i = 1:size(inputs,1)
    net.layers{i}.size = 1;
    net.layers{i}.transferFcn = 'purelin';
    net.layers{i}.initFcn = ''; % no init
end

if verbose, fprintf('createPCDNN: Setting Hidden Layers Prop.\n'); end
for i=1:num_pcds  
    net.layers{size(inputs,1)+i}.size = 1;
    net.layers{size(inputs,1)+i}.transferFcn = trn_params.act_fnc{1};
    net.layers{size(inputs,1)+i}.initFcn = 'initnw'; % matlab init values
end

if verbose, fprintf('createPCDNN: Setting Output Layers Prop.\n'); end
fprintf('createPCDNN: Number of Outputs: %i\n',size(targets,1))
for i = 1:size(targets,1)
    net.layers{size(inputs,1)+num_pcds+i}.size = 1;
    net.layers{size(inputs,1)+num_pcds+i}.transferFcn = trn_params.act_fnc{2};
    net.layers{size(inputs,1)+num_pcds+i}.initFcn = 'initnw'; % matlab init values
end

if verbose, fprintf('createPCDNN: Setting NN Prop.\n'); end
net.trainFcn                    = trn_params.train_fnc;
net.performFcn                  = trn_params.perf_fnc;

net.trainParam.lr               = 0.000001;
net.trainParam.max_fail         = 50;
net.trainParam.mc               = 0.99999;
net.trainParam.min_grad         = 1e-10;
net.trainParam.goal             = 0;
net.trainParam.epochs           = trn_params.n_epochs;

net.divideFcn                   = 'divideind';
net.divideParam.trainInd        = trn_params.itrain;
net.divideParam.testInd         = trn_params.itest;
net.divideParam.valInd          = trn_params.ivalid;

net.trainParam.show             = net.trainParam.max_fail;
net.trainParam.showWindow       = false;
net.trainParam.showCommandLine  = true;


if verbose, fprintf('createPCDNN: Creating Inputs Weigths\n'); end
for i = 1:size(inputs,1)
    net.IW{i,i} = 1;
    net.inputWeights{i,i}.learn = 0;
    % this weigth will not change in training process
end

if verbose, fprintf('createPCDNN: End\n\n\n'); end

end

