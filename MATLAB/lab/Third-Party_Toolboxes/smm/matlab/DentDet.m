% Dentate Spike Detection v.1.0
%
% Usage: DentDet(FileBase,ChNum);
%
% Instead of returning an array, this dumps the POSITIVE peak
% times (in EEG samples) of the dentate spikes into the directory, named
% FileBase.dsp.  
% NOTE: the first number in FileBase.dsp is the ChNum input!
%
% For single channel input only - filters
% the EEG and finds the peaks that are above threshold.
% The output file is so you can check the reliability.
%
% As Haj puts it, no warranty!

function DentDetect(FileBase,Period,ChNum);
if nargin<3, fprintf('Usage: DentDet(''FileBase'',Period,ChNum);\n\n'); return; end;

Par = LoadPar([FileBase '.par']);

[analsum,EEG]=Truncate(FileBase,Period,ChNum,1);

MyFilt=Sfir1(30, [50 150]/625); %change for spike det
DentFiltEEG=Filter0(MyFilt,EEG);

DHilb = Shilbert(DentFiltEEG);
DPh = angle(DHilb);
DAmp = abs(DHilb);
Dthr = mean(DAmp)+(std(DAmp)*4);

DSpikes = LocalMinima(-DentFiltEEG,10);
DSpikesThr = DSpikes(find(DAmp(DSpikes)>Dthr));
SpTimes = DSpikesThr;

fnout=fopen([FileBase '.dsp'],'w');

fprintf(fnout,'%d\n',ChNum);

for i=1:length(SpTimes)
    fprintf(fnout,'%d\n',SpTimes(i)-1); % -1 because of "filter jitter"... best I can do!
end
fclose(fnout);

fprintf('Number of detected dentate spikes: %d\n',length(SpTimes));
