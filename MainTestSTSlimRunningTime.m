%% Test ST-SLIM running time with smart inital coniditon and without
clc; 
clearvars;

%% Parameters for sampling and signals constructions 
numSamples = 512;
fs = 2;
timeGrid = (0 : numSamples - 1) / fs;
sPlot = CreatePlotConfig(0, 64, 63, 512);
sConfigSignals = CreateSignalsConfig(numSamples, timeGrid, fs);

%% Generate signals
sinesDecayExp = ConstructSignal(timeGrid, 1, sConfigSignals);
sinesDiffTime = ConstructSignal(timeGrid, 2, sConfigSignals);
chirpAndFmSine = ConstructSignal(timeGrid, 3, sConfigSignals);

%% Add noise
noiseVec = sqrt(sConfigSignals.noiseVar) * randn(1, length(timeGrid));
sinesDecayExp = sinesDecayExp + noiseVec;
sinesDiffTime = sinesDiffTime + noiseVec;
chirpAndFmSine = chirpAndFmSine + noiseVec;
          
%% Apply SLIM on signals
q = 0.1;
numFreqBins = 500;
numSamplesInFrame = 50;
stepSize = 1;
freqVec = -fs/2 : fs/numFreqBins : fs/2 - 1/numFreqBins;
A = exp( 1j*2*pi*timeGrid'*freqVec );
numIterationsSlim = 8;

% ST-SLIM_IT
% [specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(sinesDecayExp, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM_IT');
% [specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(sinesDiffTime, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM_IT');
[specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(chirpAndFmSine, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM_IT');

% ST-SLIM
% [specSlim2, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(sinesDecayExp, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM');
% [specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(sinesDiffTime, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM_IT');
% [specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(chirpAndFmSine, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM_IT');

%% Plot 
subplot(2,1,1);
surf(specTimeVec, specFreqVec, pow2db(specSlim), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,1]);
title('ST-SLIM with initial Condition'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
myColorMap = jet(256); myColorMap(1,:) = 1; colormap(myColorMap); colorbar

%%
subplot(2,1,2);
surf(specTimeVec, specFreqVec, pow2db(specSlim2), 'EdgeColor', 'none');
axis xy; axis tight; 
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,1]);
title('ST-SLIM without initial Condition'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
myColorMap = jet(256); myColorMap(1,:) = 1; colormap(myColorMap); colorbar
