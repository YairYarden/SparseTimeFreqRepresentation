function [] = CompareFftSlimIaa(signal, A, q, numIterations, freqVec)
% Synopsis : 
% INPUTS : 
% OUTPUTS : 

% Written by Yair Yarden and Ofir Kedem - 2021
%% Intialize 
numFreqBins = size(A,2);
%% Estimate PSD using IAA
[~, p_IAA] = IAA(signal, A, numIterations);

%% Estimate PSD using SLIM
[s_SLIM, ~] = SLIM(signal, A, q, numIterations);

%% Plot and compare to regular FFT
originalFft = fftshift(fft(signal, numFreqBins)) ./ length(signal);

figure, plot(freqVec, (abs(originalFft)), '.-'); hold on;
plot(freqVec, sqrt(p_IAA), 'o-'); % in IAA case p = abs(s^2)
plot(freqVec, abs(s_SLIM), '*-');

legend('FFT','IAA', 'SLIM');
xlabel('Frequency[Hz]'); ylabel('Amplitude'); grid minor;
title('Compare results of IAA, SLIM to FFT'); set(gca,'fontsize',12);

end

