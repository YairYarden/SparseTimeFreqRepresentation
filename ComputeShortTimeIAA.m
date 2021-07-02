function [spectrogramIAA, specTimeVec, specFreqVec] = ComputeShortTimeIAA(signal, numIterations, fs, ...
                                                numSamplesInFrame, stepSize, numFreqBins)
% Synopsis : Compute spectrogram using IAA, by computing IAA on each frame of the signal separately
% INPUTS : signal
%        : numIterations
%        : fs
%        : numSamplesInFrame
%        : stepSize
%        : numFreqBins 

% OUTPUT : spectrogramIAA
%        : specTimeVec
%        : specFreqVec

% Written by Yair Yarden and Ofir Kedem - 2021
%% Check validity of inputs
if(numSamplesInFrame > length(signal))
    error('Signal length cant be shorter than number of samples in each frame');
end
if(stepSize > length(signal))
    error('Signal length cant be shorter than step size');
end
if(size(signal,1) > 1) % Accept only row vector
    signal = transpose(signal);
end

%% Preparation for IAA
samplesResidum = mod(length(signal) - numSamplesInFrame, stepSize);
% Pad signal with zeros so there will be a whole number of frames
if(samplesResidum > 0)
    signal = [signal, zeros(1, stepSize - samplesResidum)];
end
numFrames = 1 + (length(signal) - numSamplesInFrame) / stepSize;
specFreqVec = -fs/2 : fs/numFreqBins : fs/2 - 1/numFreqBins;
frameTimeVec = (0 : numSamplesInFrame - 1) / fs;
A = exp( 1j*2*pi*frameTimeVec'*specFreqVec );

%% Compute IAA on each frame
spectrogramIAA = zeros(size(A,2), numFrames);
for iFrame = 1 : numFrames
    currFrame = signal(1 + (iFrame - 1) * stepSize : (iFrame-1) * stepSize + numSamplesInFrame);
    [~, spectrogramIAA(:, iFrame)] = IAA(currFrame, A, numIterations);
end

specTimeVec = (0 : numFrames - 1) *  (stepSize / fs);

end