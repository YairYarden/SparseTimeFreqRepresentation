%% Main code implementing 2016 paper : 
% STFT-like time frequency representations of nonstationary signal with arbitrary sampling schemes
clc; clearvars;

%% Parameters for sampling and signals constructions 
numSamples = 512;
fs = 2;
timeGrid = (0 : numSamples - 1) / fs;
maxTime = 400;
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

%% Generate Non-uniform sampling \ time vector
% sTimeVecs = GenerateNonUniformTimeGrid(maxTime, timeRes, numSamples, sPlot);
% sConfigSignals = CreateSignalsConfig(numSamples, timeGrid, fs);
