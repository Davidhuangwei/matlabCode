function PhasePresMD(FileBase)
%% 
%% get thetaphase pf spiketime
%% 
%% in: 
%%    nchan = tot num of eeg channel
%%    chan  = eeg channel to take phase from 
%%    skp   = spike times of neuron
%%
%% out: 
%%    spkph = vector of theat phases, sema length as spkph 
%%
%%
%%


fprintf('read in whl data...');
whl = load(['/data2/' FileBase '/video+events/' FileBase '.whl']);

WHL(:,1) = (whl(:,1)+whl(:,3))/2;
WHL(:,2) = (whl(:,2)+whl(:,4))/2;

WHL(:,3) = sign(whl(:,1)-whl(:,3));

xmin = 80;
xmax = 250;

ydif = 140;

Els = [1:4];

fprintf('read in eeg data...');
Eeg = readmulti([FileBase '.eeg'], 33, 4);

fprintf('calculating phase...');
[ThPhase ThAmp TotPhase] = ThetaPhase(Eeg,[4 10],4,20,1250);

fprintf('read in spike data...');
[spiket, spikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,Els);

fprintf('make figure... (click for next figure)');

cfigure;

for i = 1:max(spikeind)
  
  i
  
  spkt = spiket(find(spikeind==i));
  
  goodi = round(spkt/512);
  goodi(find(goodi==0))=1;
  goodi(find(goodi>length(WHL)))=WHL(end);
  
  spkpos = WHL(goodi,:);
  spkph = ThPhase(round(spkt/16))*180/pi +180; %% just to lift it into positive angles!
  
  goodpos11 = find(spkpos(:,1)>0 & spkpos(:,1)>xmin & spkpos(:,1)<xmax & spkpos(:,2)>ydif & spkpos(:,3)<0);
  goodpos12 = find(spkpos(:,1)>0 & spkpos(:,1)>xmin & spkpos(:,1)<xmax & spkpos(:,2)>ydif & spkpos(:,3)>0);

  goodpos21 = find(spkpos(:,1)>0 & spkpos(:,1)>xmin & spkpos(:,1)<xmax & spkpos(:,2)<ydif & spkpos(:,3)<0);
  goodpos22 = find(spkpos(:,1)>0 & spkpos(:,1)>xmin & spkpos(:,1)<xmax & spkpos(:,2)<ydif & spkpos(:,3)>0);

  clf;
  
  subplot(2,2,1)
  plot(spkpos(goodpos11,1),spkph(goodpos11,1),'b.',spkpos(goodpos11,1),spkph(goodpos11,1)+360,'b.',spkpos(goodpos11,1),spkph(goodpos11,1)+720,'b.')
  title([num2str(i) '/' num2str(max(spikeind))]);
  subplot(2,2,2)
  plot(spkpos(goodpos12,1),spkph(goodpos12,1),'b.',spkpos(goodpos12,1),spkph(goodpos12,1)+360,'b.',spkpos(goodpos12,1),spkph(goodpos12,1)+720,'b.')
  subplot(2,2,3)
  plot(spkpos(goodpos21,1),spkph(goodpos21,1),'b.',spkpos(goodpos21,1),spkph(goodpos21,1)+360,'b.',spkpos(goodpos21,1),spkph(goodpos21,1)+720,'b.')
  subplot(2,2,4)
  plot(spkpos(goodpos22,1),spkph(goodpos22,1),'b.',spkpos(goodpos22,1),spkph(goodpos22,1)+360,'b.',spkpos(goodpos22,1),spkph(goodpos22,1)+720,'b.')
  
  waitforbuttonpress;
  
end


