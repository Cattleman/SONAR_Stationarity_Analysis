% Projeto de Classificacao para Marinha do Brasil

%Autor: Natanael Junior (natmourajr@gmail.com)
% Laboratorio de Processamento de Sinais - UFRJ

% iniciando o script
clear all;
close all;
clc;

fprintf('Starting %s.m\n',mfilename('fullpath'));

fprintf('Goals:\n');
fprintf('1 - Read all data files\n');
fprintf('2 - Create RAW Data MatLab files \n');

inputpath = getenv('INPUTDATAPATH');
% a variavel de sistema deve apontar para o folder com todas as classes

outputpath = getenv('OUTPUTDATAPATH');

if(exist(sprintf('%s/mat/raw_sonar_data.mat',outputpath),'file'))
    fprintf('ALREADY DONE\n');
    exit;
end

% Leitura de Dados
develop = true;

fprintf('Reading data in %s\n',inputpath);
class = {};

if develop
    n_runs = 1;
else
    n_runs = 5;
end


for i = 0:n_runs-1
    fprintf('Reading ClassA Run %i\n', i);
    class{i+1} = wavread(sprintf('%s/ClasseA/navio1%i.wav',inputpath,i));
end

raw_data.A   = class;

clear class n_runs

class = {};

if develop
    n_runs = 1;
else
    n_runs = 10;
end

for i = 0:n_runs-1
    fprintf('Reading ClassB Run %i\n', i);
    class{i+1} = wavread(sprintf('%s/ClasseB/navio2%i.wav',inputpath,i));
end

raw_data.B   = class;

clear class n_runs

class = {};

if develop
    n_runs = 1;
else
    n_runs = 10;
end

for i = 0:n_runs-1
    if i == 6
        continue;
    end
    fprintf('Reading ClassC Run %i\n', i);
    class{i+1} = wavread(sprintf('%s/ClasseC/navio3%i.wav',inputpath,i));
end

raw_data.C   = class;

if ~develop
    raw_data.C(7) = [];
end

clear class n_runs

class = {};

if develop
    n_runs = 1;
else
    n_runs = 10;
end


fs = 0;
for i = 0:n_runs-1
    fprintf('Reading ClassD Run %i\n', i);
    [class{i+1},fs] = wavread(sprintf('%s/ClasseD/navio4%i.wav',inputpath,i));
end

raw_data.D   = class;

fprintf('Creating a Total Struct\n');
total = [];
% criar uma estrutura total de classe
class_labels = fieldnames(raw_data);
for j = 1:numel(class_labels) % todas as classes
    fprintf('Appending Class %s\n',class_labels{j});
    class = [];
    for i=1:length(raw_data.(class_labels{j}))
       class = [class;raw_data.(class_labels{j}){i}];
    end
    total.(class_labels{j}) = class;
end

clear('i','j','n_runs');

fprintf('Creating Raw Data File\n');

save(sprintf('%s/mat/raw_sonar_data.mat',outputpath),'fs','total','raw_data','class_labels');

clear all;
close all;

if develop
    fprintf('Finishing Create Raw Data\n');
else
    fprintf('Finishing Create Raw Data\n');
    exit;
end
