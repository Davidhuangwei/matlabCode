function OscilModelOpt2

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

%% example neurons
cl = [23:2:27]*2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example Figure
figure(123);clf
set(gcf,'position',[1829 370 592 541])


%%
subplot('position',[0.15 0.75 0.7 0.15])
hold on
%% 
yy = sum(y,2);
plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
cc = colormap('lines');
l = 1:3;
k=3;
for n=1:k
  plot(t,y(:,cl(n))/max(y(:,cl(n))),'LineWidth',2,'Color',cc(l(n),:))
end
ylabel('rate','FontSize',16)
xlim([4 6])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off
text(3.9,0.05,'probability','FontSize',16,'rotation',90)
b=get(gca,'ylim');
text(3.7,b(2),'a)','FontSize',16);

%%
subplot('position',[0.15 0.55 0.7 0.15])
hold on
colormap('default')
cc = colormap;
k=22; l = round(linspace(1,64,k));
cll = [40:1:70];
for n=1:k
  plot(t,y(:,cll(n))/max(y(:,cll(n))),'LineWidth',2,'Color',cc(l(n),:))
end
yy = sum(y,2);
plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
xlabel('time [sec]','FontSize',16)
ylabel('probability','FontSize',16)
xlim([4 6])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off
text(5.7,-0.25,'2 sec','FontSize',16)
text(3.9,0.05,'probability','FontSize',16,'rotation',90)
text(6.06,0.6,'2A','FontSize',16);
annotation('line',[0.875 0.875]+0.01,[0.67 0.695],'LineWidth',2);
annotation('line',[0.875 0.875]+0.01,[0.59 0.62],'LineWidth',2);

annotation('line',[0.87 0.88]+0.01,[0.59 0.59],'LineWidth',2);
annotation('line',[0.87 0.88]+0.01,[0.695 0.695],'LineWidth',2);

b=get(gca,'ylim');
text(3.7,b(2),'b)','FontSize',16);

PrintFig('OscilModelPart',1)
return
keyboard

%PrintFig('OscilModel.crt',GoPrint)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NOPLOT
  figure(76263);clf
  subplot('position',[0.1 0.15 0.7 0.8])
  hold on
  cc = colormap('lines');
  l = 1:3;
  k=3; 
  %l = round(linspace(1,64,k));
  %cl = [23:2:27];
  for n=1:k
    plot(t,y(:,cl(n))/max(y(:,cl(n))),'LineWidth',2,'Color',cc(l(n),:))
    ylabel('rate','FontSize',16)
    xlim([4 6])
    set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
    box off
    axis off
    text(3.95,0.3,'rate','FontSize',16,'rotation',90)
    text(5.8,-0.1,'2 sec','FontSize',16)
    PrintFig(['OscilModelScatch' num2str(n)],0)
  end
  yy = sum(y,2);
  plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
  PrintFig('OscilModelScatch4',0)
end

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

subplot('position',[0.15 0.15 0.7 0.3])
hold on
cc = colormap('lines');
l = 1:3;
k=3; 
rate = 100/sig;
for n=1:k
  y2 = y(:,cl(n))/max(y(:,cl(n)));
  y22 = zeros(size(y2));
  y22 = y2;%(find(y2>=0)) = y2(find(y2>=0));
  y3 = cumsum(y22)/sum(y22);
  r = rand(10000,1);
  [xx xi yi] = NearestNeighbour(y3,r);
  %% randomize
  rdt =  t(xi)+(rand(size(xi))-0.5)*0.3;%*0.3;
  rph =  phi(xi)*180/pi + (rand(size(xi))-0.5)*20;
  
  plot(rdt(1:10:end),rph(1:10:end),'o','markersize',3,'markerfacecolor',cc(l(n),:),'markeredgecolor',cc(l(n),:))
  plot(rdt(1:10:end),rph(1:10:end)+360,'o','markersize',3,'markerfacecolor',cc(l(n),:),'markeredgecolor',cc(l(n),:))
  
  bin = [0:30:720];
  h(:,n) = histcI([rph;rph+360],bin);
end
axis tight
xlim([4 6])
ylim([0 720])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[0:180:720])
box off
%axis off
%text(3.75,300,'phase [deg]','FontSize',16,'rotation',90)
ylabel('phase [deg]','FontSize',16)
text(5.7,-70,'2 sec','FontSize',16)

text(3.65,720,'C','FontSize',16);


%%%%%%%%
subplot('position',[0.85 0.15 0.1 0.3])
plot(h,bin(1:end-1)+mean(diff(bin))/2,'LineWidth',2)
axis tight
xlim([0 max(h(:))])
ylim([0 720])
box off
axis off
text(100,-70,'count','FontSize',16)

%PrintFig(['OscilModelScatchPh'],GoPrint)
PrintFig('OscilModel.crt',GoPrint)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% frequency and amplitude

%% optimal parameters
sig = 0.353; % [sec]
a = 3*sqrt(2);%a = 2*sqrt(-log(0.1));
f0 = 8.6;    % [Hz]
cf = 1/(a*sig*f0); % dimension less 

ft = f0*(1-cf);

t=[1:0.001:10]'; %% 10 sec

fprintf(['f0=' num2str(f0) 'c=' num2str(cf) ' L=' num2str(a*sig) ' ft=' num2str(ft) '\n']);


%% delay - compression factor
k=20;
for m=1:k
  cfm(m) = m * cf/k*2;
  f0m(m) = m * f0/k + f0/2;
  sigm(m) = m*0.11/2;
  for n=1:100
    T = 0.1*n;
    % cf
    tau = cfm(m)*T;
    ytau(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2);
    % f0
    tau = cf*T;
    yf0(:,n) = 0.5*(1+cos(2*pi*f0m(m)*(t-tau))).*exp(-(t-T).^2/sig^2);
    % sig
    tau = cf*T;
    ysig(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sigm(m)^2);
  end
  gt = find(t>3 & t<7);
  % cf 
  sy = sum(ytau,2)/max(sum(ytau,2));
  amptau(m) = diff([min(sy(gt)) max(sy(gt))]);
  fttau(m) = f0*(1-cfm(m));
  %dphitau(m,:) = OscilModelOpt_funcPhi(sig,cfm(m),f0,fttau(m),50*0.1);
  dphitau(m,:) = 2*pi*a *f0 *cfm(m) *sig *180/pi;
  % f0
  sy = sum(yf0,2)/max(sum(yf0,2));
  ampf0(m) = diff([min(sy(gt)) max(sy(gt))]);
  ftf0(m) = f0m(m)*(1-cf);
  %dphif0(m,:) = OscilModelOpt_funcPhi(sig,cf,f0m(m),ftf0(m),50*0.1);
  dphif0(m,:) = 2*pi*a *f0m(m) *cf *sig *180/pi;
  % sig
  sy = sum(ysig,2)/max(sum(ysig,2));
  ampsig(m) = diff([min(sy(gt)) max(sy(gt))]);
  ftsig(m) = f0*(1-cf);
  sigma = sigm*a;
  %dphisig(m,:) = OscilModelOpt_funcPhi(sigm(m),cf,f0,ftsig(m),50*0.1);
  dphisig(m,:) = 2*pi*a *f0 *cf *sigm(m) *180/pi;
end

figure(72356);clf
set(gcf,'position',[1828         233         729         676]);
c = [0.5 0.5 1];
%
subplot('position',[0.15 0.75 0.2 0.2]) %% 331
plot(cfm,fttau,'o','markeredgecolor',c,'markerfacecolor',c);
%set(gca,'TickDir','out','FontSize',16,'YTick',[6.5:0.5:8.5])
set(gca,'TickDir','out','FontSize',16,'YTick',[4:2:12])
axis tight 
%ylim([6.5 8])
ylim([4 12])
box off
Lines(cf,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('compression factor c','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75])
ylabel('popul. freq. f_\theta [Hz]','FontSize',16,'position',[mean(al)-diff(al)*0.7 mean(bl)])
%
subplot('position',[0.44 0.75 0.2 0.2]) %% 332
plot(cfm,amptau,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16)
axis tight 
ylim([0 1])
box off
Lines(cf,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('compression factor c','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75]) 
ylabel('amplitude A','FontSize',16,'position',[mean(al)-diff(al)*0.7 mean(bl)])
%
subplot('position',[0.75 0.75 0.2 0.2]) %% 333
plot(cfm,dphitau,'o','markeredgecolor',c,'markerfacecolor',c)
%set(gca,'TickDir','out','FontSize',16,'YTick',[0:180:720])
set(gca,'TickDir','out','FontSize',16,'YTick',[0:360:1080])
axis tight 
ylim([0 1160])
box off
Lines(cf,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('compression factor c','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75])
ylabel('tot. phase \Delta\Phi [deg]','FontSize',16,'position',[mean(al)-diff(al)*0.8 mean(bl)])
%
%
subplot('position',[0.15 0.45 0.2 0.2]) %% 334
plot(f0m,ftf0,'o','markeredgecolor',c,'markerfacecolor',c);
set(gca,'TickDir','out','FontSize',16,'XTick',[4:2:12],'YTick',[4:2:12])
hold on
plot([4 12],[4 12],'k--')
axis tight 
xlim([4 12])
ylim([4 12])
box off
Lines(f0,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('frequency f_0 [Hz]','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75])
ylabel('popul. freq. f_\theta [Hz]','FontSize',16,'position',[mean(al)-diff(al)*0.7 mean(bl)])
%
subplot('position',[0.44 0.45 0.2 0.2]) %% 335
plot(f0m,ampf0,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16,'XTick',[4:2:12])
axis tight 
xlim([4 12])
ylim([0 1])
box off
Lines(f0,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('frequency f_0 [Hz]','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75])
ylabel('amplitude A','FontSize',16,'position',[mean(al)-diff(al)*0.7 mean(bl)])
%
subplot('position',[0.75 0.45 0.2 0.2]) %% 336
plot(f0m,dphif0,'o','markeredgecolor',c,'markerfacecolor',c)
%set(gca,'TickDir','out','FontSize',16,'XTick',[4:2:12],'YTick',[0:90:720])
set(gca,'TickDir','out','FontSize',16,'XTick',[4:2:12],'YTick',[0:360:1080])
axis tight 
xlim([4 12])
ylim([0 1160]);
box off
Lines(f0,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('frequency f_0 [Hz]','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75])
ylabel('tot. phase \Delta\Phi [deg]','FontSize',16,'position',[mean(al)-diff(al)*0.8 mean(bl)])
%
%
subplot('position',[0.15 0.15 0.2 0.2]) %% 337
plot(sigma,ftsig,'o','markeredgecolor',c,'markerfacecolor',c);
set(gca,'TickDir','out','FontSize',16,'YTick',[4:2:12])
axis tight 
ylim([4 12])
box off
Lines(sig*a,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('field size L [sec]','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75])
ylabel('popul. freq. f_\theta [Hz]','FontSize',16,'position',[mean(al)-diff(al)*0.7 mean(bl)])
%
subplot('position',[0.44 0.15 0.2 0.2]) %% 338
plot(sigma,ampsig,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16)
axis tight 
ylim([0 1])
box off
Lines(sig*a,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('field size L [sec]','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75])
ylabel('amplitude A','FontSize',16,'position',[mean(al)-diff(al)*0.7 mean(bl)])
%
subplot('position',[0.75 0.15 0.2 0.2]) %% 339
plot(sigma,dphisig,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16,'YTick',[0:360:1260])
axis tight 
ylim([0 1160]);
box off
Lines(sig*a,[],[],'--');
al = get(gca,'XLim');
bl = get(gca,'YLim');
xlabel('field size L [sec]','FontSize',16,'position',[mean(al) mean(bl)-diff(bl)*0.75])
ylabel('tot. phase \Delta\Phi [deg]','FontSize',16,'position',[mean(al)-diff(al)*0.8 mean(bl)])


text(-15.5,4650,'A','FontSize',16);
text(-15.5,2900,'B','FontSize',16);
text(-15.5,1200,'C','FontSize',16);



PrintFig(['OscilModel.var'],GoPrint)


%%%%%%%%%%%%%%%%%%
%% vary bound parameters
stp = 50;


vf0 = [4:8/stp:12];
vL =  [0.5:5.5/stp:6];
vc =  [0.02:0.18/stp:0.2];

f0 = repmat(vf0,stp+1,1);
L =  repmat(vL',1,stp+1);
c =  repmat(vc',1,stp+1);

%% L=1.4
%% f_\theta=8
%% c = 0.085

figure(876);clf
set(gcf,'position',[1762 398 747 290])

subplot('position',[0.13 0.2 0.3 0.7])
imagesc(vf0,vL,f0-1./L)
colorbar
axis xy
hold on
plot(vf0,1./(vf0-8),'k','LineWidth',2);
xlabel('frequency f_0 [Hz]','FontSize',16)
ylabel('field size L [sec]','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[2:2:12])
box off
text(16,5.5,'popul. freq. f_\theta [Hz]','FontSize',16,'rotation',-90)

subplot('position',[0.6 0.2 0.3 0.7])
imagesc(vf0,vL,1./(f0.*L))
colorbar
axis xy
hold on
plot(vf0,1./(0.085*vf0),'k','LineWidth',2);
xlabel('frequency f_0 [Hz]','FontSize',16)
ylabel('field size L [sec]','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[2:2:12])
box off
text(16.7,5.5,'comression factor c','FontSize',16,'rotation',-90)

text(-16.5,6,'A','FontSize',16)
text(1,6,'B','FontSize',16)

PrintFig(['OscilModel.col'],GoPrint)



return;
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

