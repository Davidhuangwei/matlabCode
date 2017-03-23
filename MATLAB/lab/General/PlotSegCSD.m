%% PlotSegCSD(FileBase,segment,csdstep,filter)
% chnum - number of channles in dat and eeg used to plot
% several csd maps for csdchannles cell arry of ch. number vectors
% and also datchannels in separate subplot for convenince
% in segment = [reftime beg end] reftime in SECONDS and beg and end in MSEC 
% as in eega output 
function out = PlotSegCSD(FileBase,segment,varargin)
[csdstep,filter] = DefaultArgs(varargin,{2,[1 200]});

Par = LoadPar(FileBase);

eegsr=1e6/Par.SampleTime/16;
Nyquist =eegsr/2;

segment(2:3)=segment(2:3)/1000;  % from msec to sec

eegbeg=round((segment(1)+segment(2))*eegsr)*2*Par.nChannels;
eegsamples=round((segment(3)-segment(2))*eegsr);

eeg=bload([FileBase '.eeg'],[Par.nChannels, eegsamples],eegbeg)';

if FileExists('offsetcorrection')
    corr = load('offsetcorrection');
else
    corr = mean(eeg,1);
end
eeg=eeg-repmat(corr,eegsamples,1);
trange = linspace(segment(2),segment(3),eegsamples)*1000;

eeg = ButFilter(eeg, 2, filter/Nyquist,'bandpass');

if nargout>0
    out = PlotCSD96(eeg,trange,[1:Par.nChannels],Par,csdstep,0);
else
 PlotCSD96(eeg,trange,[1:Par.nChannels],Par,csdstep,0);
end

