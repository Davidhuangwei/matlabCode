%% GOOD BUT NOT NEEDED

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAP of wheel speed
if ~FileExists([FileBase '.wheelmap']) | overwrite
  
  [Av Bin1 Bin2] = MakeMap(wheel.pos,wheel.speed);
  
  wmap.speed = Av;
  wmap.bins = {Bin1, Bin2};
  wmap.limits = [min(min(Av)) max(max(Av))];
  
  save([FileBase '.wheelmap'],'wmap')
else
  load([FileBase '.wheelmap'],'-MAT')
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAP running speed
if ~FileExists([FileBase '.speedmap']) | overwrite
  
  [sAv sBin1 sBin2] = MakeMap(whl.ctr,whl.speed(:,1),[],[],PLOT);
  
  runmap.speed = sAv;
  runmap.bins = {sBin1 sBin2};
  runmap.limits = [min(min(sAv)) max(max(sAv))];
  
  save([FileBase '.speedmap'],'runmap')
else
  load([FileBase '.speedmap'],'-MAT')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get the wheel cells!
if ~FileExists([FileBase '.wheelarea']) | overwrite
  
  gp = find(WithinRanges([1:length(WhlCtr)]',run));
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap(WhlCtr(gp,:));
  
  ContFact = max(max(SOccMap))/300;
  [C H] = contour(SOccMap',[1 1]*ContFact);
  Cc = []; clear Cc;
  Cc(:,1) = (C(1,2:end)'-1)*mean(diff(Bin1)) + Bin1(1);
  Cc(:,2) = (C(2,2:end)'-1)*mean(diff(Bin2)) + Bin2(1);
  
  figure(4);clf;
  subplot(211)
  plot(WhlCtr(:,1),WhlCtr(:,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
  hold on
  plot(WhlCtr(gp,1),WhlCtr(gp,2),'.')
  subplot(212)
  imagesc(Bin1,Bin2,SOccMap',[1 ContFact]);axis xy; colorbar; hold on;
  plot(WhlCtr(gp,1),WhlCtr(gp,2),'w.')
  plot(Cc(2:end,1),Cc(2:end,2),'.m')
  
  save([FileBase '.wheelarea'],'Cc');
else
  load([FileBase '.wheelarea'],'-MAT')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gt
%% PlaceMap
if ~FileExists([FileBase '.PlaceField']) | overwrite
  m=0;
  cells = unique(spike.ind)';
  for n=cells
    m=m+1;
    
    fprintf(['n=' num2str(n) ' m=' num2str(m) '  (n_tot=' num2str(max(cells)) ')\n']);
    
    indx = find(spike.ind == n);
    
    figure(3);clf
    [RateMap Bin1 Bin2] = PlotPlaceField(spike.t(indx),WhlCtr(:,1),WhlCtr(:,2),SampleRate,WhlRate,[],[],1);
    
    [mr ir] = max(RateMap);
    [mr2 ir2] = max(mr);
    PField(m,:) =  [Bin1(ir(ir2)) Bin2(ir2)];

    hold on
    plot(Bin1(ir(ir2)),Bin2(ir2),'+','markersize',20,'color',[1 1 1])
    %WaitForButtonpress
  end
  
  PFIN = cells(find(inpolygon(PField(:,1),PField(:,2),Cc(:,1),Cc(:,2))));
  cells = PFIN;
  
  %%%%%%%%%%%%%%%%%%%%%%%%
  %% Does not take care %%
  %%  of DOUPLE-PFs!!!  %%
  %%%%%%%%%%%%%%%%%%%%%%%%
  
  save([FileBase '.PlaceField'],'PField','cells');
  
else
  load([FileBase '.PlaceField'],'-MAT')
end


%figure(8);clf;
%plot(WhlCtr(:,1),WhlCtr(:,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
%hold on
%plot(PField(:,1),PField(:,2),'+','markersize',20,'color',[1 1 1])
%plot(PField(cells,1),PField(cells,2),'+','markersize',20,'color',[1 0 0])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% collap trials into one

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Phase
[Phspk Ampspk Totphspk] = ThetaPhase(mua.rate);
[Pheeg Ampeeg Totpheeg] = ThetaPhase(mua.eeg);

APhspk = mod(Phspk,2*pi);
APheeg = mod(Pheeg,2*pi);

if PLOT
  figure(789);clf;
  [Av SAv Bin1 Bin2] = MakeOccMap([[APhspk;APhspk;APhspk+2*pi;APhspk+2*pi] [APheeg;APheeg+2*pi;APheeg;APheeg+2*pi]]); 
  imagesc(Bin1*180/pi,Bin2*180/pi,SAv')
  set(gca,'TickDir','out','FontSize',16,'YTick',[0:180:720],'XTick',[0:180:720])
  xlabel('Spike Phase [deg]')
  ylabel('Eeg Phase [deg]')
  axis xy
  box off
  
  a = 40; b = length(mua.seeg); 
  %plot(SEeg(1:b-(a-1)),SEeg(a:b),'.')
  %a = 40; b = length(SEeg); plot(SMRate(1:b-(a-1)),SMRate(a:b),'.')
  
  [Av SAv Bin1 Bin2] = MakeOccMap([mua.seeg(1:b-(a-1)) mua.seeg(a:b)],[],[],0); 
  Av(find(Av==0)) = min(min(Av))-(max(max(Av))-min(min(Av)))/63;
  
  rate = mua.rate-min(mua.rate);
  [rAv rSAv rBin1 rBin2] = MakeOccMap([rate(1:b-(a-1)) rate(a:b)],[],[],0); 
  rAv(find(rAv==0)) = min(min(rAv))-(max(max(rAv))-min(min(rAv)))/63;
  
  figure(244);clf;
  %subplot(121)
  imagesc(Bin1,Bin2,Av')
  colorbar
  colormap('default');
  cc = colormap;
  cc(1,:) = [0 0 0];
  colormap(cc)
  axis xy
  set(gca,'TickDir','out','FontSize',16)
  title('Eeg','FontSize',20)
  xlabel('Eeg(t_n)','FontSize',16)
  ylabel('Eeg(t_{n+40})','FontSize',16)
  box off
  
  figure(448);clf
  %subplot(122)
  imagesc(rBin1,rBin2,rAv')
  colorbar
  colormap('default');
  cc = colormap;
  cc(1,:) = [0 0 0];
  colormap(cc)
  axis xy
  set(gca,'TickDir','out','FontSize',16)
  title('Rate','FontSize',20)
  xlabel('Rate(t_n)','FontSize',16)
  ylabel('Rate(t_{n+40})','FontSize',16)
  box off
  
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Maze

[Rate rRate RBin] = InstantRate(FileBase,spike.t(find(ismember(spike.ind,find(ctype.num==2)))));


x = [Eeg(1:length(rRate))' rRate];
nFFT = 2^11;
Fs = EegRate;
WinLength = nFFT;
nOverlap = [];
NW = 3;
Detrend = 1;
nTapers = [];

[yo, fo, to] = mtchglong(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,[1 15]);

sSpeed = ButFilter(whl.speed(:,1),1,4*mean(diff(to))/(EegRate/2),'low');
%SEeg = ButFilter(PEeg,1,[4 12]/(EegRate/2),'bandpass');

[dummy, Ind] = histcI([1:length(whl.speed)]'/1250,[to; to(end)+mean(diff(to))], 1);
Ind(find(Ind==0)) = max(Ind);
N = Accumulate(Ind, 1, max(Ind));
Av = Accumulate(Ind, sSpeed, max(Ind));
goodN = find(N);
Av(goodN) = Av(goodN)./N(goodN);

figure(777);clf;
subplot(511)
imagesc(to,fo,yo(:,:,1,1)'); axis xy
subplot(512)                        
imagesc(to,fo,yo(:,:,2,2)'); axis xy
subplot(513)                        
imagesc(to,fo,yo(:,:,2,1)'); axis xy
subplot(514)
plot([1:length(whl.ctr)]/EegRate,whl.ctr(:,1));
hold on
plot([1:length(whl.ctr)]/EegRate,whl.ctr(:,2),'r');
axis tight
subplot(515)
plot([1:length(whl.ctr)]/EegRate,whl.speed(:,1));
hold on
plot([1:length(whl.ctr)]/EegRate,sSpeed,'r');
plot(to+mean(diff(to))/2,Av,'.g');
axis tight


TimeBrowse(50,10)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
 


