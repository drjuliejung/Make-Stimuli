% generates playback signal for desired acceleration
% using data from shaker
%
% jgm

function [signal] = playback(t, a, shaker)

% Fourier transform and shift desired acceleration

A = fftshift(fft(a));

% compute frequency vector

N = length(A);
delta_t = t(2) - t(1);
n = (-N/2):1:((N/2)-1);
f_hz_fft = n./(N*delta_t);

% multipliers from Michael Caldwell's 8/5/05 email and excel file entitled
% "byhand flatAmp (2).xls"

f_hz = [10	20	30	40	50	60	70	80	90	100	110	120	130	140	150	160	180	200	220	240	260	280	300	320	340	360	380	400	420	440	460	480	500	520	540	560	580	600	620	640	660	680	700	720	740	760	780	800	820	840	860	880	900	920	940	960	980	1000];
ITF  = [166.8772004	73.96336931	39.17371568	21.92031022	18.52619767	19.51614716	20.93036072	21.49604615	18.52619767	23.19310242	23.61736649	26.1629509	27.29432175	28.70853532	30.54701295	31.53696244	34.22396821	36.62813127	38.32518754	40.30508653	42.0021428	50.06316011	51.33595231	53.17442995	55.29575029	53.03300859	59.53839098	61.51828996	63.21534624	62.50823946	70.85209947	68.87220049	71.4177849	71.55920626	85.70134188	84.28712832	84.14570696	101.8233765	81.45870119	74.38763338	72.40773439	67.88225099	69.1550432	69.72072862	89.23687579	93.33809512	98.99494937	94.61088732	89.23687579	87.2569768	92.34814562	85.84276324	89.09545443	84.14570696	108.6116016	152.7350647	193.747258	260.2152955];

% use even-valued extension for negative frequencies

f_hz = [-fliplr(f_hz) f_hz];
ITF = [fliplr(ITF) ITF];

% interpolate transfer function to fft frequencies

ITF_fft = interp1(f_hz, ITF, f_hz_fft, 'nearest', 'extrap');

% compute frequency-domain signal

SIGNAL = A.*ITF_fft;

% compute time-domain signal

signal = real(ifft(ifftshift(SIGNAL)));

