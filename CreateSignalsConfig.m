function [sConfigSignals] = CreateSignalsConfig(numSamples, timeGrid, fs)
% Synopsis : This function creates a configuration struct for the signals
% to be generated.
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------

sConfigSignals.decayExp = 0.002;
sConfigSignals.sineFreqs = [0.05, 0.25, 0.35, 0.45]; % [Hz]
sConfigSignals.chirpStartFreq = 0.55;
sConfigSignals.chirpEndFreq = 0.95;
sConfigSignals.fmCentralFreq = 0.75;
sConfigSignals.fmFreqDev = 0.2;
sConfigSignals.fmSineFreq = 1 / timeGrid(256);
sConfigSignals.fs = fs;
sConfigSignals.noiseVar = 0.001;
sConfigSignals.numSamples = numSamples;

end

