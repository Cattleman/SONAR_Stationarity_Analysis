function [data_windows] = pts_window_spliter( data, window_size)
%TIME_WINDOW_SPLITER split data in windows
%   data: input data
%   window_size: window size in pts

% encontrar o numero de janelas
n_windows = floor(length(data)/(window_size));

for i_window = 1:n_windows
    if i_window == 1 
        data_windows{i_window} = data(1:floor(window_size));
    else % demais janelas
        data_windows{i_window} = data(((i_window-1)*(floor(window_size)))+1:((i_window)*(floor(window_size))));
    end
end

data_windows{n_windows+1} = data(((n_windows)*(floor(window_size))):end);

end

