%% Script to compute all figures for paper SVMUTheta

overwrite = 0;
compute = 0;
compute2 = 0;
PLOT = 0;
PRINTFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filelist ={'listSebi.txt'};

list = [];
for n=1:length(filelist)
  list = [list; LoadStringArray(filelist{n})];
end

file = [];

if isempty(file);
  file = [1:length(list)];
end
RtAll = [];PCAll = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOOP THROUGH FILES
%%
for f=file
  
  FileBase = [list{f} '/' list{f}];
  PrintBase = [list{f} '/Figs/' list{f}];
  
  fprintf('=========================\n');
  fprintf('FILE %d: %s\n',f,list{f});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Use this file?
  %%
  proj = IsProject(FileBase,'DorsalVentral',overwrite);
  if ~proj; continue; end
  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% File Info
  %%
  %whl = load([FileBase '.whl']);
  %figure(32)
  %plot(whl(:,1),whl(:,2),'.')
  %
  info = FileInfo(FileBase,overwrite);
  info
  SampleRate = info.SampleRate;
  EegRate = info.EegRate;
  WhlRate = info.WhlRate;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Electrode selection
  %%
  
  %[spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,[],WhlRate,1,SampleRate);
  %figure(1);clf
  %h=histcI(spike.clu(:,1),[0.5:1:max(spike.clu(:,1))+0.5]);
  %bar(h);
  %figure(2);clf
  %for m=1:max(spike.clu(:,1))
  %gc = find(spike.clu(:,1)==m);
  %for n=1:length(gc)
  %  [ccg t] = CCG(spike.t(spike.ind==gc(n)),1,50,60,32552);
  %  xccg(:,n) = ccg;
  %  subplotfit(n,length(gc))
  %  bar(t,ccg)
  %  axis tight
  %end
  %go = input('press');
  %end
  %elc
  
  elc = InternElc(FileBase,overwrite);
  elc = ElcRegion(FileBase,overwrite);
  elc.animal = FileBase;
  elc
  %elc.theta2 = input('ventral theta: ');
  %save([FileBase '.elc'],'elc');
  %go = input('press');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% State selection
  %% 
  %states = GetStates(FileBase,[],overwrite)
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% load position file (.whl)
  
  %% ACHTUNG  - ONLY FOR 1250/20000
  %% HAS TO BE CORRECTED!!!!! 
  
  %whl = GetWhl(FileBase); 
  %WhlCtr = whl.ctr;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Trials on maze
  %if ~isempty(find(states.ind==2))
  %  itv = round(states.itv/states.rate*WhlRate);
  %  itv(1,1) = 1;
  %  trial = GetTrials(FileBase,whl,overwrite,[],itv);
  %end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Wheel data
  %if info.Wheel
  %  wheel = GetWheelEva(FileBase,WhlCtr,overwrite,[],state.itv);
  %end
  
  % GoodPeriods{1} = run;
  % GoodPeriods{2} = trials.itv;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Eeg 
  %Eeg = GetEEG(FileBase);
  
  
  if compute2
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% get the spikes!
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,[],WhlRate,1,SampleRate);
  spike = FindGoodTheta(FileBase,spike);
  goodsp = find(spike.good);
  [spike.ph spike.uph] = SpikePhaseAdapt(FileBase,spike.t,SampleRate,EegRate);
  
  %% give file label to each neuron
  ALL(f).file = repmat(f,size(spike.clu,1),1);
   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% select neurons in CA1 and CA3
  ALL(f).cells.clu = spike.clu;
  regions = unique(elc.region);
  for n=regions
    idx = find(ismember(spike.clu(:,1),find(elc.region==n)));
    if isempty(idx); continue; end
    ALL(f).cells.region(idx,1) = n;
  end
  ALL(f).cells.good = ismember(spike.clu(:,1),find(elc.region==1 | elc.region==2));
  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% classify neurons
  if  ~FileExists([FileBase '.NeuronQuality.mat']) | overwrite
    NeuronQuality(FileBase,[],[],[],overwrite);
  end
  if  ~FileExists([FileBase '.s2s']) | overwrite
    mySpike2Spike(FileBase,overwrite);
  end
  %% classify all neurons -- otherwise demension missmatch 
  
  %if compute2
    
  Elc = find(elc.region);
  [ctype cmono] = CellTypes(FileBase,overwrite,Elc);
  AA = load([FileBase '.NeuronQuality.mat'],'-MAT');
  ALL(f).NQ = CatStruct(AA.OutArgs);
  clear AA;
  %% 
  ElName='';
  for k=1:length(Elc)
    ElName=[ElName '_' num2str(Elc(k))];
  end
  ElName(1)='';
  [ALL(f).type.elec ALL(f).type.cell ALL(f).type.type ALL(f).type.act]  = textread([FileBase '.type-' ElName],'%d%d%s%d');
  %% transform ALL(f).type.type into numbers
  u = {'n' 'w' 'x'};
  for n=1:length(u)
    m = find(strcmp(ALL(f).type.type,u{n}));
    if isempty(m); continue; end
    ALL(f).type.num(m,1) = n;
  end
  
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% prefered theta phase - overall
  if ~FileExists([FileBase '.phasestat']) | overwrite
    
    indx = find(spike.good);
    PhH = myPhaseOfTrain(spike.ph(indx),spike.ind(indx),[],[],[],[],max(spike.ind));
    
    save([FileBase '.phasestat'],'PhH')
  end
  dummy = load([FileBase '.phasestat'],'-MAT');
  PhH = CatStruct(dummy.PhH);
  clear dummy;
  ALL(f).PhH = PhH;
  %%PlotSfN08Phase
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% spectra
  goodPC = [];%find(ALL(f).type.num==2);
  goodIN = [];%find(ALL(f).type.num==1);
  run = load([FileBase '.sts.RUN']);
    if run(1,1)<1
    run(1,1)=1;
    msave([FileBase '.sts.RUN'],run);
  end
  if run(end,2)>length(Eeg)
    run(end,2)=length(Eeg)
    msave([FileBase '.sts.RUN'],run);
  end

  SL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,goodPC,goodIN,0,1,[],[],EegRate,SampleRate);
                % [goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] 
		% = DefaultArgs(varargin,{[],[],0,0,0,'.spect',1250,20000});
  ALL(f).spect = SL(f).spect;
  

  GoodSP = GoodSpect(SL(f).spect.spunit,SL(f).spect.f,ctype.num);
  ALL(f).spect.good = zeros(max(spike.ind),1);
  for n=1:length(GoodSP)
    ALL(f).spect.good(GoodSP{n}) = 1;
  end
  ALL(f).spect.feega = repmat(ALL(f).spect.feeg,size(ALL(f).cells.clu,1),1);
  
  
  %% x-corr between eeg and cells
  for n=1:size(ALL(f).spect.spunit,2)
    [ALL(f).spect.xcorr(:,n),lags] = xcorr(ALL(f).spect.spunit(:,n),ALL(f).spect.speeg,'unbiased');
  end
    
  %% Phase Spect
  
  %SL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodSP{2},GoodSP{1},overwrite,1,PRINTFIG,[],EegRate,SampleRate);
  ALL(f).spectPh = SVMUspectPh(FileBase,spike,run,PrintBase,goodPC,goodIN,[],1,[],[],EegRate,SampleRate);
   
  
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% COMPUTE
  if compute
    
    %% do computation of relative! ccg and spectra on maze and wheel running
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CCGs
    xcorrl = SVMUccg(FileBase,Eeg,spike,run,overwrite);
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
    
    %WaitForButtonpress
  end
  
  %L(f,1) = length(spike.clu)
  %L(f,2) = length(ALL(f).NQ.eDist)
  %L(f,3) = length(ALL(f).type.cell)
  
  %CatAll = ALL(f);
  %SVMUPlotPhase(FileBase,CatAll)
  %WaitForButtonpress
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% group computation


%% identify interneurons and pyramidal cells

%CatAll = CatStruct(ALL);
%SVMUPlotPhase(FileBase,CatAll)
%DVPlotSpect(CatAll)

return;





for n=1:size(CatAll.spect.spunit,2)
  m = CatAll.file(n);
  %[CatAll.spect.xcorr(:,n),lags] = xcorr(CatAll.spect.spunit(:,n),CatAll.spect.speeg(:,m),'none');
  [CatAll.spect.xcorr(:,n),lags] = xcorr(CatAll.spect.spunit(:,n),CatAll.spect.speeg(:,m),'unbiased');
end


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
for n=1:13
  %FileBase = [list{n} '/' list{n}];
  %proj = IsProject(FileBase,'SVMU',overwrite);
  %if ~proj; continue; end

  K(n,1) = length(ALL(n).cells.clu);
  K(n,2) = length(ALL(n).NQ.eDist);
  K(n,3) = length(ALL(n).type.cell);
  K(n,4) = length(ALL(n).PhH.Clu);
end
