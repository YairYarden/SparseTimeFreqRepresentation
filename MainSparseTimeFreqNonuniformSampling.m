%% Main code implementing 2016 paper -
% STFT-like time frequency representations of nonstationary signal with arbitrary sampling schemes
clc; clearvars;

%% Generate Non-uniform time vectors
numSamples = 512;
fs = 2;
sPlot = CreatePlotConfig(1, 64, 63, 512);
fullTimeVec = (0 : numSamples - 1) / fs;

%%
sConfigSignals = CreateSignalsConfig(numSamples, fullTimeVec, fs);
sTimeVecs.firstSigTimeVec = fullTimeVec + (0.5/fs) * (rand(1, numSamples) - 0.5);
sTimeVecs.secondSigTimeVec = fullTimeVec + (0.5/fs) * (rand(1, numSamples) - 0.5);
sTimeVecs.thirdSigTimeVec = fullTimeVec + (0.5/fs) * (rand(1, numSamples) - 0.5);

%% Generate signals
sinesDecayExp = ConstructSignal(sTimeVecs.firstSigTimeVec, 1, sConfigSignals);
sinesDiffTime = ConstructSignal(sTimeVecs.secondSigTimeVec, 2, sConfigSignals);
chirpAndFmSine = ConstructSignal(sTimeVecs.thirdSigTimeVec, 3, sConfigSignals);

%% Add noise
noiseVec = sqrt(sConfigSignals.noiseVar) * randn(1, numSamples);
sinesDecayExp = sinesDecayExp + noiseVec;
sinesDiffTime = sinesDiffTime + noiseVec;
chirpAndFmSine = chirpAndFmSine + noiseVec;

%% Spectrograms Params
stepSize = 1;

%% IAA - spectrograms
[firstSpecIAA, timeSpecIaa1, freqSpecIaa1] = ComputeSpecBySparseAlgo(sinesDecayExp, sTimeVecs.firstSigTimeVec, sConfigSignals.numIterationsIaa1, fs, sConfigSignals.numSamplesInFrame1, stepSize, sConfigSignals.numFreqBins1, [], 'IAA');
[secondSpecIAA, timeSpecIaa2, freqSpecIaa2] = ComputeSpecBySparseAlgo(sinesDiffTime, sTimeVecs.secondSigTimeVec, sConfigSignals.numIterationsIaa2, fs, sConfigSignals.numSamplesInFrame2, stepSize, sConfigSignals.numFreqBins2, [], 'IAA');
[thirdSpecIAA, timeSpecIaa3, freqSpecIaa3] = ComputeSpecBySparseAlgo(chirpAndFmSine, sTimeVecs.thirdSigTimeVec, sConfigSignals.numIterationsIaa3, fs, sConfigSignals.numSamplesInFrame3, stepSize, sConfigSignals.numFreqBins3, [], 'IAA');

%% SLIM - spectrograms
[firstSpecSLIM, timeSpecSLIM1, freqSpecSLIM1] = ComputeSpecBySparseAlgo(sinesDecayExp, sTimeVecs.firstSigTimeVec, sConfigSignals.numIterationsSlim1, fs, sConfigSignals.numSamplesInFrame1, stepSize, sConfigSignals.numFreqBins1, sConfigSignals.firstSlimQ, 'SLIM');
[secondSpecSLIM, timeSpecSLIM2, freqSpecSLIM2] = ComputeSpecBySparseAlgo(sinesDiffTime, sTimeVecs.secondSigTimeVec, sConfigSignals.numIterationsSlim2, fs, sConfigSignals.numSamplesInFrame2, stepSize, sConfigSignals.numFreqBins2, sConfigSignals.secondSlimQ, 'SLIM');
[thirdSpecSLIM, timeSpecSLIM3, freqSpecSLIM3] = ComputeSpecBySparseAlgo(chirpAndFmSine, sTimeVecs.thirdSigTimeVec, sConfigSignals.numIterationsSlim3, fs, sConfigSignals.numSamplesInFrame3, stepSize, sConfigSignals.numFreqBins3, sConfigSignals.thirdSlimQ, 'SLIM');

%% Plot spectrograms
figure, 
subplot(3,2,1);
surf(timeSpecIaa1, freqSpecIaa1, pow2db(firstSpecIAA), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecIaa1)]);
title('ST-IAA Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,2,2);
surf(timeSpecSLIM1, freqSpecSLIM1, pow2db(firstSpecSLIM), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecSLIM1)]);
title('ST-SLIM Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,2,3);
surf(timeSpecIaa2, freqSpecIaa2, pow2db(secondSpecIAA), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecIaa2)]);
title('ST-IAA Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,2,4);
surf(timeSpecSLIM2, freqSpecSLIM2, pow2db(secondSpecSLIM), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecSLIM2)]);
title('ST-SLIM Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,2,5);
surf(timeSpecIaa3, freqSpecIaa3, pow2db(thirdSpecIAA), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecIaa3)]);
title('ST-IAA Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,2,6);
surf(timeSpecSLIM3, freqSpecSLIM3, pow2db(thirdSpecSLIM), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecSLIM3)]);
title('ST-SLIM Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
