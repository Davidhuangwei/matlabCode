function SVMUmodelFigs

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

%%%%%%%%%%%%%%%%%%%%


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


%%%%%%%%%%%%%%%%%
%% frequency I
figure(78789);clf
xf0 = [5:1:12];
yc = [0.01:0.005:0.1];
f0 = repmat(xf0,length(yc),1);
c = repmat(yc',1,length(xf0));
ft = f0.*(1-c);
plot(yc,ft,'k','LineWidth',2)
axis tight
xlabel('compression factor c','FontSize',16)
ylabel('popul.frequency f_\theta [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
grid on
PrintFig('Function_f0c',0)

%% frequency II
xf0 = [4:0.1:12];
yc = [0.01:0.005:0.1];
f0 = repmat(xf0,length(yc),1);
c = repmat(yc',1,length(xf0));
ft = f0.*(1-c);
figure(78780);clf
imagesc(yc,xf0,ft')
axis xy
hold on
xft = [4:1:11];
yc = [0.01:0.005:0.1];
ft = repmat(xft,length(yc),1);
c = repmat(yc',1,length(xft));
f0 = ft./(1-c);
plot(yc,f0,'k','LineWidth',1)
axis tight
xlim([0.01 0.1])
ylim([4 12])
xlabel('compression factor c','FontSize',16)
ylabel('popul.frequency f_0 [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
grid on
PrintFig('Function_f0c',0)
colorbar;


%% amplitude
xf0 = [4:0.05:12];
yc = [0.005:0.005:0.1];
%yc = [1:0.05:12];

f0 = repmat(xf0,length(yc),1);
c = repmat(yc',1,length(xf0));

amp = sqrt(pi)*c.*exp(-(pi*c.*f0).^2);
figure(453578);clf
imagesc(xf0,yc,amp)
axis xy
xlabel('frequency f_0 [Hz]','FontSize',16)
ylabel('c \sigma','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

PrintFig('Function_amp',0)

hold on
plot(xf0,1./(sqrt(2)*pi*xf0),'k','LineWidth',2)
PrintFig('Function_amp2',0)


%% optimal frequency
xf0 = [4:0.05:12];
yc = [0.1:0.05:2];
f0 = repmat(xf0,length(yc),1);
c = repmat(yc',1,length(xf0));

fthe = f0.*(1-1./(sqrt(2)*pi*c.*f0));
figure(84789);clf
imagesc(xf0,yc,fthe)
axis xy
xlabel('frequency f_0 [Hz]','FontSize',16)
ylabel('\sigma [sec]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off

hold on
for n=[5:11]
  f0 = [n+0.05:0.05:12];
  c = 1./(sqrt(2)*pi*(f0-n));
  plot(f0,c,'k')
end
grid on

colorbar;

PrintFig('Function_fth',0)


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
