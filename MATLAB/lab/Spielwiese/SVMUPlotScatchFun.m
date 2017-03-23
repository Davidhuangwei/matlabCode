function SVMUPlotScatchFun

NOPLOT=0;

if NOPLOT
  %%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Scatch of single neuron  
  
  figure(74645);clf;
  x = [1:500]/1000;
  plot(x,cos(2*pi*8*x),'--','color',[1 1 1]*0.5,'LineWidth',2)
  hold on
  plot(x,cos(2*pi*8*(x-0.03)),'-','color',[0 0 1]*0.5,'LineWidth',2)
  axis off
  Lines(2/8,[],[],'--');
  Lines(2/8+0.03,[],[],'--');
  Lines([2/8 2/8+0.03],[-0.9 -0.9]);
  text(2/8, -1.1,'\tau','FontSize',30);
  
  PrintFig('Scatch1',0)
  
  figure(746897);clf;
  x = [-1000:1000]/1000;
  sig = 0.3;
  plot(x,exp(-(x/sig).^2),'-','color',[0 0 1]*0.5,'LineWidth',2)
  axis tight
  axis off
  Lines(0,[],[],'--');
  Lines([0 sig],[1 1]*exp(-1));
  text(sig/3, 0.3,'\sigma','FontSize',30);
  text(-0.04,-0.09,'T','FontSize',30);
  
  PrintFig('Scatch2',0)
  
  figure(746456);clf;
  x = [-1000:1000]/1000;
  sig = 0.3;
  plot(x,[1+cos(2*pi*8*x)]/2.*exp(-(x/sig).^2),'-','color',[0 0 1]*0.5,'LineWidth',2)
  axis tight
  axis off
  %Lines(0,[],[],'--');
  %Lines([0 sig],[1 1]*exp(-1))
  %text(sig/3, 0.3,'\sigma','FontSize',30);
  %text(-0.04,-0.09,'T','FontSize',30);
  
  PrintFig('Scatch3',0)
  
  figure(4756);clf;
  x = [-1000:1000]/1000;
  sig = 0.3;
  tau = 0.03;
  
  cc = colormap('Lines');
  
  y1=[1+cos(2*pi*8*x)]/2.*exp(-(x/sig).^2);
  plot(x,y1,'-','color',cc(1,:),'LineWidth',2)
  hold on
  T1 = 1/8+tau;
  y2=[1+cos(2*pi*8*(x-tau))]/2.*exp(-((x-T1)/sig).^2);
  plot(x,y2,'-','color',cc(2,:),'LineWidth',2)
  axis tight
  axis off
  Lines(0,[],'r','--',2);
  Lines(T1,[],'r','--',2);
  Lines([0 T1],[1 1]*0.9,'r','-',2)
  text(0, 1,'1/f+\tau','FontSize',20);
  %text(-0.04,-0.09,'T','FontSize',30);
  
  PrintFig('Scatch4',0)
end

%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
%% Function


%%%%%%%%%%%%%%%%%
%% frequency
xf0 = [5:1:12];
yc = [0.01:0.005:0.1];
f0 = repmat(xf0,length(yc),1);
c = repmat(yc',1,length(xf0));
ft = f0.*(1-c);

if NOPLOT
  figure(78789);clf
  plot(yc,ft,'b','LineWidth',2)
  axis tight
  xlabel('compression factor c','FontSize',16)
  ylabel('popul.frequency f_\theta [Hz]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  grid on
  
  PrintFig('Function_f0c',0)
end
  
%% frequency II
xft2 = [5:0.2:12];
yc2 = [0.01:0.005:0.1];
ft2 = repmat(xft2,length(yc2),1);
c2 = repmat(yc2',1,length(xft2));
f02 = ft2./(1-c2);

if NOPLOT
  figure(78722);clf
  imagesc(yc2,xft2,f02')
  cb = colorbar;
  axis xy
  hold on
  plot(yc,ft,'k','LineWidth',1)
  axis tight
  xlabel('compression factor c','FontSize',16)
  ylabel('population frequency f_{\theta} [Hz]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16)
  box off
  grid on
  xlim([0.01 0.1])
  ylim([5 12])
  text(0.125,12.3,'single neuron frequency f_0 [Hz]','rotation',-90,'FontSize',16)
  %text(0.125,12.0,'population frequency f_{\theta} [Hz]','rotation',-90,'FontSize',16)
end
  
%% frequency III
xf02 = [5:0.2:12];
yc2 = [0.01:0.005:0.1];
f02 = repmat(xf02,length(yc2),1);
c2 = repmat(yc2',1,length(xf02));
ft2 = f02.*(1-c2);

figure(78723);clf
set(gcf,'position',[1757 632 393 313])
imagesc(yc2,xf02,ft2')
cb = colorbar;
axis xy
hold on
plot(yc,f0./(1-c),'k--','LineWidth',1)
%plot(yc,f0,'k','LineWidth',1)
axis tight
xlabel('compression factor c','FontSize',16)
ylabel('single neuron frequency f_{0} [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
grid on
xlim([0.01 0.1])
ylim([5 12])
%text(0.125,12.3,'single neuron frequency f_0 [Hz]','rotation',-90,'FontSize',16)
text(0.125,12.0,'population frequency f_{\theta} [Hz]','rotation',-90,'FontSize',16)

%keyboard

PrintFig('Function_ftf0c',0)

%%%%%%%%%%%%%%%%%
%% amplitude
xf0 = [4:0.05:12];
yc = [0.005:0.005:0.1];
%yc = [1:0.05:12];
f0 = repmat(xf0,length(yc),1);
c = repmat(yc',1,length(xf0));

amp = sqrt(pi)*c.*exp(-(pi*c.*f0).^2);

figure(453578);clf
set(gcf,'position',[2159 632 393 313])
imagesc(xf0,yc,amp)
axis xy
xlabel('frequency f_0 [Hz]','FontSize',16)
ylabel('c \sigma','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

PrintFig('Function_amp',0)

hold on
plot(xf0,1./(sqrt(2)*pi*xf0),'k','LineWidth',2);

PrintFig('Function_amp2',0)

%%%%%%%%%%%%%%%%%
%% phase
xf0 = [4:0.05:12];
yc = [0.005:0.005:0.1];
%yc = [1:0.05:12];
f0 = repmat(xf0,length(yc),1);
c = repmat(yc',1,length(xf0));

a = sqrt(-log(0.01));
phi = 4*pi*a * f0.*c *180/pi;

figure(453579);clf
set(gcf,'position',[1757 233 393 313])
imagesc(xf0,yc,phi)
axis xy
xlabel('frequency f_0 [Hz]','FontSize',16)
ylabel('c \sigma','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
hold on
plot(xf0,1./(sqrt(2)*pi*xf0),'k','LineWidth',2)
plot(xf0,1./(2*a*xf0),'--k','LineWidth',2)

h=colorbar;
set(h,'YTick',[0:360:2000],'FontSize',16);

PrintFig('Function_phase',0)




%%%%%%%%%%%%%%%%%
%% optimal frequency
xf0 = [4:0.05:12];
a = sqrt(-log(0.1));
yc = [0.1:0.05:2]*a;
f0 = repmat(xf0,length(yc),1);
c = repmat(yc',1,length(xf0));
fthe = f0.*(1-1./(sqrt(2)*pi*c.*f0/a));

figure(84789);clf
set(gcf,'position',[2159 233 393 313])
imagesc(xf0,yc,fthe)
colorbar
axis xy
xlabel('frequency f_0 [Hz]','FontSize',16)
ylabel('place field size [sec]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
hold on
for n=[5:11]
  f0 = [n+0.05:0.05:12];
  c = 1./(sqrt(2)*pi*(f0-n)/a);
  plot(f0,c,'k')
end
grid on
xlim([4 12])
ylim([min(yc) max(yc)])
%text(13.5,1.55,'popul.frequency f_\theta [Hz]','rotation',-90,'FontSize',16);
text(14.5,2.85,'popul.frequency f_\theta [Hz]','rotation',-90,'FontSize',16);

PrintFig('Function_fth',0)



%return

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Vental Dorsal
ft = 7.3;
t = [-2000:2000]/1000;
tm = repmat(t',1,3);
f0 = [9 8.25 7.5];
xf0 = repmat(f0,length(t),1);
sm = 1./(sqrt(2)*pi*(f0-ft));
ysm = repmat(sm,length(t),1);
c = 1./(sqrt(2)*pi*f0.*sm);
exl = (cos(2*pi*xf0.*tm)+1)/2.*exp(-(tm./ysm).^2/2).*sqrt(pi./ysm);
plot(t,exl)
T = [-1000 0 1000]/1000;

figure(3475);clf;
for n=1:3
  tt = repmat(t',1,length(T));
  TT = repmat(T,length(t),1);
  tau = TT*c(n);
  rr =  (cos(2*pi*f0(n).*(tt-tau))+1)/2.*exp(-((tt-TT)./sm(n)).^2/2).*sqrt(pi./sm(n));
  R = [cos(2*pi*ft*t)+1]/2*max(max(rr));
  subplot(3,1,n)
  hold on
  plot(t,R,'--','color',[1 1 1]*0.5,'LineWidth',2)
  plot(t,rr,'LineWidth',2)
  ylabel('rate','FontSize',16)
  set(gca,'TickDir','out','ytick',[],'FontSize',16)
  box off
  axis tight
end
xlabel('time [sec]','FontSize',16)

PrintFig('Scatch_dorvent',0)

%end

return

%%%%%%%%%%

ft = 8;
vsig = [1 2 4];
hctext = {'dorsal' 'middle' 'ventral'};
a = 2*sqrt(-log(0.1));
figure(246);clf
for m=[1 2 3]
  sig = vsig(m)/a; % [sec]

  f0 = ft + 1/(sqrt(2)*pi*sig);    % [Hz]
  
  cf = 1/(sqrt(2)*pi*sig*f0); % dimension less 
  
  %ft = f0*(1-cf);
  
  t=[1:0.001:10]'; %% 10 sec
  for n=1:100
    T = 0.1*n;
    tau = cf*T;
    y(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2);
  end
  
  %% example neurons
  cl = [50];
  
  %subplot('position',[0.15 0.15 0.7 0.2])
  subplot(3,1,m)
  hold on
  colormap('default')
  cc = colormap;
  k=40; l = round(linspace(1,64,k));
  cll = [30:1:90];
  for n=1:k
    plot(t,y(:,cll(n))/max(y(:,cll(n))),'-','LineWidth',0.1,'Color',cc(l(n),:))
  end
  %plot(t,y(:,cll(k/2))/max(y(:,cll(k/2))),'LineWidth',2,'Color',cc(l(k/2),:))
  plot(t,y(:,cll(k/2))/max(y(:,cll(k/2))),'LineWidth',3,'Color',[0 0 0])
  yy = sum(y,2);
  plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','-','LineWidth',0.1)
  ylabel('rate','FontSize',16)
  xlim([3 7])
  set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
  box off
  text(6.6,1.1,hctext(m),'FontSize',16)
end
set(gca,'TickDir','out','FontSize',16,'XTick',[3:0.5:7],'XTickLabel',[0:0.5:4],'YTick',[])
xlabel('time [sec]','FontSize',16)
%text(5.7,-0.25,'2 sec','FontSize',16)
annotation('line',[1 1]*0.227,[0.11 0.93],'LineStyle','--');
annotation('line',[1 1]*0.275,[0.11 0.93],'LineStyle','--');

PrintFig('Scatch_dorvent',0)

%%%%%%%%%%
ft = 8;
a = 2*sqrt(-log(0.1));
sig = [0.2:0.2:10]; % [sec]
f0 = ft + 1./(sqrt(2)*pi*sig/a);    % [Hz]
cf = 1./(sqrt(2)*pi*sig.*f0/a); % dimension less 

figure(2345);clf;
col = [0.5 0.5 1];
plot(sig,f0,'k')
hold on
plot([1 2 4],ft + 1./(sqrt(2)*pi*[1 2 4]/a),'o','markeredgecolor',col,'markerfacecolor',col)
Lines([],8,'k','--');
set(gca,'TickDir','out','FontSize',16)
xlabel('place field size [sec]','FontSize',16)
ylabel('single neuron frequency [Hz]','FontSize',16)
text(1,8.8,'dorsal','FontSize',16)
text(2,8.45,'middle','FontSize',16)
text(4,8.3,'ventral','FontSize',16)
xlim([0 8])
ylim([7.5 10])
box off

PrintFig('Scatch_dorvent_b',0)
