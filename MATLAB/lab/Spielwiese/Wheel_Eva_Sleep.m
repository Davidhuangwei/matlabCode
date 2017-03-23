%function Wheel_Eva(FileBase)
%% look at wheel data from Eva:

%FileBase = 'g01_maze13_MS.001/g01_maze13_MS.001';
%FileBase = 'g01_maze13_MS.003/g01_maze13_MS.003';
%FileBase = 'g01_maze14_MS.003/g01_maze14_MS.003';
%FileBase = 'g01_maze14_MS.004/g01_maze14_MS.004';


overwrite = 0;

SampleRate = 20000;
EegRate = 1250;
WhlRate = 1250;

PLOT = 0;
PLOT1 = 1;

PRINTFIG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

list = LoadStringArray('listWheel.txt');

file = [6];

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
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Electrode selection
  %%
  elc = InternElc(FileBase,overwrite);
  elc = ElcRegion(FileBase,overwrite);
  elc.animal = FileBase;
  elc
  save([FileBase '.elc'],'elc');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Eeg 
  Eeg = GetEEG(FileBase);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% get the spikes!
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,[],WhlRate,1,SampleRate);
  spike = FindGoodTheta(FileBase,spike);
  goodsp = find(spike.good);
  [spike.ph spike.uph] = SpikePhase(FileBase,spike.t,SampleRate,EegRate);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% classify neurons
  [ctype cmono] = CellTypes(FileBase,overwrite);
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Take only HC neurons
  %HCcells = ismember(spike.ind,find(ismember(spike.clu(:,1),find(elc.region==1))));
  HCcells = find(ismember(spike.clu(:,1),find(elc.region==1)));
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% COMPUTE - REM
  
  % REM INTERVALS
  run = load([FileBase '.sts.REM']);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% CCGs
  xcorrl = SVMUccg(FileBase,Eeg,spike,run,overwrite);
  %[overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,'.xcorr',1250,20000});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% compute the spectra
  GoodPC = xcorrl.goodPC(ismember(xcorrl.goodPC,HCcells));
  GoodIN = xcorrl.goodIN(ismember(xcorrl.goodIN,HCcells));
  overwrite = 0;
  SL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodPC,GoodIN,overwrite,1,[],[],[],[],find(ctype.num==2),unique([GoodPC GoodIN]));
  overwrite = 0;
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

return;


%% FIGURE
gt = find(xcorrl.ccgt>=-1&xcorrl.ccgt<=1);
rate = mean(xcorrl.ccg(gt,:));

fr = SL(6).spect.f;

gf =  find(fr>4&fr<10);
Sp = SL(6).spect.spunit;

SpE = SL(6).spect.speeg;
SpU = SL(6).spect.mua;

SpStat = [max(Sp(gf,:))' mean(Sp(find(fr>10),:))' std(Sp(find(fr>10),:))'];
A = (SpStat(:,2)+4*SpStat(:,3)-SpStat(:,1))<0;

GoodPC = find(ctype.num==2 & spike.clu(:,1)'>4 & A');
GoodIN = find(ctype.num==1 & spike.clu(:,1)'>4 & A');

spPC = Sp(:,GoodPC);
spIN = Sp(:,GoodIN);

%[mm mi] = sort(max(spPC(gf,:)));
%[mmI miI] = sort(max(spIN(gf,:)));

[mm mi] = (max(spPC(gf,:)));
[mmI miI] = (max(spIN(gf,:)));
[mf mfi] = sort(gf(mi));
[mfI mfiI] = sort(gf(miI));

%% Eeg
[me mei] = max(SpE);
%% UMA
[mu mui] = max(SpU);

figure(4758);clf;
%% 
subplot(2,3,[1 2])
imagesc(fr,[],unity(spPC(:,mfi))')
axis xy
hold on
plot(fr,SpE/max(SpE)*length(mi),'k','LineWidth',2)
plot(fr,SpU/max(SpU)*length(mi),'--r','LineWidth',2)
ylabel('pyramidal cells #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%%
subplot(2,3,[4 5])
imagesc(fr,[],unity(spIN(:,mfiI))')
hold on
plot(fr,SpE/max(SpE)*length(miI),'k','LineWidth',2)
plot(fr,SpU/max(SpU)*length(miI),'--r','LineWidth',2)
axis xy
xlabel('frequency [Hz]','FontSize',16)
ylabel('interneuron #','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%%
subplot(433)
plot(fr,SpE/max(SpE),'k','LineWidth',2)
axis tight
xlim([4 10])
Lines(fr(mei),[],'k','--',2);
Lines(fr(mui),[],'r','--',2);
ylabel('LFP','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(436)
xx = mean(spPC');
plot(fr,xx/max(xx(gf)),'k','LineWidth',2)
axis tight
xlim([4 10])
Lines(fr(mei),[],'k','--',2);
Lines(fr(mui),[],'r','--',2);
ylabel('PC','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(439)
plot(fr,SpU/max(SpU(gf)),'k','LineWidth',2)
axis tight
xlim([4 10])
Lines(fr(mei),[],'k','--',2);
Lines(fr(mui),[],'r','--',2);
ylabel('MUA','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
%
subplot(4,3,12)
xx = mean(spIN');
plot(fr,xx/max(xx(gf)),'k','LineWidth',2)
axis tight
xlim([4 10])
Lines(fr(mei),[],'k','--',2);
Lines(fr(mui),[],'r','--',2);
xlabel('frequency [Hz]','FontSize',16)
ylabel('IN','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

PrintBase = FileBase;
FileOut = 'SVMUspectS';
PRINTFIG = 1;
PrintFig([PrintBase FileOut '1'],PRINTFIG)

%%%%%%%%

figure(545);clf;
subplot(122)
b1 = bar(1,mean(fr(gf(mi))));
hold on
b2 = bar(2,mean(fr(gf(miI))));
set(b1,'FaceColor',[1 1 1]*0.5,'EdgeColor',[0 0 0]);
set(b2,'FaceColor',[1 1 1]*0.5,'EdgeColor',[0 0 0]);
errorbar(1,mean(fr(gf(mi))),std(fr(gf(mi))),'k','LineWidth',2);
errorbar(2,mean(fr(gf(miI))),std(fr(gf(miI))),'k','LineWidth',2);
xlim([0.2 2.8]);
ylim([4 10])
Lines([],fr(mei),'k','--',2);
Lines([],fr(mui),'r','--',2);
ylabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','XTick',[],'FontSize',16)
box off
text(0.9,4.6,'PC','Fontsize',20)
text(1.9,4.6,'IN','Fontsize',20)
%text(-0.4,10,'e)','FontSize',16)
%
subplot(121)
imagesc([1:length(mi)],fr,unity(spPC(:,mfi)))
hold on
imagesc([1:length(miI)]+length(mi)+3,fr,unity(spIN(:,mfiI)))
colormap gray;
brighten(0.2)
axis tight
axis xy
pospc = mean([1:length(mi)]);
posin = mean([1:length(miI)]+length(mi)+3);
plot([1:length(mi)],fr(mf),'+','MarkerSize',10,'LineWidth',2,'MarkerEdgeColor',[1 1 1]*0)
hold on
plot([1:length(miI)]+length(mi)+3,fr(mfI),'+','MarkerSize',10,'LineWidth',2,'MarkerEdgeColor',[1 1 1]*0)
plot(pospc,mean(fr(gf(mi))),'o','markersize',7,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
plot(posin,mean(fr(gf(miI))),'o','markersize',7,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
errorbar(pospc,mean(fr(gf(mi))),std(fr(gf(mi))),'r','LineWidth',2);
errorbar(posin,mean(fr(gf(miI))),std(fr(gf(miI))),'r','LineWidth',2);
ylim([4 10])
Lines([],fr(mei),'k','--',2);
Lines([],fr(mui),'r','--',2);
ylabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','XTick',[],'FontSize',16)
box off
text(pospc-2,4.6,'PC','Fontsize',20)
text(posin-2,4.6,'IN','Fontsize',20)
text(-10,10,'d)','FontSize',16)


%%%%
figure(546);clf;
%
subplot(121)
bpc = unique(round(fr(gf)*2))/2;
hpc = histcI(fr(mf(5:end)),bpc);
hin = histcI(fr(mfI),bpc);
a1 = barh(bpc(2:end)-mean(diff(bpc))/2,[hpc],0.8);
hold on
a2 = barh(bpc(2:end)-mean(diff(bpc))/2,[hin],0.8);
colormap('default');
cc = colormap;
set(a1,'FaceColor',cc(1,:),'EdgeColor',[0 0 0]);
set(a2,'FaceColor',cc(end,:),'EdgeColor',[0 0 0]);
xlabel('count','FontSize',16)
ylabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
Lines([],fr(mei),'k','--',2);
Lines([],fr(mui),'r','--',2);
box off
%
subplot(122)
b1 = bar(1,mean(fr(gf(mi))));
hold on
b2 = bar(2,mean(fr(gf(miI))));
set(b1,'FaceColor',[1 1 1]*0.5,'EdgeColor',[0 0 0]);
set(b2,'FaceColor',[1 1 1]*0.5,'EdgeColor',[0 0 0]);
errorbar(1,mean(fr(gf(mi))),std(fr(gf(mi))),'k','LineWidth',2);
errorbar(2,mean(fr(gf(miI))),std(fr(gf(miI))),'k','LineWidth',2);
xlim([0.2 2.8]);
ylim([4 10])
Lines([],fr(mei),'k','--',2);
Lines([],fr(mui),'r','--',2);
ylabel('frequency [Hz]','FontSize',16)
set(gca,'TickDir','out','XTick',[],'FontSize',16)
box off
text(0.9,3.4,'PC','Fontsize',20)
text(1.9,3.4,'IN','Fontsize',20)

PrintFig([PrintBase FileOut '2'],PRINTFIG)





  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% correlation/theta power vs. position/rate
  
  px = whl.ctr(:,1);
  py = whl.ctr(:,2);
  npos = whl.ctr(find(WithinRanges([1:length(whl.ctr)],trial.itv)),:);
  nspeed = whl.speed(find(WithinRanges([1:length(whl.ctr)],trial.itv)),:);
  tpos = [1:length(npos)]'/1250;
  
  cc = coheM.y(:,:,1,2);
  ce = coheM.y(:,:,1,1);
  cs = coheM.y(:,:,2,2);
  cf = find(coheM.f>5 & coheM.f<9);
  ct = coheM.t;
  
  [xx xi yi] = NearestNeighbour(ct,tpos,'both');
  
  %% position
  npos2(:,1) = Accumulate(xi,npos(:,1))./(histcI(xi,[0.5:1:max(xi)+0.5]));
  npos2(:,2) = Accumulate(xi,npos(:,2))./(histcI(xi,[0.5:1:max(xi)+0.5]));
  
  %% speed
  nspeed2 = Accumulate(xi,nspeed(:,1))./(histcI(xi,[0.5:1:max(xi)+0.5]));
  
  %% max frq: coherence
  [dm im] = max(cc(:,cf)');
  mcc = coheM.f(cf(im));
  %% max frq: power eeg
  [dm im] = max(ce(:,cf)');
  mce = coheM.f(cf(im));
  %% max frq: power mua
  [dm im] = max(cs(:,cf)');
  mcs = coheM.f(cf(im));
  
  %% power/coherence
  powcc = sum(cc(:,cf),2);
  powce = sum(ce(:,cf),2);
  powcs = sum(cs(:,cf),2);
  
  %% MAPS: pos vs speed
  figure(1);clf;
  [Av Bin1 Bin2] = MakeMap(npos2,nspeed2,50,0,1);
  title('speed')
  
  %% MAPS: pos vs max/pow
  figure(2);clf;
  subplot(321)
  [Av Bin1 Bin2] = MakeMap(npos2,mcc,20,0,1);
  title('max coherence freq')
  %
  subplot(323)
  [Av Bin1 Bin2] = MakeMap(npos2,mce,20,0,1);
  title('max Eeg freq')
  %
  subplot(325)
  [Av Bin1 Bin2] = MakeMap(npos2,mcs,20,0,1);
  title('max mua freq')
  %%
  subplot(322)
  [Av Bin1 Bin2] = MakeMap(npos2,powcc,20,0,1);
  title('coherence')
  %
  subplot(324)
  [Av Bin1 Bin2] = MakeMap(npos2,powce,20,0,1);
  title('power Eeg')
  %
  subplot(326)
  [Av Bin1 Bin2] = MakeMap(npos2,powcs,20,0,1);
  title('power mua')
    
  %% MAPS: speed vs coherence/power/max
  figure(3);clf
  subplot(321)
  %plot(nspeed2,mcc,'.')
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([nspeed2/20 mcc],10);
  subplot(323)
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([nspeed2/20 mce],10);
  subplot(325)
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([nspeed2/20 mcs],10);
  %%
  subplot(322)
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([nspeed2/20 powcc],10);
  subplot(324)
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([nspeed2/20 powce/max(powce)*10],10);
  subplot(326)
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([nspeed2/20 powcs/max(powcs)*10],10);
  %%
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rate
if ~FileExists([FileBase '.rate']) | overwrite
  
  ratebin = 0.1;
  
  Rate = zeros(length(cells),ceil(max(diff(run'))/EegRate/ratebin)); %0.5 sec binsize
  
  indx = find(ismember(spike.ind,cells) & WithinRanges(spike.t/SampleRate*EegRate,run));
  T = spike.t(indx);
  I = spike.ind(indx);
  R = zeros(size(T));
  Ph = spike.ph(indx);
  
  for n=1:size(run,1)
    idx = find(WithinRanges(T/SampleRate*EegRate,run(n,:)));
    T(idx) = round((T(idx)/SampleRate-run(n,1)/EegRate)/ratebin)+1;
    R(idx) = n;
  end
  T(find(T==0)) = 1;
  T(find(T>size(Rate,2))) = size(Rate,2);
  
  for m=1:length(cells)
    idx = find(I == cells(m));
    Rate(m,:) = Rate(m,:) + smooth(Accumulate(T(idx),1,size(Rate,2)),10)';
  end
  Rate = Rate/n/ratebin;
  
  [mr ir] = max(Rate');
  irr = sortrows([ir' [1:length(cells)]'],1);
  
  bin1 = ([1:size(Rate,2)]-1)*ratebin;
  bin2 = [1:size(Rate,1)];
  
  imagesc(bin1,bin2,unity(Rate(irr(:,2),:)')');
  
  rate.map = Rate(irr(:,2),:);
  rate.bint = bin1;
  rate.cells = cells(irr(:,2));
  rate.T = T;
  rate.Ind = I;
  rate.R = R;
  rate.Phase = Ph;
  
  figure(777);clf;
  for n=1:length(cells)
    subplotfit(n,length(cells));
    indx = find(I==cells(n));
    plot(T(indx),Ph(indx)*180/pi,'.');
    hold on
    plot(T(indx),(Ph(indx)+2*pi)*180/pi,'.');
    title(['cell ' num2str(cells(n))]);
  end  
  
  figure(787);clf;
  for n=1:length(cells)
    subplotfit(n,length(cells));
    indx = find(I==cells(n));
    Sphase = round(Ph(indx)*180/pi)+1;
    msize = [max(T(indx)) max(Sphase)+360];
    Aph = Accumulate([[T(indx);T(indx)] [Sphase; Sphase+360]],1,msize);
    r1 = (-msize(1):msize(1))/msize(1);
    r2 = (-msize(2):msize(2))/msize(2);
    Smooth = 0.025;
    Smoother1 = exp(-r1.^2/Smooth^2/2);
    Smoother2 = exp(-r2.^2/Smooth^2/2);
    sAph = conv2(Smoother1,Smoother2,Aph,'same');
    %imagesc([sAph sAph]')
    imagesc([sAph]')
    axis xy
    title(['cell ' num2str(cells(n))]);
  end  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Phase

dph = 10;
for n=unique(spike.ind)'
  phbins = [0:dph:360];
  ind = find(spike.ind==n);
  PhaseHist(:,n) = histcI(spike.ph(ind)*180/pi,phbins);
  phase.mean(n) = mod(circmean(spike.ph(ind)),2*pi)*180/pi;
end
phase.hist = PhaseHist;
phase.bin = phbins(2:end)-dph/2;

figure(234);clf
for n=1:length(cells)
  subplotfit(n,length(cells));
  bar(phase.bin,phase.hist(:,cells(n)))
  hold on
  bar(phase.bin+360,phase.hist(:,cells(n)))
  axis tight
  Lines(phase.mean(cells(n)));
  Lines(phase.mean(cells(n))+360);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Place Field size
plot(xcorrl.ccgt,xcorrl.ccg(:,xcorrl.goodPC))

xx = ButFilter(xcorrl.ccg(:,xcorrl.goodPC),1,0.1,'high');

for n=1:size(xx,2)
  mxx = find(xx(:,n)>0.1*max(xx(:,n)));
  sizexx(n) = max(xcorrl.ccgt(mxx));
end
maxx = max(xx);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%[yo, fo, ph]=mtperiodogram

[y,f,phi,yerr,phierr,phloc,pow] = mtptchd(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,[1 20]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sgnificance test for PC frequency vs. LFP and model prediction
%% plot figure 

SP = CatStruct(ALL,{'spect' 'spectM'});

fau(1,:) = [mean(SP.spect.fpc(1,:)) std(SP.spect.fpc(1,:))];
fau(2,:) = [mean(SP.spectM.fpc(1,:)) std(SP.spectM.fpc(1,:))];

fau(3,:) = [mean(SP.spect.feeg) std(SP.spect.feeg)];
fau(4,:) = [mean(SP.spectM.feeg) std(SP.spectM.feeg)];

fau(5,:) = [mean(SP.spect.fmua) std(SP.spect.fmua)];
fau(6,:) = [mean(SP.spectM.fmua) std(SP.spectM.fmua)];

FF = [fau(1,1) fau(2,1)];
for m=1:length(FF)
  compf = 500;
  ARate = OscilModel_Het([],compf,FF(m),0.1,10);
  fk(1,m) = ARate.fmax
  afk(:,m) = ARate.afmax;
  mfk(1,m) = mean(ARate.afmax);
  sfk(1,m) = std(ARate.afmax);
end

% pairwise significance
% PC-EEG
Ppceeg(1) = ranksum(SP.spect.fpc(1,:),SP.spect.feeg);
Ppceeg(2) = ranksum(SP.spectM.fpc(1,:),SP.spectM.feeg);
% EEG-MUA
Pmuaeeg(1) = ranksum(SP.spect.fmua(1,:),SP.spect.feeg);
Pmuaeeg(2) = ranksum(SP.spectM.fmua(1,:),SP.spectM.feeg);
% EEG-Mod
Pmodeeg(1) = ranksum(afk(:,1),SP.spect.feeg);
Pmodeeg(2) = ranksum(afk(:,2),SP.spectM.feeg);


figure(5);clf
TT = {'Wheel' 'Maze'};
for n=1:2
  subplot(1,2,n)
  hold on
  for m=n:2:6
    b=bar(m,fau(m,1),1);
    set(b,'facecolor',[1 1 1]*0.7)
    h=errorbar(m,fau(m,1),fau(m,2));
    set(h,'color',[1 0 0],'LineWidth',2);
  end
  b=bar(m+2,mfk(n),1);
  set(b,'facecolor',[1 1 1]*0.7)
  h=errorbar(m+2,mfk(n),sfk(n));
  set(h,'color',[1 0 0],'LineWidth',2);
  %
  set(gca,'TickDir','out','FontSize',16,'XTick',[n:2:8],'XTickLabel',[{'PC'} {'MUA'} {'LFP'} {'Model'}])
  ylabel('freqency [Hz]','fontsize',16)
  xlim([n-1 m+3])
  ylim([6 10])
  title(TT{n},'Position',[n+(m+2-n)/2 9.5])
  
  SigfLine(n,m,ceil(fau(n,1)),Ppceeg(n),0.1);
  
  SigfLine(m-2,m,ceil(fau(n,1))-0.3,Pmuaeeg(n),0.1);
  SigfLine(m+2,m,ceil(fau(n,1))-0.3,Pmodeeg(n),0.1);
  
end
PrintFig('OsciModelStats2')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% this funny 4Hz rhythm...
SPf = ALL(4).spect.f;
SPeeg = ALL(4).spect.speeg;
goodPC = xcorrl.goodPC;
SPpc = mean(ALL(4).spect.spunit(:,goodPC),2);
SPmua = ALL(4).spect.mua;

figure(34876);clf
subplot(311)
plot(SPf,SPeeg/max(SPeeg),'k','LineWidth',2)
set(gca,'TickDir','out','XTick',[0:2:20],'FontSize',16)
ylabel('LFP norm. power','FontSize',16)
box off
annotation('arrow',[0.55 0.5]-0.02,[0.55 0.5]+0.28,'LineWidth',2,'color',[1 0 0])
title('Wheel','FontSize',16)
%
subplot(312)
plot(SPf,SPeeg/max(SPeeg),'--','LineWidth',2,'color',[1 1 1]*0.7)
hold on
plot(SPf,SPpc/max(SPpc),'k','LineWidth',2)
set(gca,'TickDir','out','XTick',[0:2:20],'FontSize',16)
ylabel('PC norm. power','FontSize',16)
box off
annotation('arrow',[0.55 0.5]-0.01,[0.55 0.5]+0.05,'LineWidth',2,'color',[1 0 0])
%
subplot(313)
plot(SPf,SPeeg/max(SPeeg),'--','LineWidth',2,'color',[1 1 1]*0.7)
hold on
plot(SPf,SPmua/max(SPmua),'k','LineWidth',2)
set(gca,'TickDir','out','XTick',[0:2:20],'FontSize',16)
xlabel('frequency [Hz]','FontSize',16)
ylabel('MUA norm. power','FontSize',16)
box off

%%%% maze

SPf = ALL(4).spectM.f;
SPeeg = ALL(4).spectM.speeg;
goodPC = xcorrlM.goodPC;
SPpc = mean(ALL(4).spectM.spunit(:,goodPC),2);
SPmua = ALL(4).spectM.mua;

figure(34877);clf
subplot(311)
plot(SPf,SPeeg/max(SPeeg),'k','LineWidth',2)
set(gca,'TickDir','out','XTick',[0:2:20],'FontSize',16)
ylabel('LFP norm. power','FontSize',16)
box off
%annotation('arrow',[0.55 0.5]-0.02,[0.55 0.5]+0.28,'LineWidth',2,'color',[1 0 0])
title('Maze','FontSize',16)
%
subplot(312)
plot(SPf,SPeeg/max(SPeeg),'--','LineWidth',2,'color',[1 1 1]*0.7)
hold on
plot(SPf,SPpc/max(SPpc),'k','LineWidth',2)
set(gca,'TickDir','out','XTick',[0:2:20],'FontSize',16)
ylabel('PC norm. power','FontSize',16)
box off
%annotation('arrow',[0.55 0.5]-0.01,[0.55 0.5]+0.05,'LineWidth',2,'color',[1 0 0])
%
subplot(313)
plot(SPf,SPeeg/max(SPeeg),'--','LineWidth',2,'color',[1 1 1]*0.7)
hold on
plot(SPf,SPmua/max(SPmua),'k','LineWidth',2)
set(gca,'TickDir','out','XTick',[0:2:20],'FontSize',16)
xlabel('frequency [Hz]','FontSize',16)
ylabel('MUA norm. power','FontSize',16)
box off


