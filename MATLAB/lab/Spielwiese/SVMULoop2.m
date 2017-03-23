overwrite = 0;
compute = 0;
compute2 = 0;
PLOT = 0;
PRINTFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filelist ={'listEva.txt' 'listKamran.txt' 'listKenji.txt' 'listSebi.txt'};
%filelist ={'listKamran.txt'};

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
  elc;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% File Info
  %%
  info = FileInfo(FileBase,overwrite);
  info;
  SampleRate = info.SampleRate;
  EegRate = info.EegRate;
  WhlRate = info.WhlRate;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% load Par  
  %Par = LoadPar(FileBase);

  if FileExists([FileBase '.spect'])
    fprintf([FileBase '.spect\n'])
  end
  if FileExists([FileBase '.spectPh'])
    fprintf([FileBase '.spectPh\n'])
  end
  
  
  if 0
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% detect ripples and plot ripple profile of chank with most neurons
  Rips = DetectRipples(FileBase,elc.rip,[],[],[],0);
    
  %% get ca1 shank with most cells
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,[],WhlRate,1,SampleRate);
  
  for n=1:length(Par.SpkGrps)
    k = Par.SpkGrps(n).Channels+1;
    if ~isempty(find(k==elc.theta))
      %fprintf(['\n elc.theta ' num2str(n) '\n\n'])
      chan = n;
    end
  end
  %% chank with most cells
  chanlca1 = find(elc.region==1);
  [mm1 mm2] = max(h(chanlca1));
  gshank = chanlca1(mm2)
  
  %% ripple triggered lfp of good shank
  chn = Par.SpkGrps(gshank).Channels+1;
  epochs = [Rips(:,1)-300 Rips(:,1)+300];
  [Data OrigIndex]= LoadBinary([FileBase '.eeg'],chn,Par.nChannels,[],[],[], epochs);
  
  mData = mean(reshape(Data,8,601,length(Rips)),3);
  t = [-300:300]/EegRate*1000;
  
  PlotTraces(mData,t);
  
  end
  
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end
