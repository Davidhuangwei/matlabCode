function InterPhase = PhasePrecessIntern2(FileBase,PlaceCell,spike,whl,trial,Tune,Rate,Eeg,ThRpPh,varargin)
[overwrite, RepFig] = DefaultArgs(varargin,{1,0});
AllFigs = 0

PC=(PlaceCell.ind(:,5)==1);
IN=(PlaceCell.ind(:,5)==2);

ColPC = [216 41 0; 191 0 191]/255;

if isempty(IN)
  return
end

count=0;
for dire=unique(PlaceCell.ind(find(IN),4))';

  dire 
  
  gdir = find(trial.dir==dire);
  fields = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==2);
  [neurons nindx] = unique(PlaceCell.ind(fields,1));
    
  %% ccg between cells during theta! 
  Afields = find(PlaceCell.ind(:,4)==dire);
  PCfields = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==1);
  nspikeind = zeros(size(spike.ind));
  for n=1:length(Afields)
    pfindx = find(PlaceCell.trials(:,1)==Afields(n));
    spikeindx = spike.ind==PlaceCell.ind(Afields(n),1) & WithinRanges(round(spike.t/20000*whl.rate),PlaceCell.trials(pfindx,2:3)) & spike.good;
    nspikeind(find(spikeindx),1) = Afields(n); 
  end
  [ccg, t] = CCG(spike.t(find(nspikeind)),nspikeind(find(nspikeind)),80,20,20000,unique(nspikeind(find(nspikeind))));
    
  for n=1:1%length(fields)
    gspikes = spike.ind==PlaceCell.ind(fields(n),1) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv(gdir,:)) & spike.good;
    gpos = find(WithinRanges([1:size(whl.itv,1)],trial.itv(gdir,:)));
    
    if dire~=2
      continue
    end
    
    %% FIGURE
    figure(100);clf
    
    subplot(6,3,[1 2])
    gtrial = find(trial.dir(find(trial.dir>1))==dire);
    plot(mean(Tune.rate(gtrial,:,1)),'k','linewidth',2); 
    T1=text(60,15,'P1');
    T2=text(110,18,'P2');
    set(T1,'FontSize',16,'Color',ColPC(1,:))
    set(T2,'FontSize',16,'Color',ColPC(2,:))
  
    hold on;
    
    subplot(6,3,[4 5  7 8 10 11])
    PlotPhasegram(spike.t(find(gspikes)),spike.ph(find(gspikes)), spike.lpos(find(gspikes)),whl.lin(gpos));
    hold on
    ylabel('phase [deg]','FontSize',16);
    xlabel('distance [cm]','FontSize',16);
    set(gca,'YDir','normal','FontSize',16,'TickDir','out','YTick',[0:180:720])
    box off
    
    MarkSymbole = {'pentagram', 'o'};
    MarkSymSize = [12 8];
    TextArg = {'P1','P2'};
    TextPos = [-75 4.7; -75 5.7];
    %% ccg with all pyramidal cells:
    for m=1:2%length(PCfields)
      
      subplot(6,3,[1 2])
      plot(mean(Tune.rate(gtrial,:,m+1)),'Color',ColPC(m,:),'linewidth',2);
      ylabel('rate [Hz]')
      set(gca,'FontSize',16,'XTick',[],'TickDir','out')
      axis tight; box off
      
      subplot(6,3,[3 6]+(m-1)*6)
      H=bar(t,ccg(:,find(Afields==fields(n)),find(Afields==PCfields(m))));
      if m==2 
	xlabel('time [ms]','FontSize',16)
      end
      T = text(TextPos(m,1),TextPos(m,2),TextArg{m});
      set(T,'FontSize',16,'Color',ColPC(m,:))
      ylabel('rate [Hz]','FontSize',16)
      axis tight;
      %%ylim([0 round(TextPos(m,2))])
      set(gca,'FontSize',16,'TickDir','out','YTick',[0 round(TextPos(m,2))])
      set(H,'FaceColor',ColPC(m,:),'EdgeColor',ColPC(m,:))
      box off
      
      PCIntv = PlaceCell.trials(find(PlaceCell.trials(:,1)==PCfields(m)),2:3);	  
      PCSpikes = spike.ind==PlaceCell.ind(PCfields(m),1) & WithinRanges(round(spike.t/20000*whl.rate),PCIntv) & spike.good;	  
      BinsPC = [min(spike.lpos(PCSpikes)):2:max(spike.lpos(PCSpikes))];
      [mPC lPC uPC BinsPC] = BinSmoothE(spike.lpos(PCSpikes), spike.ph(PCSpikes), 'CircConf', BinsPC);
      
      subplot(6,3,[4 5 7 8 10 11])
      plot([BinsPC';BinsPC'], [mod(mPC*180/pi,360);mod(mPC*180/pi,360)+360],...
	   MarkSymbole{m},'markerfacecolor',ColPC(m,:),'markeredgecolor',ColPC(m,:),'markersize',MarkSymSize(m));
      set(gca,'YDir','normal','FontSize',16)
    end
  end
  
  clear Index Acc smAcc;
  
  %%%%%%%%
  n=1
  subplot(6,3,[13 16])
  H=bar(ThRpPh.binCorr,ThRpPh.histCorr(n,:),1);
  axis tight;xlim([-50 50]);ylim([0 60])
  xlabel('time [ms]','FontSize',16)
  ylabel('rate [Hz]','FontSize',16)
  set(gca,'FontSize',16,'TickDir','out')
  set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
  
  subplot(12,3,[29 32 35])
  H=bar(ThRpPh.binTh,ThRpPh.histTh(n,:)*100,1);
  axis tight;
  %Lines(mod(ThRpPh.mph(n,1)*180/pi,360));
  xlabel('phase [deg]','FontSize',16)
  ylabel('probability x100','FontSize',16)
  set(gca,'FontSize',16,'TickDir','out','XTick',[0:180:360])
  set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
    
  subplot(12,3,[30 33 36])
  H=bar(ThRpPh.binRp,ThRpPh.histRp(n,:),1);
  xlabel('time [ms]','FontSize',16)
  ylabel('rate [Hz]','FontSize',16)
  set(gca,'FontSize',16,'TickDir','out')
  set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
  axis tight; xlim([-100 100]);ylim([0 3]);
  
  subplot(12,3,26)
  plot([1:360],cos([1:360]/180*pi),'Color','k','LineWidth',2)
  axis tight; %axis off; 
  subplot(12,3,27)
  plot(ThRpPh.binRpsm,ThRpPh.histRpsm(n,:),'Color','k','LineWidth',2)
  axis tight; %axis off
  xlim([-100 100])

  %%%%%%%%%%%%
  
  ForAllSubplots('box off')
  
  waitforbuttonpress
  
end

return