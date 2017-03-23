function ComputeList(ListFile)
%% Script to compute all figures for paper SVMUTheta

overwrite = 0;
compute = 0;
compute2 = 0;
PLOT = 0;
PRINTFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filelist ={'listEva.txt' 'listKamran.txt' 'listKenji.txt' 'listSebi.txt'};

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
  proj = IsProject(FileBase,'SVMU',overwrite);
  if ~proj; continue; end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% File Info
  %%
  info = FileInfo(FileBase,overwrite);
  info
  SampleRate = info.SampleRate;
  EegRate = info.EegRate;
  WhlRate = info.WhlRate;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Electrode selection
  %%
  elc = InternElc(FileBase,overwrite);
  elc = ElcRegion(FileBase,overwrite);
  elc.animal = FileBase;
  elc
  save([FileBase '.elc'],'elc');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% State selection
  %% 
  %states = GetStates(FileBase,[],overwrite)
  

  
  
  if compute2
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% load position file (.whl)
  
  %% ACHTUNG  - ONLY FOR 1250/20000
  %% HAS TO BE CORRECTED!!!!! 
  
  whl = GetWhl(FileBase); 
  WhlCtr = whl.ctr;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Trials on maze
  if ~isempty(find(states.ind==2))
    itv = round(states.itv/states.rate*WhlRate);
    itv(1,1) = 1;
    trial = GetTrials(FileBase,whl,overwrite,[],itv);
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Wheel data
  if info.Wheel
    wheel = GetWheelEva(FileBase,WhlCtr,overwrite,[],state.itv);
  end
  
  % GoodPeriods{1} = run;
  % GoodPeriods{2} = trials.itv;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Eeg 
  %Eeg = GetEEG(FileBase);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% get the spikes!
  end
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,[],WhlRate,1,SampleRate);
  %spike = FindGoodTheta(FileBase,spike);
  %goodsp = find(spike.good);
  %[spike.ph spike.uph] = SpikePhaseAdapt(FileBase,spike.t,SampleRate,EegRate);
  
  %% give file label to each neuron
  %ALL(f).file = repmat(f,size(spike.clu,1),1);
   
  if compute2
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
    %% compute the spectra
    GoodPC = xcorrl.goodPC(ismember(xcorrl.goodPC,HCcells));
    GoodIN = xcorrl.goodIN(ismember(xcorrl.goodIN,HCcells));
    SL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodPC,GoodIN,overwrite,1,[],[],[],[],find(ctype.num==2),unique([GoodPC GoodIN]));
    %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],[],0,0,0,'.spect',1250,20000});
    
    GoodSP = GoodSpect(SL(f).spect.spunit,SL(f).spect.f,ctype.num);
    SL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodSP{2},GoodSP{1},overwrite,1,PRINTFIG,[],[],[],find(ctype.num==2),unique([GoodSP{2} GoodSP{1}]));
    
    %SL(f).spectPh = SVMUspectPh(FileBase,spike,run,PrintBase,GoodSP{2},GoodSP{1},overwrite,1,[],[],[],[],find(ctype.num==2),unique([GoodSP{2} GoodSP{1}]));
    SL(f).spectPh = SVMUspectPh(FileBase,spike,run,PrintBase,GoodPC,GoodIN,overwrite,1,[],[],[],[],find(ctype.num==2),unique([GoodPC GoodIN]));
    
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


return;



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
for n=1:27
  FileBase = [list{n} '/' list{n}];

  proj = IsProject(FileBase,'SVMU',overwrite);
  if ~proj; continue; end

  K(n,1) = length(ALL(n).cells.clu);
  K(n,2) = length(ALL(n).NQ.eDist);
  K(n,3) = length(ALL(n).type.cell);
  K(n,4) = length(ALL(n).PhH.Clu);
end
