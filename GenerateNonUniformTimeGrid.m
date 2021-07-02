function [sTimeVecs] = GenerateNonUniformTimeGrid(maxTime, timeRes, numNonUniformSamples, sPlot)
% Synopsis : Generate Non-uniform time vectors for Arbitrary Non-uniform
% sampling of the signals

% INPUTS : 
    % maxTime
    % timeRes
    % numNonUniformSamples  
% OUPUTS 
    % sTimeVecs
    
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
% Extract Struct Parameters
isPlot = sPlot.isPlot;
% ----------------------------------------------------------------

fullTimeVec = 0 : timeRes : maxTime;
sTimeVecs.firstSigTimeVec = sort((randperm(round(maxTime / timeRes), numNonUniformSamples) - 1) * timeRes, 'ascend');
sTimeVecs.secondSigTimeVec = sort((randperm(round(maxTime / timeRes), numNonUniformSamples) - 1) * timeRes, 'ascend');
sTimeVecs.thirdSigTimeVec = sort((randperm(round(maxTime / timeRes), numNonUniformSamples) - 1) * timeRes, 'ascend');
% ----------------------------------------------------------------
%% Plotting 
figure,
if(isPlot) 
    % First Signal
    [~, intersectIndx] = intersect(fullTimeVec, sTimeVecs.firstSigTimeVec);
    samplingIndexs = zeros(1, length(fullTimeVec));
    samplingIndexs(intersectIndx) = 1;
    subplot(1,3,1); stem(samplingIndexs); xlim([0, find(cumsum(samplingIndexs) > 20, 1, 'first')]); 
    title('First Signal - Nonuniform Arbitrary - First 20 samples');
    % second Signal
    [~, intersectIndx] = intersect(fullTimeVec, sTimeVecs.secondSigTimeVec);
    samplingIndexs = zeros(1, length(fullTimeVec));
    samplingIndexs(intersectIndx) = 1;
    subplot(1,3,2); stem(samplingIndexs); xlim([0, find(cumsum(samplingIndexs) > 20, 1, 'first')]); 
    title('Second Signal - Nonuniform Arbitrary - First 20 samples');
    % Third Signal
    [~, intersectIndx] = intersect(fullTimeVec, sTimeVecs.thirdSigTimeVec);
    samplingIndexs = zeros(1, length(fullTimeVec));
    samplingIndexs(intersectIndx) = 1;
    subplot(1,3,3); stem(samplingIndexs); xlim([0, find(cumsum(samplingIndexs) > 20, 1, 'first')]); 
    title('Third Signal - Nonuniform Arbitrary - First 20 samples');
end
end

