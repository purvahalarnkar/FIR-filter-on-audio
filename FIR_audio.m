clc
clear all
close all

load glassDance.mat
soundsc(glassclip,srate)
time=(0:length(glassclip)-1)/srate;
plot(time,glassclip)
title('GlassClip')
xlabel('Time')

%% Inspect the power spectrum
hz=linspace(0,srate/2,floor(length(glassclip)/2)+1);
p=abs(fft(glassclip(:,1))/length(glassclip));
figure
plot(hz,p(1:length(hz)))
axis([100 2000 0 max(p)])
title('Power Spectrum')
xlabel('Frequency(Hz)')
ylabel('Amplitude')

%% 
% Pick frequencies to filter
frange=[300 460];

%FIR1 filter
filter=fir1(2001,frange/(srate/2),'bandpass');

% Apply the filter to the signal
filtglass(:,1)=filtfilt(filter,1,glassclip(:,1));
filtglass(:,2)=filtfilt(filter,1,glassclip(:,2));

%%
% Power spectrum of filtered signal
pf=abs(fft(filtglass(:,1))/length(glassclip));
hold on
plot(hz,pf(1:length(hz)),'r')
axis([100 2000 0 max(pf)])

legend('Original frequencies','Selected frequencies')

% plot the time-frequency response (spectrogram)
figure
spectrogram(glassclip(:,1),hann(round(srate/10)),[],[],srate,'yaxis')
hold on
plot(time([1 1; end end]),frange([1 2; 1 2])/1000,'k:','linew',2)
axis([0 end 0 2])
title('Time-frequency response')
%%
soundsc(filtglass,srate)