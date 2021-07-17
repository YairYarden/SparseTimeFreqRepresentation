%% Main code implementing 2016 paper - Missing data case
clc; 
clearvars;

%% Generate Non-uniform time vectors
numSamples = 2048;
numNonMissedSamples = 1780;
fs = 2;
sPlot = CreatePlotConfig(1, 64, 63, 512);
fullTimeVec = (0 : numSamples - 1) / fs;

nonMissedSamplesIndx = sort(randperm(numSamples, numNonMissedSamples));
timeVecMissingPoints = fullTimeVec(nonMissedSamplesIndx);
missingSamplesIndx = ismember(1 : numSamples, nonMissedSamplesIndx);
missingSamplesIndx = find(missingSamplesIndx == 0);

%% Generate signals
fullSignal = exp(1j*2*pi*0.1.*fullTimeVec);
nonMissingSampleSignal = fullSignal(nonMissedSamplesIndx);
missedSamples = fullSignal(missingSamplesIndx);

%% MIAA
numFreqBins = 200;
numIterationsIaa = 5;
freqVec = -fs/2 : fs/numFreqBins : fs/2 - 1/numFreqBins;
A = exp( 1j*2*pi*fullTimeVec'*freqVec );
missingSamples = MIAA(nonMissingSampleSignal, A, nonMissedSamplesIndx, missingSamplesIndx, numIterationsIaa);

%% Plot
figure, 
subplot(2,1,1); plot(real(missingSamples)); hold on; plot(real(missedSamples));
 legend('Estimated','Real'); title('Estimated missing samples vs Real missing samples');
subplot(2,1,2); plot(real(missingSamples) ./ norm(missingSamples)); hold on; plot(real(missedSamples) ./ norm(missedSamples));
legend('Estimated','Real'); title('Normalized - Estimated vs Real');
