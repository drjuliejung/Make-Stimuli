% clear workspace

clear all
close all

% define sampling rate

FS = 44E3;

% define time step

delta_t = 1/FS;

% total time

T = 30;
  
% compute number of samples

N = ceil(T/delta_t);

% create time vector

t = (0:1:(N-1))*delta_t;

% generate white noise

Y = randn(1,N);

% find maximum absolute value of white noise

M = max(abs(Y));

% scale white noise

Y = Y/M;

% plot scaled white noise

figure
plot(t, Y);
xlabel('Time (s)')
ylabel('Signal')

% compute FFT

n = (-N/2):1:((N/2)-1);
f_n = n/(N*delta_t);

Y_FFT = fft(Y);

% plot FFT

figure
plot(f_n, fftshift(abs(Y_FFT)));
xlabel('Frequency (Hz)')
ylabel('Magnitude of FFT')

% play sound over speakers

sound(Y, FS)

% write data to wave file

audiowrite('white_noise.wav',Y,FS,'BitsPerSample',64);



