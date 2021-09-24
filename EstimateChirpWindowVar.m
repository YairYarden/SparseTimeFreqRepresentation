function [chirpVar] = EstimateChirpWindowVar(instFreqVec, fs, zeta)
% Synopsis : This function is for estimating good variance parameter for
% chirp window
% INPUTS : instFreqVec - vector of estimation of the instaneous frequency
%                        at each time stamp
%        : fs - sampling frequency
%        : zeta  - Threshold parameter
% OUTPUTS : chirpVar - estimated variance of adaptive chirp window
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
%% Validation of inputs
% Default Threshold parameter
if(~exist('zeta','var'))
    zeta = fs * 10; % Threshold parameter 
end

if(size(instFreqVec, 1) > 1 && size(instFreqVec, 2) > 1)
    error('instFreqVec should be a vector and not a matrix');
end

%% Compute Variance at each frame
numFrames = length(instFreqVec);
chirpVar = zeros(1, numFrames);
normFactor = 2 * sqrt(2 * log(2));
startInd = 0;
endInd = 0;
for iTime = 1 : numFrames
    currSum = 0;
    timeOffset = 0;
    while(currSum < zeta && startInd > -1 && endInd < numFrames)      
        if(iTime - timeOffset < 1)
            startInd = 1;
        else
            startInd = iTime - timeOffset;
        end
        
        if(iTime + timeOffset > numFrames)
            endInd = numFrames;
        else
            endInd = iTime + timeOffset;
        end
        
        currSum = (1/fs) * sum(instFreqVec(startInd : endInd));
        timeOffset = timeOffset + 1;
    end
    chirpVar(iTime) = ((endInd - startInd + 1) / normFactor)^2;
end

end

