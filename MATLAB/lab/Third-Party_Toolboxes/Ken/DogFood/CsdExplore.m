% CsdExplore(Csd, f)
% 
% Plots Cross-Spectrum amplitude, phase, coherence, and gain
% Csd and f should be from the output of mtcsd.

function CsdExplore(Csd,f)

nCh = size(Csd,2);
nFreqs = size(Csd,1);

figure(1)
% Cross Spectrum amplitude
PlotMatrix(f,20*log10(abs(Csd)))   
set(gcf, 'name', 'Cross-Spectrum Amplitude');

figure(2)
% Cross spectrum phase
PlotMatrix(f,180*angle(Csd)/pi, '.', 'MarkerSize', 1);
ForAllSubplots('ylim([-180 180])');
set(gcf, 'name', 'Cross-Spectrum Phase');

figure(3)
% Coherence
coh = zeros(size(Csd));
for i=1:nCh, for j=1:nCh
	coh(:,i,j) = abs(Csd(:,i,j)) ./ sqrt(Csd(:,i,i) .* Csd(:,j,j));
end, end;

PlotMatrix(f,coh);
set(gcf, 'name', 'Coherence');
ForAllSubplots('ylim([0 1])');


figure(4)
% Gain
for i=1:nCh, for j=1:nCh
	gain(:,i,j) = Csd(:,i,j) ./ Csd(:,i,i);
end, end;
PlotMatrix(f, abs(gain));
set(gcf, 'name', 'Gain');

figure(5)
% Time domain cross-correlation
for i=1:nCh, for j=1:nCh
	FullFFT = [Csd(:,i,j) ; flipud(conj(Csd(2:nFreqs-1,i,j)))];
	TimeDom = real(fft(FullFFT));
	ccg(:,i,j) = [TimeDom(nFreqs+1:end) ; TimeDom(1:nFreqs)];
end, end;
SampleRate = f(end)*2;
tRange = [2-nFreqs : nFreqs-1] / SampleRate;
PlotMatrix(tRange,ccg);
set(gcf, 'name', 'Cross Covariance');

figure(6)
% Time domain transfer function
for i=1:nCh, for j=1:nCh
	FullFFT = [gain(:,i,j) ; flipud(conj(gain(2:nFreqs-1,i,j)))];
	TimeDom = real(fft(FullFFT));
	transfer(:,i,j) = [TimeDom(nFreqs+1:end) ; TimeDom(1:nFreqs)];
end,end
SampleRate = f(end)*2;
tRange = [2-nFreqs : nFreqs-1] / SampleRate;
PlotMatrix(tRange,transfer);
set(gcf, 'name', 'Transfer function');
