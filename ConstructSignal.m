function signal = ConstructSignal(timeGrid, optionNumber, sConfigSignals)
% Synopsis : This function Construct one of three optional signals
% The first one is sum of sines mulltiplied by decaying exponent.
% The second one is sum of sines each "lives" in different time domain
% The third consists of two components: one is an ascending chirp, 
% which increases from low frequency 0.55 to high frequency 0.95 
% and another is a frequency modulated signal in the middle frequency region
% (“sin” modulation with period 256, central frequency 0.75 and modulation range from 0.55 to 0.95).
% In addition, the amplitude of the chirp component is modulated with a Gaussian
% window function (maximum value is equal to one unit), while the
% amplitude of the frequency modulated signal is a constant one unit

% INPUTS : 
    % optionNumber - Which signal to construct
    % sConfigSignals - configuration of signals parameters     
% OUPUTS 
    % signal
    
% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------
% Extract Parameters
decayExp = sConfigSignals.decayExp;
sineFreqs = sConfigSignals.sineFreqs;
chirpStartFreq = sConfigSignals.chirpStartFreq;
chirpEndFreq = sConfigSignals.chirpEndFreq;
fmCentralFreq = sConfigSignals.fmCentralFreq;
fmSineFreq = sConfigSignals.fmSineFreq;
fmFreqDev = sConfigSignals.fmFreqDev;
fs = sConfigSignals.fs;
% ----------------------------------------------------------------
signal = zeros(1, length(timeGrid));
switch optionNumber
    case 1 % Sum of sines multiplied by decay exponent 
        sineMat = exp(1j*2*pi*sineFreqs'*timeGrid);
        signal = sum(sineMat, 1) .* exp(-decayExp * timeGrid); 
    
    case 2 % Sum of sines each in different time
        numSines = length(sineFreqs);
        frameSize = round(length(timeGrid) / numSines);
        centers = zeros(1,numSines); %[-5, -6.5, -3, -1];
        scales = ones(1,numSines); % [3, 1, 2, 2.5];
        
        currSignalIdx = 1;
        for iFrame = 1 : numSines - 1
            signal(currSignalIdx : currSignalIdx + frameSize) = exp(1j*2*pi*sineFreqs(iFrame)*timeGrid(1 : 1 + frameSize)) * scales(iFrame) + centers(iFrame);
            currSignalIdx = currSignalIdx + frameSize;
        end
        signal(currSignalIdx : end) = exp(1j*2*pi*sineFreqs(end) * timeGrid(1 : end - currSignalIdx + 1)) * scales(end) + centers(end);
    
    case 3 % Chirp + FM modulated sine
        gaussWindow = gausswin(length(timeGrid));
        chirpPart = gaussWindow' .* chirp(timeGrid, chirpStartFreq, max(timeGrid), chirpEndFreq);      
        sineBeforeFm = sin(2*pi*fmSineFreq*timeGrid);
        fmSine = fmmod(sineBeforeFm, fmCentralFreq, fs, fmFreqDev);
        signal = chirpPart + fmSine;
end

end
