function [instFreqVec] = EstimateInstFreq(inputSignal, estimationMethod, frameSize, framesOverlap, numFreqBins, fs)
% Synopsis : Estimates the instaneous frequency of signal at desired frames
% INPUTS : inputSignal
%        : estimationMethod - options : ['max', ]
%        : frameSize
%        : framesOverlap
%        : numFreqBins
%        : fs

% OUTPUTS : instFreqVec - estimated instaneous frequency at desired frames

% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
%% Input Validation
% Check that input signal is a vector
if(size(inputSignal, 1) > 1 && size(inputSignal, 2) > 1)
    error('instFreqVec should be a vector and not a matrix');
end

% Convert to column vector
if(size(inputSignal, 1) > 1)
    inputSignal = transpose(inputSignal);
end

%% Compute instaneous frequency
% Compute spectrogram
[~, freqSpec, ~, powerSpec] = spectrogram(inputSignal, frameSize, framesOverlap, numFreqBins, fs);

switch estimationMethod
    % Take max frequency at each frame
    case 'max'     
        [~, maxFreqIndx] = max(powerSpec,[],1);
        instFreqVec = freqSpec(maxFreqIndx);
    case 'mean'
        instFreqVec = zeros(1, size(powerSpec,2));
        for iTime = 1 : size(powerSpec, 2)
            currFramePowerSpec = powerSpec(:,iTime);
            currFramePowerSpec = currFramePowerSpec ./ norm(currFramePowerSpec);
            instFreqVec(iTime) = mean(freqSpec .* currFramePowerSpec);
        end
    otherwise
        error('No such estimation method');
end


end