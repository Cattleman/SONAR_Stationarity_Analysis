function [time, freqs, intensity] = lofar(data,window,n_overlap,n_pts_fft,Fs,decimation_rate,norm_parameters)
%LOFAR Summary of this function goes here
%   Detailed explanation goes here
%   outputs:
%               time  - vector of time
%               freqs - vector of frequences
%               intensity - matrix of spectrum intensities

%   inputs:
%               data - data (1xN) (expected)
%               window - kind of window (default: hanning(8))
%               n_overlap - number of samples used to overlap (default: 0)
%               n_pts_fft - number of fft points (default: 1024)
%               Fs - Sampling Frequence (default: 2*fft)
%               decimation_rate - for decimation propouse (default:1)
%               norm_parameters

%                   for TPSW normalization: npts - number of points of data to be used (default: size(data,2)+1)
%                                           lat_window_size - size of lateral window (default: 10)
%                                           lat_gap_size - size of lateral gap (default: 1)
%                                           threshold - tpsw threshold (default: 1.3)

%                   for WAVELET normalization: to be done!!!!

% no input arguments
if nargin < 1
    error('Invalid arguments');
end

% only data argument
if nargin < 2
    window = hanning(8);
    n_overlap = 0;
    n_pts_fft = 1024;
    Fs = 2*max(fft(data,n_pts_fft)); 
    decimation_rate = 1;
    norm_parameters.npts = length(data);
    norm_parameters.lat_window_size = 10;
    norm_parameters.lat_gap_size = 1;
    norm_parameters.threshold = 1.3;
end

% only data and window
if nargin < 3
    n_overlap = 0;
    n_pts_fft = 1024;
    Fs = 2*max(fft(data,n_pts_fft)); 
    decimation_rate = 1;
    norm_parameters.npts = length(data);
    norm_parameters.lat_window_size = 10;
    norm_parameters.lat_gap_size = 1;
    norm_parameters.threshold = 1.3;
end

% data, window and n_overlap
if nargin < 4
    n_pts_fft = 1024;
    Fs = 2*max(fft(data,n_pts_fft)); 
    decimation_rate = 1;
    norm_parameters.npts = length(data);
    norm_parameters.lat_window_size = 10;
    norm_parameters.lat_gap_size = 1;
    norm_parameters.threshold = 1.3;
end

% data, window, n_overlap and n_pts_fft
if nargin < 5
    Fs = 2*max(fft(data,n_pts_fft)); 
    decimation_rate = 1;
    norm_parameters.npts = length(data);
    norm_parameters.lat_window_size = 10;
    norm_parameters.lat_gap_size = 1;
    norm_parameters.threshold = 1.3;
end

% data, window, n_overlap, n_pts_fft and Fs
if nargin < 6
    decimation_rate = 1;
    norm_parameters.npts = length(data);
    norm_parameters.lat_window_size = 10;
    norm_parameters.lat_gap_size = 1;
    norm_parameters.threshold = 1.3;
end

% data, window, n_overlap, n_pts_fft, Fs, decimation_rate
if nargin < 7
    norm_parameters.npts = length(data);
    norm_parameters.lat_window_size = 10;
    norm_parameters.lat_gap_size = 1;
    norm_parameters.threshold = 1.3;
end



data = data -mean(data);

if decimation_rate>1
   data=decimate(data,decimation_rate,10, 'FIR');
   Fs=Fs/decimation_rate;
end
[intensity, freqs, time] = spectrogram(data,window,n_overlap,n_pts_fft,Fs);
intensity=abs(intensity);

intensity=log10(intensity);
intensity=intensity-tpsw(intensity,size(intensity,1),norm_parameters.lat_window_size,norm_parameters.lat_gap_size,norm_parameters.threshold);
intensity(intensity<0)=0;

end

