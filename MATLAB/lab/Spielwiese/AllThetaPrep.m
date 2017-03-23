function spike = AllThetaPrep(FileBase,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%
% function [whl, trial, spike] = Trial2TrialPrep(FileBase,varargin)
% 
% computes/loads:
% whl, trial, spike (see dokumented program)
% 

Par = LoadPar([FileBase '.par']);
EegRate = 1250;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Behavioral states:
%% states.ind:  states identification numbers
%% states.itv:  intervals in Eeg-sampling rates
%% states.info: which ind number corresponds top which state
load([FileBase '.states'],'-MAT')
states.run = states.ind(find(states.ind>1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% POSITION:
%% whl.ctr :   center of lights
%% whl.plot:   does not contain -1
%% whl.speed:  speed of rat 
%% whl.rate:   sampling rate of whl file
%% whl.ncol:   columns of position (e.g. [2 3] or [1 2 3 4])
%fprintf('  whl data....\n');
%whl = GetWhl(FileBase,overwrite,states.itv);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRIALS:
%% trial.itv:  trial intervals 
%% trial.dir:  trial direction
%% trial.stim: time of stimmulation
%% trial.mean: 
%fprintf('  trials....\n');
%whstates = round(states.itv/EegRate*whl.rate); whstates(:,1) = whstates(:,1)+1;
%trial = GetTrials(FileBase,whl,overwrite,[],whstates);
%trial = GetTrials(FileBase,whl,1,[],whstates);

%% Linearized whl position
%fprintf('  linearized rat position....\n');
%whl.dir = zeros(length(whl.ctr),1);
%for segs=1:length(trial)
%  if ~isempty(trial(segs).OneMeanTrial)
%    for n=unique(trial(segs).dir)'
%      whlindx = find(WithinRanges([1:length(whl.ctr)],trial(segs).itv(find(trial(segs).dir==n),:)));
%      whl.dir(whlindx) = n;
%    end
%  end
%end

%whl.lin = -10.0*ones(size(whl.ctr,1),1);
%for segs=1:length(trial)
%  if ~isempty(trial(segs).OneMeanTrial) & ~trial(segs).OneMeanTrial
%    for n=unique(trial(segs).dir)'
%      if isempty(trial(segs).mean(n).mean)
%	continue
%      end
%      whlindx = find(WithinRanges([1:length(whl.ctr)],trial(segs).itv(find(trial(segs).dir==n),:)));
%      whl.lin(whlindx,1) = GetSpikeLinPos(whl.ctr(whlindx,:),trial(segs).mean(n).mean,trial(segs).mean(n).sclin);
%    end
%  elseif ~isempty(trial(segs).OneMeanTrial) & trial(segs).OneMeanTrial
%    n=2;
%    whlindx = find(WithinRanges([1:length(whl.ctr)],trial(segs).itv(find(trial(segs).dir>1),:)));
%    whl.lin(whlindx,1) = GetSpikeLinPos(whl.ctr(whlindx,:),trial(segs).mean(n).mean,trial(segs).mean(n).lin);
%  end
%end

%% linear speed
%smlinpos = whl.lin;
%whl.speedlin = zeros(size(whl.lin));
%for segs=1:length(states.run)
%  if states.run(segs)~=2;
%    continue;
%  else
%    for tr=1:size(trial(segs).itv,1)
%      inx = find(WithinRanges([1:size(whl.ctr,1)],trial(segs).itv(tr,:)));
%      smlinpos(inx,1)=smooth(whl.lin(inx,1),50,'lowess');
%      whl.speedlin(inx,1) = [0; diff(smlinpos(inx,1))*whl.rate];
%      clear inx;
%    end
%  end
%end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SPIKES
%% spike.t:   spike times within ranges of position data
%% spike.ind: spike identification
%% spike.pos: position of spike (x,y)
%% spike.clu: cluster (shank,cluster)
%% spike.dir: trial direction of spike
%% spike.ph:  spike phase during theta
%fprintf('  spikes....\n');
%[spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,whl.ctr,whl.rate,1);

%% Spike-indices of one direction
%spike.dir = zeros(length(spike.t),1);
%for segs=1:length(trial)
%  for nn=unique(trial(segs).dir)'
%    spike.dir(find(WithinRanges(spike.t/20000*whl.rate,trial(segs).itv(find(trial(segs).dir==nn),:))),:)=nn;
%  end
%end

%% Linearized spike position:
%fprintf('  linearized spike position....\n');
%spike = SpikeLinPos(spike,trial);

Par = LoadPar([FileBase '.par']);
[xspike.t, xspike.ind, spike.clu, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);

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
