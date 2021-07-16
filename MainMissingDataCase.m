%% Main code implementing 2016 paper - Missing data case
clc; 
% clearvars;

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
numFreqBins = 300;
numIterationsIaa = 5;
freqVec = -fs/2 : fs/numFreqBins : fs/2 - 1/numFreqBins;
A = exp( 1j*2*pi*fullTimeVec'*freqVec );
[missingSamples, p] = MIAA(nonMissingSampleSignal, A, nonMissedSamplesIndx, missingSamplesIndx, numIterationsIaa, tmpP);
%%
figure, 
% plot(real(missingSamples)); hold on; plot(real(missedSamples));
plot(real(missingSamples) ./ norm(missingSamples)); hold on; plot(real(missedSamples) ./ norm(missedSamples));
legend('Estimated','Real');
