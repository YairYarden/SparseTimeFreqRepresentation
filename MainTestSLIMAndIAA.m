%% Test SLIM & IAA Implementation
clc; clearvars;

%% Define Parameters
fs = 1e3;
numSamples = 200;
numFreqBins = 2000;
timeVec = (0 : numSamples - 1).'/fs;
SNR = 10; % Linear
numIterationsIaa = 10;

%% Construct Signal
expFreqVec = [-137, -80, 98, 130, 167, 200];
ampVec = [1, 0.6, 2, 0.5, 0.7, 1];
expMatrix = ampVec .* exp(1j*2*pi*timeVec*expFreqVec);
x = sum(expMatrix, 2);

%% Add noise
signalEnergy = sum(abs(x).^2);
noiseVar = (1 / numSamples) * signalEnergy / SNR;
noiseVec = sqrt(noiseVar) .* (1/sqrt(2)) .* (randn(numSamples, 1) + 1j * randn(numSamples,1));
y = x + noiseVec;

%% Generate A steering matrix for IAA algorithm
freqVec = -fs/2 : fs/numFreqBins : fs/2 - 1/numFreqBins;
A = exp( 1i*2*pi*timeVec*freqVec );

%% Estimate PSD using IAA
[s_IAA, p_IAA] = IAA(y, A, numIterationsIaa);

%% Estimate PSD using SLIM
q = 0.1;
[s_SLIM, p_SLIM] = SLIM(y, A, q, numIterationsIaa);

%% Plot and compare to regular FFT
originalFft = fftshift(fft(y, numFreqBins)) ./ length(x);

figure, plot(freqVec, (abs(originalFft)), '.-'); hold on;
plot(expFreqVec, (ampVec) , 'xm', 'LineWidth', 2); 
plot(freqVec, sqrt(p_IAA), 'o-'); % in IAA case p = abs(s^2)
plot(freqVec, abs(s_SLIM), '*-');

legend('FFT','True','IAA', 'SLIM');
xlabel('Frequency[Hz]'); ylabel('Amplitude'); grid minor;
title('Compare results of IAA, SLIM to FFT'); set(gca,'fontsize',12);
