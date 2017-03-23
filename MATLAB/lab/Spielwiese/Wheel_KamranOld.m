function Wheel_Kamran
%% look at wheel data from Kamran:
FileBase = '2006-6-9_2-7-16/2006-6-9_2-7-16';

SampleRate = 32552;
EegRate = 1252;
WhlRate = 60;

%% make Whl data from celldata:
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

WhlCtr(:,1) = (WhlCtr(:,1)-min(WhlCtr(:,1)))*100+1;
WhlCtr(:,2) = (WhlCtr(:,2)-min(WhlCtr(:,2)))*100+1;

%% Wheel data
Wee = celldata.xx; %% in Eeg sampling rate!!!!
mm = round([1:length(Wee)]/1252*60);
mm(find(mm==0)) = 1;
mm(find(mm>size(WhlCtr,1))) = size(WhlCtr,1);
Weep = WhlCtr(mm,:);

[b,a]=butter(4,0.05/20,'low');
FWee = filtfilt(b,a,Wee);

Weespeed(:,1) = mean([[diff(FWee); 0] [0; diff(FWee)]],2); 
WeespeedW = Weespeed(find([1 diff(mm)]));


%figure(1)
%subplot(211)
%plot([1:length(Wee)]/1252, Weespeed)
%subplot(212)
%plot([1:length(WhlCtr)]/60, WhlCtr)

figure(2);clf
Arg(:,1) = round((Weep(:,1)-min(Weep(:,1)))*10)+1;
Arg(:,2) = round((Weep(:,2)-min(Weep(:,2)))*10)+1;
[Av Std Bins] = MakeAvF(Arg,Weespeed,[max(Arg(:,1)) max(Arg(:,2))]);
sBins{1} = (Bins{1}-ones(size(Bins{1})))/10;
sBins{2} = (Bins{2}-ones(size(Bins{2})))/10;
imagesc(sBins{1},sBins{2},Av')
colorbar
axis xy
title('average wheel speed')

%% select wheel area
[infield ply] = myClusterPoints(WhlCtr,0);


figure(3);clf
subplot(211)
Occ = Accumulate(Arg,1);
sOcc = sparse(Occ);
[a b c] = find(sOcc);
nOcc = full(sparse(a,b,1))*10-9;
imagesc(sBins{1},sBins{2},nOcc)
colorbar
axis xy
title('visited places')
subplot(212)
imagesc(sBins{1},sBins{2},Occ,[0 1000])
colorbar
axis xy

figure(4);clf
subplot(211)
[a b c] = find(sparse(nOcc));
[aa bb cc] = find(sparse(Av));
nAv = full(sparse([a;aa],[b;bb],[c;cc]));
imagesc(Bins{1},Bins{2},nAv,[min(min(Av)) max(max(Av))]+1)
%imagesc(nAv,[1 2])
colorbar
colormap('default');
cc = colormap;
cc(1,:) = [1 1 1];
colormap(cc)
axis xy
title('average wheel speed in occupied bins')
%
subplot(212)
dx = mean([[diff(WhlCtr(:,1));0] [0; diff(WhlCtr(:,1))]],2);
dy = mean([[diff(WhlCtr(:,2));0] [0; diff(WhlCtr(:,2))]],2);
rspeed = (sqrt(dx.^2+dy.^2));
SArg(:,1) = round((WhlCtr(:,1)-min(WhlCtr(:,1)))*10+1);
SArg(:,2) = round((WhlCtr(:,2)-min(WhlCtr(:,2)))*10+1);
[SAv Std SBins] = MakeAvF(SArg,rspeed,[max(SArg(:,1)) max(SArg(:,2))]);
[sa sb sc] = find(sparse(SAv));
MaxSpeed = mean(sc)+3*std(sc);
sc(find(sc>=MaxSpeed)) = MaxSpeed;
nSAv = full(sparse([a;sa],[b;sb],[c;sc]));
imagesc(SBins{1},SBins{2},nSAv,[min(min(SAv)) MaxSpeed]+1)
colorbar
colormap('default')
cc = colormap;
cc(1,:) = [0 0 0];
colormap(cc)
axis xy
title('running speed')


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


%% get the spikes!
[spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,WhlCtr,WhlRate,1,SampleRate);

spike = FindGoodTheta(FileBase,spike);

goodsp = find(spike.pos(:,1)>0 | spike.pos(:,2)>0 & spike.good);


%% PlaceMap

%% plot spikes
for c=1:2
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
    %imagesc(sBins{1},sBins{2},Av')
    %colorbar
    %axis xy
    %title('average wheel speed')
    
    %subplot(312)
    [RateMap Bin1 Bin2] = PlotPlaceField(spike.t(indx),WhlCtr(:,1),WhlCtr(:,2),SampleRate,WhlRate,0);
    
    [mr ir] = max(RateMap);
    [mr2 ir2] = max(mr);
    if c==1
      PlaceField(m,:) =  [Bin1(ir(ir2)) Bin2(ir2)];
    end
    %hold on
    %plot(Bin1(ir(ir2)),Bin2(ir2),'+','markersize',20,'color',[1 1 1])
    
    %kk = waitforbuttonpress;
    %if kk == 0
    %  continue;
    %else
    %  break
    %end
    
  end
  
  PFIN = cells(find(inpolygon(PlaceField(:,1),PlaceField(:,2),ply(:,1),ply(:,2))));
  cells = PFIN;
end
  
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
  
  kk = waitforbuttonpress;
  if kk == 0
    continue;
  else
    break
  end
    
end

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


