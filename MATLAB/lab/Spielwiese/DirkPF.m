%function DirkPF

FileBase = 'CD1_170202009_3/CD1_170202009_3';

COMP = 0;
if COMP

  Par = LoadPar([FileBase '.xml']);
  
  SampleRate = Par.SampleRate;
  EegRate = Par.lfpSampleRate;
  
  %% get position
  whl = GetWhl(FileBase);
  
  %% get trials
  trial = GetTrials(FileBase,whl);
  
  %% get linearized position
  whl = GetWhlLin(whl,trial);
  
  %% get spikes
  [spike.t, spike.ind, spike.pos, numclus, xspikeph, spike.clu] = SpikePos(FileBase,whl.ctr,Par.lfpSampleRate,0,Par.SampleRate);
  spike.dir = zeros(length(spike.t),1);
  for nn=unique(trial.dir)'
    spike.dir(find(WithinRanges(spike.t/Par.SampleRate*whl.rate,trial.itv(find(trial.dir==nn),:))),:)=nn;
  end
  spike = SpikeLinPos(spike,trial,Par.lfpSampleRate,[],Par.SampleRate);
  
  
  %% get theta phase
  [spike.ph spike.uph] = SpikePhase(FileBase,spike.t,SampleRate,EegRate);
  
  %% compute linear rate
  Lbin = [0:ceil(max(whl.lin))];
  Lbinp = Lbin(1:end-1)+mean(diff(Lbin))/2;
  ind = find(WithinRanges([1:length(whl.lin)],trial.itv(find(trial.dir==2),:)));
  Occr = smooth(histcI(whl.lin(ind),Lbin),10,'lowess');
  ind = find(WithinRanges([1:length(whl.lin)],trial.itv(find(trial.dir==3),:)));
  Occl = smooth(histcI(whl.lin(ind),Lbin),5,'lowess');
  
end

for n=4%unique(spike.ind)'
  
  figure(1);clf;
  indr = find(WithinRanges(round(spike.t/SampleRate*EegRate),trial.itv(find(trial.dir==2),:)) & spike.ind==n);
  indl = find(WithinRanges(round(spike.t/SampleRate*EegRate),trial.itv(find(trial.dir==3),:)) & spike.ind==n);
  
  subplot(321)
  plot(whl.plot(1:50:end,1),whl.plot(1:50:end,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
  hold on
  plot(spike.pos(indr,1),spike.pos(indr,2),'o','markersize',5,'markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0])
  set(gca,'TickDir','out','FontSize',16)
  box off
  axis tight
  title('right','FontSize',16)
  xlabel('space','FontSize',16)
  ylabel('space','FontSize',16)
  %
  subplot(322)
  plot(whl.plot(1:50:end,1),whl.plot(1:50:end,2),'o','markersize',5,'markerfacecolor',[1 1 1]*0.8,'markeredgecolor',[1 1 1]*0.8)
  hold on
  plot(spike.pos(indl,1),spike.pos(indl,2),'o','markersize',5,'markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0])
  set(gca,'TickDir','out','FontSize',16)
  box off
  axis tight
  title('left','FontSize',16)
  xlabel('space','FontSize',16)
  ylabel('space','FontSize',16)
  %
  
  
  rater = smooth(histcI(spike.lpos(indr),Lbin),10,'lowess')./Occr;
  ratel = smooth(histcI(spike.lpos(indl),Lbin),10,'lowess')./Occl;
  subplot(323)
  plot(Lbinp,rater,'r','LineWidth',2)
  axis tight
  ylim([0 max(rater)])
  ylabel('rate','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(324)
  plot(Lbinp,ratel,'r','LineWidth',2)
  axis tight
  ylim([0 max(ratel)])
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  
  
  lxlim = get(gca,'xlim');
  subplot(325)
  plot(spike.lpos(indr),spike.ph(indr)*180/pi,'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
  hold on
  plot(spike.lpos(indr),spike.ph(indr)*180/pi+360,'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
  xlim(lxlim)
  ylim([0 720])
  xlabel('distance','FontSize',16)
  ylabel('phase','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  %
  subplot(326)
  plot(spike.lpos(indl),spike.ph(indl)*180/pi,'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
  hold on
  plot(spike.lpos(indl),spike.ph(indl)*180/pi+360,'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
  xlim(lxlim)
  ylim([0 720])
  set(gca,'TickDir','out','FontSize',16)
  box off
  xlabel('distance','FontSize',16)
  %
  
  
  figure(2);clf
  for k=1:1000
    m = [1:2]+(k-1)*2;
    subplot(121)
    plot(spike.lpos(indr(m)),spike.ph(indr(m))*180/pi,'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
    hold on
    plot(spike.lpos(indr(m)),spike.ph(indr(m))*180/pi+360,'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
    hold off
    xlim(lxlim)
    ylim([0 720])
    xlabel('distance','FontSize',16)
    ylabel('phase','FontSize',16)
    set(gca,'TickDir','out','FontSize',16)
    box off
    %
    subplot(122)
    plot(spike.lpos(indl(m)),spike.ph(indl(m))*180/pi,'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
    hold on
    plot(spike.lpos(indl(m)),spike.ph(indl(m))*180/pi+360,'o','markersize',5,'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1])
    hold off
    xlim(lxlim)
    ylim([0 720])
    set(gca,'TickDir','out','FontSize',16)
    box off
    xlabel('distance','FontSize',16)
    WaitForButtonpress
  end
  
  
  %reportfig(gcf, 'Dirk01', 0, ['cell ' num2str(n)], 100,0)
  
  %WaitForButtonpress
end

