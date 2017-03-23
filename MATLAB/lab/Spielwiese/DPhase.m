function DPhase(PlaceCell,spike,whl,trial)

RateFactor = 20000/whl.rate;
RateEeg = 1250/whl.rate;

cellen = unique(PlaceCell.ind(:,1));
for plc=1:1%size(PlaceCell.ind,1)
  
  if PlaceCell.ind(plc,5)==2
    continue;
  end
  
  neu = PlaceCell.ind(plc,1);
  dire = PlaceCell.ind(plc,4);
  trials = find(trial.dir==dire);
  pftrials = PlaceCell.trials(find(PlaceCell.trials(:,1)==plc),2:3);
  
  indx = spike.ind==neu & spike.dir==dire & spike.good & whl.ctr(round(spike.t/RateFactor),1)>0;
  %spiketr = WithinRanges(round(spike.t(indx)/RateFactor),trial.itv(trials,:),[1:length(trials)],'vector');
  pftrials = PlaceCell.trials(find(PlaceCell.trials(:,1)==plc),[2 3]);
  spiketr = WithinRanges(round(spike.t(indx)/RateFactor),pftrials,[1:length(trials)],'vector');

  %% ccg
  [ccg, t, pairs] = CCG(spike.uph(indx)*180/pi,1,10,100,1000,[],'count');

  figure(123); clf;
  bar(t,ccg)
  axis tight
  Lines([-1800:180:1800],[],[],'--',1);
  set(gca,'YDir','normal','TickDir','out','FontSize',16,'XTick',[-1800:360:1800])
  
  
  %% detect bursts
  INDX = find(indx);
  [Burst, BurstLen, SpkPos, OutOf, FromBurst] = SplitIntoBursts(spike.t(indx),0.03*20000);
  %[Burst1, BurstLen1, SpkPos1, OutOf1, FromBurst1] = SplitIntoBursts(spike.uph(indx)*180/pi,30);
  %[Burst2, BurstLen2, SpkPos2, OutOf2, FromBurst2] = SplitIntoBursts(spike.uph(INDX(Burst1))*180/pi,60);
  %[Burst, BurstLen, SpkPos, OutOf, FromBurst] = SplitIntoBursts(spike.uph(INDX(Burst1(Burst2)))*180/pi,90);
  
  [ccg, t, pairs] = CCG(spike.uph(INDX(Burst))*180/pi,1,10,100,1000,[],'count');

  figure(124); clf;
  bar(t,ccg)
  axis tight
  Lines([-1800:180:1800],[],[],'--',1);
  set(gca,'YDir','normal','TickDir','out','FontSize',16,'XTick',[-1800:360:1800])

  figure(125); clf;
  %GGINDX = INDX(find(SpkPos==1));
  GGINDX = INDX(Burst(find(BurstLen==1)));
  plot(spike.lpos(INDX(Burst)),spike.ph(INDX(Burst))*180/pi,'.');
  hold on
  plot(spike.lpos(INDX(Burst)),spike.ph(INDX(Burst))*180/pi+360,'.');
  plot(spike.lpos(GGINDX),spike.ph(GGINDX)*180/pi,'r.');
  plot(spike.lpos(GGINDX),spike.ph(GGINDX)*180/pi+360,'r.');
  axis tight
  %Lines([-1800:180:1800],[],[],'--',1);
  %set(gca,'YDir','normal','TickDir','out','FontSize',16,'XTick',[-1800:360:1800])
  
  figure(126);clf
  hist([spike.ph(INDX)*180/pi;spike.ph(INDX)*180/pi+360],90)
  axis tight
  Lines(circmean(spike.ph(INDX))*180/pi)
  Lines([180:180:720])
  
  %keyboard
  
  %waitforbuttonpress
  
end