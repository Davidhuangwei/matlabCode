%[ccg, t] = WaveLocking(filename,FreqRange,Thresh,...
%                       WhatPhase,EegCh,UnitsEl,BinSize, HalfBins)
%calculates the correlogram of units to the particular phase of the
% ripple at FreqRange above the Thresh power from the mean in std's
function [ccg, t] = WaveLocking(filename,FreqRange,Thresh,...
                                    WhatPhase,EegCh,UnitsEl,BinSize, HalfBins)

Par = LoadPar([filename '.par']);
SampleRate=round(1e6/Par.SampleTime);
eegSampleRate = 1250;
epsilon =0.05;

Eeg=readsinglech([filename '.eeg'],Par.nChannels,EegCh);

[WavePhase, WaveAmp] = WavePhase(Eeg, FreqRange);

GoodWavePeriods=find(((WaveAmp-mean(WaveAmp))/std(WaveAmp))>Thresh);

WhatPhaseT=find(abs(abs(WavePhase)-WhatPhase)<epsilon);

LockTimes=intersect(WhatPhaseT,GoodWavePeriods)*SampleRate/eegSampleRate;
LockTimes = LockTimes(:);
[T,G,numclu] = ReadEl4CCG(filename,UnitsEl);

T=[LockTimes; T]; 
G = [ones(length(LockTimes),1); G+1];
%keyboard
[ccg, t] = CCG(T, G, BinSize, HalfBins, SampleRate, [], 'scale');
%CCG(T, G, BinSize, HalfBins, SampleRate, [], 'scale');
ccg = squeeze(ccg(:,1,:));
if nargout<1
    figure
    for i=1:size(ccg,2)
        subplotfit(i,size(ccg,2));
        bar(t,ccg(:,i));
        axis tight
    end
end







