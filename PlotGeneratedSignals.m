function [] = PlotGeneratedSignals(firstSignal, secondSignal, thirdSignal, fs, timeGrid, sPlot)
% Synopsis : Plot generated signals in time domain, FFT, and STFT
% INPUTS : 
    % firstSignal
    % secondSignal
    % timeGrid

% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
% Extract and initialize Parameters 
stftNumSamplesInFrame = sPlot.stftNumSamplesInFrame;
stftNumSamplesNonOverlap = sPlot.stftNumSamplesNonOverlap;
stftNumFreqBins = sPlot.stftNumFreqBins;
freqGrid = -fs/2 : fs/length(timeGrid) : fs/2 - 1/length(timeGrid);
figure,
%% First Signal
% Time domain
subplot(3,3,1); plot(timeGrid, firstSignal); grid minor;
xlabel('Time[sec]'); ylabel('Amplitude'); title('Sum of sines with decaying Exponent');
% FFT
firstSignalFft = fftshift(fft(firstSignal));
subplot(3,3,2); plot(freqGrid, mag2db(abs(firstSignalFft))); grid minor; xlim([0, max(freqGrid)]);
xlabel('frequency[Hz]'); ylabel('Amplitude'); title('FFT - Sum of sines with decaying Exponent');
% STFT
[~, freqSpec, timeSpec, firstSpectrogram] = spectrogram(firstSignal, stftNumSamplesInFrame, stftNumSamplesNonOverlap, 256, fs);
subplot(3,3,3); surf(timeSpec, freqSpec, firstSpectrogram, 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,0.5]);
title('Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

%% Second signal
% Time Domain
subplot(3,3,4); plot(timeGrid, secondSignal); grid minor;
xlabel('Time[sec]'); ylabel('Amplitude'); title('Sum of sines in different times');
% FFT
secondSignalFft = fftshift(fft(secondSignal));
subplot(3,3,5); plot(freqGrid, mag2db(abs(secondSignalFft))); grid minor; xlim([0, max(freqGrid)]);
xlabel('frequency[Hz]'); ylabel('Amplitude'); title('FFT - Sum of sines Different times');
% STFT
[~, freqSpec, timeSpec, secondSpectrogram] = spectrogram(secondSignal, stftNumSamplesInFrame, stftNumSamplesNonOverlap, stftNumFreqBins, fs);
subplot(3,3,6); surf(timeSpec, freqSpec, secondSpectrogram, 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,0.5]);
title('Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

%% Third signal
% Time Domain
subplot(3,3,7); plot(timeGrid, thirdSignal); grid minor;
xlabel('Time[sec]'); ylabel('Amplitude'); title('Chirp + Fm modulated Sine');
% FFT
thirdSignalFft = fftshift(fft(thirdSignal));
subplot(3,3,8); plot(freqGrid, mag2db(abs(thirdSignalFft))); grid minor; xlim([0, max(freqGrid)]);
xlabel('frequency[Hz]'); ylabel('Amplitude'); title('FFT - Chirp + Fm modulated Sine');
% STFT
[~, freqSpec, timeSpec, thirdSpectrogram] = spectrogram(thirdSignal, stftNumSamplesInFrame, stftNumSamplesNonOverlap, stftNumFreqBins, fs);
subplot(3,3,9); surf(timeSpec, freqSpec, pow2db(thirdSpectrogram), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)');
title('Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
end

