%% Main code implementing 2016 paper : 
% STFT-like time frequency representations of nonstationary signal with arbitrary sampling schemes
clc; clearvars;

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

%% Plot generated Signals
PlotGeneratedSignals(sinesDecayExp, sinesDiffTime, chirpAndFmSine, fs, timeGrid, sPlot)

%% Apply IAA on signals
% FR - IAA
numFreqBins = numSamples * 2;
freqVec = -fs/2 : fs/numFreqBins : fs/2 - 1/numFreqBins;
A = exp( 1j*2*pi*timeGrid'*freqVec );
numIterationsIaa = 8;

[~, first_p_IAA] = IAA(sinesDecayExp', A, numIterationsIaa);
[~, second_p_IAA] = IAA(sinesDiffTime', A, numIterationsIaa);
[~, third_p_IAA] = IAA(chirpAndFmSine', A, numIterationsIaa);

% TFR - IAA
[firstSpecIAA, timeSpecIaa, freqSpecIaa] = ComputeShortTimeIAA(sinesDecayExp, numIterationsIaa, fs, 64, 1, 200);
[secondSpecIAA, ~, ~] = ComputeShortTimeIAA(sinesDiffTime, numIterationsIaa, fs, 64, 1, 200);
[thirdSpecIAA, ~, ~] = ComputeShortTimeIAA(chirpAndFmSine, numIterationsIaa, fs, 64, 1, 200);

PlotTdrFdrTfr(sinesDecayExp, sinesDiffTime, chirpAndFmSine, timeGrid, ...
              first_p_IAA, second_p_IAA, third_p_IAA, freqVec, ...
              firstSpecIAA, secondSpecIAA, thirdSpecIAA, timeSpecIaa, freqSpecIaa);
      
%% Generate Non-uniform sampling \ time vector
maxTime = 1000;
sTimeVecs = GenerateNonUniformTimeGrid(maxTime, timeRes, numSamples, sPlot);
sConfigSignals = CreateSignalsConfig(numSamples, timeGrid, fs);