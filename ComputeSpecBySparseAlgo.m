function [spectrogram, specTimeVec, specFreqVec,lossVec] = ComputeSpecBySparseAlgo(signal, timeVec, numIterations, fs, ...
                                                numSamplesInFrame, stepSize, numFreqBins, q, algorithmType, initCondType, initPoints)
% Synopsis : Compute spectrogram using Sparsity promoting algorithm IAA or
% SLIM
% INPUTS : signal
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

%% Compute IAA on each frame
initCondCounter = 0;
spectrogram = zeros(size(A,2), numFrames);
lossVec = zeros(1, numFrames);
% stftForInitCondition = ComputeStftForInitCondition(signal, numSamplesInFrame, stepSize,...
%                                                    numFreqBins, fs);
for iFrame = 1 : numFrames
    currA = A(1 + (iFrame - 1) * stepSize : (iFrame-1) * stepSize + numSamplesInFrame, :);
    currFrame = signal(1 + (iFrame - 1) * stepSize : (iFrame-1) * stepSize + numSamplesInFrame);
    switch algorithmType
        case 'IAA'
            [~, spectrogram(:, iFrame)] = IAA(currFrame, currA, numIterations);
        case 'SLIM'
            [curr_s_frame, ~, loss] = SLIM(currFrame, currA, q, numIterations);
            lossVec(iFrame) = loss;
            spectrogram(:, iFrame) = abs(curr_s_frame).^2;
            
        case 'SLIM_IT'
            switch initCondType
                case 'prevFrame'
                    if(iFrame == 1 || (exist('curr_s_frame','var') && norm(curr_s_frame) < 1e-5)...
                     || (~isempty(find(initPoints == iFrame,1))))
                        [curr_s_frame, ~,loss] = SLIM(currFrame, currA, q, numIterations);
                        initCondCounter = 0;
                        lossVec(iFrame) = loss;
                    else
                        curr_s_frame = curr_s_frame ./ norm(curr_s_frame);
                        [curr_s_frame, ~, loss] = SLIM_IT(currFrame, currA, q, 1, curr_s_frame);
                        initCondCounter = initCondCounter + 1;
                        
                        lossVec(iFrame) = loss;
                    end
                    spectrogram(:, iFrame) = abs(curr_s_frame).^2;
                    
                case 'stft'
                    [curr_s_frame, ~] = SLIM_IT(currFrame, currA, q, 4, stftForInitCondition(:, iFrame));
                    spectrogram(:, iFrame) = abs(curr_s_frame).^2;       
                    
                otherwise
                    error('No such Inital condition type');
            end
        otherwise
            error('No such algorithm Type option');           
       
    end
end

specTimeVec = (0 : numFrames - 1) *  (stepSize / fs);

end