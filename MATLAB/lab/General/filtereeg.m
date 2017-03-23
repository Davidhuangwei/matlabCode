%function eegout=filtereeg(eeg,passband,stopband,sRate,order,dB)
function eegout= filtereeg(eeg,passband,stopband,sRate,order,dB)

if nargin<4 | isempty(sRate)
    sRate=1250;
end
Nyquist=sRate/2;
%dB=10;
nsamples=1*sRate;
if nargin<2 | isempty(passband)
    passband=[1,15];
end
if (length(passband)>2) passband=[passband(1) passband(end)]; end
if nargin<3 | isempty(stopband)
    stopband = passband + diff(passband)/10 * [-1 1];
end

eegsize=size(eeg);
if eegsize(1)<eegsize(2)
    eeg=eeg';
end
chnum=min(size(eeg));
eegout=[];
% theta
%[n Wn] = Scheb2ord([5 10]/Nyquist, [4 12]/Nyquist, 1, dB);
%[bThe aThe] = Scheby2(n, dB, Wn);
%gamma
%[n Wn] = Scheb2filtord([30 80]/Nyquist, [25 85]/Nyquist, 1, dB);
%[bGam aGam] = Scheby2(n, dB, Wn);

[n Wn] = Scheb2ord(passband/Nyquist, stopband/Nyquist, 1, dB);
if nargin>4 & ~isempty(order)
    n=order;
end

[b a] = Scheby2(n, dB, Wn);
%keyboard
for i=1:chnum
    eegout(:,i)=Sfiltfilt(b,a,eeg(:,i));
end

