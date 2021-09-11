%% Main Test Sparse spectrogram using chirp window
clc; clearvars;

%% General Parameters
isRegularStSlim;
isConstVarChirp = false;
isAdaptiveVarChirp = true;
instFreqEstMethod = 'max';

%% Parameters for sampling and signals constructions 
numSamples = 512;
fs = 2;
timeGrid = (0 : numSamples - 1) / fs;
sPlot = CreatePlotConfig(0, 64, 63, 512);
sConfigSignals = CreateSignalsConfig(numSamples, timeGrid, fs);

%% Generate signals
chirpAndFmSine = ConstructSignal(timeGrid, 3, sConfigSignals);

%% Add noise
noiseVec = sqrt(sConfigSignals.noiseVar) * randn(1, numSamples);
chirpAndFmSine = chirpAndFmSine + noiseVec;

%% Parameters for ST-SLIM
q = 0.05;
numFreqBins = 1024;
numSamplesInFrame = 64;
stepSize = 1;
timeVec = 0 : 1/fs : length(chirpAndFmSine)/fs - 1/fs;
numIterationsSlim = 8;
% Chirp window
frameTimeVec = -numSamplesInFrame/(2*fs) : 1/fs : numSamplesInFrame/(2*fs) - 1/fs;
sigma = 20;
chirpWin = (1 / sqrt(2*pi*sigma) ) * exp(-(frameTimeVec.^2) ./ (2 * sigma));

%% Compute ST-SLIM with constant variance chirp window
if(isConstVarChirp)
    [specSlim, timeSpecSlim, freqSpecSlim] = ComputeSpecBySparseAlgo(chirpAndFmSine, timeVec, numIterationsSlim,...
                                                    fs, numSamplesInFrame, stepSize, numFreqBins,...
                                                    q, chirpWin, 'SLIM');

    % Plot
    surf(timeSpecSlim, freqSpecSlim, pow2db(specSlim), 'EdgeColor', 'none');
    axis xy; axis tight; colormap(jet); view(0,90);
    xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecSlim)]);
    title('ST-SLIM Spectrogram. const \sigma^2 = 30'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
end

%% ST-SLIM with adaptive variance chirp window
if(isAdaptiveVarChirp)
    % Adaptive Chirp window
    [instFreqVec] = EstimateInstFreq(chirpAndFmSine, instFreqEstMethod, numSamplesInFrame,...
                                     numSamplesInFrame-stepSize, numFreqBins, fs);
    adaptiveVar = EstimateChirpWindowVar(instFreqVec, fs);
    [chirpWinMat] = CreateAdaptiveChirpWindow(adaptiveVar, numSamplesInFrame, fs);
    
    % ST-SLIM
    [specSlim, timeSpecSlim, freqSpecSlim] = ComputeSpecBySparseAlgo(chirpAndFmSine, timeVec, numIterationsSlim,...
                                                fs, numSamplesInFrame, stepSize, numFreqBins,...
                                                q, chirpWinMat, 'SLIM', 'adaptive');
    
    % Plot
    surf(timeSpecSlim, freqSpecSlim, pow2db(specSlim), 'EdgeColor', 'none');
    axis xy; axis tight; colormap(jet); view(0,90);
    xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecSlim)]);
    title('ST-SLIM Spectrogram. const \sigma^2 = 30'); xlabel('Time[sec]'); ylabel('Freq[Hz]');
end

