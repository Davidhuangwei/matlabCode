overwrite = 0;
compute = 0;
compute2 = 0;
PLOT = 0;
PRINTFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%filelist ={'listEva.txt' 'listKamran.txt' 'listKenji.txt' 'listSebi.txt'};
filelist ={'listKamran.txt'};

list = [];
for n=1:length(filelist)
  list = [list; LoadStringArray(filelist{n})];
end

file = [];
%file = [2];

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
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  proj = IsProject(FileBase,'SVMU',overwrite);
  if ~proj; continue; end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Electrode selection
  %%
  elc = InternElc(FileBase,overwrite);
  elc
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% load Par  
  Par = LoadPar(FileBase);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% File Info
  %%
  info = FileInfo(FileBase,overwrite);
  info
  SampleRate = info.SampleRate;
  EegRate = info.EegRate;
  WhlRate = info.WhlRate;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% get the spikes!
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,[],WhlRate,1,SampleRate);
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% mark selected theta channel
  for n=1:length(Par.SpkGrps)
    k = Par.SpkGrps(n).Channels+1;
    if ~isempty(find(k==elc.theta))
      fprintf(['\n elc.theta ' num2str(n) '\n\n'])
      chan = n;
    end
  end
  figure(34785);clf;
  bin = [0.5:1:max(spike.clu(:,1))+0.5];
  pbin = [1:max(spike.clu(:,1))];
  h = histcI(spike.clu(:,1),bin);
  bar(pbin,h)
  Lines(chan);  
  
  %% chank with most cells
  chanlca1 = find(elc.region==1);
  [mm1 mm2] = max(h(chanlca1));
  maxcount = chanlca1(mm2)
  
  %% take first channel for theta detection
  thetchan = Par.SpkGrps(maxcount).Channels(1)+1
  elc.theta = thetchan;
  save([FileBase '.elc'],'elc');
    
  elc
  
  %% detect ripples
  Rips = DetectRipples(FileBase,elc.rip,[],[],[],0);
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% spike phase and good spikes
  Eeg = LoadBinary([FileBase '.eeg'],elc.theta,Par.nChannels);
  [Phase.deg Phase.amp] = myThetaPhase(Eeg,[4 10],4,20,EegRate);
  spike.ph = mod(Phase.deg(round(spike.t/SampleRate*EegRate)),2*pi);
  
  spike = FindGoodTheta(FileBase,spike);
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% prefered theta phase - overall
  %%
  if ~FileExists([FileBase '.phasestat']) | 1%overwrite
    indx = find(spike.good);
    PhH = myPhaseOfTrain(spike.ph(indx),spike.ind(indx),[],[],[],[],max(spike.ind));
    save([FileBase '.phasestat'],'PhH')
  end
  dummy = load([FileBase '.phasestat'],'-MAT');
  PhH = CatStruct(dummy.PhH); clear dummy;
  ALL(f).PhH = PhH;

  
  dummy = load([FileBase '.phasestat'],'-MAT');
  PhH = CatStruct(dummy.PhH); clear dummy;

  %% cell type
  Elc = find(elc.region);
  [ctype cmono] = CellTypes(FileBase,overwrite,Elc);
  ElName='';
  for k=1:length(Elc)
    ElName=[ElName '_' num2str(Elc(k))];
  end
  ElName(1)='';
  [ALL(f).type.elec ALL(f).type.cell ALL(f).type.type ALL(f).type.act]  = textread([FileBase '.type-' ElName],'%d%d%s%d');
  %% transform ALL(f).type.type into numbers
  u = {'n' 'w' 'x'};
  ALL(f).type.num = [];
  for n=1:length(u)
    m = find(strcmp(ALL(f).type.type,u{n}));
    if isempty(m); continue; end
    ALL(f).type.num(m,1) = n;
  end

  for n=1:size(PhH.phhist,2)
    SHH(:,n) = smooth(PhH.phhist(:,n),5,'lowess');
  end

  ca1 = spike.clu(:,1)>8;
  pc = ALL(f).type.num==2;
  good = PhH.pval<0.05;
  
  
  figure(34787);clf
  subplot(211)
  imagesc((PhH.phbin(:,1))*180/pi,[],unity(SHH(:,ca1&pc&good))')
  Lines(circmean(PhH.th0(ca1&pc&good))*180/pi);
  axis xy
  subplot(212)
  imagesc((PhH.phbin(:,1))*180/pi,[],unity(SHH(:,~ca1&pc&good))')
  Lines(circmean(PhH.th0(~ca1&pc&good))*180/pi);
  axis xy
  
  go = input('go');


  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Phase relationship between channels
  %%
  %for n=1:4
  %  for m=1:4
  %    find CA1 channels
  %    
  %    find one good CA3 channel
  %    
  %    compute crosscorrelogram between channels
  %  end
  %end
  
  
  %EegR = LoadBinary([FileBase '.eeg'],elc.theta,Par.nChannels,[],[],[],epochs);
  
  %for n=1:length
  %end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end
