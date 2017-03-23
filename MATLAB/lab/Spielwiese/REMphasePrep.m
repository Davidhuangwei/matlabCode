function [spike] = REMphasePrep(FileBase,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%
% function [whl, trial, spike] = Trial2TrialPrep(FileBase,varargin)
% 
% computes/loads:
% whl, trial, spike (see dokumented program)
% 

Par = LoadPar([FileBase '.par']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SPIKES
%% spike.t:   spike times within ranges of position data
%% spike.ind: spike identification
%% spike.clu: cluster (shank,cluster)
%% spike.ph:  spike phase during theta
fprintf('  spikes....\n');
[spike.t, spike.ind, numclus, phspike, spike.clu] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);

%% Phase for spikes
ThPhase = InternThetaPh(FileBase);
spike.ph = mod(ThPhase.deg(round(spike.t/16)),2*pi); %%% 0 is PEAK of theta!!
UThPhase = unwrap(ThPhase.deg);
spike.uph = UThPhase(round(spike.t/16)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find Good Theta
fprintf('  find theta episodes....\n');
%% 
load([FileBase '.elc'],'-MAT');
%dummy = trial.itv;
if ~FileExists([FileBase '.sts.REM']) | overwrite
  if FileExists([FileBase '.whl'])
    [whl.itv whl.ctr] = InterpolWhl(FileBase);
    figure(333);clf
    plot(whl.itv(:,1));hold on; plot(whl.itv(:,2),'r');
    numsessions=input('how many sessions [1]: ');
    run = find(whl.itv(:,1) >0 & whl.itv(:,2)>0);
    edges = [];
    for n=1:numsessions
      figure(333);clf
      plot(whl.itv(:,1));hold on; plot(whl.itv(:,2),'r');
      title('mark BEFORE and AFTER run')
      marker = ginput(2);
      edges = [edges min(run(find(run>marker(1,1)))) max(run(find(run<marker(2,1))))];
      Lines(edges);
    end
    
    sleep = reshape([0 edges length(whl.ctr(:,1))],(length(edges)+2)/2,2)';
    figure(333);clf
    plot(whl.itv(:,1));hold on; plot(whl.itv(:,2),'r');
    Lines(sleep(:,1),[],'g','-',2);
    Lines(sleep(:,2),[],'r','-',2);
    msave([FileBase '.sts.REM'],sleep*32);
  end
  CheckEegStates(FileBase,'REM',[],[1 100],elc.theta,1);
  go = input('go? ');
end
newstats = load([FileBase '.sts.REM']);
spike.rem = WithinRanges(round(spike.t/16),newstats);
if FileExists([FileBase '.sts.RUN'])
  runstats = load([FileBase '.sts.RUN']);
  spike.run = WithinRanges(round(spike.t/16),runstats) & ~spike.rem;
  spike.nrem = ~spike.rem & ~spike.run;
else
  spike.nrem = ~spike.rem;
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
