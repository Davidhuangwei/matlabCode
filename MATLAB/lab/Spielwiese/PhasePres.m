function [spkph]=PhasePres(FileBase,nchan,chan,spiket)
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

%% read in eeg:
Eeg = readmulti([FileBase '.eeg'], nchan, chan);

%% get phase
[ThPhase ThAmp TotPhase] = ThetaPhase(Eeg,[4 10],4,20,1250);

%% get phase times
spkph = ThPhase(round(spkt/16));

%% plot
plot(spkt/20000,spkph,'.')


return;

Eeg = readmulti([FileBase '.eeg'], 33, 4);
[ThPhase ThAmp TotPhase] = ThetaPhase(Eeg,[4 10],4,20,1250);

[xspiket, xspikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,Els);

%% Rat = [time angle direction radius speed]
Pos(:,:) = Rat(:,:);

Pos(:,1) = Pos(:,1)/39.065;

Pos(:,2) = Rat(:,2)-90;
Pos(find(Pos(:,2)<0),2) = Pos(find(Pos(:,2)<0),2)+360;

spiket = xspiket(find(xspiket/20000>min(Pos(:,1))&xspiket/20000<max(Pos(:,1))));
spikeind = xspikeind(find(xspiket/20000>min(Pos(:,1))&xspiket/20000<max(Pos(:,1))));


cfigure;

for i = 1:max(unique(xspikeind))
  spkt = spiket(find(spikeind==i));
  spkph = ThPhase(round(spkt/16))*180/pi;
    
  %pos = Pos(find(Rat(round(spkt/512),2);
  
  goodpos = round(spkt/512)-min(Rat(:,1))+1;
  goodpos(find(goodpos<1))=1;
  goodpos(find(goodpos>length(Pos)))=length(Pos);
  
  pos=Pos(goodpos,2);

  plot(pos,spkph,'.',pos,spkph+360,'.');
  title(num2str(i))
  
  waitforbuttonpress;
  
  clear spkt spkph pos;
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


whl = load(['/data2/' FileBase '/video+events/' FileBase '.whl']);

WHL(:,1) = (whl(:,1)+whl(:,3))/2;
WHL(:,2) = (whl(:,2)+whl(:,4))/2;

FWHL = 

WHL(:,3) = sign(whl(:,1)-whl(:,3));

xmin = 80;
xmax = 250;

ydif = 140;

Els = [1:4];

Eeg = readmulti([FileBase '.eeg'], 33, 4);
[ThPhase ThAmp TotPhase] = ThetaPhase(Eeg,[4 10],4,20,1250);

[spiket, spikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,Els);


cfigure;

for i = 1:max(unique(spikeind))
  
  %plot(WHL(goodwhl,1),WHL(goodwhl,2),'.')
  %goodwhl1 = find(WHL(:,1)>0 & WHL(:,1)>xmin & WHL(:,1)<xmax & WHL(:,2)>ydif);
  %goodwhl2 = find(WHL(:,1)>0 & WHL(:,1)>xmin & WHL(:,1)<xmax & WHL(:,2)<ydif);
  
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
  title(num2str(i));
  subplot(2,2,2)
  plot(spkpos(goodpos12,1),spkph(goodpos12,1),'b.',spkpos(goodpos12,1),spkph(goodpos12,1)+360,'b.',spkpos(goodpos12,1),spkph(goodpos12,1)+720,'b.')
  subplot(2,2,3)
  plot(spkpos(goodpos21,1),spkph(goodpos21,1),'b.',spkpos(goodpos21,1),spkph(goodpos21,1)+360,'b.',spkpos(goodpos21,1),spkph(goodpos21,1)+720,'b.')
  subplot(2,2,4)
  plot(spkpos(goodpos22,1),spkph(goodpos22,1),'b.',spkpos(goodpos22,1),spkph(goodpos22,1)+360,'b.',spkpos(goodpos22,1),spkph(goodpos22,1)+720,'b.')
  
  waitforbuttonpress;
  
end


