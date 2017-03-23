function [whl, trial, spike] = Trial2TrialPrep(FileBase,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%
% function [whl, trial, spike] = Trial2TrialPrep(FileBase,varargin)
% 
% computes/loads:
% whl, trial, spike (see dokumented program)
% 

Par = LoadPar([FileBase '.par']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% POSITION:
%% whl.ctr :   center of lights
%% whl.plot:   does not contain -1
%% whl.speed:  speed of rat 
%% whl.rate:   sampling rate of whl file
%% whl.ncol:   columns of position (e.g. [2 3] or [1 2 3 4])
fprintf('  whl data....\n');
whl = GetWhl(FileBase,overwrite);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRIALS:
%% trial.itv:  trial intervals 
%% trial.dir:  trial direction
%% trial.stim: time of stimmulation
%% trial.mean: 
fprintf('  trials....\n');
trial = GetTrials(FileBase,whl,overwrite);
%trial = MarkEvents(FileBase,trial,whl,overwrite);

%% Linearized whl position
fprintf('  linearized rat position....\n');
whl.dir = zeros(length(whl.ctr),1);
for n=unique(trial.dir)'
  whlindx = find(WithinRanges([1:length(whl.ctr)],trial.itv(find(trial.dir==n),:)));
  whl.dir(whlindx) = n;
end

whl.lin = -10.0*ones(size(whl.ctr,1),1);
if ~trial.OneMeanTrial
  for n=unique(trial.dir)'
    if isempty(trial.mean(n).mean)
      continue
    end
    whl.lin(find(whl.dir==n),1) = GetSpikeLinPos(whl.ctr(find(whl.dir==n),:),trial.mean(n).mean,trial.mean(n).sclin);
  end
else
  n=2;
  whl.lin(find(whl.dir>1),1) = GetSpikeLinPos(whl.ctr(find(whl.dir>1),:),trial.mean(n).mean,trial.mean(n).lin);
end

%% smoothing of lin pos
smlinpos = whl.lin;
whl.speedlin = zeros(size(whl.lin));
for tr=1:length(trial.itv)
  inx = find(WithinRanges(find(whl.ctr(:,1)),trial.itv(tr,:)));
  smlinpos(inx,1)=smooth(whl.lin(inx,1),10,'lowess');
  whl.speedlin(inx,1) = [0; diff(smlinpos(inx,1))*whl.rate];
  clear inx;
end
%inx = find(WithinRanges(find(whl.ctr(:,1)),trial.itv) & whl.lin>-10);
%plot(find(whl.lin(inx))/whl.rate,whl.speedlin(inx),'.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SPIKES
%% spike.t:   spike times within ranges of position data
%% spike.ind: spike identification
%% spike.pos: position of spike (x,y)
%% spike.clu: cluster (shank,cluster)
%% spike.dir: trial direction of spike
%% spike.ph:  spike phase during theta
fprintf('  spikes....\n');
[spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,whl.ctr,whl.rate,0);

%% Spike-indices of one direction
spike.dir = zeros(length(spike.t),1);
for nn=unique(trial.dir)'
  spike.dir(find(WithinRanges(spike.t/20000*whl.rate,trial.itv(find(trial.dir==nn),:))),:)=nn;
end

%% Linearized spike position:
fprintf('  linearized spike position....\n');
spike = SpikeLinPos(spike,trial);

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{%
%>> figure
%>> subplot(121)
%>> subplot(211)
%>>
%>>
%>> spect = load([FileBase '.eegseg.mat']);
%>> imagesc(spect
%spect                     spectrogram               spectview
%spectralanalysisobjsdemo  spectrum
%>> imagesc(spect.
%f    t    y
%>> imagesc(spect.t, spect.f,spect.y');
%>> imagesc(spect.t, spect.f,spect.y');axis xy
%>> imagesc(spect.t, spect.f,spect.y');axis xy
%>> fi = find(spect.f<15);
%>> imagesc(spect.t, spect.f(fi),spect.y(:,fi)');axis xy
%>> subplot(212)
%>> plot([1:size(whl.ctr,1)]/1250,whl.ctr);
%>> axis tight
%>> TimeBrowse(100,40)
%>> No more to the right, change step
%No more to the right, change step
%No more to the right, change step
%No more to the left, change step%

%>> help TimeBrowse
% function TimeBrowse([action,] [Data,] Width, Position, tRange )
%%% plot hist of slopes
%AA = CatStruct(PlaceCell);
%figure
%subplot(121)
%hist(AA.slope(find(AA.slope(:,2)~=0),2))%%
%
%subplot(122)%
%plot(AA.slope(find(AA.slope(:,2)~=0),2),-log(AA.slope(find(AA.slope(:,2)~=0),4)),'.')

%plot(whll(find(whll(:,1)>0),1),whll(find(whll(:,1)>0),2))
