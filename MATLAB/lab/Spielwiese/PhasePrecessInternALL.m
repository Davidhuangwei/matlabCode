function InterPhase = PhasePrecessInternALL(FileBase,PlaceCell,spike,whl,trial,Tune,Rate,Eeg,ThRpPh,varargin)
[overwrite, RepFig] = DefaultArgs(varargin,{0,0});

if ~FileExists([FileBase '.internprecess']) | overwrite

  PC=(PlaceCell.ind(:,5)==1);
  IN=(PlaceCell.ind(:,5)==2);
  
  TuneN=unique(PlaceCell.ind(:,1));
  
  ColPC = [216 41 0; 191 0 191]/255;
  
  %%Subplot coordinates
  sptune = [0.1 0.82 0.35 0.1; 0.55 0.82 0.35 0.1];
  spimage = [0.1 0.44 0.35 0.336; 0.55 0.44 0.35 0.336];
  spcolbar = [0.46 0.44 0.015 0.336; 0.91 0.44 0.015 0.336];
  spinter = [0.13 0.11 0.2 0.245; 0.42 0.11 0.2 0.18; 0.72 0.11 0.2 0.18];
  sptrigg = [0.42 0.29 0.2 0.085; 0.72 0.29 0.2 0.085];
  
  if isempty(IN)
    return
  end
  
  count=0;
  
  %fields = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==2);
  fields = unique(PlaceCell.ind(IN,1));
  [neurons nindx] = unique(PlaceCell.ind(IN,1));
  
  for n=1:length(fields)
    figure(100);clf
    
    for dire=[2 3];
      
      gdir = find(trial.dir==dire);
      gspikes = spike.ind==neurons(n) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv(gdir,:)) & spike.good;
      gpos = find(WithinRanges([1:size(whl.itv,1)],trial.itv(gdir,:)));
      
      %% FIGURE
      
      %subplot(6,3,[1 2])
      subplot('Position',sptune(dire-1,:));
      gtrial = find(trial.dir(find(trial.dir>1))==dire);
      plot(mean(Tune.rate(gtrial,:,find(TuneN==neurons(n)))),'k','linewidth',2);
      ylabel('rate [Hz]','FontSize',16)
      set(gca,'FontSize',16,'XTick',[],'TickDir','out')
      axis tight; box off
      
      
      %subplot(6,3,[4 5  7 8 10 11])
      subplot('Position',spimage(dire-1,:));
      PlotPhasegram(spike.t(find(gspikes)),spike.ph(find(gspikes)), spike.lpos(find(gspikes)),whl.lin(gpos));
      colorbar('Position',spcolbar(dire-1,:));
      xlabel('rate [Hz]');
      hold on
      ylabel('phase [deg]','FontSize',16);
      xlabel('distance [cm]','FontSize',16);
      set(gca,'YDir','normal','FontSize',16,'TickDir','out','YTick',[0:180:720])
      box off
      
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
      box off
      
      %subplot(12,3,[29 32 35])
      subplot('Position',spinter(2,:));
      H=bar(ThRpPh.binTh,ThRpPh.histTh(nn,:)*100,1);
      axis tight;
      %Lines(mod(ThRpPh.mph(n,1)*180/pi,360));
      xlabel('phase [deg]','FontSize',16)
      ylabel('probability [%]','FontSize',16)
      set(gca,'FontSize',16,'TickDir','out','XTick',[0:180:360])
      set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
      box off
      
      %subplot(12,3,[30 33 36])
      subplot('Position',spinter(3,:));
      H=bar(ThRpPh.binRp,ThRpPh.histRp(nn,:),1);
      xlabel('time [ms]','FontSize',16)
      ylabel('rate [Hz]','FontSize',16)
      set(gca,'FontSize',16,'TickDir','out')
      set(H,'FaceColor',[1 1 1]*0.2,'EdgeColor',[1 1 1]*0.2)
      axis tight; xlim([-100 100]);%ylim([0 3]);
      box off
      
      %subplot(12,3,26)
      subplot('Position',sptrigg(1,:));
      plot([1:360],cos([1:360]/180*pi),'Color','k','LineWidth',2)
      axis tight; axis off; 
      %subplot(12,3,27)
      subplot('Position',sptrigg(2,:));
      plot(ThRpPh.binRpsm,ThRpPh.histRpsm(nn,:),'Color','k','LineWidth',2)
      axis tight; axis off
      xlim([-100 100])
      box off
      
      %%%%%%%%%%%%
      
      ForAllSubplots('box off')
      
    end
    count = count+1;
    goodIN = find(PlaceCell.ind(:,1)==neurons(n));
    InterPhase.ind(count,:) = PlaceCell.ind(goodIN(1),:);
    InterPhase.precess(count,1) = input('interneuron has how many place fields? ');
    InterPhase.theta(count,1) = circmean(spike.ph(find(gspikes)))*180/pi;
    InterPhase.ripp(count,1) = input('brfore [1] during [2] after [3] nan [0]: ');
    
    %waitforbuttonpress
    %keyboard
    
  end
  save([FileBase '.internprecess'],'InterPhase');
else
  load([FileBase '.internprecess'],'-MAT');
end
return;