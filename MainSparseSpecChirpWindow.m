%% Main Test Sparse spectrogram using chirp window
clc; 
% clearvars;

%% General Parameters
isRegularSt = true;
isHammingWindow = false;
isConstVarChirp = false;
isAdaptiveVarChirp = true;
instFreqEstMethod = 'max';

%% Parameters for sampling and signals constructions 
numSamples = 512;
fs = 2;
timeGrid = (0 : numSamples - 1) / fs;
sConfigSignals = CreateSignalsConfig(numSamples, timeGrid, fs);

%% Generate signals
inputSignal = ConstructSignal(timeGrid, 3, sConfigSignals);

%% Add noise
noiseVec = sqrt(sConfigSignals.noiseVar) * randn(1, numSamples);
inputSignal = inputSignal + noiseVec;

%% Parameters for ST-SLIM
q = 0.1;
numFreqBins = 500;
numSamplesInFrame = 50;
stepSize = 1;
timeVec = 0 : 1/fs : length(inputSignal)/fs - 1/fs;
numIterations = 8;
% Chirp window
frameTimeVec = -numSamplesInFrame/(2*fs) : 1/fs : numSamplesInFrame/(2*fs) - 1/fs;
sigma = 600;
chirpWin = (1 / sqrt(2*pi*sigma) ) * exp(-(frameTimeVec.^2) ./ (2 * sigma));
hammingWin = transpose(hamming(length(frameTimeVec)));
%% Regular window ST-SLIM
if(isRegularSt)
    [regSpecSlim, regTimeSpec, regFreqSpec] = ComputeSpecBySparseAlgo(inputSignal, timeVec, numIterations,...
                                                fs, numSamplesInFrame, stepSize, numFreqBins,...
                                                q, [], 'SLIM', 'none');
end

if(isHammingWindow)
    [hammingSpecSlim, hammingTimeSpec, hammingFreqSpec] = ComputeSpecBySparseAlgo(inputSignal, timeVec, numIterations,...
                                                fs, numSamplesInFrame, stepSize, numFreqBins,...
                                                q, hammingWin, 'SLIM', 'const');
end

%% Compute ST-SLIM with constant variance chirp window
if(isConstVarChirp)
    [chirpSpecSlim, timeSpecSlim, freqSpecSlim] = ComputeSpecBySparseAlgo(inputSignal, timeVec, numIterations,...
                                                    fs, numSamplesInFrame, stepSize, numFreqBins,...
                                                    q, chirpWin, 'SLIM');
    %% Plot
    figure,
    subplot(3,1,1);
    surf(regTimeSpec, regFreqSpec, pow2db(regSpecSlim), 'EdgeColor', 'none');
    axis xy; axis tight; colormap(jet); view(0,90);
    xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(regFreqSpec)]);
    title('ST-SLIM Spectrogram. no window'); xlabel('Time[sec]'); ylabel('Freq[Hz]');
    
    subplot(3,1,2);
    surf(hammingTimeSpec, hammingFreqSpec, pow2db(hammingSpecSlim), 'EdgeColor', 'none');
    axis xy; axis tight; colormap(jet); view(0,90);
    xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecSlim)]);
    title('ST-SLIM Spectrogram. Hamming window'); xlabel('Time[sec]'); ylabel('Freq[Hz]');
    
    subplot(3,1,3);
    surf(timeSpecSlim, freqSpecSlim, pow2db(chirpSpecSlim), 'EdgeColor', 'none');
    axis xy; axis tight; colormap(jet); view(0,90);
    xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecSlim)]);
    title(strcat('ST-SLIM Spectrogram. const \sigma^2 = ', num2str(sigma))); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
end

%% ST-SLIM with adaptive variance chirp window
if(isAdaptiveVarChirp)
    %% Adaptive Chirp window
    [instFreqVec] = EstimateInstFreq(inputSignal, instFreqEstMethod, numSamplesInFrame,...
                                     numSamplesInFrame-stepSize, numFreqBins, fs);
    zeta = 5.9 * fs;                            
    adaptiveVar = EstimateChirpWindowVar(instFreqVec, fs, zeta);
%     adaptiveVar = transpose(1./ (2*pi * instFreqVec) );
    [chirpWinMat] = CreateAdaptiveChirpWindow(adaptiveVar, numSamplesInFrame, fs);
    figure, subplot(1,2,1); plot(adaptiveVar); subplot(1,2,2); plot(chirpWinMat);
    
    %% ST-SLIM
    [chirpSpecSlim, timeSpecSlim, freqSpecSlim] = ComputeSpecBySparseAlgo(inputSignal, timeVec, numIterations,...
                                                fs, numSamplesInFrame, stepSize, numFreqBins,...
                                                q, chirpWinMat, 'SLIM', 'adaptive');
    
    %% Plot
    figure();
    subplot(2,1,1);
    surf(regTimeSpec, regFreqSpec, pow2db(regSpecSlim), 'EdgeColor', 'none');
    axis xy; axis tight; colormap(jet); view(0,90);
    xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(regFreqSpec)]);
    title('ST-SLIM Spectrogram. no window'); xlabel('Time[sec]'); ylabel('Freq[Hz]');
    
%     subplot(3,1,2);
%     surf(hammingTimeSpec, hammingFreqSpec, pow2db(hammingSpecSlim), 'EdgeColor', 'none');
%     axis xy; axis tight; colormap(jet); view(0,90);
%     xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(hammingFreqSpec)]);
%     title('ST-SLIM Spectrogram. Hamming window'); xlabel('Time[sec]'); ylabel('Freq[Hz]');
    
    subplot(2,1,2);
    surf(timeSpecSlim, freqSpecSlim, pow2db(chirpSpecSlim), 'EdgeColor', 'none');
    axis xy; axis tight; colormap(jet); view(0,90);
    xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(freqSpecSlim)]);
    title('ST-SLIM Spectrogram. adaptive variance. zeta = 3 * fs'); xlabel('Time[sec]'); ylabel('Freq[Hz]');
end

