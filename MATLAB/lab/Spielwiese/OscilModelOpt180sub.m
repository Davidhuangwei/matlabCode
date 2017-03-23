function [Dph,DT,Slp,ExpPnt,ExpLn] = OscilModelOpt180sub(rdt,rph,N,nS,varargin)
[Plot] = DefaultArgs(varargin,{[0]});

%nS = 10;                   % spikes/trial
%N = 1000;%round(length(rph)/10);   % estimated number of trials

k = randi(length(rph),[N*nS,1]); % draw spikes 
drph = reshape(rph(k),N,nS);     % find phase of spikes
drdt = reshape(rdt(k),N,nS);     % find time of spikes

[sdrdt si] = sort(drdt,2); 
for n=1:N
  sdrph(n,:) = drph(n,si(n,:));
  [b sts]=robustfit(sdrdt(n,:),sdrph(n,:));
  
  RR(:,1) = abs(sdrph(n,:)-360 - (b(1)+b(2)*sdrdt(n,:)));
  RR(:,2) = abs(sdrph(n,:) - (b(1)+b(2)*sdrdt(n,:)));
  RR(:,3) = abs(sdrph(n,:)+360 - (b(1)+b(2)*sdrdt(n,:)));
  [mRR mRRi] = min(RR,[],2);

  sdrph(n,:) = sdrph(n,:)+(mRRi'-2)*360;
  
  [b sts]=robustfit(sdrdt(n,:),sdrph(n,:));
  
  xxx(n,:)=sdrdt(n,[1 nS]);
  xxy(n,:)=sdrph(n,[1 nS]);
  ee(n) = -diff(b(1)+b(2)*xxx(n,:));
  bb(n,:) = b;
  bv(n,:) = sts.p';
end

gs = find(bv(:,1)<=0.1 & bv(:,2)<=0.1 & ee'>0);


Dph = ee(gs);
DT  = diff(xxx(gs,:)');
Slp = bb(gs,2)';

%% Example

n=1; r = [1:nS];
if nS>500;
  r = randi(nS,[500 1]);
end
ExpPnt = [sdrdt(gs(n),r); sdrph(gs(n),r)];
ExpLn = [xxx(gs(n),:); bb(gs(n),1)+bb(gs(n),2)*xxx(gs(n),:)];


if Plot
  n=1; r = [1:nS];
  plot(sdrdt(gs(n),r),sdrph(gs(n),r),'o','markersize',5,'markeredgecolor',[0.5 0.5 1],'markerfacecolor',[0.5 0.5 1])
  hold on
  ab = bb(gs(n),1)+bb(gs(n),2)*xxx(gs(n),:);
  plot(xxx(gs(n),:),ab,'--r','LineWidth',2)
  axis tight
  xlim([-1 1])
  ylim([-90 450])
  box off
  set(gca,'TickDir','out','FontSize',16,'YTick',[0 180 360] )
  %xlabel('time t [sec]','FontSize',16)
  ylabel('phase \phi [deg]','FontSize',16)
  Lines(xxx(gs(n),1),[-90 ab(1)],'k','--',1);
  Lines(xxx(gs(n),2),[-90 ab(2)],'k','--',1);
  Lines([xxx(gs(n),1) 1],ab(1),'k','--',1);
  Lines([xxx(gs(n),2) 1],ab(2),'k','--',1);
  %text(mean(xxx(gs(n),:))-0.05,20,'\Delta t','FontSize',20)
  %text(0.85,mean(ab),'\Delta \phi','FontSize',20)
  
end

return;