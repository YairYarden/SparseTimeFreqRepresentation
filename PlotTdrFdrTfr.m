function [] = PlotTdrFdrTfr(firstSignal, secondSignal, thirdSignal, timeDomainVec, ...
                            first_p_IAA, second_p_IAA, third_p_IAA, FreqDomainVec,...
                            firstSpecIAA, secondSpecIAA, thirdSpecIAA, specTimeVec, specFreqVec)
% Synopsis : Make a subplot of Time domain, Frequency domain, and
% Time-Frequency domain plots of 3 different signals

% INPUTS : 

% OUTPUT : 

% Written by Yair Yarden and Ofir Kedem - 2021
% ----------------------------------------------------------------

%% First Signal
% Time domain
subplot(3,3,1); plot(timeDomainVec, firstSignal); grid minor;
xlabel('Time[sec]'); ylabel('Amplitude'); title('Sum of sines with decaying Exponent');
% FFT
subplot(3,3,2); plot(FreqDomainVec, mag2db(abs(first_p_IAA))); grid minor; xlim([0, max(FreqDomainVec)]);
xlabel('frequency[Hz]'); ylabel('Amplitude'); 
% STFT
subplot(3,3,3); surf(specTimeVec, specFreqVec, pow2db(firstSpecIAA), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,1]);
title('Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

%% Second signal
% Time Domain
subplot(3,3,4); plot(timeDomainVec, secondSignal); grid minor;
xlabel('Time[sec]'); ylabel('Amplitude'); title('Sum of sines in different times');
% FFT
subplot(3,3,5); plot(FreqDomainVec, mag2db(abs(second_p_IAA))); grid minor; xlim([0, max(FreqDomainVec)]);
xlabel('frequency[Hz]'); ylabel('Amplitude'); 
% STFT
subplot(3,3,6); surf(specTimeVec, specFreqVec, pow2db(secondSpecIAA), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,1]);
title('Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

%% Third signal
% Time Domain
subplot(3,3,7); plot(timeDomainVec, thirdSignal); grid minor;
xlabel('Time[sec]'); ylabel('Amplitude'); title('Chirp + Fm modulated Sine');
% FFT
subplot(3,3,8); plot(FreqDomainVec, mag2db(abs(third_p_IAA))); grid minor; xlim([0, max(FreqDomainVec)]);
xlabel('frequency[Hz]'); ylabel('Amplitude');
% STFT
subplot(3,3,9); surf(specTimeVec, specFreqVec, pow2db(thirdSpecIAA), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time'); colorbar; ylabel('Frequency(HZ)'); ylim([0,max(specFreqVec)]);
title('Spectrogram'); xlabel('Time[sec]'); ylabel('Freq[Hz]'); set(gca,'fontsize',12);

end

