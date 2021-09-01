%% Test STFT with chirp window
clearvars;
clc;

%% Signal Configurations
numSamples = 512;
fs = 2;
timeGrid = (0 : numSamples - 1) / fs;
chirpStartFreq = 0.55;
chirpEndFreq = 0.95;
fmCentralFreq = 0.75;
fmFreqDev = 0.2;
fmSineFreq = 1 / timeGrid(256);

%% Generate Signal
gaussWindow = gausswin(length(timeGrid));
chirpPart = gaussWindow' .* chirp(timeGrid, chirpStartFreq, max(timeGrid), chirpEndFreq);      
sineBeforeFm = sin(2*pi*fmSineFreq*timeGrid);
fmSine = fmmod(sineBeforeFm, fmCentralFreq, fs, fmFreqDev);
% signal = chirpPart + fmSine;
signal = fmSine;
% signal = chirpPart;

%% Plot STFT
frameLength = 64;
framesOverlap = 63;
stepSize = frameLength - framesOverlap;
numFreqBins = 1023;
frameTimeVec = -frameLength/(2*fs) : 1/fs : frameLength/(2*fs) - 1/fs;
sigma = 30;
chirpWin = (1 / sqrt(2*pi*sigma) ) * exp(-(frameTimeVec.^2) ./ (2 * sigma));
chirpWin = chirpWin ./ norm(chirpWin);
hammingWin = hamming(frameLength) ./ norm(hamming(frameLength));

% Spectrogram with hamming window
[~, freqSpec, timeSpec, specHamming] = spectrogram(signal, hammingWin, framesOverlap, numFreqBins, fs);
figure(1);
subplot(3,1,1); surf(timeSpec, freqSpec, pow2db(specHamming), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)');
title('Spectrogram with hamming window'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

% Spectrogram with chirp window
[~, freqSpec, timeSpec, specChirp] = spectrogram(signal, chirpWin, framesOverlap, numFreqBins, fs);
subplot(3,1,2); surf(timeSpec, freqSpec, pow2db(specChirp), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)');
title('Spectrogram with Chirp window with const variance'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

%% Estimate Instaneous frequency 
[~, maxFreqIndx] = max(specHamming,[],1);
instFreqVec = freqSpec(maxFreqIndx);

%% Estimate chirp window variance 
zeta = fs * 10; % Threshold parameter 
numFrames = length(instFreqVec);
sigma = zeros(1, numFrames);
normFactor = 2 * sqrt(2 * log(2));
for iTime = 1 : numFrames
    currSum = 0;
    l = 0;
    while(currSum < zeta)      
        if(iTime - l < 1)
            startInd = 1;
        else
            startInd = iTime - l;
        end
        
        if(iTime + l > numFrames)
            endInd = numFrames;
        else
            endInd = iTime + l;
        end
        
        currSum = sum(instFreqVec(startInd : endInd));
        l = l + 1;
    end
    sigma(iTime) = (endInd - startInd + 1) / normFactor;
end

figure(2), subplot(2,1,1); plot(instFreqVec); subplot(2,1,2); plot(sigma);

%% STFT with chirp window with changing variance
chirpWinMat = (1 ./ sqrt(2*pi*sigma) ) .* exp(-(frameTimeVec'.^2) ./ (2 * sigma));
chirpWinMatNorm = vecnorm(chirpWinMat);
chirpWinMat = chirpWinMat ./ chirpWinMatNorm;

%%
S = STFT(signal, chirpWinMat, stepSize, numFreqBins, fs);
S = S(1 : size(specHamming,1), :);
S = abs(S).^2;

figure(1), subplot(3,1,3); surf(timeSpec, freqSpec, pow2db(S), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)');
title('Spectrogram with Chirp window with changing variance'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);
