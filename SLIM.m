function [s, p] = SLIM(y, A, q, numIterations)
% Synopsis : Implementation of SLIM (Sparse Learning via Iterative
% Minimization. 
% eta corresponds to the noise power
% INPUTS : 
    % y - the sampled signal
    % A - the steering matrix
    % q - number in range [0,1] or (0,1] according to the paper.
%     Meaning of norm type to use for sparsity encourging penalty
% numIterations
% OUPUTS 
    % s - The estimated sparse signal 
    % p - the power of s
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
% Check Validation of inputs
if(size(y,2) > 1)
    y = transpose(y);
end
% ----------------------------------------------------------------
stopThreshold = 0.01;
% Initialize
[numSamples, ~] = size(A);
rowsNormA = sum( abs(A).^2 ).'; % size numBinsInNewBasis
s = A'*y ./ rowsNormA;
eta = mean( abs( y - A * s ).^2 );
% ----------------------------------------------------------------
% Start iterating
for iterationNum = 1 : numIterations
   p = abs( s ).^( 2 - q );
   P = diag(p);
   Sigma = A * P * A' + eta * eye(numSamples);
   s_new = P * A' * (Sigma \ y);
   if(norm(s_new - s) / norm(s) < stopThreshold)
       s = s_new; 
       break;
   end
   s = s_new;
   eta = mean( abs( y - A * s ).^2 );
end

end

