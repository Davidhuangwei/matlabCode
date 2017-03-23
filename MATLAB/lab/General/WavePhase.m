% [WavePhase, WaveAmp, TotWavePhase] = WavePhase(Eeg, FreqRange, FilterOrd, Ripple)
%
% takes a 1-channel Eeg file (assumes 1250 Hz) and produces
% instantaneous phase and amplitude for given freq. band.  TotWavePhase is
% unwrapped phase.
%
% Wave is filtered with filtfilt and a cheby2 filter with parameters
% FreqRange, FilterOrd, Ripple defautls [6 15], 4, 20.
% good values for 
% gamma are [40 100], 8, 20.
% theta [4 10], 4, 20
% if no args are provided, will plot some diagnostics

function [WavePhase, WaveAmp, TotWavePhase] = WavePhase(Eeg, FreqRange, FilterOrd, Ripple,sRate)

if nargin<2, FreqRange = [6 15]; end

if nargin<4, Ripple = 20; end;
if nargin<5 | isempty(sRate)
    sRate=1250;
end
Nyquist=sRate/2;


if min(size(Eeg)>1)
	error('Eeg should be 1 channel only!');
elseif size(Eeg,1)==1
    Eeg = Eeg(:);
end

    [FilterOrd Wn] = Scheb2ord(FreqRange/Nyquist, (FreqRange+[-1 1].*FreqRange/5)/Nyquist, 1, Ripple);
   
    fprintf('filter order =  %d, cutoff freq = %d - %d\n',FilterOrd,Wn);  
   
[b a] = Scheby2(FilterOrd, Ripple, Wn);
Eegf = Sfiltfilt(b,a,Eeg);
% remove constant term to avoid bias
Eegf = Eegf - mean(Eegf);
if nargout>0, clear Eeg; end;
Hilb = Shilbert(Eegf);
if nargout>0, clear Eegf; end;
WavePhase = angle(Hilb);

if nargout>=2
	WaveAmp = abs(Hilb);
end
if nargout>=3
	TotWavePhase = unwrap(WavePhase);
end

if nargout==0
    subplot(3,1,1);
    [h w s] = freqz(b, a, 2048, 1250);
    plot(w,abs(h));
    grid on
    
    subplot(3,1,2)
    xr = (1:length(Eeg))*1000/1250;
    plot(xr, [Eeg, Eegf]);
    
    subplot(3,1,3);
    plot(xr, [Eegf, WavePhase*std(Eegf)]);
    clear WavePhase
end
