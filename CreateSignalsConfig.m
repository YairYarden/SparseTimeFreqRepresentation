function [sConfigSignals] = CreateSignalsConfig(numSamples, timeGrid, fs)
% Synopsis : This function creates a configuration struct for the signals
% to be generated.
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
% Parmeter for signal creation
sConfigSignals.decayExp = 0.015;
sConfigSignals.sineFreqs = [0.05, 0.25, 0.35, 0.45]; % [Hz]
sConfigSignals.chirpStartFreq = 0.55;
sConfigSignals.chirpEndFreq = 0.95;
sConfigSignals.fmCentralFreq = 0.75;
sConfigSignals.fmFreqDev = 0.2;
sConfigSignals.fmSineFreq = 1 / timeGrid(256);
sConfigSignals.fs = fs;
sConfigSignals.noiseVar = 0.001;
sConfigSignals.numSamples = numSamples;

% Parameters for ST-IAA and SLIM
sConfigSignals.numIterationsIaa1 = 13;
sConfigSignals.numIterationsIaa2 = 10;
sConfigSignals.numIterationsIaa2 = 7;

sConfigSignals.numIterationsSlim1 = 13;
sConfigSignals.numIterationsSlim2 = 10;
sConfigSignals.numIterationsSlim2 = 7;

sConfigSignals.numFreqBins1 = 1000;
sConfigSignals.numFreqBins2 = 1200;
sConfigSignals.numFreqBins3 = 2000;

sConfigSignals.numSamplesInFrame1 = 120;
sConfigSignals.numSamplesInFrame2 = 50;
sConfigSignals.numSamplesInFrame3 = 50;

end

