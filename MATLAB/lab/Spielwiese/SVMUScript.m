%% Script to compute all figures for paper SVMUTheta

overwrite = 0;
compute = 0;
compute2 = 0;
PLOT = 0;
PRINTFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filelist ={'listEva.txt' 'listKamran.txt' 'listKenji.txt' 'listSebi.txt'};
%           [1:16]        [17:30]          [31:??]         [??:??] 

list = [];
for n=1:length(filelist)
  list = [list; LoadStringArray(filelist{n})];
end

%file = [1 2 4 5];
%file = [6 7 8 9 30];
file = [6:60];
%file = [31:60];
%file = [23];
%file = [2 23];

if isempty(file);
  file = [1:length(list)];
end
RtAll = [];PCAll = []; L = [];
ff = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOOP THROUGH FILES
%%
for f=file
  
  FileBase = [list{f} '/' list{f}];
  PrintBase = [list{f} '/Figs/' list{f}];
  
  fprintf('=========================\n');
  fprintf('FILE %d: %s\n',f,list{f});
  
  fname = ['Matlab' num2str(f) '.mat' ];
  if FileExists(fname)
    fprintf(['Load file ' fname '\n']);
    load(fname,'-MAT')
    ALL(f) = CALL;
    clear CALL
  else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Use this file?
  %%
  proj = IsProject(FileBase,'SVMU',overwrite);
  if ~proj; continue; end
  
  ff = ff+1;
  LIST{ff} = list{f}; 
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% File Info
  %%
  info = FileInfo(FileBase,overwrite);
  info
  SampleRate = info.SampleRate;
  EegRate = info.EegRate;
  WhlRate = info.WhlRate;
  ALL(f).info = info;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Electrode selection
  %%
  elc = InternElc(FileBase,overwrite);
  elc = ElcRegion(FileBase,overwrite);
  elc.animal = FileBase;
  elc
  save([FileBase '.elc'],'elc');
  
  %elc.theta = FindThetaChan(FileBase,find(elc.region==1))
  %save([FileBase '.elc'],'elc');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% State selection
  %% ACHTUNG! states are specific to scientists!! 
  %%
  states = GetStatesSRS(FileBase,overwrite,'Eva',list{f});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Eeg 
  %Eeg = GetEEG(FileBase);
  %newstats = load([FileBase '.sts.RUN']);
  %if diff(newstats(end,:))<0
  %  Eeg = GetEEG(FileBase);
  %  newstats(end,2) = length(Eeg);
  %  msave([FileBase '.sts.RUN'],newstats);
  %end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  SPIKES = 1;
  if SPIKES
    fprintf('... spikes ...\n');
    %% ===>>> spikes
    SVMUspikes
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% find region of neurons
    ALL(f).cells.clu = spike.clu;
    regions = unique(elc.region);
    ALL(f).cells.region = [];
    for n=regions
      idx = find(ismember(spike.clu(:,1),find(elc.region==n)));
      if isempty(idx); continue; end
      ALL(f).cells.region(idx,1) = n;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ===>>> neuron types
    SVMUtype
  end
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  POSITION = 1;
  %if POSITION
  if f<31
  
    %% load position file (.whl)
    %% ACHTUNG  - ONLY FOR 1250/20000
    %% HAS TO BE CORRECTED!!!!!
    whl = GetWhl(FileBase);
    WhlCtr = whl.ctr;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Trials on maze
    if ~isempty(find(states.ind==2 | states.ind==23))
      itv = round(states.itv/states.rate*WhlRate);
      if itv(1,1) < 1; itv(1,1)=1; end
      if itv(end,end) > length(whl.ctr); itv(end,end)=length(whl.ctr);end
      trial = GetTrials(FileBase,whl,overwrite,[],itv);
      %trial = GetTrials(FileBase,whl,1,[],itv);
      
      %% fix some trials. is fixes in program. can be deleted later
      for segs=1:length(trial)
	for mm=2:length(trial(segs).mean)
	  if size(trial(segs).mean(mm).sclin,1)<size(trial(segs).mean(mm).sclin,2)
	    error('wrong dimensions!!')
	    trial(segs).mean(mm).sclin=trial(segs).mean(mm).sclin';
	  end
	end
      end
      %save([FileBase '.trials'],'trial');
      
      % align linear trials
      if length(trial)>1
	%%% ==>> align trials of long and short 
	%trial = AlignSegmentTrials(trial,varargin)
	
	%for segs=1:length(trial)
	%  whl = GetWhlLin(whl,trial(segs));
	%  wlin(:,segs) = whl.lin;
	%  wgood(:,segs) = whl.lin>-10;
	%  wdir(:,segs) = whl.dir;
	%end
	%whl.dir = sum(wdir'); 
	%LL = sum((wlin.*wgood)');
	%LL(find(sum(wgood')==0))=-10;
	%%% ???????
      else
	whl = GetWhlLin(whl,trial);
      end
      
      AllTrial = trial(1);
      [spiketorig, spikeind, spike.pos, numclus, spikeph, ClustByEl] = SpikePos(FileBase,whl.ctr,[],[],[],0);
      clear spiketorig spikeind numclus spikeph ClustByEl;
      spike.dir = zeros(length(spike.t),1);
      for nn=unique(AllTrial.dir)'
	spike.dir(find(WithinRanges(spike.t/SampleRate*whl.rate,AllTrial.itv(find(AllTrial.dir==nn),:))),:)=nn;
      end
      
      spike = SpikeLinPos(spike,trial(1),WhlRate,[],SampleRate);
      
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Wheel data
    if ~isfield(info,'Wheel')
      info.Wheel = input('is there wheel running? ');
      save([FileBase '.info'],'info')
    end
    if info.Wheel
      if f<17
	wheel = GetWheelEva(FileBase,WhlCtr,overwrite,EegRate,WhlRate);
	spike.wpos = wheel.dist(round(spike.t/SampleRate*wheel.whlrate));

	%ix = find(ismember(spike.ind,find(ALL(f).type.num==2)) & WithinRanges(spike.t/SampleRate*wheel.whlrate,wheel.runs));
	%%spikew = FindWheelCells(FileBase,spike.t(ix),spike.ind(ix),spike.ph(ix),wheel)
	%Eeg = GetEEG(FileBase);
	%xcorrl = SVMUccg(FileBase,Eeg,spike,trial.itv,0,0,'.xcorr');
	%GoodPC = xcorrl.goodPC;
	%%WheelCell=FindWheelFields(FileBase, spike, whl, wheel,GoodPC);
      elseif f>=17 & f<=30
	wheel = GetWheelEva(FileBase,overwrite)
      end 
    end
    % GoodPeriods{1} = run;
    % GoodPeriods{2} = trials.itv;
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% prefered theta phase - overall
  PHASE = 1;
  if PHASE
    fprintf('... phase ...\n');
    if ~FileExists([FileBase '.phasestat']) | overwrite
      indx = find(spike.good);
      dummy = myPhaseOfTrain(spike.ph(indx),spike.ind(indx),[],[],[],[],max(spike.ind));
      PhH = CatStruct(dummy);
      for n=1:size(PhH.phhist,1)
	PhH.sphhist(n,:) = smooth(PhH.phhist(n,:),5,'lowess');
      end
      save([FileBase '.phasestat'],'PhH')
    end
    dummy = load([FileBase '.phasestat'],'-MAT');
    ALL(f).PhH = dummy.PhH;
    clear dummy;
    %PhH = CatStruct(dummy.PhH); clear dummy;
    %for n=1:size(PhH.phhist,2)
    %  ALL(f).PhH.sphhist(:,n) = smooth(PhH.phhist(:,n),5,'lowess');
    %end
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  SPECT = 1;
  if SPECT

    fprintf('... spect ...\n');
    Eeg = GetEEG(FileBase);
    
    %%%%%%%%%%%%%%%%
    %% ALL THETA
    run = load([FileBase '.sts.RUN']);
    if run(1,1)<1; run(1,1)=1; msave([FileBase '.sts.RUN'],run); end
    if run(end,2)>length(Eeg); run(end,2)=length(Eeg); msave([FileBase '.sts.RUN'],run); end
    
    FileOut = '.spect';
    SVMUSpect
    ALL(f).spect = dspect;
    
    %% Phase Spect
    fprintf('... phase spect ...\n');
    FileOut = '.spectPh';
    ALL(f).spectPh = SVMUspectPh(FileBase,spike,run,PrintBase,[],[],overwrite,[],[],FileOut,EegRate,SampleRate);
    
    %overwrite=0;
    ALL(f).xcorrl = SVMUccgWidth(FileBase,spike.t(find(spike.good)),spike.ind(find(spike.good)),run,overwrite,0,'xcorrWidth',EegRate,SampleRate,[],[],max(spike.ind),whl.speed(:,1),whl.rate);
    %overwrite=0;
    %ALL(f).xcorrlPh = SVMUccgWidthPh(FileBase,spike.t(find(spike.good)),spike.ph(find(spike.good)),spike.ind(find(spike.good)),run,overwrite,0,'xcorrWidthPh',EegRate,SampleRate,[],[],max(spike.ind),whl.speed(:,1),whl.rate);
   
    if f<31
    %%%%%%%%%%%%%%%%
    %% MAZE
    if ~isempty(find(states.ind==2 | states.ind==23))
      runitv = CatStruct(trial,'itv',1);
      run = round(runitv.itv/whl.rate*EegRate);
      FileOut = '.spectM';
      %overwrite = 1;
      SVMUSpect
      ALL(f).spectM = dspect;
      %overwrite = 0;
      
      %% Phase Spect
      fprintf('... phase spect ...\n');
      FileOut = '.spectPhM';
      ALL(f).spectPhM = SVMUspectPh(FileBase,spike,run,PrintBase,[],[],overwrite,[],[],FileOut,EegRate,SampleRate);
      
      %overwrite=0;
      ALL(f).xcorrlM = SVMUccgWidth(FileBase,spike.t(find(spike.good)),spike.ind(find(spike.good)),run,overwrite,0,'xcorrWidthM',EegRate,SampleRate,[],[],max(spike.ind),whl.speed(:,1),whl.rate);
      %overwrite=0;
      %ALL(f).xcorrlPhM = SVMUccgWidthPh(FileBase,spike.t(find(spike.good)),spike.ph(find(spike.good)),spike.ind(find(spike.good)),run,overwrite,0,'xcorrWidthPhM',EegRate,SampleRate,[],[],max(spike.ind),whl.speed(:,1),whl.rate);
    
    end
    %%%%%%%%%%%%%%%%
    %% WHEEL
    if ~isfield(info,'Wheel')
      info.Wheel = input('is there wheel running? ');
      save([FileBase '.info'],'info')
    end
    if info.Wheel
      run = wheel.runs;
      FileOut = '.spectW';
      %overwrite = 1;
      SVMUSpect
      ALL(f).spectW = dspect;
      overwrite = 0;
      
      %% Phase Spect
      fprintf('... phase spect ...\n');
      FileOut = '.spectPhW';
      ALL(f).spectPhW = SVMUspectPh(FileBase,spike,run,PrintBase,[],[],overwrite,[],[],FileOut,EegRate,SampleRate);

      %overwrite=1;
      ALL(f).xcorrlW = SVMUccgWidth(FileBase,spike.t(find(spike.good)),spike.ind(find(spike.good)),run,overwrite,0,'xcorrWidthW',EegRate,SampleRate,[],[],max(spike.ind),wheel.speed(:,1),wheel.whlrate);
      %overwrite=0;
      %ALL(f).xcorrlPhW = SVMUccgWidthPh(FileBase,spike.t(find(spike.good)),spike.ph(find(spike.good)),spike.ind(find(spike.good)),run,overwrite,0,'xcorrWidthPhW',EegRate,SampleRate,[],[],max(spike.ind),whl.speed(:,1),whl.rate);
      
      %% Phase Hist
      indx = find(spike.good & WithinRanges(spike.t/SampleRate*wheel.whlrate,run));
      PhH = myPhaseOfTrain(spike.ph(indx),spike.ind(indx),[],[],[],[],max(spike.ind));
      for n=1:size(PhH.phhist,2)
	PhH.sphhist(:,n) = smooth(PhH.phhist(:,n),5,'lowess');
      end
      %save([FileBase '.phasestat'],'PhH')
      %dummy = load([FileBase '.phasestat'],'-MAT');
      ALL(f).PhH = PhH;
      clear PhH indx;
    end
        
    %overwrite = 0;
  end
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% MUA
  MUA = 0 ;
  if MUA
    overwrite = 1;
 
    fprintf('... mua ...\n');
    %% get mua rate of CA1
    run = load([FileBase '.sts.RUN']);
    muarun = run;
    allPC = find(ALL(f).type.num==2 & ALL(f).cells.region==1);
    mua = SVMUmua(FileBase,Eeg,spike.t,spike.ind,run,allPC,overwrite);
    mua = SVMUmuMore(FileBase,mua);
    
    ALL(f).mua = mua;
    %% get mua rate of CA3
    allPC = find(ALL(f).type.num==2 & ALL(f).cells.region==2);
    if ~isempty(allPC)
      fprintf('... mua ca3 ...\n');
      mua3 = SVMUmua(FileBase,Eeg,spike.t,spike.ind,run,allPC,overwrite,[],'.muarateCA3');
      mua3 = SVMUmuMore(FileBase,mua3);
    end
    
    overwrite = 0;
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  COMPRESS = 1;
  if COMPRESS & ~isempty(find(states.ind==2 | states.ind==23)) & f<31
    
    runitv = trial(1).itv;
    run = round(runitv/whl.rate*EegRate);
    ix = find(spike.good);
    C = SVMUCompFact(FileBase,round(spike.t(ix)/SampleRate*EegRate),spike.ind(ix),spike.pos(ix),run,0,trial(1).dir,find(ALL(f).spect.good & ALL(f).type.num'==2));
    
    if FileExists([FileBase '.seqcompr'])
    
      load([FileBase '.seqcompr'],'-MAT')
      ALL(f).compr = compr;
      
      if f>16 & f<=30
	Clu = ALL(f).cells.clu;
	A = zeros(max(Clu));
	A(sub2ind(max(Clu),Clu(:,1),Clu(:,2))) = [1:length(Clu)];
	C1 = A(sub2ind(max(Clu),ALL(f).compr.shank1,ALL(f).compr.clu1));
	C2 = A(sub2ind(max(Clu),ALL(f).compr.shank2,ALL(f).compr.clu2));
	gC = C1>0 & C2>0;
	FF = zeros([length(ALL(f).spectM.f) length(C1)]);
	FF(:,find(gC)) = ALL(f).spectM.spunit(:,C1(gC)).*ALL(f).spectM.spunit(:,C2(gC));
	gf = find(ALL(f).spectM.f>6 & ALL(f).spectM.f<12);
	[mm mi] = max(FF(gf,:));
	ALL(f).compr.fpair = ALL(f).spectM.f(gf(mi));
	ALL(f).compr.feeg = repmat(ALL(f).spectM.feeg,1,length(C1));
	ALL(f).compr.cellids = [C1; C2];
      
	clear Clu A C1 C2 gC FF gf
      end
      
      if f<=16
	%% Wheel
	C1 = compr.Tclu1;
	C2 = compr.Tclu2;
	FF = ALL(f).spectW.spunit(:,find(ALL(f).spect.good));
	gf = find(ALL(f).spectW.f>6 & ALL(f).spectW.f<12);
	[mm mi] = max(FF(gf,:));
	ALL(f).compr.Wfpair = repmat(mean(ALL(f).spectW.f(gf(mi))),1,length(C1));
	ALL(f).compr.Wfeeg = repmat(ALL(f).spectW.feeg,1,length(C1));
	ALL(f).compr.Wcellids = [C1; C2];
	
	%% Maze
	ALL(f).compr.Mtheta = C.Sdt;
	ALL(f).compr.Mrunt = C.Ldt;
	ALL(f).compr.Mdist = C.Pdt;
	C1 = C.Ppair(:,1);
	C2 = C.Ppair(:,2);
	FF = ALL(f).spectM.spunit(:,C1).*ALL(f).spectM.spunit(:,C2);
	gf = find(ALL(f).spectM.f>6 & ALL(f).spectM.f<12);
	[mm mi] = max(FF(gf,:));
	ALL(f).compr.Mfpair = ALL(f).spectM.f(gf(mi));
	ALL(f).compr.Mfeeg = repmat(ALL(f).spectM.feeg,1,length(C1));
	ALL(f).compr.Mcellids = [C1; C2];
      end
    elseif FileExists([FileBase 'compfact']) & ismember(f,[2 3 10 14])% f<4
      %runitv = trial(1).itv;
      %run = round(runitv/whl.rate*EegRate);
      %C = SVMUCompFact(FileBase,spike.t,spike.ind,spike.pos,run);
      load([FileBase 'compfact'],'-MAT');
      ALL(f).compr = C;
    end
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  CHECK = 0;
  if CHECK
    %% check lengths of structs - some cells missing??
    fprintf('Clu file cells PhH type NQ\n');
    L(f,1) = length(spike.clu);
    L(f,2) = length(ALL(f).file);
    L(f,3) = length(ALL(f).cells.region);
    L(f,4) = length(ALL(f).PhH.Clu);
    L(f,5) = length(ALL(f).type.num);
    L(f,6) = length(ALL(f).NQ.eDist)
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Plot for individual files
  %CatAll = ALL(f);
  %SVMUPlotPhase(FileBase,CatAll)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% save strct for ravana
  %save([FileBase '.rav.mat'],'spike')

  
  %WaitForButtonpress
  CALL = ALL(f);
  save(fname,'CALL')
  clear CALL
  end
end
  
  
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cat Struct
%CatAll = CatStruct(ALL);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% identify interneurons and pyramidal cells overall
%newpcin = CheckPCIN(CatAll,overwrite,'SVMUnewPCIN.mat');
%CatAll.type.num = newpcin;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT
% Fig 1a: PlotIntroSfN08
% Fig 1b: CatAll = CatStruct(ALL);
%         SVMUPlotPhase('2006-6-13_15-22-3/2006-6-13_15-22-3',CatAll)
% Fig 2:  SVMUPlotSpectExpl(ALL)
% Fig 3:  SVMUPlotSpect_small(CatAll,ALL)
% Fig 4:  SVMUPlotMua(ALL(23))
% Fig 5:  OscilModelOpt
% Fig 6:  OscilModelExpl
% Fig 7:  SVMUPlotSpectExplGrp(ALL)
% Fig 8:  OscilModelExplDV

% Fig ?:  SVMUPlotScatchFun


%% PLOT NEW:
% Fig 1:  PlotIntroSfN08
% Fig 2:  SVMUPlotSpectExpl(ALL) - 2nd half
% Fig 3:  SVMUPlotMua(ALL(23))
% Fig 4:  OscilModelOpt2
% Fig 5:  OscilModelExpl
% Fig 6:  SVMUPlotSpectExplGrp(ALL)
% Fig 7:  OscilModelExplDV

% Fig S1: CatAll = CatStruct(ALL);
%         SVMUPlotPhase('2006-6-13_15-22-3/2006-6-13_15-22-3',CatAll)
% Fig S2: SVMUPlotSpectExpl(ALL) - 1st half
% Fig S3: SVMUPlotSpect_small(CatAll,ALL)
% Fig S4: OscilModelOpt2
% Fig S5: OscilModelOpt2
% Fig S6: OscilModelOpt180
% Fig S7: OscilModeOptSparse
% Fig S7b SVMUPlotMua6
% Fig S8: OscilModeSparse_jitt






return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Overall cell identifiction
Good = find(CatAll.cells.good); 
mrksize = CatAll.NQ.eDist(Good);

colors = colormap;
cc = colors(round(linspace(1,64,10))',:);
mrkcol = cc(CatAll.type.act(Good)+1,:);

celltype = zeros(size(mrksize));
celltype(strcmp(CatAll.type.type(Good),'w'))=1;
celltype(strcmp(CatAll.type.type(Good),'n'))=2;

marker = ['*' '+' 'o'];
mrktype = marker(celltype+1);

AA = CatAll.NQ.SpkWidthR(Good);
BB = CatAll.NQ.AmpSym(Good);
CC = CatAll.NQ.FirRate(Good);

int = find(celltype==2);
pc = find(celltype==1);

figure(7845)
for n=[1 2]
  m = find(celltype==n);
  scatter(AA(m),BB(m),mrksize(m)+1,mrkcol(m),marker(n+1))
  hold on
end
hold off



%% check number of entries in structures
for n=1:60
  FileBase = [list{n} '/' list{n}];

  proj = IsProject(FileBase,'SVMU',overwrite);
  if ~proj; continue; end

  K(n,1) = length(ALL(n).cells.clu);
  K(n,2) = length(ALL(n).NQ.eDist);
  K(n,3) = length(ALL(n).type.cell);
  K(n,4) = length(ALL(n).PhH.Clu);
  K(n,5) = length(ALL(n).PhH.pval);
  K(n,6) = length(ALL(n).cells.region);
  K(n,7) = length(ALL(n).type.num);
end


%% print filenames
%% check number of entries in structures
filelist ={'listEva.txt' 'listKamran.txt' 'listKenji.txt' 'listSebi.txt'};
%           [1:16]        [17:30]          [31:??]         [??:??] 
list = [];
for n=1:length(filelist)
  list = [list; LoadStringArray(filelist{n})];
end

file = [1:60];

if isempty(file);
  file = [1:length(list)];
end
for n=1:60
  FileBase = [list{n} '/' list{n}];

  proj = IsProject(FileBase,'SVMU');
  if ~proj; continue; end

  fprintf('FILE %d: %s\n',n,list{n});

end







  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% COMPUTE
  if compute
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CCGs
    %xcorrl = SVMUccg(FileBase,Eeg,spike,run,overwrite);
    %[overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,'.xcorr',1250,20000});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% compression index
    %spikelpos = wheel.dist(round(spike.t/SampleRate*EegRate))/10;
    %% assume 10 count = 1 cm: spikepos is in cm
    %run1 = run(find(wheel.dir==1),:);
    %ALL(f).compr1 = SVMUCompFact(FileBase,round(spike.t/SampleRate*EegRate),spike.ind,spikelpos,run1,overwrite,[],find(ctype.num==2));overwrite = 1;
    %run2 = run(find(wheel.dir==2),:);
    %ALL(f).compr2 = SVMUCompFact(FileBase,round(spike.t/SampleRate*EegRate),spike.ind,spikelpos,run2,overwrite,[],find(ctype.num==2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% MUA Rate
    mua = SVMUmua(FileBase,Eeg,spike,run,PrintBase,find(ctype.num==2),overwrite);
    %[gcells,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],0,0,'.muarate',1250,20000});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Coherence measure - in time
    %cohe = SVMUspectL(FileBase,spike,run,mua,PrintBase,find(ctype.num==2),overwrite,1);
    %[gcells,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,0,'.coherence',1250,20000});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CCGs
    %xcorrlPh = SVMUccgPh(FileBase,spike.t,spike.ind,run,GoodPC,GoodIN,overwrite);
    %[overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,'.xcorr',1250,20000});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% collap trials into one
    %acohe = SVMUmuaAv(FileBase,Eeg,spike,run,find(ctype.num==2),overwrite,1,'.acoherence');
    %[gcells,overwrite,PLOT,OutFile,PrintBase,PRINTFIG,EegRate,SampleRate] = DefaultArgs(varargin,{[],1,0,'.acoherence','Out',0,1250,20000});
    
  end
    
    ALL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,[],[],overwrite,0,[],[],EegRate,SampleRate);
    %[GoodSP GoodSPA] = GoodSpect(ALL(f).spect.spunit,ALL(f).spect.f,ones(size(spike.clu(:,1))));
    [GoodSP GoodSPA] = GoodSpect(ALL(f).spect.spunit,ALL(f).spect.f,[],[],[],[],ALL(f).type.num);
    
    allPC = find(ALL(f).type.num==2 & ALL(f).cells.region<3);
    ALL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodSP{2},GoodSP{1},overwrite,1,[],[],EegRate,SampleRate,allPC,[],0);
    
    ALL(f).spect.good = GoodSPA>1;
    ALL(f).spect.feega = repmat(ALL(f).spect.feeg,size(ALL(f).cells.clu,1),1);
    
    %% x-corr between eeg and cells
    fprintf('... xcorr ...\n');
    gf = find(ALL(f).spect.f>2 & ALL(f).spect.f<14);
    ALL(f).spect.xcorr=[];
    for n=1:size(ALL(f).spect.spunit,2)
      %[ALL(f).spect.xcorr(:,n),lags] = xcorr(ALL(f).spect.spunit(gf,n),ALL(f).spect.speeg(gf),'unbiased');
      [ALL(f).spect.xcorr(:,n),lags] = xcorr(ALL(f).spect.spunit(gf,n),ALL(f).spect.speeg(gf));
    end
    ALL(f).spect.xct = lags*mean(diff(ALL(f).spect.f));
    
