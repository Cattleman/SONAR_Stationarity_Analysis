% Projeto de Classificacao para Marinha do Brasil

% Autor: Natanael Junior (natmourajr@gmail.com)
% Laboratorio de Processamento de Sinais - UFRJ


% Objetivos: Extrair PCDs do banco de dados
%

% iniciando o script
clear all;
close all;
clc;

fprintf('Starting %s.m\n',mfilename('fullpath'));

% get path for data
datapath = getenv('OUTPUTDATAPATH');


% importando funcoes
fprintf('Importing Functions\n');
addpath(genpath('../functions'));

% load data
fprintf('Load Data\n');

if(~exist(sprintf('%s/mat/raw_sonar_data.mat',datapath),'file'))
    error('DO READ DATA\n');
    exit;
else 
    load(sprintf('%s/mat/raw_sonar_data.mat',datapath));
end

if(~exist(sprintf('%s/mat/lofar_sonar_data.mat',datapath),'file'))
    error('DO READ DATA\n');
    exit;
else
    load(sprintf('%s/mat/lofar_sonar_data.mat',datapath));
end


%project into first and second pca.
data2pcd = [];
target2pcd = [];
target2pcd_norm = [];

fprintf('Mounting PCD Data\n');
for j = 1:numel(class_labels) % todas as classes
    fprintf('Class %s\n',class_labels{j});
    % data
    aux = total_lofar.(class_labels{j});
    data2pcd   = [data2pcd aux];
    
    % targets
    aux = ones(1,size(total_lofar.(class_labels{j}),2))*j;
    target2pcd = [target2pcd aux];
    
    % target normalized
    aux = zeros(numel(class_labels),size(total_lofar.(class_labels{j}),2));
    aux(j,:) = ones(1,size(total_lofar.(class_labels{j}),2));
    target2pcd_norm = [target2pcd_norm aux];
end

% Calculating PCD
fprintf('Calculating PCD\n');

n_folds = 20; n_init = 100; num_pcds = 10;
CVO = cvpartition(length(data2pcd),'Kfold',n_folds);

for ifolds = 1:n_folds
    trn_id =  CVO.training(ifolds);
    tst_id =  CVO.test(ifolds);
    
    itrn = []; itst = [];
    for i = 1:length(data2pcd)
        if trn_id(i) == 1
            itrn = [itrn;i];
        else
            itst = [itst;i];
        end
    end
    
    % normalization
    [data_norm, norm_fact] = mapstd(data2pcd(:,itrn));
    data_norm = mapstd('apply', data2pcd ,norm_fact);
    
    trn_params.itrain = itrn;
    trn_params.itest = itst;
    trn_params.ivalid = itst;
    trn_params.train_fnc = 'trainlm';
    trn_params.perf_fnc = 'mse';
    trn_params.act_fnc = {'tansig' 'tansig'};
    trn_params.n_epochs = 500;


    for i_init = 1:n_init
        fprintf('iFold: %i of %i - Init: %i of %i\n',ifolds, n_folds, i_init, n_init);
        if(exist(sprintf('%s/mat/pcd/pcd_folds_%i_n_init_%i.mat',datapath,ifolds,i_init)))
            fprintf('Exists\n')
            continue;
        end
        
        [pcds,net,trn_desc, sp_valid] = pcd_extractor(data_norm(1:50,:),target2pcd_norm,num_pcds,trn_params);
        save(sprintf('%s/mat/pcd/pcd_folds_%i_n_init_%i.mat',datapath,ifolds,i_init),'pcds','net','trn_desc','sp_valid');
    end
end

% Analysis
v_sp = [];
for ifolds =1:n_folds
    for i_init = 1:n_init
        fprintf('Folds %i - Init %i\n',ifolds, i_init);
        load(sprintf('%s/mat/pcd/pcd_folds_%i_n_init_%i.mat',datapath,ifolds,i_init));
        v_sp = [v_sp; sp_valid];
    end
end

h_hand = figure;
h_aux = errorbar(1:num_pcds,mean(v_sp),var(v_sp)); set(h_aux,'LineWidth',2.0); 
title(sprintf('PCD Analysis - Cross Validation - $N_{inits}:%i$, $N_{folds}: %i$',n_init,n_folds),'Interpreter','LaTex','FontSize',20,'FontWeight','bold');
xlabel('Number of PCDs','FontSize', 15,'FontWeight', 'bold');
ylabel('SP','FontSize', 15,'FontWeight', 'bold');
set(gca,'XTick',0:num_pcds+1);
grid on;

fig2pdf(h_hand, sprintf('%s/pict/pcd/pcd_analysis_cv.pdf', datapath));
close(h_hand);

% removendo funcoes
fprintf('Removing Functions\n');
rmpath(genpath('../functions'));

%exit;
