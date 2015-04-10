% Projeto de Classificacao para Marinha do Brasil

%Autor: Natanael Junior (natmourajr@gmail.com)
% Laboratorio de Processamento de Sinais - UFRJ

% Segundo Approach

% iniciando o script
clear all;
close all;
clc;

fprintf('Starting %s.m\n',mfilename('fullpath'));

% importando funcoes
fprintf('Importing Functions\n');
addpath(genpath('../functions'));

% get path for data
outputpath = getenv('OUTPUTDATAPATH');

% load data
fprintf('Load Data\n'); 

if(~exist(sprintf('%s/mat/raw_sonar_data.mat',outputpath),'file'))
    error('DO READ DATA\n');
    exit;
else 
    load(sprintf('%s/mat/raw_sonar_data.mat',outputpath));
end

if(~exist(sprintf('%s/mat/lofar_sonar_data.mat',outputpath),'file'))
    error('DO READ DATA\n');
    exit;
else
    load(sprintf('%s/mat/lofar_sonar_data.mat',outputpath));
end


if(~exist(sprintf('%s/mat/pca/pca_90_energy.mat',outputpath),'file'))
    error('DO EXTRACT PCA\n');
    exit;
else 
    load(sprintf('%s/mat/pca/pca_90_energy.mat',outputpath));
end


% novelty detector
fprintf('Novelty Detector\n');

%project into first and second pca.
novelty_data = [];
novelty_target = [];
novelty_target_norm = [];

fprintf('Mounting Novelty Detector Data\n');

novelty_data = [];
novelty_target = [];

n_pcas = 2;

for j = 1:numel(class_labels) % todas as classes
    fprintf('Class %s\n',class_labels{j});
    % data
    aux = [total_lofar.(class_labels{j})'*pcas(:,1:n_pcas)]; 
    novelty_data   = [novelty_data; aux];
    
    % targets
    aux = ones(size(aux,1),1)*j;
    novelty_target = [novelty_target; aux];
     
end


CVO = cvpartition(length(novelty_data),'Kfold',2);
trn_id =  CVO.training(1);
tst_id =  CVO.test(1);

warning('off')

fracrej = 0.0001; %rejection fraction
%v_fracrej = [0.00001 0.0001 0.001 0.01 0.1 0.5 0.9];
v_fracrej = [0.001 0.01 0.1 0.15 0.2 0.3 ];
param = 0.9;

n_init = 2;
max_error = 0.03;

v_iclass = [1 2 3 4];

v_tx_error_without_novelty = zeros(length(v_fracrej),numel(class_labels));
v_tx_acert_without_novelty = zeros(length(v_fracrej),numel(class_labels));

v_tx_error_with_novelty = zeros(length(v_fracrej),numel(class_labels));
v_tx_acert_with_novelty = zeros(length(v_fracrej),numel(class_labels));

for ifracrej = 1:length(v_fracrej)
    fracrej = v_fracrej(ifracrej);
    % loop over all class
    for iclass = 1:numel(class_labels) % todas as classes
        fprintf('Doing Novelty Class = %s\n',class_labels{iclass})
        
        novelty_class_trn_data = []; novelty_class_tst_data = [];
        
        % selecting classes - excluding novelty class
        m_iclass = v_iclass;
        m_iclass(iclass) = [];
        
        know_class_trn_data = gendatoc(novelty_data((trn_id & novelty_target == m_iclass(1) | novelty_target == m_iclass(2) | novelty_target == m_iclass(3)), 1:n_pcas), novelty_data((trn_id & novelty_target == iclass),1:n_pcas));
        know_class_tst_data = gendatoc(novelty_data((tst_id & novelty_target == m_iclass(1) | novelty_target == m_iclass(2) | novelty_target == m_iclass(3)), 1:n_pcas), novelty_data((tst_id & novelty_target == iclass),1:n_pcas));
        
        W_class = [];
        E_class = [];
        
        stop_criteria = false;
        
        fprintf('Training for Known Class\n');
        for init_id = 1:n_init
            rng('shuffle');
            w = parzen_dd(know_class_trn_data,fracrej,[]);
            e = dd_error(know_class_tst_data,w);
            fprintf('%io train - error: %1.3f%%\n',init_id,100*e(1));
            if (e(1) < max_error) || (init_id == n_init)
                stop_criteria = true;
                W_class = w;
                E_class = e;
            end
            if stop_criteria
                fprintf('Classifier Trained - error = %1.3f%%\n',100*E_class(1));
                break;
            end
        end
        W_class =  setlabels(W_class,['Classes'; 'Outlier']);
        
        
        save(sprintf('%s/mat/novelty_detector/combined_know_class_%s_fracrej_%1.5f_second_approach.mat',outputpath,class_labels{iclass},fracrej),'W_class','E_class');
        
        
        % Result without insert novelty
        result_known_class = gendatoc(novelty_data((tst_id & novelty_target == m_iclass(1) | novelty_target == m_iclass(2) | novelty_target == m_iclass(3)), 1:n_pcas))*W_class*labeld;
        num_result_known_class = zeros(length(result_known_class),1);
        num_target_known_class = ones(length(result_known_class),1);
        
        for i = 1:length(result_known_class)
            if(strcmp(result_known_class(i,:),'Classes'))
                num_result_known_class(i,:) = 1;
            end
         
            if(strcmp(result_known_class(i,:),'Outlier'))
                num_result_known_class(i,:) = 0;
            end
        end
 
               
        % draw scatter plot
        if n_pcas == 2
            fprintf('\nExporting Scatterd Pict\n');
            h_hand = figure; clf; hold on;
            H = []; h = [];
            
            v_colors = {'b' 'g' 'y' 'r'};
            
            for icolor = 1:length(v_colors)
                if icolor == iclass
                    v_colors{icolor} = sprintf('%s%s',v_colors{icolor},'*');
                else
                    v_colors{icolor} = sprintf('%s%s',v_colors{icolor},'o');
                end
            end
            
            
            H(1) = plot(novelty_data((trn_id & novelty_target == 1), 1),novelty_data((trn_id & novelty_target == 1),2),v_colors{1});
            H(2) = plot(novelty_data((trn_id & novelty_target == 2), 1),novelty_data((trn_id & novelty_target == 2),2),v_colors{2});
            H(3) = plot(novelty_data((trn_id & novelty_target == 3), 1),novelty_data((trn_id & novelty_target == 3),2),v_colors{3});
            H(4) = plot(novelty_data((trn_id & novelty_target == 4), 1),novelty_data((trn_id & novelty_target == 4),2),v_colors{4});
            
            hold on;
            
            h = plotc(W_class,'k');
            H(5) = h(1); set(H(5),'LineWidth',2.0);
            
            m_leg = {'Class A','Class B','Class C','Class D','Classifier'};
            m_leg{iclass} = 'Novelty Class';
            
            h = legend(H,m_leg);
            %legend('boxoff');
            
            htext=findobj(get(h,'children'),'type','text');
            set(htext,'fontsize',15,'fontweight','bold');
            
            fprintf('Exporting Figures\n');
            %axis equal;
            title(sprintf('Novelty Detector (Class %s) - SVM Single-Class',class_labels{iclass}),'Interpreter','LaTex','FontSize',20,'FontWeight','bold');
            xlabel('PCA 1','FontSize', 15,'FontWeight', 'bold');
            ylabel('PCA 2','FontSize', 15,'FontWeight', 'bold');
            grid on;
            fig2pdf(h_hand, sprintf('%s/pict/novelty_detector/novelty_detector_class_all_compare_novelty_class_%s_fracrej_%1.5f_second_approach.pdf',outputpath,class_labels{iclass},fracrej));
            close(h_hand);
        end
        
        % Result with insertion of novelty
        % just plot confusion - scatter will no be necessary
        % Result without insert novelty
        
        num_novelty_events = 100;
        result_class_novelty = gendatoc(novelty_data((trn_id & novelty_target == iclass), 1:n_pcas))*W_class*labeld;
        num_result_class_novelty = zeros(num_novelty_events,1);
        num_target_class_novelty = zeros(num_novelty_events,1);;

        
        for i = 1:length(num_result_class_novelty)
            if(strcmp(result_class_novelty(i,:),'Classes'))
                num_result_class_novelty(i,:) = 1;
            end
            
            if(strcmp(result_class_novelty(i,:),'Outlier'))
                num_result_class_novelty(i,:) = 0;
            end
        end
        
        num_result_known_and_novelty = [num_result_known_class; num_result_class_novelty];
        num_target_known_and_novelty = [num_target_known_class; num_target_class_novelty];
        
        %Known class + Novelty
        h_hand = figure;
        plotconfusion(num_target_known_and_novelty',num_result_known_and_novelty');
        
        title(sprintf('SVM Single-Class Classifier - Confusion Matrix'),'Interpreter','LaTex','FontSize',20,'FontWeight','bold');
        xlabel('Target Class','FontSize', 15,'FontWeight', 'bold');
        ylabel('Output Class','FontSize', 15,'FontWeight', 'bold');
        
        l_aux = {'Novelty Class','Classes','Total'};
        set(gca,'XTickLabel',l_aux,'fontWeight','bold');
        set(gca,'YTickLabel',l_aux,'fontWeight','bold');
        fig2pdf(gcf, sprintf('%s/pict/novelty_detector/confusion_1x1_class_%s_fracrej_%1.5f_second_approach.pdf',outputpath,class_labels{iclass},fracrej));
        close(h_hand);
        
        [a,b,c,d] = confusion(num_target_known_and_novelty',num_result_known_and_novelty');
        
        tx_error = a;
        tx_acert = 1-a;
        
        v_tx_error_with_novelty(ifracrej,iclass) = tx_error;
        v_tx_acert_with_novelty(ifracrej,iclass) = tx_acert;      
                
        fprintf('\n');
    end

end


h_hand = figure;
H = [];
%lm=0:0.01:1.0;
marker_style = ['o', '^', 'v' , 'd']; 

for class_id = 1:numel(class_labels)
    h = plot(v_fracrej,v_tx_acert_with_novelty(:,class_id),sprintf('b-%s',marker_style(class_id)),'LineWidth',2.0,'MarkerSize',2.5);
    if class_id == 1, hold on; end
    H(class_id) = h;
    h = plot(v_fracrej,v_tx_error_with_novelty(:,class_id),sprintf('r--%s',marker_style(class_id)),'LineWidth',2.0,'MarkerSize',2.5);
    H(class_id+numel(class_labels)) = h;
end
hold off;
c = axis;
c(1) = 0; c(2) = 0.4; c(3) = 0; c(4) = 1;
axis(c);
grid on;
title('Rates of SVM One-Class Classifier (with Event of Novelty)','FontSize', 15,'FontWeight', 'bold');
ylabel('Rates (%)','FontSize', 15,'FontWeight', 'bold');
xlabel('Rejection Fraction','FontSize', 15,'FontWeight', 'bold');
legend(H,'Hit Rate - Class A', 'Hit Rate - Class B', 'Hit Rate - Class C', 'Hit Rate - Class D', 'Novelty Rate - Class A','Novelty Rate - Class B','Novelty Rate - Class C','Novelty Rate - Class D');
set(gca,'YTickLabel',{'0.0','10.0', '20.0', '30.0', '40.0', '50.0', '60.0', '70.0', '80.0','90.0', '100.0'});
set(gca,'FontWeight','bold');
fig2pdf(h_hand,sprintf('%s/pict/novelty_detector/novelty_detector_class_all_hit_rate_with_novelty_second_approach.pdf',outputpath));
close(h_hand);


warning('on')
% excluindo funcoes
fprintf('Removing Functions\n');
rmpath(genpath('../functions'));