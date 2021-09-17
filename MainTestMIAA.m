%% Main code implementing 2016 paper - Missing data case
clc; 
clearvars;

%% Generate Non-uniform time vectors
numSamples = 512;
fs = 2; % Hz
fullTimeGrid = (0 : numSamples - 1) / fs;
sPlot = CreatePlotConfig(0, 64, 63, 512);
sConfigSignals = CreateSignalsConfig(numSamples, fullTimeGrid, fs);

sinesDecayExp = ConstructSignal(fullTimeGrid, 1, sConfigSignals);
sinesDiffTime = ConstructSignal(fullTimeGrid, 2, sConfigSignals);
chirpAndFmSine = ConstructSignal(fullTimeGrid, 3, sConfigSignals);

% add noise
noiseVec = sqrt(sConfigSignals.noiseVar) * randn(1, length(fullTimeGrid));
sinesDecayExp = sinesDecayExp + noiseVec;
sinesDiffTime = sinesDiffTime + noiseVec;
chirpAndFmSine = chirpAndFmSine + noiseVec;

% randomly delete data
numNonMissedSamples = floor(numSamples * 0.6);
nonMissedSamplesIndx = sort(randperm(numSamples, numNonMissedSamples));
missingSamplesIndx = ismember(1 : numSamples, nonMissedSamplesIndx);
missingSamplesIndx = find(missingSamplesIndx == 0);

nonMissingTimeGrid = fullTimeGrid(nonMissedSamplesIndx);
nonMissingSinesDecayExp = sinesDecayExp(nonMissedSamplesIndx);
nonMissingSinesDiffTime = sinesDiffTime(nonMissedSamplesIndx);
nonMissingChirpAndFmSine = chirpAndFmSine(nonMissedSamplesIndx);

%% Generate zero fill signals
zeroFilledSinesDecayExp = zeros(1, numSamples);
zeroFilledSinesDecayExp(nonMissedSamplesIndx) = nonMissingSinesDecayExp;

zeroFilledSinesDiffTime = zeros(1, numSamples);
zeroFilledSinesDiffTime(nonMissedSamplesIndx) = nonMissingSinesDiffTime;

zeroFilledChirpAndFmSine = zeros(1, numSamples);
zeroFilledChirpAndFmSine(nonMissedSamplesIndx) = nonMissingChirpAndFmSine;

%% Compute ST-IAA for the avliable data points only
numIterations = 5;

[nonMissingSinesDecayExpSpec, ~, nonMissingFreqSpec] = ComputeSpecBySparseAlgo(nonMissingSinesDecayExp, nonMissingTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');
[nonMissingSinesDiffTimeSpec, ~, ~] = ComputeSpecBySparseAlgo(nonMissingSinesDiffTime, nonMissingTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');
[nonMissingChirpAndFmSineSpec, ~, ~] = ComputeSpecBySparseAlgo(nonMissingChirpAndFmSine, nonMissingTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');

%% Compute full data ST-IAA
numIterations = 8;

[sinesDecayExpSpec, ~, freqSpec] = ComputeSpecBySparseAlgo(sinesDecayExp, fullTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');
[sinesDiffTimeSpec, ~, ~] = ComputeSpecBySparseAlgo(sinesDiffTime, fullTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');
[chirpAndFmSineSpec, ~, ~] = ComputeSpecBySparseAlgo(chirpAndFmSine, fullTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');

%% Compute ST-IAA for zero filled data
[zeroFilledSinesDecayExpSpec, ~, zeroFilledFreqSpec] = ComputeSpecBySparseAlgo(zeroFilledSinesDecayExp, fullTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');
[zeroFilledSinesDiffTimeSpec, ~, ~] = ComputeSpecBySparseAlgo(zeroFilledSinesDiffTime, fullTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');
[zeroFilledChirpAndFmSineSpec, ~, ~] = ComputeSpecBySparseAlgo(zeroFilledChirpAndFmSine, fullTimeGrid, numIterations, fs, 32, 1, 200, [], 'IAA');


%% Plot

% zero filled
subplot(3,3,1); surf(1:size(zeroFilledSinesDecayExpSpec,2), zeroFilledFreqSpec, pow2db(zeroFilledSinesDecayExpSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(zeroFilledFreqSpec)]);
title('Zero Filled ST-IAA'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,3,4); surf(1:size(zeroFilledSinesDecayExpSpec,2), zeroFilledFreqSpec, pow2db(zeroFilledSinesDiffTimeSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(zeroFilledFreqSpec)]);
title('Zero Filled ST-IAA'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,3,7); surf(1:size(zeroFilledSinesDecayExpSpec,2), zeroFilledFreqSpec, pow2db(zeroFilledChirpAndFmSineSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(zeroFilledFreqSpec)]);
title('Zero Filled ST-IAA'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);


% avliable data only
subplot(3,3,2); surf(1:size(nonMissingSinesDecayExpSpec, 2), nonMissingFreqSpec, pow2db(nonMissingSinesDecayExpSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(nonMissingFreqSpec)]);
title('Available Data ST-IAA (ST-MIAA)'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,3,5); surf(1:size(nonMissingSinesDecayExpSpec, 2), nonMissingFreqSpec, pow2db(nonMissingSinesDiffTimeSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(nonMissingFreqSpec)]);
title('Available Data ST-IAA (ST-MIAA)'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,3,8); surf(1:size(nonMissingSinesDecayExpSpec, 2), nonMissingFreqSpec, pow2db(nonMissingChirpAndFmSineSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(nonMissingFreqSpec)]);
title('Available Data ST-IAA (ST-MIAA)'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

% full data

subplot(3,3,3); surf(1:size(sinesDecayExpSpec,2), freqSpec, pow2db(sinesDecayExpSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(freqSpec)]);
title('Full data ST-IAA'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,3,6); surf(1:size(sinesDecayExpSpec,2), freqSpec, pow2db(sinesDiffTimeSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(freqSpec)]);
title('Full data ST-IAA'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

subplot(3,3,9); surf(1:size(sinesDecayExpSpec,2), freqSpec, pow2db(chirpAndFmSineSpec), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90); ylim([0,max(freqSpec)]);
title('Full data ST-IAA'); xlabel('Frame #'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
