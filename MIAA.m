function [recoveredSamples] = MIAA(sampledSignal, A, nonMissingSamplesIndx, missingSamplesIndx, numIterations, inversionType)
% Synopsis : Estimate Missing data samples using IAA algorithm
% INPUTS
    % y - the sampled signal
    % A - the steering matrix
    % nonMissingSamplesIndx - 
    % missingSamplesIndx - 
    % numIterations - 
    % inversionType - Options : svd \ linearEq \ regular
% OUTPUTS
    % recoveredSamples - Estimation of missing samples
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
%% Estimation of coefficients in new basis using IAA algorithm with the
% non-missing samples
nonMissingA = A(nonMissingSamplesIndx, :);
[~, p] = IAA(sampledSignal, nonMissingA, numIterations);

%% Estimate the missing samples
numMissingSamples = length(missingSamplesIndx);
missingA = A(missingSamplesIndx, :);
Rm = ( missingA .* repmat( p.', numMissingSamples, 1 ) ) * missingA';

% define svd as default in case input isn't received
if(~exist('inversionType','var'))
    inversionType = 'svd'; 
end

switch inversionType
    case 'svd'
        Rm_inv = pinv(Rm, 1e-4);
        ym_numerator = missingA' * Rm_inv;
        ym_denumerator = sum( (missingA' * Rm_inv) * missingA, 2 );
        h = (ym_numerator ./ ym_denumerator)';
        leftPart = pinv(h * h', 1e-4);
        rightPart = sum(p' .* h, 2);
        recoveredSamples = leftPart * rightPart;

    case 'linear'
        ym_numerator = missingA' / Rm;
        ym_denumerator = sum( (missingA' / Rm) * missingA, 2 );
        h = (ym_numerator ./ ym_denumerator)';
        leftPart = h * h';
        rightPart = sum(p' .* h, 2);
        recoveredSamples = leftPart \ rightPart;
        
    case 'regular'
        Rm_inv = inv(Rm);
        ym_numerator = missingA' * Rm_inv;
        ym_denumerator = sum( (missingA' * Rm_inv) * missingA, 2 );
        h = (ym_numerator ./ ym_denumerator)';
        leftPart = inv(h * h');
        rightPart = sum(p' .* h, 2);
        recoveredSamples = leftPart * rightPart;
        
    otherwise
        error('No Implementation of such inversion method');
end

end

