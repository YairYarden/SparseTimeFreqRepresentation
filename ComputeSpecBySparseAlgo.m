function [spectrogram, specTimeVec, specFreqVec] = ComputeSpecBySparseAlgo(signal, timeVec, numIterations, fs, ...
                                                numSamplesInFrame, stepSize, numFreqBins, q, algorithmType)
% Synopsis : Compute spectrogram using Sparsity promoting algorithm IAA or
% SLIM
% INPUTS : signal
%        : timeVec
%        : numIterations
%        : fs
%        : numSamplesInFrame
%        : stepSize
%        : numFreqBins 
%        : q
%        : algorithmType

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
% samplesResidum = mod(length(signal) - numSamplesInFrame, stepSize);
% Pad signal with zeros so there will be a whole number of frames
% if(samplesResidum > 0)
%     signal = [signal, zeros(1, stepSize - samplesResidum)];
% end
numFrames = floor(1 + (length(signal) - numSamplesInFrame) / stepSize);
specFreqVec = -fs/2 : fs/numFreqBins : fs/2 - 1/numFreqBins;
A = exp( 1j*2*pi*timeVec'*specFreqVec );

%% Compute FDR on each frame
spectrogram = zeros(size(A,2), numFrames);
for iFrame = 1 : numFrames
    currA = A(1 + (iFrame - 1) * stepSize : (iFrame-1) * stepSize + numSamplesInFrame, :);
    currFrame = signal(1 + (iFrame - 1) * stepSize : (iFrame-1) * stepSize + numSamplesInFrame);
    switch algorithmType
        case 'IAA'
            [~, spectrogram(:, iFrame)] = IAA(currFrame, currA, numIterations);
        case 'SLIM'
            [curr_s_frame, ~] = SLIM(currFrame, currA, q, numIterations);
            spectrogram(:, iFrame) = abs(curr_s_frame).^2;
        otherwise
            error('No such algorithm Type option');
    end
end

specTimeVec = (0 : numFrames - 1) *  (stepSize / fs);

end