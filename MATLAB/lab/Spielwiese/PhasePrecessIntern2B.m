function InterPhase = PhasePrecessIntern2B(FileBase,PlaceCell,spike,whl,trial,Tune,Rate,Eeg,ThRpPh,varargin)
[overwrite, RepFig] = DefaultArgs(varargin,{0,0});

AllFigs = 0

PC=(PlaceCell.ind(:,5)==1);
IN=(PlaceCell.ind(:,5)==2);

TuneN=unique(PlaceCell.ind(:,1));

ColPC = [216 41 0; 191 0 191]/255;

%%Subplot coordinates
sptune = [0.13 0.82 0.45 0.1];
spimage = [0.13 0.44 0.45 0.336];
spcolbar = [0.59 0.44 0.02 0.336];
spccgpc = [0.72 0.71 0.2 0.21; 0.72 0.44 0.2 0.21];
spinter = [0.13 0.11 0.2 0.245; 0.42 0.11 0.2 0.18; 0.72 0.11 0.2 0.18];
sptrigg = [0.42 0.29 0.2 0.085; 0.72 0.29 0.2 0.085];

if isempty(IN)
  return
end

count=0;
for dire=unique(PlaceCell.ind(find(IN),4))';
  
  dire 
  
  if dire==2
    continue
  end
  
  gdir = find(trial.dir==dire);
  fields = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==2);
  [neurons nindx] = unique(PlaceCell.ind(fields,1));
  
  %% ccg between cells during theta! 
  Afields = find(PlaceCell.ind(:,4)==dire);
  PCfieldsX = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==1);
  PCfields = PCfieldsX(2:3,1);
  nspikeind = zeros(size(spike.ind));
  for n=1:length(Afields)
    pfindx = find(PlaceCell.trials(:,1)==Afields(n));
    spikeindx = spike.ind==PlaceCell.ind(Afields(n),1) & WithinRanges(round(spike.t/20000*whl.rate),PlaceCell.trials(pfindx,2:3)) & spike.good;
    nspikeind(find(spikeindx),1) = Afields(n); 
  end
  [ccg, t] = CCG(spike.t(find(nspikeind)),nspikeind(find(nspikeind)),100,20,20000,unique(nspikeind(find(nspikeind))));
  [ccgpval, tpval, prc] = Ccgpval(FileBase,spike.t(find(nspikeind)),nspikeind(find(nspikeind)),spike.ph(find(nspikeind)),200,10,20000,100,[],[],trial.itv(gdir,:));
  
  %keyboard
  
  for n=3%:length(fields)
    gspikes = spike.ind==PlaceCell.ind(fields(n),1) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv(gdir,:)) & spike.good;
    gpos = find(WithinRanges([1:size(whl.itv,1)],trial.itv(gdir,:)));
    
     %% FIGURE
    figure(100);clf
    
    %keyboard
    
    %subplot(6,3,[1 2])
    subplot('Position',sptune);
    gtrial = find(trial.dir(find(trial.dir>1))==dire);
    plot(mean(Tune.rate(gtrial,:,find(TuneN==neurons(n)))),'k','linewidth',2);
    %text(100,4,'P1','FontSize',16,'Color',ColPC(1,:))
    %text(45,10,'P2','FontSize',16,'Color',ColPC(2,:))
    text(45,10,'P1','FontSize',16,'Color',ColPC(1,:))
    text(100,12,'P2','FontSize',16,'Color',ColPC(2,:))
    text(10,6,'IN','FontSize',16)
    
    hold on;
    
    %subplot(6,3,[4 5  7 8 10 11])
    subplot('Position',spimage);
    PlotPhasegram(spike.t(find(gspikes)),spike.ph(find(gspikes)), spike.lpos(find(gspikes)),whl.lin(gpos));
    colorbar('Position',spcolbar);
    text(225,500,'rate [Hz]','rotation',-90,'FontSize',16);
    xlabel('rate [Hz]');
    hold on
    ylabel('phase [deg]','FontSize',16);
    xlabel('distance [cm]','FontSize',16);
    set(gca,'YDir','normal','FontSize',16,'TickDir','out','YTick',[0:180:720])
    box off
    
    MarkSymbole = {'pentagram', 'o'};
    MarkSymSize = [12 8];
    TextArg = {'P1-IN','P2-IN'};
    %TextPos = [-75 18; -75 3];
    TextPos = [-75 3; -75 5];
    %% ccg with all pyramidal cells:
    for m=[1 2]%length(PCfields)
      
      [PCneurons PCnindx] = unique(PlaceCell.ind(PCfields,1));
      
      %subplot(6,3,[1 2])
      subplot('Position',sptune);
      plot(mean(Tune.rate(gtrial,:,TuneN==PCneurons(m))),'Color',ColPC(m,:),'linewidth',2);
      ylabel('rate [Hz]')
      set(gca,'FontSize',16,'XTick',[],'TickDir','out')
      axis tight; box off
      
      %subplot(6,3,[3 6]+(m-1)*6)
      subplot('Position',spccgpc(m,:));
      H=bar(t,ccg(:,find(Afields==fields(n)),find(Afields==PCfields(m))));
      hold on
      plot(tpval,smooth(prc(:,find(Afields==fields(n)),find(Afields==PCfields(m)),1),6,'lowess'),'--','color',[0 0 0],'LineWidth',1);
      plot(tpval,smooth(prc(:,find(Afields==fields(n)),find(Afields==PCfields(m)),2),6,'lowess'),'--','color',[0 0 0],'LineWidth',1);
      h1 = gca;
      if m==2 
	xlabel('time [ms]','FontSize',16)
      end
      text(TextPos(m,1),TextPos(m,2),TextArg{m},'FontSize',16,'Color',ColPC(m,:))
      ylabel('rate [Hz]','FontSize',16,'Position',[-90  round(TextPos(m,2))/2])
      axis tight;
      ylim([0 round(TextPos(m,2))])
      xlim([-80 80]);
      set(gca,'FontSize',16,'TickDir','out','YTick',[0 round(TextPos(m,2))])
      set(H,'FaceColor',ColPC(m,:),'EdgeColor',ColPC(m,:))
      box off
      %
      %h2 = axes('Position',get(h1,'Position'));
      %plot(tpval,ccgpval(:,find(Afields==fields(n)),find(Afields==PCfields(m))),'--','color',[0 0 0],'LineWidth',1);
      %set(h2,'YAxisLocation','right','Color','none','XTickLabel',[]);
      %set(h2,'FontSize',16,'TickDir','out','YTick',[0 1],'XLim',get(h1,'XLim'),'YLim',[0 1]);
      %ylabel('p','rotation',-90)
      %Lines([],[0.05 0.95],[0 0 0],':',1);
      %box off;
        
      PCIntv = PlaceCell.trials(find(PlaceCell.trials(:,1)==PCfields(m)),2:3);	  
      PCSpikes = spike.ind==PlaceCell.ind(PCfields(m),1) & WithinRanges(round(spike.t/20000*whl.rate),PCIntv) & spike.good;
      BinsPC = [min(spike.lpos(PCSpikes)):2:max(spike.lpos(PCSpikes))];
      [mPC lPC uPC BinsPC] = BinSmoothE(spike.lpos(PCSpikes), spike.ph(PCSpikes), 'CircConf', BinsPC);
      
      %subplot(6,3,[4 5 7 8 10 11])
      subplot('Position',spimage);
      plot([BinsPC';BinsPC'], [mod(mPC*180/pi,360);mod(mPC*180/pi,360)+360],...
	   MarkSymbole{m},'markerfacecolor',ColPC(m,:),'markeredgecolor',ColPC(m,:),'markersize',MarkSymSize(m));
      set(gca,'YDir','normal','FontSize',16)
    end
    %end
    
    clear Index Acc smAcc;
    
    %%%%%%%%
    nn=find(unique(PlaceCell.ind(IN,1))==neurons(n));
    %subplot(6,3,[13 16])
    subplot('Position',spinter(1,:));
    H=bar(ThRpPh.binCorr,ThRpPh.histCorr(nn,:),1);
    axis tight;xlim([-50 50]);%ylim([0 60])
    xlabel('time [ms]','FontSize',16)
    ylabel('rate [Hz]','FontSize',16)
    set(gca,'FontSize',16,'TickDir','out')
    set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
    
    %subplot(12,3,[29 32 35])
    subplot('Position',spinter(2,:));
    H=bar(ThRpPh.binTh,ThRpPh.histTh(nn,:)*100,1);
    axis tight;
    %Lines(mod(ThRpPh.mph(n,1)*180/pi,360));
    xlabel('phase [deg]','FontSize',16)
    ylabel('probability [%]','FontSize',16)
    set(gca,'FontSize',16,'TickDir','out','XTick',[0:180:360])
    set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
    
    %subplot(12,3,[30 33 36])
    subplot('Position',spinter(3,:));
    H=bar(ThRpPh.binRp,ThRpPh.histRp(nn,:),1);
    xlabel('time [ms]','FontSize',16)
    ylabel('rate [Hz]','FontSize',16)
    set(gca,'FontSize',16,'TickDir','out')
    set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
    axis tight; xlim([-100 100]);%ylim([0 3]);
    
    
    text(-795,3.48,'A','FontSize',20);
    text(-795,2.8,'B','FontSize',20);
    text(-170,3.48,'C','FontSize',20);
    text(-795,1,'D','FontSize',20);
    
    %subplot(12,3,26)
    subplot('Position',sptrigg(1,:));
    plot([1:360],cos([1:360]/180*pi),'Color','k','LineWidth',2)
    axis tight; axis off; 
    %subplot(12,3,27)
    subplot('Position',sptrigg(2,:));
    plot(ThRpPh.binRpsm,ThRpPh.histRpsm(nn,:),'Color','k','LineWidth',2)
    axis tight; axis off
    xlim([-100 100])
    
    
    
    %%%%%%%%%%%%
    
    ForAllSubplots('box off')
    
    %waitforbuttonpress
    %keyboard
      
  end
end

InterPhase=1;

return;