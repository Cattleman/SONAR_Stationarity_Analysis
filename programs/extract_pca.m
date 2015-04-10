% Projeto de Classificacao para Marinha do Brasil

%Autor: Natanael Junior (natmourajr@gmail.com)
% Laboratorio de Processamento de Sinais - UFRJ


% Objetivos: Extrair PCAs do banco de dados
%

% iniciando o script
clear all;
close all;
clc;

fprintf('Starting %s.m\n',mfilename('fullpath'));

outputpath = getenv('OUTPUTDATAPATH');

if(~exist(sprintf('%s/mat/raw_sonar_data.mat',outputpath),'file'))
    fprintf('DO READ DATA\n');
    exit;
else 
    load(sprintf('%s/mat/raw_sonar_data.mat',outputpath));
end

if(~exist(sprintf('%s/mat/lofar_sonar_data.mat',outputpath),'file'))
    fprintf('DO PERFORM_LOFAR_ANALYSIS\n');
    exit;
else
    load(sprintf('%s/mat/lofar_sonar_data.mat',outputpath));
end

if(exist(sprintf('%s/mat/pca/pca_90_energy.mat',outputpath),'file')) 
    fprintf('ALREADY DONE\n');
    exit;
end
    
data2pca = [];
% analisando o comportamento das 2 primeiras PCAs
fprintf('PCAs computing\n');
fprintf('Mounting PCA data\n');
for j = 1:numel(class_labels) % todas as classes
    fprintf('Class %s\n',class_labels{j});
    data2pca = [data2pca total_lofar.(class_labels{j})];
end

% aplicar pca para reduzir as dimensoes
fprintf('Calculating PCA\n');
[pcas, ~, pca_energy] = pca(data2pca');
%[data_pca, pcas, pca_energy] = m_pca(data2pca');

%corte de pcas pela energia - curva de carga
m_energy = zeros(length(pca_energy),1);
n_pcas = 0;

for i=1:size(pca_energy,1)
    if i ==1
        m_energy(i) = 100*(pca_energy(i)/sum(pca_energy));
    else
        m_energy(i) = m_energy(i-1)+100*(pca_energy(i)/sum(pca_energy));
    end
    
    if(m_energy(i) > 90 && n_pcas == 0)
        n_pcas = i;
    end
end

% importando funcoes
fprintf('Importing Functions\n');
addpath(genpath('../functions'));

h = figure;
plot(1:n_pcas+10,m_energy(1:n_pcas+10),'LineWidth', 1.5);
xlabel('# PCAs','FontSize', 15,'FontWeight', 'bold');
ylabel('Normalized Energy (%)','FontSize', 15,'FontWeight', 'bold');
title(sprintf('PCA Energy Curve'),'FontSize', 15,'FontWeight', 'bold');


set(gca,'XTick', 0:10:n_pcas+10);
xticklabel_rotate([],90,[],'interpreter','none','Fontweight','bold');
set(gca,'YTick', 0:10:110);

hold on;

plot(1:0.5:n_pcas+10,90,'r-','LineWidth',2.0);
hold off;

grid on;

fig2pdf(h, sprintf('%s/pict/pca/pca_curve.pdf',outputpath));
close(h);

fprintf('Creating PCA File\n');
save(sprintf('%s/mat/pca/pca_90_energy.mat',outputpath),'pcas','n_pcas', 'pca_energy');

% excluindo funcoes
fprintf('Removing Functions\n');
rmpath(genpath('../functions'));

exit;