function Spect = PhaseTimeSpectFix(FileBase,spike,Eeg,type,varargin)
[overwrite,plotting] = DefaultArgs(varargin,{0,0});

if ~FileExists([FileBase '.PhaseTimeSpectEeg']) | overwrite
  
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
  
  %% compute phase precession slope for all  
  Res = round(spike.t(indx)/16);
  Clu = spike.ind(indx);
  nFFT = 2^12; %1024;
  Fs = 1250;
  WinLength = nFFT/2;%1250;
  nOverlap = WinLength*(1-1/8);%625;
  NW = 3;
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  CluSubset = allclu;%(find(type.num==1));
  CluSubset2 = CluSubset(1);
  %CluSubset2 = [1:2];
  
  [y,f,t] = mtptcsdGnew(Eeg,Res,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset2);
  
  Spect.y = y;
  Spect.t = t;
  Spect.f = f;
  Spect.cells = CluSubset2;
  
  save([FileBase '.PhaseTimeSpectEeg'],'Spect');
else
  load([FileBase '.PhaseTimeSpectEeg'],'-MAT');
end
SpectEeg = Spect;
load([FileBase '.PhaseTimeSpect'],'-MAT');

keyboard

  
if plotting
  y = Spect.y;
  t = Spect.t;
  f = Spect.f;
  CluSubset2 = Spect.cells;
  
  figure(236);clf
  subplot(311)
  imagesc(t,f,log(sq(y(:,:,1)))')
  axis xy;
  caxis([0 max(max(log(sq(y(:,:,1)))))*0.9])
  hold on
  [dummy kk] = max(sq(y(:,:,1))');
  plot(t,f(kk),'o','markersize',5,'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])
  
  ttitle = {'interneuron', 'pyramidal cell', 'undecided'};
  
  %figure(237);clf
  for ccn=2:size(y,3)
    
    subplot(312);
    imagesc(t,f,log(sq(y(:,:,ccn)))')
    axis xy;
    hold on
    ywin = y;
    ywin(:,find(f<4 | f>15),:) = 0;
    [dummy ll] = max(sq(ywin(:,:,ccn))');
    title(ttitle{type.num(CluSubset2(ccn-1))});
    
    goodsegs = find(f(ll)>f(1));
    if isempty(goodsegs)
      continue;
    end
    
    plot(t(goodsegs),f(kk(goodsegs)),'o','markersize',5,'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0])
    plot(t(goodsegs),f(ll(goodsegs)),'o','markersize',5,'markerfacecolor',[0 1 0],'markeredgecolor',[0 1 0])
    hold off 
    
    subplot(325)
    plot(f(kk(goodsegs)),f(ll(goodsegs)),'o','markersize',5,'markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0]);
    xlabel('Eeg')
    ylabel('Unit')
    ff = [f(kk(goodsegs)); f(ll(goodsegs))];
    xlim([floor(min(ff)) ceil(max(ff))])
    ylim([floor(min(ff)) ceil(max(ff))])
    hold on
    plot([floor(min(ff)) ceil(max(ff))],[floor(min(ff)) ceil(max(ff))],'--','color',[0 0 0], 'LineWidth',2)
    
    waitforbuttonpress;
  end
end
