  
  %% wrap around for computng comression index.
  %% ACHTUNG!! does not work well yet!!!
  
  
  AllTrial = CatStruct(trial);
    pos = round(whl.lin(WithinRanges([1:length(whl.lin)],AllTrial.itv) & round(whl.lin)>0));
    HCcells = find(ismember(spike.clu(:,1),find(elc.region==1)));
    
    Eeg = GetEEG(FileBase);
    xcorrlM = SVMUccg(FileBase,Eeg,spike,trial.itv,0,0,'.xcorrM');
    GoodPC = xcorrlM.goodPC(ismember(xcorrlM.goodPC,HCcells));
    GoodIN = xcorrlM.goodIN(ismember(xcorrlM.goodIN,HCcells));
    
    ix = ismember(spike.ind,GoodPC) & WithinRanges(round(spike.t/SampleRate*WhlRate),AllTrial.itv) & spike.lpos(:,1)>0 & spike.good;
    %ix = ismember(spike.ind,GoodSP{2}) & WithinRanges(round(spike.t/SampleRate*WhlRate),AllTrial.itv) & spike.lpos(:,1)>0 & spike.good;
    ALL(f).cmprs = CompressIndx(FileBase,spike.t(ix),spike.ind(ix),spike.lpos(ix),pos,[],10,1,[-50 30],[-500 400]);
    
    figure(f+100);clf
    subplot(211)
    cmpr = ALL(f).cmprs;
    plot(cmpr.posx,cmpr.thetat,'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
    hold on
    plot([-100:100],cmpr.cmprp(1)+cmpr.cmprp(2)*[-100:100],'r--')
    axis tight
    xlim([-100 100])
    ylim([-200 200])
    xlabel('\Delta distance [cm]','FontSize',16)
    ylabel('\Delta time [ms]','FontSize',16)
    c = round(cmpr.cmprp(2)*10)/10;
    text(-70,150,['c=' num2str(c) ' [ms/cm]'],'FontSize',16);
    set(gca,'FontSize',16,'TickDir','out')
    box off
    %
    subplot(212)
    plot(cmpr.fieldt,cmpr.thetat,'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
    hold on
    plot([-1000:1000],cmpr.cmprt(1)+cmpr.cmprt(2)*[-1000:1000],'r--')
    axis tight
    xlim([-1000 1000])
    ylim([-100 100])
    xlabel('\Delta time [ms]','FontSize',16)
    ylabel('\Delta time [ms]','FontSize',16)
    c = round(cmpr.cmprt(2)*10)/10;
    text(-900,70,['c=' num2str(c)],'FontSize',16);
    set(gca,'FontSize',16,'TickDir','out')
    box off
    
    if info.Wheel
      pos = round(wheel.dist(find(WithinRanges([1:length(wheel.dist)],wheel.runs)))/2/pi);
      ix = ismember(spike.ind,GoodPC) & WithinRanges(round(spike.t/SampleRate*WhlRate),wheel.runs) & spike.good;
      spike.wpos = wheel.dist(round(spike.t/SampleRate*wheel.whlrate))/2/pi;
      ALL(f).wcmprs = CompressIndx(FileBase,spike.t(ix),spike.ind(ix),spike.wpos(ix),pos,[],5);    
      
      figure(f+200);clf
      cmpr = ALL(f).wcmprs;
      subplot(211)
      plot(cmpr.posx,cmpr.thetat,'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
      hold on
      plot([-200 200],cmpr.cmprp(1)+cmpr.cmprp(2)*[-200 200],'r--')
      axis tight
      xlim([-200 200])
      ylim([-100 100])
      xlabel('\Delta distance [cm]','FontSize',16)
      ylabel('\Delta time [ms]','FontSize',16)
      c = round(cmpr.cmprp(2)*10)/10;
      text(-150,70,['c=' num2str(c) ' [ms/cm]'],'FontSize',16);
      set(gca,'FontSize',16,'TickDir','out')
      box off
      %
      subplot(212)
      plot(cmpr.fieldt,cmpr.thetat,'o','markersize',5,'markerfacecolor',[1 1 1]*0,'markeredgecolor',[1 1 1]*0)
      hold on
      plot([-1000 1000],cmpr.cmprt(1)+cmpr.cmprt(2)*[-100 100],'r--')
      axis tight
      xlim([-1000 1000])
      ylim([-100 100])
      xlabel('\Delta time [ms]','FontSize',16)
      ylabel('\Delta time [ms]','FontSize',16)
      c = round(cmpr.cmprt(2)*10)/10;
      text(-900,70,['c=' num2str(c) ' [ms/cm]'],'FontSize',16);
      set(gca,'FontSize',16,'TickDir','out')
      box off

    end
    
