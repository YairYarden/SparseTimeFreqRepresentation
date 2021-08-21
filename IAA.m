function [s, p] = IAA(y, A, numIterations)
% Synopsis : This function estimates the sparsest signal s such that
% minimzes the L2 norm term ||y - As||
% INPUTS
    % y - the sampled signal
    % A - the steering matrix
    % numIterations - 
% OUTPUTS
    % s - The estimated sparse signal 
    % p - the power of s
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
% Check Validation of inputs
if(size(y,2) > 1)
    y = transpose(y);
end
% ----------------------------------------------------------------
% Initialize
[numSamples, numBinsInNewBasis] = size(A);
rowsNormA = sum( abs(A).^2 ).'; % size numBinsInNewBasis
s = A'*y ./ rowsNormA; % size 
% ----------------------------------------------------------------
% Start iterating
for iterationNum = 1 : numIterations
    p = abs(s).^2;
    % Very efficient (better than P = diag( p ); R = A*P*A'; )
    R = ( A .* repmat( p.', numSamples, 1 ) ) * A';
    if(rcond(R) < 1e-17) % invertion of R is unstable
        break;
    end
    R_inv = inv(R);
    
    % Efficient implementation
    sNumerator     = A' * R_inv * y;
    sDenumerator   = sum( (A' * R_inv) .* A.', 2 );
    s = sNumerator ./ sDenumerator;  
end
p = abs(s).^2;
end

