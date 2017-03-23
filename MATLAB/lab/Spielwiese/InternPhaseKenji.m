function InterPhase = InternPhaseKenji(FileBase,PlaceCell,spike,whl,trial,Tune,varargin)
[overwrite, RepFig] = DefaultArgs(varargin,{1,0});
AllFigs = 0

col = [216 41 0; 0 127 0]/255;
RateFactor = 20000/whl.rate;

Cell(1) = find(spike.clu(:,1)==6 & spike.clu(:,2)==5);%PC
Cell(2) = find(spike.clu(:,1)==6 & spike.clu(:,2)==3);%IN
%Cell(1) = find(spike.clu(:,1)==6 & spike.clu(:,2)==4);%PC
%Cell(2) = find(spike.clu(:,1)==7 & spike.clu(:,2)==6);%IN

figure(100);clf

cc=0;
for dire=3%[2 3]
    
  gdir = find(trial.dir==dire);
  
  for n=[1 2]
    gspikes = spike.ind==Cell(n) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv(gdir,:));
  
    gpos = find(WithinRanges([1:size(whl.itv,1)],trial.itv(gdir,:)));
    
    Index(:,1) = [round(spike.lpos(gspikes))+1; round(spike.lpos(gspikes))+1];
    %Index(:,1) = Index(:,1)-min(Index(:,1))+1;
    Index(find(Index(:,1)<1),1) = 1;
    Index(:,2) = [round(spike.ph(gspikes)*180/pi)+1; round(spike.ph(gspikes)*180/pi+360)+1];
    %Index(:,2) = Index(:,2)-min(Index(:,2))+1;
    Index(find(Index(:,2)<1),2) = 1;
  
    Pos = round(whl.lin(gpos))+1;
    Pos(find(Pos<1)) = 1;
    
    Acc = Accumulate(Index,1,max(Index));
    Occ = Accumulate(Pos,1,max(Pos));
    smOcc = smooth(Occ,10,'lowess');
    smOcc([1:10]) = ones(10,1)*smOcc(10);
    smOcc([end-9:end]) = ones(10,1)*smOcc(end-9);
    smOcc = clip(smOcc,0.2*mean(smOcc),max(smOcc));
    for d=1:size(Acc,2)
      smAcc(:,d) = smooth(Acc(:,d),10,'lowess')./smOcc(1:max(Index(:,1)));
    end
    for d=1:size(Acc,1)
      smAcc(d,:) = smooth(smAcc(d,:),40,'lowess');
    end
    
    %% spike count - Tune-Rate
    pos = round(whl.lin);
    trialindwh = WithinRanges([1:length(whl.lin)],trial.itv(gdir,:),[1:length(gdir)]','vector')';
    gpos = (pos>0 & trialindwh >0);
    SpkCnt = Accumulate([round(spike.t(gspikes)/RateFactor) spike.ind(gspikes)],1,[length(whl.lin) max(spike.ind(gspikes))])*whl.rate;
    [AvR StdR Bins] = MakeAvF([trialindwh(gpos) pos(gpos)],SpkCnt(gpos,unique(spike.ind(gspikes))),[max(trialindwh) max(pos)]);
    smAvR = smooth(mean(AvR),50,'lowess');

    
    cc=cc+1;
    subplot(5,1,1)
    plot(smAvR,'Color',col(n,:),'LineWidth',2)
    hold on
    axis tight
    ylabel('rate [Hz]','FontSize',16);
    set(gca,'YDir','normal','FontSize',16,'TickDir','out','YTick',[0:180:720])
    box off
    
    subplot(5,1,[2 3]+(n-1)*2)
    imagesc(unique(Index(:,1)),unique(Index(:,2)),smAcc')
    if n==2
      caxis([0 0.007])
    else
      caxis([0 0.008])
    end
    ylabel('phase [deg]','FontSize',16);
    xlabel('distance [cm]','FontSize',16);
    set(gca,'YDir','normal','FontSize',16,'TickDir','out','YTick',[0:180:720])
    box off
            
    %waitforbuttonpress
      
    clear Index Acc smAcc;
  end
end

figure(5);clf
spikesall = spike.ind==Cell(1) | spike.ind==Cell(2);
[ccg , t] = CCG(spike.t(spikesall),spike.ind(spikesall),20,50);
subplot(313)
B=bar(t,ccg(:,1,1));
set(B,'EdgeColor',col(1,:),'FaceColor',col(1,:));
set(gca,'FontSize',16,'TickDir','out')
xlabel('time [ms]','FontSize',16)
ylabel('rate [Hz]','FontSize',16)
subplot(311)
B=bar(t,ccg(:,1,2))
set(B,'EdgeColor',[1 1 1]*0.1,'FaceColor',[1 1 1]*0.1);
set(gca,'FontSize',16,'TickDir','out')
ylabel('rate [Hz]','FontSize',16)
subplot(312)
B=bar(t,ccg(:,2,2))
set(B,'EdgeColor',col(2,:),'FaceColor',col(2,:));
set(gca,'FontSize',16,'TickDir','out')
ylabel('rate [Hz]','FontSize',16)
ForAllSubplots(['axis tight; box off'])

return

