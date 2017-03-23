function elc = FindThetaChan(FileBase,ElcGrp,overwrite)

%keyboard


Par = LoadPar(FileBase);
[xspiket, xspikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);

%% hist of number of cells per shank
figure(887);clf;
bin = [0.5:1:Par.nElecGps+0.5];
pbin = [1:Par.nElecGps];
hh = histcI(ClustByEl(:,1),bin);
bar(pbin,hh)

%% selected shank with most cells
chanlca1 = ElcGrp;
[mm1 mm2] = max(hh(chanlca1));
gshank = chanlca1(mm2)

Lines(gshank);

%% ripple triggered lfp of good shank
elc = InternElc(FileBase);
nRips = DetectRipples(FileBase,elc.rip,[],[],[],0);
chn = Par.SpkGrps(gshank).Channels+1;
Rips = nRips(find(nRips(:,1)>300 & nRips(:,1)<FileLength([FileBase '.eeg'])/2/Par.nChannels-300),:);
epochs = [Rips(:,1)-300 Rips(:,1)+300];
[Data OrigIndex]= LoadBinary([FileBase '.eeg'],chn,Par.nChannels,[],[],[], epochs);

mData = mean(reshape(Data,size(Data,1),601,length(Rips)),3);
t = [-300:300]/Par.lfpSampleRate*1000;

figure(888);clf;
flip = [size(mData,1):-1:1];
h=PlotTraces(mData(flip,:),t);
Lines(0);
axis off

updown = [1 size(mData,1)];
[mx mi] = max(mData(updown,301));
set(h(flip(updown(mi))),'color','r')

top = input('is that right [1/0]? ');

if top
  elc = Par.SpkGrps(gshank).Channels(updown(mi))+1
else
  elc = Par.SpkGrps(gshank).Channels(flip(updown(mi)))+1
  set(h(flip(updown(mi))),'color','k')
  set(h((updown(mi))),'color','r')
end
  
  
return;