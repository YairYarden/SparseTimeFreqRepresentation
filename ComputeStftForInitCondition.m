function [stftForInitCondition] = ComputeStftForInitCondition(signal,numSamplesInFrame,stepSize,...
                                                               numFreqBins, fs)
% Synopsis : Computes Regular STFT to be used as initial condition for
% ST-SLIM-IT
% INPUTS :
% OUTPUTS : 
% Written by Yair Yarden and Ofir Kedem - 2021
% ------------------------------------------------------------------

% Compute STFT
stft = STFT(signal, numSamplesInFrame, stepSize, numFreqBins, fs);
stft(:,end) = [];

% Organize Axis
stftForInitCondition = zeros(size(stft));
stftForInitCondition(1 : numFreqBins / 2, :) = stft(numFreqBins/2 + 1 : end, :);
stftForInitCondition(numFreqBins/2 + 1 : end, :) = stft(1 : numFreqBins/2, :);
end

