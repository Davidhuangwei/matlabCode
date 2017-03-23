sRate = 1250;
Nyquist = sRate/2;
nSamps = 1e5;

xr = (1:nSamps)';

% Make filters
%TheFil = fir1(200, 2*[6 10]/sRate);
%GamFil = fir1(200, 2*[40 100]/sRate);

dB = 20;
[n Wn] = cheb2ord([5 10]/Nyquist, [4 12]/Nyquist, 1, dB);
[bThe aThe] = cheby2(n, dB, Wn);
[n Wn] = cheb2ord([40 100]/Nyquist, [35 105]/Nyquist, 1, dB);
%[n Wn] = cheb2ord([240 300]/Nyquist, [235 305]/Nyquist, 1, dB);
[bGam aGam] = cheby2(n, dB, Wn);

if 0
	% compute fake EEG data
	Theta = cos(2*pi*xr*8/sRate);
	Gamma = cos(2*pi*xr*40/sRate);
	%Gamma = filter(GamFil, 1, randn(1,nSamps));
	EEG = Theta + .1*Gamma.*(Theta+1);
elseif 0
	eegAll = bload('/u5/b/ken/data/g2705/g2705.eeg-1-9-18', [3 inf]);
	REMEpoch = [900 1100];
	REMEEG = eegAll(1,round(REMEpoch(1)*1250):round(REMEpoch(2)*1250))';
    EEG = REMEEG;
end
if 0
    % make simulated Gaussian noise EEG
    [p f] = psd(REMEEG,1024);
    EEG = ColoredNoise(nSamps, p, f);
end
    
% compute phases and amplitude
%TheFiltEEG = filter(TheFil, 1, EEG);
TheFiltEEG = filtfilt(bThe, aThe, EEG);
TheHilb = hilbert(TheFiltEEG);
ThePh = angle(TheHilb);
TheAmp = abs(TheHilb);

% compute gamma phase and amplitude
%GamFiltEEG = filter(GamFil, 1, EEG);
GamFiltEEG = filtfilt(bGam, aGam, EEG);
GamHilb = hilbert(GamFiltEEG);
GamPh = angle(GamHilb);
GamAmp = abs(GamHilb);

% plot stuff
dr = 3e3:4e3-1;

subplot(2,2,1)
plot([EEG(dr), TheFiltEEG(dr), GamFiltEEG(dr)])
legend('Unfiltered', 'Theta', 'Gamma');
title('EEG data');

subplot(2,2,3)
plot([TheFiltEEG(dr), ThePh(dr)*mean(TheAmp(dr))/4, TheAmp(dr)]);
title('Hilbert Transform');
legend('Theta filtered', 'Inst. Phase', 'Inst Amp');

% find peaks
subplot(2,2,2)
Peaks = [LocalMinima(GamFiltEEG) , LocalMinima(-GamFiltEEG)]';
%plot(GamFiltEEG(Peaks), ThePh(Peaks), '.', 'markersize', 1);
[m Bins] = BinSmooth(GamFiltEEG(Peaks), ThePh(Peaks), 'circmean', -500:60:500);
plot(Bins, m*180/pi);
xlabel('Gamma Peak Amplitude');
ylabel('Mean Phase');
title('Positive and Negative Peaks');

% gamma amplitude vs. theta phase
[m Bins std stderr] = MeanSmooth(ThePh*180/pi, GamAmp, -180:10:170);
subplot(2,2,4)
errorbar(Bins, m, stderr);
xlabel('Theta Phase');
ylabel('Inst. Gamma Power');
title('Gamma Power Largest on Falling Phase');

return

a.ThePh = ThePh;
a.TheAmp = TheAmp;
a.GamPh = GamPh;
a.GamAmp = GamAmp;
xgobi(a);

return

% width of hamming window (on each side)
WinWidth = 10;

% loop thru phases
for a=1:8;
	Ph0 = (a-4.9)*pi/4;
	% now find phase crossings
	Crossings = find(Ph(1:nSamps-1)<=Ph0 & Ph(2:nSamps)>Ph0);
	% delete those that don't have a whole segment
	Crossings(find(Crossings<=WinWidth | Crossings>=nSamps-WinWidth)) = [];
	nCrossings = length(Crossings);
		
	% extract segments
	IndMat = repmat(Crossings, 2*WinWidth+1,1) + repmat((-WinWidth:WinWidth)',1,nCrossings);
	Segs = EEG(IndMat);
	subplot(2,2,3);
	plot(Segs);
	
	% now hamming window them, fourier transform, and average	
	SegWin = Segs.*repmat(hamming(2*WinWidth+1),1,nCrossings);
%	Pow = mean(abs(fft(SegWin
end