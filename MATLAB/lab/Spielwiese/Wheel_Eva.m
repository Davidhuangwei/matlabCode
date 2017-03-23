%function Wheel_Eva(FileBase)
%% look at wheel data from Eva:

overwrite = 0;

SampleRate = 20000;
EegRate = 1250;
WhlRate = 1250;

PLOT = 0;
PLOT1 = 1;

PRINTFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

list = LoadStringArray('listWheel.txt');

file = [1 2 3 4 5 7 8 9 10]; % alternation task and wheel running
%% file = 6 is REM!!
%file = [7 8 9 10]; % control wheel running
%file = [1 2 3 4 5];

if isempty(file);
  file = [1:length(list)];
end
RtAll = [];PCAll=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOOP THROUGH FILES
%%
for f=file
  
  FileBase = [list{f} '/' list{f}];
  PrintBase = [list{f} '/Figs/' list{f}];
  
  fprintf('=========================\n');
  fprintf('FILE %d: %s\n',f,list{f});
  
  %%%%%%%%%%%
  %% Whl data
  if ~FileExists([FileBase '.whl']) %| overwrite
    error('no whl file!');
  else
    whl = GetWhl(FileBase); 
    WhlCtr = whl.ctr;
  end
  
  %%%%%%%%%%%%%%%%%
  %% Trials on Maze
  if f<6
    trial = GetTrials(FileBase,whl);
    
    %% linearized position
    whl = GetWhlLin(whl,trial);
  end
  
  %%%%%%%%%%%%%%%%%%%%%%
  %% Electrode selection
  %%
  elc = InternElc(FileBase,overwrite);
  elc = ElcRegion(FileBase,overwrite);
  elc.animal = FileBase;
  elc
  save([FileBase '.elc'],'elc');

  %%%%%%
  %% Eeg 
  Eeg = GetEEG(FileBase);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Wheel data - in EegRate
  wheel = GetWheelEva(FileBase,WhlCtr,overwrite);
  run = wheel.runs;

  %ask = input('do you need to correct wheel.dir? [0/1] ');
  %if ask
  %  wheel.dir
  %  ask = input('plus how much? ');
  %  wheel.dir = wheel.dir + ask;
  %end
  
  %%%%%%%%%%%%%%%%%%
  %% get the spikes!
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,WhlCtr,WhlRate,1,SampleRate);
  spike = FindGoodTheta(FileBase,spike);
  %goodsp = find(spike.pos(:,1)>0 | spike.pos(:,2)>0 & spike.good);
  [spike.ph spike.uph] = SpikePhase(FileBase,spike.t,SampleRate,EegRate);
  
  %% linearized position
  spike.dir = zeros(length(spike.t),1);
  if f<6
    for nn=unique(trial.dir)'
      spike.dir(find(WithinRanges(spike.t/20000*whl.rate,trial.itv(find(trial.dir==nn),:))),:)=nn;
    end
    fprintf('  linearized spike position....\n');
    spike = SpikeLinPos(spike,trial,WhlRate);
  end
  
  %% spike distance on wheel
  %spike.whl = wheel.dist(round(spike.t/SampleRate*EegRate));
  spike.whl = wheel.count(round(spike.t/SampleRate*EegRate));
  
  %%%%%%%%%%%%%%%%%%%
  %% classify neurons
  [ctype cmono] = CellTypes(FileBase,overwrite);
    
  %%%%%%%%%%%%%%%%%%%%%%%
  %% Take only HC neurons
  %HCcells = ismember(spike.ind,find(ismember(spike.clu(:,1),find(elc.region==1))));
  HCcells = find(ismember(spike.clu(:,1),find(elc.region==1)));
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% COMPUTE - WHEEL
  
  %%%%%%%
  %% CCGs
  xcorrl = SVMUccg(FileBase,Eeg,spike,run,overwrite);
  %[overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,'.xcorr',1250,20000});
  
  
  %%%%%%%%%%%%%%%%%%%%%%
  %% compute the spectra
  GoodPC = xcorrl.goodPC(ismember(xcorrl.goodPC,HCcells));
  GoodIN = xcorrl.goodIN(ismember(xcorrl.goodIN,HCcells));
  ALL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodPC,GoodIN,overwrite,1,0,[],[],[],find(ctype.num==2),unique([GoodPC GoodIN]));
  %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate,allPC,CluSubset] = DefaultArgs(varargin,{[],[],0,0,0,'.spect',1250,20000,[],[]});
  GoodSP = GoodSpect(ALL(f).spect.spunit,ALL(f).spect.f,ctype.num);
  ALL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodSP{2},GoodSP{1},overwrite,1,PRINTFIG,[],[],[],find(ctype.num==2),unique([GoodSP{2} GoodSP{1}]));
    
  ALL(f).goodn = GoodSP;

  %%%%%%%%%%%%%%%
  %% width of ccg
  ALL(f).width = SVMUccgWidth(FileBase,spike.t,spike.ind,run,0,1,[],[],[],GoodSP{2},GoodSP{1});
 
  
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% Phase ccg and spectrum
  ALL(f).xcorrlPh = SVMUccgPh(FileBase,spike.t,spike.ind,run,GoodSP{2},GoodSP{1},find(ctype.num==2),0,1);
  %[run,gPC,gIN,allPC,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],[],[],[],0,0,'.xcorrPh',1250,20000});
  %ALL(f).spectPh = SVMUspectPh(FileBase,spike,run,PrintBase,GoodSP{2},GoodSP{1},0,1,[],[],[],[],find(ctype.num==2));
  %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate,allPC,CluSubset] = DefaultArgs(varargin,{[],[],0,0,0,'.spectPh',1250,20000,[],[]});
  
  %%%%%%%%%%%
  %% MUA Rate
  %mua = SVMUmua(FileBase,Eeg,spike,run,PrintBase,find(ctype.num==2),overwrite);
  %[gcells,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],0,0,'.muarate',1250,20000});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Coherence measure - in time
  %cohe = SVMUspectL(FileBase,spike,run,mua,PrintBase,overwrite);
  %[overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,0,'.coherence',1250,20000});
  %coheM = SVMUspectL(FileBase,spike,run,mua,PrintBase,find(ctype.num==2),overwrite,1,0,'.coherenceM');

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% COMPUTE - MAZE

  if f>6
    %% for controll task
    trial.itv = load([FileBase '.sts.RUN']);
    runM = trial.itv;
    
    itv = MixIntervals(runM,run,0);
  else
    itv = trial.itv;
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% CCGs
  xcorrlM = SVMUccg(FileBase,Eeg,spike,itv,overwrite,0,'.xcorrM');
  %[overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,'.xcorr',1250,20000});

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% compute the spectra
  GoodPC = xcorrlM.goodPC(ismember(xcorrlM.goodPC,HCcells));
  GoodIN = xcorrlM.goodIN(ismember(xcorrlM.goodIN,HCcells));
  ALL(f).spectM = SVMUspect(FileBase,Eeg,spike,itv,PrintBase,GoodPC,GoodIN,overwrite,1,0,'spectM',[],[],find(ctype.num==2),unique([GoodPC GoodIN]));
  %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],[],0,0,0,'.spect',1250,20000});
  GoodSP = GoodSpect(ALL(f).spectM.spunit,ALL(f).spect.f,ctype.num);
  ALL(f).spectM = SVMUspect(FileBase,Eeg,spike,itv,PrintBase,GoodSP{2},GoodSP{1},overwrite,1,PRINTFIG,'spectM',[],[],find(ctype.num==2),unique([GoodSP{2} GoodSP{1}]));
    
  ALL(f).goodnM = GoodSP;
  
  %%%%%%%%%%%%%%%
  %% Width of ccg
  ALL(f).width = SVMUccgWidth(FileBase,spike.t,spike.ind,run,0,1,'.xcorrWidthM',[],[],GoodSP{2},GoodSP{1});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% Phase ccg and spectrum
  ALL(f).xcorrlPhM = SVMUccgPh(FileBase,spike.t,spike.ind,itv,GoodSP{2},GoodSP{1},find(ctype.num==2),0,1,'.xcorrPhM');
  %[run,gPC,gIN,allPC,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],[],[],[],0,0,'.xcorrPh',1250,20000});
  %spectPhM = SVMUspectPh(FileBase,spike,itv,PrintBase,GoodSP{2},GoodSP{1},0,1,[],'.spectPhM',[],[],find(ctype.num==2));
  %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate,allPC,CluSubset] = DefaultArgs(varargin,{[],[],0,0,0,'.spectPh',1250,20000,[],[]});
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% MUA Rate
  %muaM = SVMUmua(FileBase,Eeg,spike,trial.itv,PrintBase,find(ctype.num==2),overwrite,0,'.muarateM');
  %[gcells,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],0,0,'.muarate',1250,20000});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Coherence measure - in time
  %coheM = SVMUspectL2(FileBase,spike,muaM,PrintBase,overwrite,1,0,'.coherenceM');
  %[overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,0,'.coherence',1250,20000});
  %
  %coheM = SVMUspectL(FileBase,spike,trial.itv,muaM,PrintBase,find(ctype.num==2),overwrite,1,0,'.coherenceM');
  %[gcells,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],0,0,0,'.coherence',1250,20000});
  
 
  %%%%%%%%%%%%%%%%%%%
  %% overall theta
  if ~FileExists([FileBase '.phasestat']) | 1
    
    idx = find(WithinRanges(round(spike.t/SampleRate*EegRate),run));
    PhH = myPhaseOfTrain(spike.ph(idx),spike.ind(idx));
    
    idx = find(WithinRanges(round(spike.t/SampleRate*EegRate),itv));
    PhHM = myPhaseOfTrain(spike.ph(idx),spike.ind(idx));
    
    save([FileBase '.phasestat'],'PhH','PhHM')
  end
  dummy = load([FileBase '.phasestat'],'-MAT');
  PhH = CatStruct(dummy.PhH);
  PhHM = CatStruct(dummy.PhHM);
  clear dummy;
  ALL(f).PhH = PhH;
  ALL(f).PhHM = PhHM;
  ALL(f).type = ctype.num;
end

%PlotSfN08Phase
  

return;

