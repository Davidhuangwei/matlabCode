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

file = [1 2 3 4 5 7 8 9 10]; % alternation task and wheel running
%% file = 6 is REM!!
file = [7 8 9 10]; % control wheel running
%file = [1 2 3 4 5];

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
  
  %%%%%%%%%%%
  %% Whl data
  if ~FileExists([FileBase '.whl']) %| overwrite
    error('no whl file!');
  else
    whl = GetWhl(FileBase); 
    WhlCtr = whl.ctr;
  end
  
  %%%%%%%%%%%%%%%%%
  %% Trials on Maze
  if f<6
    trial = GetTrials(FileBase,whl);
    
    %% linearized position
    whl = GetWhlLin(whl,trial);
  end
  
  %%%%%%%%%%%%%%%%%%%%%%
  %% Electrode selection
  %%
  elc = InternElc(FileBase,overwrite);
  elc = ElcRegion(FileBase,overwrite);
  elc.animal = FileBase;
  elc
  save([FileBase '.elc'],'elc');

  %%%%%%
  %% Eeg 
  Eeg = GetEEG(FileBase);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Wheel data - in EegRate
  wheel = GetWheelEva(FileBase,WhlCtr,overwrite);
  run = wheel.runs;

  %ask = input('do you need to correct wheel.dir? [0/1] ');
  %if ask
  %  wheel.dir
  %  ask = input('plus how much? ');
  %  wheel.dir = wheel.dir + ask;
  %end
  
  %%%%%%%%%%%%%%%%%%
  %% get the spikes!
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,WhlCtr,WhlRate,1,SampleRate);
  spike = FindGoodTheta(FileBase,spike);
  %goodsp = find(spike.pos(:,1)>0 | spike.pos(:,2)>0 & spike.good);
  [spike.ph spike.uph] = SpikePhase(FileBase,spike.t,SampleRate,EegRate);
  
  %% linearized position
  spike.dir = zeros(length(spike.t),1);
  if f<6
    for nn=unique(trial.dir)'
      spike.dir(find(WithinRanges(spike.t/20000*whl.rate,trial.itv(find(trial.dir==nn),:))),:)=nn;
    end
    fprintf('  linearized spike position....\n');
    spike = SpikeLinPos(spike,trial,WhlRate);
  end
  
  %% spike distance on wheel
  %spike.whl = wheel.dist(round(spike.t/SampleRate*EegRate));
  spike.whl = wheel.count(round(spike.t/SampleRate*EegRate));
  
  %%%%%%%%%%%%%%%%%%%
  %% classify neurons
  [ctype cmono] = CellTypes(FileBase,overwrite);
    
  %%%%%%%%%%%%%%%%%%%%%%%
  %% Take only HC neurons
  %HCcells = ismember(spike.ind,find(ismember(spike.clu(:,1),find(elc.region==1))));
  HCcells = find(ismember(spike.clu(:,1),find(elc.region==1)));
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% COMPUTE - WHEEL
  
  %%%%%%%
  %% CCGs
  xcorrl = SVMUccg(FileBase,Eeg,spike,run,overwrite);
  %[overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,'.xcorr',1250,20000});
  
  
  %%%%%%%%%%%%%%%%%%%%%%
  %% compute the spectra
  GoodPC = xcorrl.goodPC(ismember(xcorrl.goodPC,HCcells));
  GoodIN = xcorrl.goodIN(ismember(xcorrl.goodIN,HCcells));
  ALL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodPC,GoodIN,overwrite,1,0,[],[],[],find(ctype.num==2),unique([GoodPC GoodIN]));
  %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate,allPC,CluSubset] = DefaultArgs(varargin,{[],[],0,0,0,'.spect',1250,20000,[],[]});

  GoodSP = GoodSpect(ALL(f).spect.spunit,ALL(f).spect.f,ctype.num);
  
  ALL(f).spect = SVMUspect(FileBase,Eeg,spike,run,PrintBase,GoodSP{2},GoodSP{1},overwrite,1,PRINTFIG,[],[],[],find(ctype.num==2),unique([GoodSP{2} GoodSP{1}]));
    
  ALL(f).width = SVMUccgWidth(FileBase,spike.t,spike.ind,run,0,1,[],[],[],GoodSP{2},GoodSP{1});
 
  
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% Phase ccg and spectrum
  ALL(f).xcorrlPh = SVMUccgPh(FileBase,spike.t,spike.ind,run,GoodSP{2},GoodSP{1},find(ctype.num==2),0,1);
  %[run,gPC,gIN,allPC,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],[],[],[],0,0,'.xcorrPh',1250,20000});
  ALL(f).spectPh = SVMUspectPh(FileBase,spike,run,PrintBase,GoodSP{2},GoodSP{1},0,1,[],[],[],[],find(ctype.num==2));
  %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate,allPC,CluSubset] = DefaultArgs(varargin,{[],[],0,0,0,'.spectPh',1250,20000,[],[]});
  
  
  %%%%%%%%%%%%%%%%%%%%
  %% compression index
  %spikelpos = wheel.dist(round(spike.t/SampleRate*EegRate))/10;
  %% assume 10 count = 1 cm: spikepos is in cm
  %run1 = run(find(wheel.dir==1),:);
  %ALL(f).compr1 = SVMUCompFact(FileBase,round(spike.t/SampleRate*EegRate),spike.ind,spikelpos,run1,overwrite,[],find(ctype.num==2));
  % ==>> ALL(f).compr = SVMUCompFact(FileBase,round(spike.t/SampleRate*EegRate),spike.ind,spikelpos,run,overwrite,wheel.dir,find(ctype.num==2));
  %run2 = run(find(wheel.dir==2),:);
  %ALL(f).compr2 = SVMUCompFact(FileBase,round(spike.t/SampleRate*EegRate),spike.ind,spikelpos,run2,overwrite,[],find(ctype.num==2));
  
  %%%%%%%%%%%
  %% MUA Rate
  %mua = SVMUmua(FileBase,Eeg,spike,run,PrintBase,find(ctype.num==2),overwrite);
  %[gcells,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],0,0,'.muarate',1250,20000});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Coherence measure - in time
  %cohe = SVMUspectL(FileBase,spike,run,mua,PrintBase,overwrite);
  %[overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,0,'.coherence',1250,20000});
  %coheM = SVMUspectL(FileBase,spike,run,mua,PrintBase,find(ctype.num==2),overwrite,1,0,'.coherenceM');
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% collap trials into one
  %acohe = SVMUmuaAv(FileBase,Eeg,spike,run,find(ctype.num==2),overwrite,1,'.acoherence');
  %[gcells,overwrite,PLOT,OutFile,PrintBase,PRINTFIG,EegRate,SampleRate] = DefaultArgs(varargin,{[],1,0,'.acoherence','Out',0,1250,20000});
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% COMPUTE - MAZE

  if f>6
    %% for controll task
    trial.itv = load([FileBase '.sts.RUN']);
    runM = trial.itv;
    
    itv = MixIntervals(runM,run,0);
  else
    itv = trial.itv;
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% CCGs
  xcorrlM = SVMUccg(FileBase,Eeg,spike,itv,overwrite,0,'.xcorrM');
  %[overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,'.xcorr',1250,20000});

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% compute the spectra
  GoodPC = xcorrlM.goodPC(ismember(xcorrlM.goodPC,HCcells));
  GoodIN = xcorrlM.goodIN(ismember(xcorrlM.goodIN,HCcells));
  ALL(f).spectM = SVMUspect(FileBase,Eeg,spike,itv,PrintBase,GoodPC,GoodIN,overwrite,1,0,'spectM',[],[],find(ctype.num==2),unique([GoodPC GoodIN]));
  %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],[],0,0,0,'.spect',1250,20000});
  
  GoodSP = GoodSpect(ALL(f).spectM.spunit,ALL(f).spect.f,ctype.num);
  
  ALL(f).spectM = SVMUspect(FileBase,Eeg,spike,itv,PrintBase,GoodSP{2},GoodSP{1},overwrite,1,PRINTFIG,'spectM',[],[],find(ctype.num==2),unique([GoodSP{2} GoodSP{1}]));
    
  xcorrlWidth = SVMUccgWidth(FileBase,spike.t,spike.ind,run,0,1,'.xcorrWidthM',[],[],GoodSP{2},GoodSP{1});
  %WaitForButtonpress
  
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% Phase ccg and spectrum
  ALL(f).xcorrlPhM = SVMUccgPh(FileBase,spike.t,spike.ind,itv,GoodSP{2},GoodSP{1},find(ctype.num==2),0,1,'.xcorrPhM');
  %[run,gPC,gIN,allPC,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],[],[],[],0,0,'.xcorrPh',1250,20000});
  spectPhM = SVMUspectPh(FileBase,spike,itv,PrintBase,GoodSP{2},GoodSP{1},0,1,[],'.spectPhM',[],[],find(ctype.num==2));
  %[goodPC,goodIN,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate,allPC,CluSubset] = DefaultArgs(varargin,{[],[],0,0,0,'.spectPh',1250,20000,[],[]});
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% compression index
  %spikelpos = wheel.dist(round(spike.t/SampleRate*EegRate))/10;
  % assume 10 count = 1 cm: spikepos is in cm
  %ALL(f).comprM = SVMUCompFact(FileBase,round(spike.t/SampleRate*EegRate),spike.ind,spike.lpos,trial.itv,overwrite,[],find(ctype.num==2));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% MUA Rate
  %muaM = SVMUmua(FileBase,Eeg,spike,trial.itv,PrintBase,find(ctype.num==2),overwrite,0,'.muarateM');
  %[gcells,overwrite,PLOT,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],0,0,'.muarate',1250,20000});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Coherence measure - in time
  %coheM = SVMUspectL2(FileBase,spike,muaM,PrintBase,overwrite,1,0,'.coherenceM');
  %[overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{0,0,0,'.coherence',1250,20000});
  %
  %coheM = SVMUspectL(FileBase,spike,trial.itv,muaM,PrintBase,find(ctype.num==2),overwrite,1,0,'.coherenceM');
  %[gcells,overwrite,PLOT,PRINTFIG,FileOut,EegRate,SampleRate] = DefaultArgs(varargin,{[],0,0,0,'.coherence',1250,20000});
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% collap trials into one
  %acoheM = SVMUmuaAv(FileBase,Eeg,spike,trial.itv,find(ctype.num==2),overwrite,1,'.acoherenceM');
  %[gcells,overwrite,PLOT,OutFile,PrintBase,PRINTFIG,EegRate,SampleRate] = DefaultArgs(varargin,{[],1,0,'.acoherence','Out',0,1250,20000});
  

  %%%%%%%%%%%%%%%%%%%
  %% overall theta
  %if ~FileExists([FileBase '.phasestat']) | 1
  %  PhH = myPhaseOfTrain(spike.ph,spike.ind);
  %  save([FileBase '.phasestat'],'PhH')
  %end
  %dummy = load([FileBase '.phasestat'],'-MAT');
  %PhH = CatStruct(dummy.PhH);
  %clear dummy;
  %ALL(f).PhH = PhH;
  %ALL(f).type = ctype.num;
  %PlotSfN08Phase
  
end

%% polar plot of phases

return;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RATE
if 0
  %% Rate
  [t, ratet, d, rated] = AvRate(round(spike.t/SampleRate*EegRate),spike.ind,spike.whl,wheel.dist,run(find(wheel.dir==2),:));
  %% find 'good' cells
  
  gc = find(ctype.num==2 & max(ratet)>2); 
  plot(ratet(1:end-20,gc))
  imagesc((ratet(1:end-20,gc))')
  
  %score = Placeness(ratet(1:end-20,gc));
  [PeakRate]= max(ratet(1:end-20,:));
  
  
  %%%% rate vs. phase
  [spk ind] = SelectPeriods(round(spike.t/16),run,'d',1,1);
  [Rate rawRate RBin] = InstantRate(FileBase,spk,spike.ind(ind),0);
  %
  ThPhase = InternThetaPh(FileBase);
  the = mod(ThPhase.deg(find(WithinRanges([1:length(Eeg)],run)))+2*pi,2*pi);
  
  m=0;
  for n=1:size(Rate,2)
    
    if PeakRate<2
      continue;
    end
    m=m+1;
    n
    
    [Av Std Bins Occ] = MakeAvF(the*180/pi,Rate(:,n),36);
    
    X = round(the*180/pi);
    Y = Rate(:,n);
    I = find(Y>0);
    [OccMap SOccMap Bin1 Bin2] = MakeOccMap([X(I) Y(I)],[36 100],[],0);
    
    PhRat.Av(:,m) = Av;
    PhRat.Std(:,m) = Std;
    PhRat.bins(:,:,m) = Bins{1};
    PhRat.bin1(:,m) = Bin1;
    PhRat.bin2(:,m) = Bin2;
    PhRat.cell(m) = n;
    PhRat.celltype(m) = ctype.num(n);
    
    figure(34756);clf;
    subplot(221)
    plot(Bins{1},Av)
    hold on
    plot(Bins{1},Av-Std,'--')
    plot(Bins{1},Av+Std,'--')
    
    subplot(222)
    plot(Bins{1},Occ)
    
    subplot(223)
    imagesc(Bin1,Bin2,SOccMap')
    colorbar
    axis xy
    
    subplot(224)
    plot(Rate(:,n))
    
    
    WaitForButtonpress;
    
  end
  
end
    
  
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
  
  
    %%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%
  
  %AA = Accumulate(ALL(f).compr.Spair,ALL(f).compr.Sdt,[max(spike.ind) max(spike.ind)]);
  %AAM = Accumulate(ALL(f).comprM.Spair,ALL(f).comprM.Sdt,[max(spike.ind) max(spike.ind)]);
  %Occ = Accumulate(ALL(f).compr.Spair,1,[max(spike.ind) max(spike.ind)]);
  %OccM = Accumulate(ALL(f).comprM.Spair,1,[max(spike.ind) max(spike.ind)]);
  %AAM(find(AA==0))=0;
  %AA(find(AAM==0))=0;
  %MM = abs(AAM-AA);
  %MO = Occ.*OccM;
  %MM(find(MO==0))=min(min(MM(find(MO~=0))))-(max(max(MM(find(MO~=0))))-min(min(MM(find(MO~=0)))))/63;
  %figure
  %subplot(311)
  %imagesc(AA)
  %axis xy
  %subplot(312)
  %imagesc(AAM)
  %axis xy
  %subplot(313)
  %imagesc(MM)
  %colorbar
  %colormap('default')
  %cc = colormap;
  %cc(1,:) = [0 0 0];
  %colormap(cc)
  %imagesc(MM)
  %colorbar
  %axis xy
  %figure
  %bin = [floor(min(min(MM))):ceil(max(max(MM)))];
  %Kbin = bin(1:end-1)+0.5;
  %KK = histcI(MM(find(MM>min(min(MM)))),bin); 
  %bar(Kbin,KK)
  %hold on
  %KAA = histcI(abs(ALL(f).compr.Sdt),bin);
  %plot(Kbin,KAA)
  %KAM = histcI(abs(ALL(f).comprM.Sdt),bin);
  %plot(Kbin,KAM,'r')
  %hold off
  
  
  
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


