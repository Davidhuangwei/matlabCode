function InternRSpect(FileBase,PlaceCell,Eeg,spike,whl,trial,varargin)
[overwrite,plotting] = DefaultArgs(varargin,{0,1});

%% compute spectra in time and space of interneurons, field and coherence. 

RateFactor = 20000/whl.rate;
EegRateFac = 1250/whl.rate;
%% Interneurons
IN = unique(PlaceCell.ind(find(PlaceCell.ind(:,5)==2),1));

if ~FileExists([FileBase '.intspect']) | overwrite
  
  %mtptchd_segs
  x=Eeg;
  nFFT = 2^13;
  Fs = 1250;
  nOverlap = [];
  NW = 2;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 20];
  CluSubset = [];
  pval = [];
 
  %% good spikes/intervals
  gspikes = find(ismember(spike.ind,IN) & WithinRanges(round(spike.t/RateFactor),[min(trial.itv(:,1)) max(trial.itv(:,2))]) & spike.good);
  Res = round(spike.t(gspikes)/16);
  Clu = spike.ind(gspikes);
  WinLength = 2500;%1250;
  
  Starts = [min(Res):1250/2:max(Res)];
  StartsInd = find(WithinRanges(Starts/EegRateFac,trial.itv));
  for m=1:length(StartsInd)
    [y(:,:,:,m),f,phi,yerr,phierr]=mtptchd_segs(x,Res,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset,Starts(StartsInd(m)));
    %for n=1:length(IN)
    %  [Corr(:,m,n) Lags] = xcorr(y(:,1,1,m),y(:,n,n,m));
    %end
  end
  y=permute(y,[4 1 2 3]);
  
  goodf = find(f>4 & f<12);
  for m=1:length(StartsInd)
    for n=1:length(IN)
      [Corr(:,m,n) Lags] = xcorr(squeeze(y(m,goodf,n,n)),squeeze(y(m,goodf,1,1)),'unbiased');
      [Max Mlag] = max(Corr(:,m,n));
      MaxCorr(:,n,m) = [Max Lags(Mlag)*diff(f(1:2))];
    end
  end
 
  
  %% good y
  for n=1:length(StartsInd)
    nsp(n) = length(find(WithinRanges(Res,[Starts(StartsInd(n)) Starts(StartsInd(n))+WinLength])));
  end
  
  %% position of Segments
  Pos = round(whl.lin(round((Starts(StartsInd)+WinLength/2)/EegRateFac)));
  Dir = whl.dir(round((Starts(StartsInd)+WinLength/2)/EegRateFac));
  uDir = unique(Dir(find(Dir>1)));
  
  %% Speed of segments
  for n=1:length(StartsInd)
    kk = whl.speed(round(Starts(StartsInd(n))/EegRateFac):round((Starts(StartsInd(n))+WinLength)/EegRateFac),2);
    if isempty(find(kk>-1))
      Speed(n) = 0;
    else
      Speed(n) = mean(kk(find(kk>-1)));
    end
  end
  
  keyboard
  
  for p=1:max(Pos)
    for d=1:length(uDir)
      gsegs = find(ismember(Pos,[p:p+5]) & nsp'>10 & Dir==uDir(d));
      posy(p,:,:,:,d) = nanmean(y(gsegs,:,:,:),1);
      %gsegs = find(ismember(Pos,[p:p+1]) & nsp'>10 & Dir==3);
      %posy3(p,:,:,:) = mean(y(gsegs,:,:,:),1);
    end
  end

  %% save
  IntSpect.x = [1:max(Pos)];
  IntSpect.f = f;
  IntSpect.t = (Starts(StartsInd)+WinLength/2)/1250;
  IntSpect.yt = y;
  IntSpect.yx = posy;
  IntSpect.IN = IN;
  IntSpect.corr = Corr;
  IntSpect.corrf = Lags*diff(f(1:2));
  IntSpect.corrmax = MaxCorr;
    
  save([FileBase '.intspect'],'IntSpect')
else 
  load([FileBase '.intspect'],'-MAT');
end
  
%keyboard
if plotting
  myf = find(IntSpect.f>2 & IntSpect.f<15);
  for n=2:length(IN)+1
    figure(3987);clf
    subplot(311)
    imagesc(IntSpect.x,IntSpect.f,log(squeeze(IntSpect.yx(:,:,1,1,1)))'); axis xy
    set(gca,'FontSize',16,'TickDir','out'); box off;
    ylabel('frequency [Hz]','FontSize',16);
    ylim([4 12])
    [maxx maxi] = max(log(squeeze(IntSpect.yx(:,:,1,1,1)))');
    hold on
    plot(IntSpect.x,IntSpect.f(maxi),'o','markersize',5,'markeredgecolor',[0 0 0],'markerfacecolor',[0 0 0])
    Lines([],[mean(IntSpect.f(maxi)) mean(IntSpect.f(maxi))],[],'--',2);
    subplot(312)
    imagesc(IntSpect.x,IntSpect.f,log(squeeze(IntSpect.yx(:,:,n,n,1)))'); axis xy
    set(gca,'FontSize',16,'TickDir','out'); box off;
    ylabel('frequency [Hz]','FontSize',16);
    ylim([4 12])
    [maxx maxii] = max(log(squeeze(IntSpect.yx(:,myf,n,n,1)))');
    hold on
    plot(IntSpect.x,IntSpect.f(myf(maxii)),'o','markersize',5,'markeredgecolor',[0 0 0],'markerfacecolor',[0 0 0])
    Lines([],[mean(IntSpect.f(maxi)) mean(IntSpect.f(maxi))],[],'--',2);
     %subplot(413)
    %imagesc(IntSpect.x,IntSpect.f,(squeeze(IntSpect.yx(:,:,1,n,1)))'); axis xy
    %set(gca,'FontSize',16,'TickDir','out'); box off;
    %ylabel('frequency [Hz]','FontSize',16);
    subplot(313)
    for nn=1:size(squeeze(IntSpect.yx(:,:,n,n,1)),1)
      [XX(nn,:) XXlag] = xcorr(squeeze(IntSpect.yx(nn,:,1,1,1)),squeeze(IntSpect.yx(nn,:,n,n,1)));
      [XXmax(nn) XXmaxlag(nn)] = max(XX(nn,:));
    end
    imagesc(IntSpect.x,-XXlag,unity(XX')); 
    set(gca,'FontSize',16,'TickDir','out'); box off;
    hold on
    plot(IntSpect.x,-XXlag(XXmaxlag),'o','markersize',5,'markeredgecolor',[0 0 0],'markerfacecolor',[0 0 0])
    ylim([-15 15]);axis xy;
    Lines([],[0 0],[],'--',2);
    xlabel('distance [cm]','FontSize',16);
    ylabel('\Delta frequency [Hz]','FontSize',16);
    
    %subplot(422)
    %imagesc(IntSpect.x,IntSpect.f,log(squeeze(IntSpect.yx(:,:,1,1,2)))'); axis xy
    %subplot(424)
    %imagesc(IntSpect.x,IntSpect.f,log(squeeze(IntSpect.yx(:,:,n,n,2)))'); axis xy
    %subplot(426)
    %imagesc(IntSpect.x,IntSpect.f,(squeeze(IntSpect.yx(:,:,1,n,2)))'); axis xy
    %subplot(428)
    %for nn=1:size(squeeze(IntSpect.yx(:,:,n,n,1)),1)
    %  [XX(nn,:) XXlag] = xcorr(squeeze(IntSpect.yx(nn,:,1,1,2)),squeeze(IntSpect.yx(nn,:,n,n,2)));
    %  [XXmax(nn) XXmaxlag(nn)] = max(XX(nn,:));
    %end
    %imagesc(IntSpect.x,XXlag,XX'); ylim([-20 20]);
    %hold on
    %plot(IntSpect.x,XXlag(XXmaxlag),'.k')
    %Lines([],[0 0]);
    
    figure(2837);clf
    subplot(411)
    imagesc(IntSpect.t,IntSpect.f,log(squeeze(IntSpect.yt(:,:,1,1)))'); axis xy
    subplot(412)
    imagesc(IntSpect.t,IntSpect.f,log(squeeze(IntSpect.yt(:,:,n,n)))'); axis xy
    subplot(413)
    imagesc(IntSpect.t,IntSpect.f,(squeeze(IntSpect.yt(:,:,1,n)))'); axis xy
    subplot(414)
    imagesc(IntSpect.t,IntSpect.corrf,unity(squeeze(IntSpect.corr(:,:,n-1)))); axis xy
    hold on
    plot(IntSpect.t,squeeze(IntSpect.corrmax(2,n-1,:)),'.k');
    
    %waitforbuttonpress
  end
end
return;


%%%%%%%%%%%%%%%%%%
if plotting
  for n=2:length(IN)+1
    figure(3987);clf
    subplot(311)
    imagesc([1:max(Pos)],f,log(squeeze(posy(:,:,1,1)))'); ylim([1 15]); axis xy
    subplot(312)
    imagesc([1:max(Pos)],f,log(squeeze(posy(:,:,n,n)))'); ylim([1 15]); axis xy
    subplot(313)
    imagesc([1:max(Pos)],f,(squeeze(posy(:,:,1,n)))'); ylim([1 15]); axis xy
    
    figure(2837);clf
    subplot(311)
    imagesc((Starts(StartsInd)+WinLength/2)/1250,f,log(squeeze(y(:,:,1,1)))'); ylim([1 15]); axis xy
    subplot(312)
    imagesc((Starts(StartsInd)+WinLength/2)/1250,f,unity(squeeze(y(:,:,n,n))')); ylim([1 15]); axis xy
    subplot(313)
    imagesc((Starts(StartsInd)+WinLength/2)/1250,f,squeeze(y(:,:,1,n))'); ylim([1 15]); axis xy
    
    waitforbuttonpress
  end
end
