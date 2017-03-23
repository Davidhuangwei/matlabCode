function OscilModelOpt180

NOPLOT = 0;
GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% default parameters

sig = 0.32; % [sec]
f0 = 8.7;    % [Hz]
cf = 1/(3*sqrt(2)*sig*f0); % dimension less 

ft = f0*(1-cf);

t=[1:0.001:10]'; %% 10 sec
for n=1:100
  T = 0.1*n;
  tau = cf*T;
  y(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2);
end

yy = sum(y,2);

%% example neuron
cl = [27]*2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PHASE
%% compute the phase of yy
gt = find(t>1 & t<=9);
t2 = t(gt)-1;
yy2 = [yy(gt)/max(yy(gt))];
a = (max(yy2)-min(yy2))/2;
b = (max(yy2)+min(yy2))/2;
yy2 = (yy2-b)/a;
dyy = diff(yy2)./diff(t2);
dyy = dyy/max(dyy);

dt = t2(2:end)-mean(diff(t2))/2;
yy3 = yy2(1:end-1)+diff(yy2)/2;

phi = angle(yy3-i*dyy);
phi = mod(phi+pi,2*pi);

y2 = y(:,cl)/max(y(:,cl));
y3 = cumsum(y2)/sum(y2);


%% draw random spikes
NN = 50000;
r = rand(NN,1);
[xx xi yi] = NearestNeighbour(y3,r);
%% randomize
rdt =  t(xi)-cl*0.1+(rand(size(xi))-0.5)*0.2;%*0.4;
rph =  phi(xi)*180/pi + (rand(size(xi))-0.5)*20;


%%%%%%%%
%% PLOT PHASE OF SINGLE TRIALS
figure(475);clf
set(gcf,'position',[1687         175         972         794])

nS = 10;                   % spikes/trial
N = 5000;%round(length(rph)/10);   % estimated number of trials

stp = 40; % binsize for histograms

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

%% collect phase, time, slope
Dph = ee(gs);
DT = diff(xxx(gs,:)');
Slp = bb(gs,2);

%% histograms
%hi = [0:20:500];hipph = [10:20:490];
%hdph(1,:)=histcI(Dph,hi);
%mDph(1) = mean(Dph);
%
%hi = [0:0.08:2];hipt = [0.04:0.08:1.96];
%hdt(1,:)=histcI(DT,hi);
%mDT(1) = mean(DT);
%%
%hi = [-1000:40:0];hipslp = [-980:40:-20];
%hslp(1,:)=histcI(Slp,hi);
%mSlp(1) = mean(Slp);

n=1;
%% histograms
hstp = 500/stp;
hi = [0:hstp:500];hipph = [hstp/2:hstp:500-hstp/2];
hdph(n,:)=histcI(Dph,hi);
mDph(n) = mean(Dph);
%
hstp = 2/stp;
hi = [0:hstp:2];hipt = [hstp/2:hstp:2-hstp/2];
hdt(n,:)=histcI(DT,hi);
mDT(n) = mean(DT);
%
hstp = 1000/stp;
hi = [-1000:hstp:0];hipslp = [-1000+hstp/2:hstp:-hstp/2];
hslp(n,:)=histcI(Slp,hi);
mSlp(n) = mean(Slp);

%% trace
subplot('position',[0.1 0.85 0.4 0.1])
plot(t-cl*0.1,yy/max(yy),'--','color',[1 1 1]*0.6,'LineWidth',3)
hold on
plot(t-cl*0.1,y2,'-k','LineWidth',2)
plot(t-cl*0.1,0,'-k','LineWidth',2)
%XXXXX
xlim([-1 1])
axis off

%% labels!!
text(-1.35,1,'A','FontSize',16)
text(-1.35,0,'B','FontSize',16)
text(-1.35,-2.5,'C','FontSize',16)
text(-1.35,-5,'D','FontSize',16)
text(1.05,1,'E','FontSize',16)
text(1.05,-2,'F','FontSize',16)
text(1.05,-5,'G','FontSize',16)



subplot('position',[0.1 0.65 0.4 0.2])
n = 1;
plot(sdrdt(gs(n),:),sdrph(gs(n),:),'o','markersize',5,'markeredgecolor',[0.5 0.5 1],'markerfacecolor',[0.5 0.5 1])
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

text(0-0.05,-50,'\Delta t','FontSize',20)
text(0.8,180,'\Delta \phi','FontSize',20)
%Lines([xxx(gs(n),1) 1],ab(1),'k','--',1)


%% different sample size
k = [20 40 80 100 200 400 800 1000];
%k = [100 200];
cnt = 0;
for n=[2:length(k)+1]
  nn = k(n-1);
  if k(n-1)==100 | k(n-1)==1000
    cnt = cnt+1;
    
   subplot('position',[0.1 0.65-cnt*0.25 0.4 0.2])
   [Dph,DT,Slp,ExpPnt,ExpLn] = OscilModelOpt180sub(rdt,rph,N,nn,1);
    
  else
    [Dph,DT,Slp] = OscilModelOpt180sub(rdt,rph,1000,nn);
  end
  
  %% hist
  hstp = 500/stp;
  hi = [0:hstp:500];hipph = [hstp/2:hstp:500-hstp/2];
  hdph(n,:)=histcI(Dph,hi);
  mDph(n) = mean(Dph);
  %
  hstp = 2/stp;
  hi = [0:hstp:2];hipt = [hstp/2:hstp:2-hstp/2];
  hdt(n,:)=histcI(DT,hi);
  mDT(n) = mean(DT);
  %
  hstp = 1000/stp;
  hi = [-1000:hstp:0];hipslp = [-1000+hstp/2:hstp:-hstp/2];
  hslp(n,:)=histcI(Slp,hi);
  mSlp(n) = mean(Slp);
  text(0-0.05,-50,'\Delta t','FontSize',20)
  text(0.8,180,'\Delta \phi','FontSize',20)
end
xlabel('time t [sec]','FontSize',16)
%text(0-0.05,-50,'\Delta t','FontSize',20)
%text(0.8,180,'\Delta \phi','FontSize',20)

kp = [1 5 9];
%kp = [1 2 3]


%% phase
subplot('position',[0.59 0.75 0.15 0.2])
p=plot(hipph,hdph(kp,:),'LineWidth',2);
set(p(1),'color',[0 0 0.6])
set(p(2),'color',[0 0.5 0])
set(p(3),'color',[0.6 0 0])
axis tight
xlim([0 500])
box off
set(gca,'TickDir','out','FontSize',16,'XTick',[0:180:540])
xlabel('\Delta\phi [deg]','FontSize',16)
a = get(gca,'XLim');
b = get(gca,'YLim');
ylabel('count','FontSize',16,'position',[a(1)-diff(a)*0.32 mean(b)])

subplot('position',[0.82 0.75 0.15 0.2])
plot(mDph,[10 k],'LineWidth',2,'color',[1 1 1]*0.4);
axis tight
xlim([0 500])
ylim([0 1000])
box off
set(gca,'TickDir','out','FontSize',16,'XTick',[0:180:540],'YTick',[0:200:1000])
%ylabel('sample size','FontSize',16)
xlabel('<\Delta\phi> [deg]','FontSize',16)
ylabel('# spikes/session','FontSize',16)



%% time
subplot('position',[0.59 0.45 0.15 0.2])
p=plot(hipt,hdt(kp,:),'LineWidth',2);
set(p(1),'color',[0 0 0.6])
set(p(2),'color',[0 0.5 0])
set(p(3),'color',[0.6 0 0])
axis tight
box off
set(gca,'TickDir','out','FontSize',16)
xlabel('\Delta t [sec]','FontSize',16)
a = get(gca,'XLim');
b = get(gca,'YLim');
ylabel('count','FontSize',16,'position',[a(1)-diff(a)*0.32 mean(b)])

subplot('position',[0.82 0.45 0.15 0.2])
plot(mDT,[10 k],'LineWidth',2,'color',[1 1 1]*0.4);
axis tight
xlim([0 2])
ylim([0 1000])
box off
set(gca,'TickDir','out','FontSize',16,'YTick',[0:200:1000]);
%ylabel('sample size','FontSize',16)
xlabel('<\Delta t> [sec]','FontSize',16)
ylabel('# spikes/session','FontSize',16)



% slope
subplot('position',[0.59 0.15 0.15 0.2])
p=plot(hipslp,hslp(kp,:),'LineWidth',2);
set(p(1),'color',[0 0 0.6])
set(p(2),'color',[0 0.5 0])
set(p(3),'color',[0.6 0 0])
axis tight
box off
set(gca,'TickDir','out','FontSize',16,'XTick',[-800:400:0])
xlabel('slope [deg/sec]','FontSize',16)
a = get(gca,'XLim');
b = get(gca,'YLim');
ylabel('count','FontSize',16,'position',[a(1)-diff(a)*0.32 mean(b)])

subplot('position',[0.82 0.15 0.15 0.2])
plot(mSlp,[10 k],'LineWidth',2,'color',[1 1 1]*0.4);
axis tight
xlim([-1000 0])
ylim([0 1000])
box off
set(gca,'TickDir','out','FontSize',16,'XTick',[-800:400:0],'YTick',[0:200:1000])
%ylabel('sample size','FontSize',16)
xlabel('<slope> [deg/sec]','FontSize',16)
ylabel('# spikes/session','FontSize',16)


%for n=[2:5]
%  subplot('position',[0.72 0.13+(n-2)*0.22 0.18 0.15])
%  plot(sdrdt(gs(n),:),sdrph(gs(n),:),'o','markersize',10,'markeredgecolor',[0.5 0.5 1],'markerfacecolor',[0.5 0.5 1])
%  hold on
%  ab = bb(gs(n),1)+bb(gs(n),2)*xxx(gs(n),:);
%  plot(xxx(gs(n),:),ab,'r','LineWidth',2)
%  xlim([-1 1])
%  ylim([0 400])
%  box off
%  set(gca,'TickDir','out','FontSize',16,'YTick',[0 180 360] )
%  xlabel('time t [sec]','FontSize',16)
%  ylabel('phase \phi [deg]','FontSize',16)
%end

keyboard

PrintFig('OscilModel.size',0)


return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

