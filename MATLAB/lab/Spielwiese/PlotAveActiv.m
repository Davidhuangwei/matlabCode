
goodsp = find(ismember(spike.ind,find(ismember(spike.clu(:,1),find(elc.region==1)))));
ST = spike.t(goodsp);
SI = spike.ind(goodsp);

goodcells = find(ismember(spike.clu(:,1),find(elc.region==1 | elc.region==5)));

%% CA1 PS and interneurons
PC = goodcells(find(type.num==2));
IN = goodcells(find(type.num==1));

STP = spike.t(find(ismember(spike.ind,PC)));
SIP = spike.ind(find(ismember(spike.ind,PC)));

STI = spike.t(find(ismember(spike.ind,IN)));
SII = spike.ind(find(ismember(spike.ind,IN)));


%% select firing interval
figure(666)
subplot(311)
%plot([1:length(whl.speed)]/whl.rate,whl.speed)
plot([1:length(whl.speed)]/whl.rate,[whl.ctr(:,1) whl.ctr(:,2)])
axis tight
subplot(312)
[H,HN] = hist(STP/20000,50000);
bar(HN,H);
axis tight
subplot(313)
plot([1:length(Eeg)]/1250,Eeg)
axis tight


xlm = get(gca,'XLim');
ylm = get(gca,'YLim');
xlim(xlm)
ylim(ylm)

while 1
  xa = ginput(1)
  if xa(1)>xlm(2) | xa(1)<xlm(1)
    break
  end
  if xa(2)>ylm(2) | xa(2)<ylm(1)
    break
  end
  xb = ginput(1);
  ForAllSubplots(['xlim([' num2str(xa(1)) ' '  num2str(xb(1)) '])'])
  xlm = [xa(1) xb(1)];
end
  

%% identify samples for whl, spikes and eeg

BinWhl = [1:length(whl.speed)]/whl.rate;
BinEeg = [1:length(Eeg)]/1250;

aw = [round(xa(1)*whl.rate):round(xb(1)*whl.rate)];
asp = find(STP>xa(1)*20000 & STP<xb(1)*20000);
asi = find(STI>xa(1)*20000 & STI<xb(1)*20000);
ae = [round(xa(1)*1250):round(xb(1)*1250)];

figure(666)
subplot(411)
%plot(BinWhl(aw),whl.speed(aw))
plot(BinWhl(aw),[whl.ctr(aw,1) whl.ctr(aw,2)])
ylabel('running speed')
axis tight

subplot(813)
plot(STP(asp)/20000,SIP(asp),'.')
axis tight
box off
subplot(814)
[H,HN] = hist(STP(asp)/20000,round((xb(1)-xa(1))*100));
bar(HN,H);

subplot(815)
plot(STI(asi)/20000,SII(asi),'.')
axis tight
box off
subplot(816)
[H,HN] = hist(STI(asi)/20000,round((xb(1)-xa(1))*100));
bar(HN,H);

subplot(414)
plot(BinEeg(ae),Eeg(ae))
xlabel('time [sec]')
ylabel('LFP');
axis tight
ForAllSubplots(['xlim([' num2str(xa(1)) ' '  num2str(xb(1)) '])'])

waitforbuttonpress

