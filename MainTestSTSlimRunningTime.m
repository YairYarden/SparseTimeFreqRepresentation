%% Test ST-SLIM running time with smart inital coniditon and without
clc; 
clearvars;

%% Parameters for sampling and signals constructions 
numSamples = 512;
fs = 2;
timeGrid = (0 : numSamples - 1) / fs;
sPlot = CreatePlotConfig(0, 64, 63, 512);
sConfigSignals = CreateSignalsConfig(numSamples, timeGrid, fs);
instFreqEstMethod = 'mean';


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
numSamplesInFrame = 60;
stepSize = 1;
freqVec = -fs/2 : fs/numFreqBins : fs/2 - 1/numFreqBins;
A = exp( 1j*2*pi*timeGrid'*freqVec );
numIterationsSlim = 8;

%% Estimate inst freq
[instFreqVec] = EstimateInstFreq(sinesDecayExp, instFreqEstMethod, numSamplesInFrame,...
                                 numSamplesInFrame-stepSize, numFreqBins, fs);
changeTh = 0.1;
[changingPoints] = FindChangingPoints(instFreqVec, changeTh);
changingPoints = 1;
% point1 = changingPoints(2) : 10 : changingPoints(2) + 10*5;
% point2 = changingPoints(3) : 10 : changingPoints(3) + 10*5;
% point3 = changingPoints(4) : 10 : changingPoints(4) + 10*5;
% changingPoints = [1, point1, point2, point3];
%% ST-SLIM_IT
% [specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(sinesDecayExp, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM_IT','prevFrame',changingPoints);
% [specSlim, specTimeVec, specFreqVec,lossVec] = ComputeSpecBySparseAlgo(sinesDiffTime, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM_IT','prevFrame', changingPoints);
% [specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(chirpAndFmSine, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM_IT', 'prevFrame',changingPoints);

% ST-SLIM
[specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(sinesDecayExp, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM');
% [specSlim, specTimeVec, specFreqVec, lossVec] = ComputeSpecBySparseAlgo(sinesDiffTime, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM');
% [specSlim, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(chirpAndFmSine, timeGrid, numIterationsSlim, fs, numSamplesInFrame, stepSize, numFreqBins, q, 'SLIM');

%% Plot 
% subplot(2,1,1);
figure,
% surf(specTimeVec, specFreqVec, pow2db(specSlim), 'EdgeColor', 'none');
imagesc(specTimeVec, specFreqVec, sqrt(specSlim));
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,1]);
title('ST-SLIM without initial Condition'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
myColorMap = jet(256); myColorMap(1,:) = 1; colormap(myColorMap); colorbar
grid minor;
%%
% stftForInitCondition = ComputeStftForInitCondition(chirpAndFmSine,numSamplesInFrame,stepSize,...
%                                                    numFreqBins, fs);
% % 
% % subplot(2,1,2);
% surf(specTimeVec, specFreqVec, pow2db(stftForInitCondition), 'EdgeColor', 'none');
% axis xy; axis tight;  view(0,90);
% xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,1]);
% title('ST-SLIM without initial Condition'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
% myColorMap = jet(256); myColorMap(1,:) = 1; colormap(myColorMap); colorbar
