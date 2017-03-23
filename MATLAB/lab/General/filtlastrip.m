function eegout= filter2need(eeg,lowband,highband)

sRate=1250;
Nyquist=sRate/2;
dB=20;
nsamples=1*sRate;
if nargin<2
lowband=6;
highband=15;
end
% theta
%[n Wn] = Scheb2ord([5 10]/Nyquist, [4 12]/Nyquist, 1, dB);
%[bThe aThe] = Scheby2(n, dB, Wn);
%gamma
%[n Wn] = Scheb2filtord([30 80]/Nyquist, [25 85]/Nyquist, 1, dB);
%[bGam aGam] = Scheby2(n, dB, Wn);

[n Wn] = Scheb2ord([lowband highband]/Nyquist, [lowband-20 highband+20]/Nyquist, 1, dB);
[bSpnd aSpnd] = Scheby2(n, dB, Wn);
eegout=Sfiltfilt(bRip,aRip,eeg(:,end));
