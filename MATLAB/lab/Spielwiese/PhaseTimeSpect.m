function Spect = PhaseTimeSpect(FileBase,spike,Eeg,type,varargin)
[overwrite,plotting] = DefaultArgs(varargin,{0,0});

if ~FileExists([FileBase '.PhaseTimeSpect']) | overwrite
  
  load([FileBase '.elc'],'-MAT');
  allclu = find(ismember(spike.clu(:,1),find(elc.region==1)));
  maxclu = max(allclu);
  minclu = min(allclu);
  
  %% compute spectra for overlapping windows for each state
  %% using only spikes within good theta. 
  
  indx = find(ismember(spike.ind,allclu) & spike.good);
  
  %% cut into segments for whole file!!! do state
  %% segmentation afterwards! 
  Itvs = [1:length(Eeg)];
  
  %% compute spectra of spikes and field for all segments which contain spikes.
  Res = round(spike.t(indx)/16);
  Clu = spike.ind(indx);
  nFFT = 2^12; %1024;
  Fs = 1250;
  WinLength = nFFT/2;%1250;
  nOverlap = [];%625;
  NW = 3;
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  CluSubset = allclu;%(find(type.num==1));
  CluSubset2 = CluSubset(1:2);
  
  [y,f,t] = mtptcsdGnew(Eeg,Res,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange, CluSubset2);
  
  Spect.y = y;
  Spect.t = t;
  Spect.f = f;
  Spect.cells = CluSubset2;
  
  save([FileBase '.PhaseTimeSpect'],'Spect');
else
  load([FileBase '.PhaseTimeSpect'],'-MAT');
end
  
%WinLength = 2^11;
%nOverlap = WinLength*(1-1/8);
%Spect.t = ([1:size(Spect.y,1)]*(WinLength-nOverlap) - (WinLength/2-nOverlap))/1250;
%save([FileBase '.PhaseTimeSpect'],'Spect');

if plotting

  y = Spect.y;
  t = Spect.t;
  f = Spect.f;
  CluSubset2 = Spect.cells;
  clear Spect;
  
  %% modify count
  TT = t*1250;
  AA = size(y,3);
  LL = 2^11;
  SpT = round(spike.t(find(spike.good))/16);
  for NN = 1:length(TT)
    XX = find(SpT >TT(NN)-LL/2 & SpT <= TT(NN)+LL/2);
    if isempty(XX)
      Count(NN,:) = zeros(AA,1)';
    else
      Count(NN,:) = histcI(spike.ind(XX),[1:AA+1]-0.5);
    end
    if mod(NN,500)==0
      fprintf([num2str(NN) ' ..... ']);
    end
  end
  
  keyboard
  
  %[FA FB] = find(Count<5);
  for NN = 1:size(Count,2)
    y(find(Count(:,NN)<5),:,NN) = 0;
  end
  
  
  figure(236);clf
  subplot(311)
  imagesc(t,f,log(sq(y(:,:,1)))')
  axis xy;
  caxis([0 max(max(log(sq(y(:,:,1)))))*0.9])
  hold on
  [dummy kk] = max(sq(y(:,:,1))');
  plot(t,f(kk),'o','markersize',5,'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])
  
  ttitle = {'interneuron', 'pyramidal cell', 'undecided'};
  
  %% get number of spikes for each segment 
  
  %figure(237);clf
  for ccn=2:size(y,3)
    
    %% changing the tolerance for good segments: counting spikes
    
    
    subplot(312);
    imagesc(t,f,log(sq(y(:,:,ccn)))')
    axis xy;
    hold on
    ywin = y;
    %ywin(:,find(f<4 | f>15),:) = 0;
    [dummy ll] = max(sq(ywin(:,:,ccn))');
    title(['cell no. ' num2str(ccn-1) '(' num2str(type.elec(ccn-1)) '|' num2str(type.cell(ccn-1)) ') is ' ttitle{type.num(CluSubset2(ccn-1))}]);
    
    goodsegs = find(f(ll)>f(1));
    if isempty(goodsegs)
      continue;
    end
    
    plot(t(goodsegs),f(kk(goodsegs)),'o','markersize',5,'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])
    plot(t(goodsegs),f(ll(goodsegs)),'o','markersize',5,'markerfacecolor',[0 1 0],'markeredgecolor',[0 1 0])
    hold off 
    
    
    %% ADD: different color for REM and RUN
    %% ADD: number of spikes per segment - redefine threshold. 
    subplot(325)
    plot(f(kk(goodsegs)),f(ll(goodsegs)),'o','markersize',5,'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0]);
    xlabel('Eeg')
    ylabel('Unit')
    ff = [f(kk(goodsegs)); f(ll(goodsegs))];
    xlim([floor(min(ff)) ceil(max(ff))])
    ylim([floor(min(ff)) ceil(max(ff))])
    hold on
    plot([floor(min(ff)) ceil(max(ff))],[floor(min(ff)) ceil(max(ff))],'--','color',[0 0 0], 'LineWidth',2)
    hold off
    
    waitforbuttonpress;
  end
  
  keyboard
  
end
