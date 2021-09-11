function [chirpWinMat] = CreateAdaptiveChirpWindow(adaptiveVar, frameLength, fs)
% Synopsis : Creating chirp adaptive window using estimated variance at
% each frame
% INPUTS : adaptiveVar
%        : frameLength
%        : fs
% 
% OUTPUTS : chirpWinMat

% Written by Yair Yarden and Ofir Kedem - 2021
% ------------------------------------------------------------
frameTimeVec = -frameLength/(2*fs) : 1/fs : frameLength/(2*fs) - 1/fs;
chirpWinMat = (1 ./ sqrt(2*pi*adaptiveVar) ) .* exp(-(frameTimeVec'.^2) ./ (2 * adaptiveVar));
chirpWinMatNorm = vecnorm(chirpWinMat);
chirpWinMat = chirpWinMat ./ chirpWinMatNorm;

end

