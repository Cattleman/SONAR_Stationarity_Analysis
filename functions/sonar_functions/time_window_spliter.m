function [data_windows] = time_window_spliter( data, fs, window_size)
%TIME_WINDOW_SPLITER split data in windows
%   data: input data
%   fs: sample frequency
%   window_size: time window size in seconds

% encontrar o numero de janelas
n_windows = floor(length(data)/(window_size*fs));

for i_window = 1:n_windows
    if i_window == 1 % primeira janela
        data_windows{i_window} = data(1:floor(window_size*fs));
    else % demais janelas
        data_windows{i_window} = data(((i_window-1)*(floor(window_size*fs)))+1:((i_window)*(floor(window_size*fs))));
    end
end

data_windows{n_windows+1} = data(((n_windows)*(floor(window_size*fs))):end);

end

