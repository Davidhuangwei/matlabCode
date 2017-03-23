function C = SVMUCompFact(FileBase,spiket,spikei,spikep,run,varargin)
%function C = SVMUCompFact(FileBase,spiket,spikei,spikep,run,varargin)
%
% compute compression index
%
% spiket and run in same sampling rate!
%
[overwrite,rundir,Cells,OutFile,EegRate,PLOT] = DefaultArgs(varargin,{0,[],[],'compfact',1250,0});

overwrite = 1;

if ~FileExists([FileBase OutFile]) | overwrite
  
  
  if isempty(rundir)
    dire=2;
    rundir = ones(size(run,1),1)*2;
  else
    dire = unique(rundir(find(rundir>=2)));
    if size(dire,1)>size(dire,2)
      dire=dire';
    end
  end
    
  if isempty(Cells)
    Cells = unique(spikei);
  end
  
  %%%%%%%%%%%%%%%%%%%%
  %% small time lag
  cyi = [];
  cy  = [];
  ctd = [];
  for d=dire
    gindx = find(WithinRanges(spiket,run(rundir==d,:)) & ismember(spikei,Cells));
    gcells = unique(spikei(gindx));
    dt = round(5/1000*EegRate);
    [ccg, t] = CCG(spiket(gindx),spikei(gindx),dt,50,EegRate);
    [y yi] = GetOffDiagonal(ccg);
    cy = [cy y];
    cyi = [cyi; gcells(yi)];
    ctd = [ctd; repmat(d,max(size(yi)),1)];
  end
  
  %% find good pairs
  gpairs = mean(cy)>5;
  gg = find(gpairs);
  
  %keyboard
  
  %% smooth ccg
  %scy2 = reshape(smooth(cy(:,gpairs),round(100/mean(diff(t))),'lowess'),length(t),[]);
  scy = ButFilter(cy(:,gpairs),2,9/(1000/mean(diff(t))/2),'low');
  
  %% find local extrema closest to zero
  %% maxima
  xx = reshape(scy,1,[]);
  lm = LocalMinima(-xx,50/mean(diff(t)));
  T = (repmat(t,1,size(scy,2)));
  [mm mx my] = NearestNeighbour(lm,find(T==0),'both',length(t)/2);
  gmx = T(lm(mx));
  amp = xx(lm(mx));
  %% closest minima
  lm2 = LocalMinima(xx,50/mean(diff(t)));
  %[mm2 mx2 my2] = NearestNeighbour(lm2,find(T==0),'both',length(t)/2);
  [mm2 mx2 my2] = NearestNeighbour(lm2,lm(mx),'both',length(t)/2);
  gmx2 = T(lm2(mx2));
  amp2 = xx(lm2(mx2));
  
  gg2 = find(amp2./amp<0.7 & amp>1);
  
  a = amp-amp2;
  b = amp2./amp;
  c =  gmx2 - gmx;
  
  C.Sxcorr = scy(:,gg2);
  C.Sxcorrt = t;
  C.Spair = cyi(gg(gg2),:);
  C.Strisldir = ctd;
  C.Sdt = gmx(gg2);
  
  %%%%%%%%%%%%%%%%%%%
  %% field distance - time
  cyi = [];
  cy  = [];
  ctd = [];
  for d=dire
    gindx = find(WithinRanges(spiket,run(rundir==d,:)) & ismember(spikei,Cells));
    gcells = unique(spikei(gindx));
    dt = round(50/1000*EegRate);
    [ccg, t] = CCG(spiket(gindx),spikei(gindx),dt,50,EegRate);
    [y yi] = GetOffDiagonal(ccg);
    cy = [cy y];
    cyi = [cyi;gcells(yi)];
    ctd = [ctd; repmat(d,max(size(yi)),1)];
  end
   
  %% smooth ccg
  scy = ButFilter(cy(:,gg(gg2)),2,1/(1000/mean(diff(t))/2),'low');
  %scy2 = reshape(smooth(cy(:,gpairs),round(2000/mean(diff(t))),'lowess'),length(t),[]);

  %% find local minima closest to zero
  xx = reshape(scy,1,[]);
  lm = LocalMinima(-xx,50/mean(diff(t)));
  T = (repmat(t,1,size(scy,2)));
  [mm mx my] = NearestNeighbour(lm,find(T==0),'both',length(t)/2);
  gmx = T(lm(mx));
  
  %% find max
  [mm mi] = max(scy);  
  
  % save
  C.Lxcorr = scy;
  C.Lxcorrt = t;
  C.Lpair = cyi(gg(gg2),:);
  C.Ltrisldir = ctd(gg(gg2));
  C.Ldt = gmx;
  C.Ldtmax = t(mi);
  
    
  gx = find(C.Ldt>-500 & C.Ldt<500);
  plot(C.Ldt(gx),C.Sdt(gx),'.')
  [b] = robustfit(C.Ldt(gx),C.Sdt(gx));
  hold on
  plot([-800:800],b(1)+b(2)*[-800:800],'--r')
  hold off
  [r p] = RankCorrelation(C.Ldt(gx),C.Sdt(gx))
  
  
  
  %keyboard
  
  

  
  
  %%%%%%%%%%%%%%%%%%%
  %% field distance - distance in cm
  cyi = [];
  cy  = [];
  ctd = [];
  for d=dire
    gindx = find(WithinRanges(spiket,run(rundir==d,:)) & ismember(spikei,Cells));
    gcells = unique(spikei(gindx));
    
    [XP XI] = sort(spikep(gindx));
    
    [ccg, t] = CCG(round(round(spikep(gindx(XI))*100)),spikei(gindx(XI)),1000,100,100);
    [y yi] = GetOffDiagonal(ccg);
    cy = [cy y];
    cyi = [cyi;gcells(yi)];
    ctd = [ctd; repmat(d,max(size(yi)),1)];
  end
   
  %% smooth ccg
  scy = reshape(smooth(cy(:,gpairs),20,'lowess'),length(t),[]);
  %scy = ButFilter(cy(:,gpairs),2,2/(1000/mean(diff(t))/2),'low');

  %for n=1:size(scy,2)
  %  figure(3);clf
  %  plot(t/1000,cy(:,gg(n)))
  %  hold on;
  %  plot(t/1000,scy(:,n),'r')
  %  WaitForButtonpress
  %end
  
  
  [mm mi] = max(scy);
  
  %  for n=1:size(scy,2)
  %    plot(t,cy(:,gg(n)),'k')
  %    hold on
  %    plot(t,scy(:,n))
  %    %plot(t,scy2(:,n),'r')
  %    %Lines(t(gmx(n)));
  %    Lines(t(mi(n)),[],'g');
  %    hold off
  %    WaitForButtonpress
  %  end
 
  % save
  C.Pxcorr = scy;
  C.Pxcorrt = t/1000;
  C.Ppair = cyi(gpairs,:);
  C.Ptrisldir = ctd(gpairs);
  C.Pdt = t(mi)/1000;

  
  %%%%%%%%%%%%%%%%%
  save([FileBase OutFile],'C')
  
  
else
  
  load([FileBase OutFile],'-MAT')
  
end
  
%% PLOT
if PLOT

  figure(1);clf
  subplot(311)
  imagesc(C.Sxcorrt,[],unity(C.Sxcorr)');
  axis xy
  hold on
  plot(C.Sdt,[1:length(C.Sdt)],'k.')
  hold off
  xlabel('time [ms]','FontSize',16)
  ylabel('cells #','FontSize',16)
  %
  subplot(312)
  imagesc(C.Lxcorrt,[],unity(C.Lxcorr)');
  axis xy
  hold on
  plot(C.Ldt,[1:length(C.Ldt)],'k.')
  plot(C.Ldtmax,[1:length(C.Ldt)],'ko')
  hold off
  xlabel('time [ms]','FontSize',16)
  ylabel('cells #','FontSize',16)
  %
  subplot(313)
  imagesc(C.Pxcorrt,[],unity(C.Pxcorr)');
  axis xy
  hold on
  plot(C.Pdt,[1:length(C.Pdt)],'k.')
  hold off
  xlabel('distance [cm]','FontSize',16)
  ylabel('cells #','FontSize',16)
  
  %%%
  
  figure(2);clf
  subplot(321)
  plot(C.Pdt,C.Ldt,'k.')
  hold on
  %[a b] = robustfit(C.Pdt,C.Ldt);
  %plot([min(C.Pdt) max(C.Pdt)],a(2)*[min(C.Pdt) max(C.Pdt)]+a(1),'--','color',[1 0 0],'LineWidth',2)
  [a b] = robustfit(C.Ldt,C.Pdt);
  plot(a(2)*[min(C.Ldt) max(C.Ldt)]+a(1),[min(C.Ldt) max(C.Ldt)],'--','color',[1 0 0],'LineWidth',2)
  text(min(C.Pdt),max(C.Ldt),['p=' num2str(round(b.p(2)*100)/100)],'FontSize',16)
  xlabel('distance [cm]','FontSize',16)
  ylabel('time [sec]','FontSize',16)
  %axis tight
  %
  subplot(322)
  comp = C.Pdt./C.Ldt;
  comp(find(C.Ldt==0)) = 0;
  hist(abs(comp)*10,50)
  xlabel('running speed [cm/s]','FontSize',16)
  ylabel('count','FontSize',16)
  %
  subplot(323)
  plot(C.Pdt,C.Sdt,'k.')
  hold on
  %[a b] = robustfit(C.Pdt,C.Sdt);
  %plot([min(C.Pdt) max(C.Pdt)],a(2)*[min(C.Pdt) max(C.Pdt)]+a(1),'--','color',[1 0 0],'LineWidth',2)
  [a b] = robustfit(C.Sdt,C.Pdt);
  plot(a(2)*[min(C.Sdt) max(C.Sdt)]+a(1),[min(C.Sdt) max(C.Sdt)],'--','color',[1 0 0],'LineWidth',2)
  text(min(C.Pdt),max(C.Sdt),['p=' num2str(round(b.p(2)*100)/100)],'FontSize',16)
  xlabel('distance [cm]','FontSize',16)
  ylabel('time [sec]','FontSize',16)
  %
  subplot(324)
  comp = C.Sdt./C.Pdt;
  comp(find(C.Pdt==0)) = 0;
  hist(abs(comp),50)
  xlabel('comprssion idx [ms/cm]','FontSize',16)
  ylabel('count','FontSize',16)
  %
  subplot(325)
  plot(C.Ldt,C.Sdt,'.')
  hold on
  %[a b] = robustfit(C.Ldt,C.Sdt);
  %plot([min(C.Ldt) max(C.Ldt)],a(2)*[min(C.Ldt) max(C.Ldt)]+a(1),'--','color',[1 0 0],'LineWidth',2)
  [a b] = robustfit(C.Sdt,C.Ldt);
  plot(a(1)+a(2)*[min(C.Sdt) max(C.Sdt)],[min(C.Sdt) max(C.Sdt)],'--','color',[1 0 0],'LineWidth',2)
  text(min(C.Ldt),max(C.Sdt),['p=' num2str(round(b.p(2)*100)/100)],'FontSize',16)
  xlabel('time [sec]','FontSize',16)
  ylabel('time [sec]','FontSize',16)
  %
  %subplot(326)
  %comp = C.Pdt./C.Sdt;
  %comp(find(C.Sdt==0)) = 0;
  %hist(abs(comp),50)
  
  %keyboard
  
  figure(3);clf
  subplot(311)
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([C.Pdt' C.Sdt'],50,20);
  subplot(312)
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([C.Pdt' C.Ldt'],50,20);
  subplot(313)
  [OccMap SOccMap Bin1 Bin2] = MakeOccMap([C.Sdt' C.Ldt'],50,20);
end
  

return;

