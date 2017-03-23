% Histograms = WaveLocking(filename,freqrange,wavecutoff,whatphase,numch,eegch,elind,tbin,swwindow,numbin, swtype)
% selects 'whatphase' from 'freqrange' filtered  with 'wavecutoff' (in std) 'eegch' of 'filename'.eeg
% plots or outputs CCG ('tbin' in sec, 'numbin' bins) for units on 'elind' in and outside the +/- 'swwidnow' (sec) of 'swtype' periods
% swtype can be a vector of preriods centers 
function Histograms = WaveLocking(filename,freqrange,wavecutoff,whatphase,numch,eegch,elind,tbin,swwindow,numbin,swtype)


if nargin<3 
    tbin=0.05;
    swwindow=0.5;
    ifprint=0;
    swtype='h';
elseif nargin<4
    tbin=0.05;
    swwindow=0.5;
    swtype='h';
end
ssr=20000;
esr=1250;

fn=[pwd '/' filename];
clu=load([fn '.clu.' num2str(elind)]);
clunum=clu(1);
clu=clu(2:end);
res=load([fn '.res.' num2str(elind)]);
spk=res(find(clu~=1));

if swtype=='h'
    sw=load([fn '.swa']);
    sw=sw(:,2);
elseif swtype=='j'
    sw=load([fn '.sw']);
    sw=sw(:,2);
else
    sw=swtype;
end


eeg=readsinglech(strcat(fn,'.eeg'),numch,eegch);

[WavePhase, WaveAmp] = WavePhase(eeg, freqrange);

GoodWavePeriods=find((WaveAmp-mean(WaveAmp))/std(WaveAmp)>wavecutoff);

WhatPhaseT=find(abs(abs(WavePhase)-whatphase)<0.05);

LockTimes=intersect(WhatPhaseT,GoodWavePeriods);

spkin=[];
for ii=1:size(sw,1)
    spkin=[spkin; spk(find((spk>sw(ii)-swwindow*20000) & (spk<sw(ii)+swwindow*20000)))];
end
spkout=setdiff(spk,spkin);
%numbin=%ceil(swwindow/tbin
[histin,t]=PointCorrel(LockTimes*ssr/esr,spkin,tbin*ssr,numbin,0,ssr,'count');
[histout,t]=PointCorrel(LockTimes*ssr/esr,spkout,tbin*ssr,numbin,0,ssr,'count');
histin = histin(:)/sum(histin);
histout = histout(:)/sum(histout);
t=t(:);
if nargout==0    
    subplot(211)
    bar(t,histout,'g');
    title('outside');
    %hold on
    subplot(212)
    bar(t,histin,'r');
    title('inside')
    %hold off
else
    Histograms=[histin,histout,t];
end


