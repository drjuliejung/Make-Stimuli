% Function: generate_bandpass_filtered_white_noise_id
% 
% Description: Generate a signal with a steady duration/interval pattern.
%     Note that signal always starts and ends with duration, so it will 
%     have one less interval than duration. Durations consist of random
%     white noise at specified sampling rate, with a frequency between
%     cutoff1 and cutoff2. num_cycles parameter specifies how many
%     durations are in the pattern.
%                   
% Parameters:
%     sampling_rate: the sampling rate of the signal
%     cutoff1: the lower frequency cutoff
%     cutoff2: the higher frequency cutoff
%     num_cycles: the number of durations in the pattern. There will be
%         num_cycles-1 intervals
%     i_length: length of each interval
%     d_length: length of each duration
%
% Returns:
%     signal: the resulting signal
%
function [signal] = ...
    generate_bandpass_filtered_white_noise_id (sampling_rate, cutoff1, cutoff2, num_cycles, i_length, d_length)

% get the total length of the signal, based on sampling_rate, num_cycles,
% i_length, and d_length
length = int32((i_length + d_length) * num_cycles * sampling_rate);

% generate array of random numbers of that length
rng('shuffle');
x = randn(length,1);

% construct a bandpass filter specifying frequency between cutoff1 and
% cutoff2
hf = design(fdesign.bandpass('N,F3dB1,F3dB2', 10, cutoff1, cutoff2, sampling_rate));

% filter random array through hf
result = filter(hf,x);
result = result';

deltaT = 1/sampling_rate;
t = 0:deltaT:(numel(result)-1)*deltaT;

% run signal through playback function (written by Greg), which contains
% the parameters that deals with low-frequency cutoff for the equipment
signal = playback(t,result,1);

count = d_length;

% set intervals periods to 0 in signal
for i = 1:num_cycles-1
    signal(int32(count*sampling_rate+1) : int32((count + i_length)*sampling_rate)) = 0.0;    
    count = count + i_length + d_length;
end

% cut off last interval (we don't need a trailing interval)
signal = signal(1:int32(count*sampling_rate));

% normalize signal so that max value is 1
signal = signal/max(abs(signal));