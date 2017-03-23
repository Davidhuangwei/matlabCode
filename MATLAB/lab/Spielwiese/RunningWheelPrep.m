function [whl, trial, spike] = RunningWheelPrep(FileBase,varargin)
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
%whl = GetWhl(FileBase,overwrite);
whl = GetWhl(FileBase,0);
whl = GetWheelSpeed(whl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRIALS:
%% trial.itv:  trial intervals 
%% trial.dir:  trial direction
%% trial.stim: time of stimmulation
%% trial.mean: 
fprintf('  trials....\n');
trial = GetTrialsWheel(FileBase,whl,overwrite);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SPIKES
%% spike.t:   spike times within ranges of position data
%% spike.ind: spike identification
%% spike.pos: position of spike (x,y)
%% spike.clu: cluster (shank,cluster)
%% spike.dir: trial direction of spike
%% spike.ph:  spike phase during theta
fprintf('  spikes....\n');
[spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,whl.ctr,whl.rate);

%% Spike-indices of one direction
%spike.dir = zeros(length(spike.t),1);
%for nn=unique(trial.dir)'
%  spike.dir(find(WithinRanges(spike.t/20000*whl.rate,trial.itv(find(trial.dir==nn),:))),:)=nn;
%end

%% Phase for spikes
ThPhase = InternThetaPh(FileBase);
spike.ph = mod(ThPhase.deg(round(spike.t/16)),2*pi); %%% 0 is PEAK of theta!!
UThPhase = unwrap(ThPhase.deg);
spike.uph = UThPhase(round(spike.t/16)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find Good Theta
fprintf('  find theta episodes....\n');
%% 
if ~FileExists([FileBase '.sts.ask']) | overwrite
  ask = input('Do you want to select good theta periods [0/1]? ');
  msave([FileBase '.sts.ask'],ask);
end
SelectGoodTheta = load([FileBase '.sts.ask']);
if SelectGoodTheta
  load([FileBase '.elc'],'-MAT');
  %dummy = trial.itv;
  if ~FileExists([FileBase '.sts.RUN']) & ~FileExists([FileBase '.sts.theta'])
    CheckEegStates(FileBase,'RUN',[],[1 100],elc.theta,1);
    go = input('go? ');
  elseif ~FileExists([FileBase '.sts.RUN']) & FileExists([FileBase '.sts.theta']) 
    system(['cp ' FileBase '.sts.theta ' FileBase '.sts.RUN']);
    CheckEegStates(FileBase,'RUN',[],[1 100],elc.theta,1);
    go = input('go? ');
  elseif FileExists([FileBase '.sts.RUN']) & overwrite
    CheckEegStates(FileBase,'RUN',[],[1 100],elc.theta,1);
    go = input('go? ');
  end
  newstats = load([FileBase '.sts.RUN']);
  spike.good = WithinRanges(round(spike.t/16),newstats);
else
  spike.good = ones(length(spike.t),1);
end

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
