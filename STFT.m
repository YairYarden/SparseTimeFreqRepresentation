function [S] = STFT(signal, win, hopSize, F, Fs)
% Input:
    % signal –input audio signal.
    % win – the window to be used for STFT, if win is a scalar a
    % Hamming widow of length win should be used .
    % hopSize – time-hop between consecutive STFT time frames.
    % F – if F is a scalar it should be the number of frequencies to be
    % used by the FFT in this case S should have F rows. If F is a vector it should
    % contain the frequencies for which the STFT should be calculated at each
    % time-step, in this case S should have the same number of rows
    % as the number of elements in F.
    % Fs – the signals sampling frequency.
    
% Output:
    % S – the STFT of the input signal. S should always have a number
    % of columns equal to the number of time-steps in the signal.

% Written by Yair Yarden & Ofir Kedem. 
% Date : May 2021
% ------------------------------------------------------------------
if(size(signal, 2) == 1) % make signal a row vector
    signal = signal';
end
if(length(win) == 1) % win indicates the size of window
    win = hamming(win);
elseif(size(win, 1) == 1)
    win = win'; % Make window a row vector 
end
% frameLength = length(win);
frameLength = size(win,1);
if(length(F) == 1)
    fftSize = F;
end

if(length(F) == 1) % Implement using FFT on each frame  
    % Divide signal to frames
%     bufferSize = length(win);
    bufferSize = size(win,1);
    overlap = bufferSize - hopSize;
    signalFrames = buffer(signal, bufferSize, overlap, 'nodelay'); % each column is a time window of the signal

    % Multiply by window element-wise
    signalFrames = signalFrames .* win;

    % Zero pad if needed
    numFrames = size(signalFrames, 2);
    if(fftSize > bufferSize)
        signalFrames = [signalFrames; zeros(fftSize - bufferSize, numFrames)];
    elseif(fftSize < bufferSize)
        % In order to reduce resolution in frequency must make aliasing in time
        signalFrames = SumAliasedReplicas(signalFrames, fftSize, bufferSize);
    end

    % Compute FFT of each frame
    S = fft(signalFrames);
%     S = S(1 : 1 + floor(fftSize / 2), :); % take only positive freqs
    
else % Implement using filter banks
   n = 0 : length(signal) - 1;
   normFreqVec = F .* (2*pi / Fs);
   % Generate filter banks. Each row in matrix corresponds to filter with
   % different frequency
   expMat = exp(-1j .* normFreqVec' * n); 
   mulByExp = expMat .* signal;
   % Convolve with flipped window
   convWithWin = conv2(1, flip(win), mulByExp, 'same');
   S = convWithWin(:, ceil(frameLength/2) : hopSize : end - ceil(frameLength/2) );
   nPhaseAdjust = 0 : hopSize : hopSize * (size(S,2) - 1);
   expAdjustPhaseMat = exp(1j .* normFreqVec' * nPhaseAdjust); 
   S = S .* expAdjustPhaseMat;
end

end