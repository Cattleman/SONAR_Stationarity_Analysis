% Projeto de Classificacao para Marinha do Brasil

%Autor: Natanael Junior (natmourajr@gmail.com)
% Laboratorio de Processamento de Sinais - UFRJ

% iniciando o script
clear all;
close all;
clc;

fprintf('Starting %s.m\n',mfilename('fullpath'));

fprintf('Goals:\n');
fprintf('1 - Read Raw Data\n');
fprintf('2 - Create LOFAR Data file \n');

fprintf('Importing Functions\n');
addpath(genpath('../functions'));

outputpath = getenv('OUTPUTDATAPATH');

if(~exist(sprintf('%s/mat/raw_sonar_data.mat',outputpath),'file'))
    fprintf('DO create_raw_data.m\n');
    %exit;
    return;
end

load(sprintf('%s/mat/raw_sonar_data.mat',outputpath));

%n_pts_fft = 2048;

for i_pts_fft = 5:13
    n_pts_fft = 2^i_pts_fft;
    
%     if(exist(sprintf('%s/mat/lofar_sonar_data_nfft_%i.mat',outputpath,n_pts_fft),'file'))
%         fprintf('LOFAR Analysis for %i already DONE\n',n_pts_fft);
%         continue;
%     end
%     
    % do LOFAR Analysis
    decimation_rate = 4;
    
    num_overlap = 0;
    
    norm_parameters.lat_window_size = 10;
    norm_parameters.lat_gap_size = 1;
    norm_parameters.threshold = 1.3;
    
    total_lofar = [];
    
    fprintf('\nLOFAR Computing\n');
    for j = 1:numel(class_labels) % todas as classes
        fprintf('Class %s\n',class_labels{j});
        if decimation_rate >=1
            total_lofar.(class_labels{j})=decimate(total.(class_labels{j}),decimation_rate,10,'FIR');
            Fs=fs/decimation_rate;
        else
            total_lofar.(class_labels{j})=total.(class_labels{j});
            Fs=fs;
        end
        
        [intensity,f,t]=spectrogram(total_lofar.(class_labels{j}),hanning(n_pts_fft),num_overlap,n_pts_fft,Fs);
        intensity = abs(intensity);
        intensity=intensity./tpsw(intensity);
        intensity=log10(intensity);
        intensity(find(intensity<-.2))=0;
        total_lofar.(class_labels{j}) = intensity;
        
        h_hand = figure;
        imagesc(f,t,intensity');
        colorbar;
        
        if decimation_rate >=1
            title(sprintf('LOFARgram for Class %s with Decimation Ratio: %d - (pts windows: %i)',class_labels{j},decimation_rate,n_pts_fft),'FontSize', 15,'FontWeight', 'bold');
        else
            title(sprintf('LOFARgram for Class %s - (pts windows: %i)',class_labels{j},n_pts_fft),'FontSize', 15,'FontWeight', 'bold');
        end
        
        ylabel('Time (seconds)','FontSize', 15,'FontWeight', 'bold');
        xlabel('Frequency (Hz)','FontSize', 15,'FontWeight', 'bold');
        fig2pdf(h_hand,sprintf('%s/pict/sonar/lofargram_class%s_n_pts_fft_%i_decimation_factor_%i.pdf',outputpath,class_labels{j},n_pts_fft,decimation_rate));
        saveas(h_hand,sprintf('%s/pict/sonar/lofargram_class%s_n_pts_fft_%i_decimation_factor_%i.png',outputpath,class_labels{j},n_pts_fft,decimation_rate));
        close(h_hand);
        
        fprintf('Windows Qtd:  %1.0f\n',size(t,2));
        fprintf('Windows Size:  %1.0f\n\n',size(total.(class_labels{j}),1)/size(t,2));
    end
    
    fprintf('Creating LOFAR Data File\n');
    save(sprintf('%s/mat/lofar_sonar_data_nfft_%i_decimation_factor_%i.mat',outputpath,n_pts_fft,decimation_rate),'decimation_rate','Fs','num_overlap','norm_parameters','total_lofar','n_pts_fft');
end

% if(exist(sprintf('%s/mat/lofar_sonar_data.mat',outputpath),'file'))
%     fprintf('ALREADY DONE\n');
%     exit;
% end


fprintf('Removing Functions\n');
warning('off');
rmpath(genpath('../functions'));
warning('on');

clear all;
close all;
%clc;
%exit;
