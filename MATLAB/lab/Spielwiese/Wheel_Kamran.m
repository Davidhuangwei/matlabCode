%% look at wheel data from Kamran:
%FileBase = '2006-6-9_2-7-16/2006-6-9_2-7-16';

overwrite = 0;

SampleRate = 32552;
EegRate = 1252;
WhlRate = 60;

PLOT = 0;
PLOT1 = 1;

PRINTFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

list = LoadStringArray('listWheelKamran.txt');

file = [1 2 3 4];
%file = [2];

if isempty(file);
  file = [1:length(list)];
end
RtAll = [];PCAll=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOOP THROUGH FILES
%%
for f=file
  
  %figure;close all;
  
  FileBase = [list{f} '/' list{f}];
  PrintBase = [list{f} '/Figs/' list{f}];
  
  fprintf('=========================\n');
  fprintf('FILE %d: %s\n',f,list{f});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Whl data
  if ~FileExists([FileBase '.whl']) %| overwrite
    error('no whl file!');
  else
    whl = GetWhl(FileBase); 
    WhlCtr = whl.ctr;
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Trials on Maze
  trial = GetTrials(FileBase,whl);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Eeg 
  Eeg = GetEEG(FileBase);
  
end


%% make Whl data from celldata:
if ~FileExists([FileBase '.whl']) | overwrite
  
  load([FileBase '.celldata'],'-MAT');
  if max(diff([celldata.xyt(:,3) celldata.xyt2(:,3)]'))
    error('there is a mismatch in back and front light!')
  end
  X = mean([celldata.xyt(:,1) celldata.xyt2(:,1)],2);
  Y = mean([celldata.xyt(:,2) celldata.xyt2(:,2)],2);
  WhlMean = [X Y];
  % -- interpolate/resample data
  T = (celldata.xyt(:,3)-celldata.xyt(1,3))/1000000;
  WhlT = [min(T):1/WhlRate:max(T)]';
  xNWhl = interp1(T,[celldata.xyt(:,[1 2]) celldata.xyt2(:,[1 2])],WhlT);
  % -- cut beginning and end according to celldata.tbegin and celldata.tend
  xb = (celldata.tbegin-celldata.xyt(1,3))/1000000;
  xe = (celldata.ftend-celldata.xyt(1,3))/1000000;
  NWhl = xNWhl(find(WhlT>=xb & WhlT<=xe),:);
  
  %WhlCtr(:,1) = mean(NWhl(:,[1 3]),2);
  %WhlCtr(:,2) = mean(NWhl(:,[2 4]),2);
  WhlCtr = NWhl(:,[1 2]);

  %% the position is scaled such that the origien is at [1 1]
  WhlCtr(:,1) = (WhlCtr(:,1)-min(WhlCtr(:,1)))*100+1;
  WhlCtr(:,2) = (WhlCtr(:,2)-min(WhlCtr(:,2)))*100+1;

  msave([FileBase '.whl'],WhlCtr)
else
  WhlCtr = load([FileBase '.whl']);
end
  

%% Wheel data
if ~FileExists([FileBase '.wheel']) | overwrite
  Wee = celldata.xx; %% in Eeg sampling rate!!!!
  mm = round([1:length(Wee)]/1252*60);
  mm(find(mm==0)) = 1;
  mm(find(mm>size(WhlCtr,1))) = size(WhlCtr,1);
  Weep = WhlCtr(mm,:);
  
  [b,a]=butter(4,0.05/20,'low');
  FWee = filtfilt(b,a,Wee);
  
  Weespeed(:,1) = mean([[diff(FWee); 0] [0; diff(FWee)]],2); 
  WeespeedW = Weespeed(find([1 diff(mm)]));
  
  wheel.count = Wee;
  wheel.pos = Weep;
  wheel.speed = Weespeed;
  wheel.whlrate = find([1 diff(mm)]);
  
  save([FileBase '.wheel'],'wheel')
else
  load([FileBase '.wheel'],'-MAT')
end


%% compute Maps:
if ~FileExists([FileBase '.wheelmap']) | overwrite
  
  % Wheelspeed vs position
  Arg(:,1) = round((wheel.pos(:,1)-min(wheel.pos(:,1)))*10)+1;
  Arg(:,2) = round((wheel.pos(:,2)-min(wheel.pos(:,2)))*10)+1;
  [Av Std Bins] = MakeAvF(Arg,wheel.speed,[max(Arg(:,1)) max(Arg(:,2))]);
  [Av Std Bins] = MakeAvF(Arg,wheel.speed,[max(Arg(:,1)) max(Arg(:,2))]);
  %sBins{1} = (Bins{1}-ones(size(Bins{1})))/10;
  %sBins{2} = (Bins{2}-ones(size(Bins{2})))/10;
  sBins{1} = (Bins{1}-1)/10+1;
  sBins{2} = (Bins{2}-1)/10+1;
  
  %% "take out" not visited places
  Occ = Accumulate(Arg,1);
  sOcc = sparse(Occ);
  [a b c] = find(sOcc);
  nOcc = full(sparse(a,b,1))*10-9;
  
  [a b c] = find(sparse(nOcc));
  [aa bb cc] = find(sparse(Av));
  nAv = full(sparse([a;aa],[b;bb],[c;cc]));
  
  
  wmap.speed = nAv;
  wmap.bins = sBins;
  wmap.limits = [min(min(Av)) max(max(Av))];

  save([FileBase '.wheelmap'],'wmap')
else
  load([FileBase '.wheelmap'],'-MAT')
end  
  
if ~FileExists([FileBase '.speedmap']) | overwrite
  
  mult = 1; % 10; multiplication factor
  %%spmult = [2 1];%[10 9];
  
  dx = mean([[diff(WhlCtr(:,1));0] [0; diff(WhlCtr(:,1))]],2);
  dy = mean([[diff(WhlCtr(:,2));0] [0; diff(WhlCtr(:,2))]],2);
  rspeed = (sqrt(dx.^2+dy.^2));
  SArg(:,1) = round((WhlCtr(:,1)-min(WhlCtr(:,1)))*mult+1);
  SArg(:,2) = round((WhlCtr(:,2)-min(WhlCtr(:,2)))*mult+1);
  
  sOcc = sparse(Accumulate(SArg,1));
  %%[a b c] = find(sOcc);
  %%%[a b c] = find(sparse(full(sparse(a,b,1))*spmult(1)-spmult(2)));
  %%[a b c] = find(sparse(full(sparse(a,b,1))*spmult(1)-spmult(2)));

  [SAv Std SBins] = MakeAvF(SArg,rspeed,[max(SArg(:,1)) max(SArg(:,2))]);
  
  %% smooth
  msize = size(SAv);
  Smooth = 1/100;mult 
  r1 = (-msize(1):msize(1))/msize(1);
  r2 = (-msize(2):msize(2))/msize(2);
  Smoother1 = exp(-r1.^2/Smooth^2/2);
  Smoother2 = exp(-r2.^2/Smooth^2/2);
  SAv = conv2(Smoother1,Smoother2,SAv,'same');
  
  %%[sa sb sc] = find(sparse(SAv));
  VAv = reshape(SAv,size(SAv,1)*size(SAv,2),1);
  MaxSpeed = mean(VAv(find(sOcc)))+2*std(VAv(find(Occ)));
  %%sc(find(sc>=MaxSpeed)) = MaxSpeed;
  VAv(find(VAv>MaxSpeed)) = MaxSpeed;
  %%nSAv = full(sparse([a;sa],[b;sb],[c;sc]));
  VAv(find(reshape(sOcc,size(sOcc,1)*size(sOcc,2),1))==0) = min(VAv)-(max(VAv)-min(VAv))/63;
  SAv = reshape(VAv,size(SAv,1),size(SAv,2));
  
  sSBins{1} = (SBins{1}-1)/mult + 1;
  sSBins{2} = (SBins{2}-1)/mult + 1;

  runmap.speed = SAv;
  runmap.bins = sSBins;
  runmap.limits = [min(min(SAv)) MaxSpeed];
 
  if PLOT
    imagesc(sSBins{1},sSBins{2},SAv')
    colorbar
    colormap('default');
    cc = colormap;
    cc(1,:) = [1 1 1]*0;
    colormap(cc)
    axis xy
  end
  
  save([FileBase '.speedmaps'],'runmap')
else
  load([FileBase '.speedmaps'],'-MAT')
end


if ~FileExists([FileBase '.wheelarea']) | overwrite
  figure(4);clf
  subplot(211)
  imagesc(wmap.bins{1},wmap.bins{2},wmap.speed')%,wmap.limits+1)
  colorbar
  colormap('default');
  cc = colormap;
  cc(1,:) = [1 1 1];
  colormap(cc)
  axis xy
  title('average wheel speed in occupied bins')
  %
  subplot(212)
  imagesc(runmap.bins{1},runmap.bins{2},runmap.speed')
  colorbar
  colormap('default')
  cc = colormap;
  cc(1,:) = [1 1 1]*1;
  colormap(cc)
  axis xy
  title('running speed')
  
  %% select wheel area
  figure(4)
  subplot(211)
  [infield ply] = myClusterPoints(WhlCtr,0);
  
  save([FileBase '.wheelarea'],'infield','ply');
else
  load([FileBase '.wheelarea'],'-MAT')
end
  

%% get the spikes!
[spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,WhlCtr,WhlRate,1,SampleRate);
spike = FindGoodTheta(FileBase,spike);
goodsp = find(spike.pos(:,1)>0 | spike.pos(:,2)>0 & spike.good);
[spike.ph spike.uph] = SpikePhase(FileBase,spike.t,SampleRate,EegRate);

%% classify neurons
[ctype cmono] = CellTypes(FileBase,overwrite);


%% PlaceMap
if ~FileExists([FileBase '.PlaceField']) | overwrite
  %for c=1:2
    m=0;
    cells = unique(spike.ind)';
    for n=cells
      m=m+1;
      
      indx = find(spike.ind == n);
      
      %figure(7);clf
      %subplot(313)
      %plot(WhlCtr(1:10:end,1),WhlCtr(1:10:end,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
      %hold on
      %plot(spike.pos(indx,1),spike.pos(indx,2),'.')
      %xlim([min(spike.pos(goodsp,1)) max(spike.pos(goodsp,1))])
      %ylim([min(spike.pos(goodsp,2)) max(spike.pos(goodsp,2))])
      %title('cell')
      %subplot(311)
      %imagesc(wmap.bins{1},wmap.bins{2},wmap.speed',wmap.limits+1)
      %colorbar
      %axis xy
      %title('average wheel speed')
      %subplot(312)
      
      [RateMap Bin1 Bin2] = PlotPlaceField(spike.t(indx),WhlCtr(:,1),WhlCtr(:,2),SampleRate,WhlRate,[],[],1);
      
      [mr ir] = max(RateMap);
      [mr2 ir2] = max(mr);
      %if c==1
	PField(m,:) =  [Bin1(ir(ir2)) Bin2(ir2)];
      %end
      
      %hold on
      %plot(Bin1(ir(ir2)),Bin2(ir2),'+','markersize',20,'color',[1 1 1])
      %kk = waitforbuttonpress;
      %if kk == 0
      %  continue;
      %else
      %  break
      %end
      
    end
    
    PFIN = cells(find(inpolygon(PField(:,1),PField(:,2),ply(:,1),ply(:,2))));
    cells = PFIN;
  %end
  
  save([FileBase '.PlaceField'],'PField','cells');

else
  load([FileBase '.PlaceField'],'-MAT')
end
  

figure(8);clf;
plot(WhlCtr(:,1),WhlCtr(:,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
hold on
plot(PField(:,1),PField(:,2),'+','markersize',20,'color',[1 1 1])
plot(PField(cells,1),PField(cells,2),'+','markersize',20,'color',[1 0 0])


%% use CheckEegStates to find wheel running episodes
if ~FileExists([FileBase '.sts.Wheel'])
  load([FileBase '.elc'],'-MAT');
  Aux1 = [1:length(wheel.speed)]/1252;
  xp = round(find(infield)/60*1252);
  Aux2 = zeros(size(Aux1));
  Aux2(xp) = wheel.speed(xp);
  CheckEegStates(FileBase,'Wheel',{Aux1,[],Aux2,'plot'},[1 100],elc.theta,1);
  go = input('go? ');
end
run = load([FileBase '.sts.Wheel']); %% in Eeg rate
  
figure(9);clf;
plot(WhlCtr(:,1),WhlCtr(:,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
hold on
itv = round(run/1252*60); %% in whl rate (60)
gp = find(WithinRanges([1:length(WhlCtr)]',itv));
plot(WhlCtr(gp,1),WhlCtr(gp,2),'.')


%% Eeg 
Eeg = GetEEG(FileBase);

%% compute the spectra
nFFT = 2^13;
Fs = EegRate;
nOverlap = [];
NW = 1;  %% ~5 for gamma
Detrend = 'linear';
nTapers = [];
FreqRange = [1 20];
CluSubset = [];
pval = []; 
WinLength = 2^12;%512;

indx = find(ismember(spike.ind,cells));
NRes = round(spike.t(indx)/SampleRate*EegRate); %% in Eeg rate!!!!!
NClu = spike.ind(indx);
m=0;
for n=unique(NClu)'
  m=m+1;
  nNClu(find(NClu==n)) = m;
end
NClu = nNClu';clear nNclu;
Ntype = ctype.num(cells);
IN = find(Ntype==1);
PC = find(Ntype==2);

for n=1:size(itv,1)
  %SEeg = Eeg(run(n,1):run(n,2),1);
  
  %% find the good cells: good number of or no spikes
  indx = find(WithinRanges(NRes,run(n,:)));
  Res = NRes(indx);
  Clu = NClu(indx);
  x = Accumulate(Clu,1,max(NClu));
  goody = find(x);
  
  [SP,f]=mtptcsd(Eeg,NRes,NClu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,[],run(n,:),[],1);
  
  [nf nch nch] = size(SP);
  ind = sub2ind( size(SP), repmat([1:nf],1,nch)',reshape(repmat([1:nch],nf,1),[],1), reshape(repmat([1:nch],nf,1),[],1));
  spmat = reshape(SP(ind), nf, nch);
  spind(1) = 0;
  spind(2:length(goody)+1) = goody+1;
  
  numspike(1) = 0;
  numspike(2:length(goody)+1) = x(goody);
  
  iPC = (find(ismember(spind,PC)));
  iIN = (find(ismember(spind,IN)));
  
  %speeg = SP(:,1,1);
  %spcel = [];
  %for m=2:size(SP,2)
  %  spcel(:,m-1) = sq(SP(:,m,m));
  %end
  
  %% max of Eeg-power:
  [m im] = max(spmat(:,1));
  
  %% select frequency window
  gf = find(f);%>7 & f<12);
  
  figure(12);clf;
  subplotfit(1,length(goody)+1)
  plot(f(gf),spmat(gf,1))
  Lines(f(im));
  for c=1:length(goody)
    subplotfit(c+1,length(goody)+1);
    plot(f(gf),spmat(gf,c+1));
    Lines(f(im));
    title([num2str(x(goody(c))) ' spikes']);
  end
  ForAllSubplots('axis tight')
  
  kk = waitforbuttonpress;
  if kk == 0
    continue;
  else
    break
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
  


%% plot spiking...
for n=1:size(itv,1)
  figure(10);clf
  subplot(411)
  indx = find(ismember(spike.ind,cells) & WithinRanges(round(spike.t/SampleRate*EegRate),run(n,:)));  
  scatter(spike.t(indx)/SampleRate,spike.ind(indx),20,spike.ph(indx))
  
  subplot(412)
  indx2 = [run(n,1):run(n,2)];
  plot(indx2/1252,wheel.speed(indx2)) 
  
  subplot(4,1,[3:4])
  plot(WhlCtr(1:10:end,1),WhlCtr(1:10:end,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
  hold on
  plot(WhlCtr(itv(n,1):itv(n,2),1),WhlCtr(itv(n,1):itv(n,2),2), ...
       'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
  plot(WhlCtr(itv(n,1),1),WhlCtr(itv(n,1),2), ...
       'o','markersize',10,'markerfacecolor',[0 1 0],'markeredgecolor',[0 1 0])
  plot(WhlCtr(itv(n,2),1),WhlCtr(itv(n,2),2), ...
       'o','markersize',10,'markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0])
  
  kk = waitforbuttonpress;
  if kk == 0
    continue;
  else
    break
  end
end





keyboard


if 0


  
%% find trials
%trial = GetTrials(FileBase,WhlCtr);
figure(8);clf;
gtrial = FindTrialsNoEvt(FileBase,WhlCtr,6); 
gtrialW = round(gtrial*EegRate/WhlRate);

for n=1:size(gtrial,1)
  figure(8);clf;
  subplot(511)
  plot([gtrialW(n,1):10:gtrialW(n,2)]/EegRate,Wee(gtrialW(n,1):10:gtrialW(n,2),:),'.')
  axis tight
  
  subplot(512)
  scatter([gtrialW(n,1):10:gtrialW(n,2)]/EegRate,Weespeed(gtrialW(n,1):10:gtrialW(n,2)),10,Weespeed(gtrialW(n,1):10:gtrialW(n,2)))
  axis tight
  ylim([min(Weespeed) max(Weespeed)])
  
  subplot(5,1,[3 4 5])
  plot(WhlCtr(:,1),WhlCtr(:,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
  hold on
  scatter(WhlCtr(gtrial(n,1):gtrial(n,2),1),WhlCtr(gtrial(n,1):gtrial(n,2),2),20,WeespeedW(gtrial(n,1):gtrial(n,2)))
  colorbar
  
  %kk = waitforbuttonpress;
  %if kk == 0
  %  continue;
  %else
  %  break
  %end
    
end

end

%% Time Browse the wheel and position
figure(9);clf
subplot(311)
plot([1:length(Wee)]/EegRate,Wee)
Lines(gtrialW(:,1)/EegRate,[],'g');
Lines(gtrialW(:,2)/EegRate,[],'r');




keyboard
%%%%%%%%%%%%%%%%%%%%%%%%%%
%fprintf('length of Eeg is %2.3f sec\n',length(Eeg)/EegRate);
%fprintf('length of Whl is %2.3f sec\n',length(Whl)/60);
%%fprintf('length of xyt is %2.3f sec\n',length(celldata.xyt));
%fprintf('length of xyt is %2.3f sec\n',(celldata.xyt(end,3)-celldata.xyt(1,3))/1000000);%%%

%clf
%plot(Whl(:,1),'r')
%hold on
%k=33;
%%plot([1:length(celldata.xyt)-(k-1)]*2.002,celldata.xyt(k:end,1)*100)
%plot([1:length(celldata.xyt)]*2.0009,celldata.xyt(:,1)*100)

%clf
%subplot(211)
%plot((celldata.xyt2(:,3)-celldata.xyt2(1,3))/1000000-1,celldata.xyt2(:,1)*100)
%hold on
%plot([1:length(Whl)]/60,Whl(:,1),'r')
%subplot(212)
%plot([1:length(Eeg)]/EegRate,Eeg)

%Par = LoadPar([FileBase '.par']);
%[xspiket, xspikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);


%%% resample wheelspeed to running speed
%resamplWheel = resample(Weespeed,60,1252);
%dd = length(resamplWheel)-length(rspeed);
%figure(6)
%subplot(211)
%plot(rspeed,resamplWheel(1:end-dd),'.')
%subplot(212)
%SArgs(:,1) = round(rspeed*100)+1;
%SArgs(:,2) = round((resamplWheel(1:end-dd)-min(resamplWheel(1:end-dd)))*100)+1;
%Speeds = Accumulate(SArgs,1);
%bin{1} = (unique(SArgs(:,1))-1)/100;
%bin{2} = (unique(SArgs(:,2))+min(resamplWheel(1:end-dd))*100-1)/100;
%imagesc(bin{1},bin{2},Speeds',[0 1000])
%colorbar
%axis xy

%for n=unique(NClu)'
%for m=1:size(itv,1)
%  indx = find(NClu==n);
%  xx = find(WithinRanges(NRes,run(m,:)) & NClu==n);
%  length(xx)
%  if length(xx)<3
%    continue
%  end
%  %SEeg = Eeg(run(m,1):run(m,2))';
%  [SP,f]=mtptcsd(Eeg,NRes(indx),NClu(indx),nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,[],[run(m,1) run(m,2)],[],1);
%  
%  whos SP
%  clear SP
%end
%end


