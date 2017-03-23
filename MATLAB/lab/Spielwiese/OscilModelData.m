function OscilModelData(ALL)

%% reproduce data

NOPLOT = 0;
GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get data
CatAll = CatStruct(ALL);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% default parameters

sig = 0.3; % [sec]
f0 = 8;    % [Hz]
cf = 1/(sqrt(2)*pi*sig*f0); % dimension less 

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
subplot('position',[0.15 0.65 0.7 0.2])
colormap('default')
imagesc(t,[],y')
axis xy
ylabel('cell #','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[],'yTick',[])
xlim([4 6])
ylim([38 62])
box off
colormap('default')

subplot('position',[0.15 0.4 0.7 0.2])
hold on
%% 
cc = colormap('lines');
l = 1:3;
k=3; %l = round(linspace(1,64,k));
%cl = [47:3:53];
%cl = [23:2:27];
for n=1:k
  plot(t,y(:,cl(n))/max(y(:,cl(n))),'LineWidth',2,'Color',cc(l(n),:))
end
yy = sum(y,2);
plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
ylabel('rate','FontSize',16)
xlim([4 6])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off
text(3.95,0.25,'rate','FontSize',16,'rotation',90)

subplot('position',[0.15 0.15 0.7 0.2])
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
ylabel('rate','FontSize',16)
xlim([4 6])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off
text(5.7,-0.25,'2 sec','FontSize',16)
text(3.95,0.25,'rate','FontSize',16,'rotation',90)

PrintFig('OscilModel.crt',GoPrint)

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

figure(762346);clf
subplot('position',[0.15 0.15 0.7 0.8])
hold on
cc = colormap('lines');
l = 1:3;
k=3; %l = round(linspace(1,64,k));
rate = 100/sig;
for n=1:k
  y2 = y(:,cl(n))/max(y(:,cl(n)));
  y3 = cumsum(y2)/sum(y2);
  r = rand(10000,1);
  [xx xi yi] = NearestNeighbour(y3,r);
  %% randomize
  rdt =  t(xi)+(rand(size(xi))-0.5)*0.14;
  rph =  phi(xi)*180/pi + (rand(size(xi))-0.5)*0;
  
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
%text(3.95,300,'phase','FontSize',16,'rotation',90)
text(3.75,300,'phase','FontSize',16,'rotation',90)
text(5.7,-70,'2 sec','FontSize',16)

%%%%%%%%
subplot('position',[0.85 0.15 0.1 0.8])
plot(h,bin(1:end-1)+mean(diff(bin))/2,'LineWidth',2)
axis tight
xlim([0 max(h(:))])
ylim([0 720])
box off
axis off
text(100,-70,'count','FontSize',16)


PrintFig(['OscilModelScatchPh'],GoPrint)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% frequency and amplitude

%% optimal parameters
sig = 0.3; % [sec]
f0 = 8;    % [Hz]
cf = 1/(sqrt(2)*pi*sig*f0); % dimension less 

ft = f0*(1-cf);

t=[1:0.001:10]'; %% 10 sec


%% delay - compression factor
k=20;
for m=1:k
  cfm(m) = m * cf/k*2;
  f0m(m) = m * f0/k + f0/2;
  sigm(m) = m*0.1;
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
  % f0
  sy = sum(yf0,2)/max(sum(yf0,2));
  ampf0(m) = diff([min(sy(gt)) max(sy(gt))]);
  ftf0(m) = f0m(m)*(1-cf);
  % sig
  sy = sum(ysig,2)/max(sum(ysig,2));
  ampsig(m) = diff([min(sy(gt)) max(sy(gt))]);
  ftsig(m) = f0*(1-cf);
  sigma = sigm*sqrt(-log(0.1))*2;
end

figure(72356);clf
c = [0.5 0.5 1];
%
subplot(321)
plot(cfm,fttau,'o','markeredgecolor',c,'markerfacecolor',c);
set(gca,'TickDir','out','FontSize',16)
xlabel('compression factor','FontSize',16)
ylabel('popul. freq. [Hz]','FontSize',16)
axis tight 
box off
Lines(cf,[],[],'--');
%
subplot(322)
plot(cfm,amptau,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16)
xlabel('compression factor','FontSize',16)
ylabel('rel. amplitude','FontSize',16)
axis tight 
ylim([0 1])
box off
Lines(cf,[],[],'--');
%
subplot(323)
plot(f0m,ftf0,'o','markeredgecolor',c,'markerfacecolor',c);
set(gca,'TickDir','out','FontSize',16)
xlabel('frequency [Hz]','FontSize',16)
ylabel('popul. freq. [Hz]','FontSize',16)
hold on
plot([4 12],[4 12],'k--')
axis tight 
box off
Lines(f0,[],[],'--');
%
subplot(324)
plot(f0m,ampf0,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16)
xlabel('frequency [Hz]','FontSize',16)
ylabel('rel. amplitude','FontSize',16)
axis tight 
ylim([0 1])
box off
Lines(f0,[],[],'--');
%
subplot(325)
plot(sigma,ftsig,'o','markeredgecolor',c,'markerfacecolor',c);
set(gca,'TickDir','out','FontSize',16)
xlabel('field size [s]','FontSize',16)
ylabel('popul. freq. [Hz]','FontSize',16)
axis tight 
box off
Lines(sig*sqrt(-log(0.1))*2,[],[],'--');
%
subplot(326)
plot(sigma,ampsig,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16)
xlabel('field size [s]','FontSize',16)
ylabel('rel. amplitude','FontSize',16)
axis tight 
ylim([0 1])
box off
Lines(sig*sqrt(-log(0.1))*2,[],[],'--');


PrintFig(['OscilModel.var'],GoPrint)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Suppl: cell density
sig = 0.3; % [sec]
f0 = 8;    % [Hz]
cf = 1/(sqrt(2)*pi*sig*f0); % dimension less 
ft = f0*(1-cf);
t=[1:0.001:10]'; %% 10 sec

%% fft
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
gt = find(t>2 & t<8);
L = length(t(gt));                     % Length of signal
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2);

figure(4536);clf;

k=0;s=1;sy=[];
for m=[1 10 100 1000]
  k=k+1;
  y = [];%zeros(size(t));
  for n=1:m
    T = n/m*10;
    tau = cf*T;
    %y = y+0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2)/m;
    y(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2)/m;
  end
  gt = find(t>3 & t<7);
  sy(k,:) = sum(y,2)/max(sum(y,2));
  amp(k) = diff([min(sy(k,gt)) max(sy(k,gt))]);
  %% fft
  Y = fft(sy(k,gt),NFFT)/L;
  PY(k,:) = 2*abs(Y(1:NFFT/2));
  
  if k==2 
    subplot(2,2,1)
    hold on
    colormap('default')
    cc = colormap;
    q=5; l = round(linspace(1,64,q));
    cll = [2:m];
    plot(t,sy(k,:),'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
    for r=1:q
      plot(t,y(:,cll(r))/max(y(:,cll(r))),'LineWidth',2,'Color',cc(l(r),:))
    end
    xlim([2 4])
    ylim([0 1.1])
    set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
    box off
    axis off
    %text(3.7,-0.25,'2 sec','FontSize',16)
    text(1.95,0.25,'rate','FontSize',16,'rotation',90)

  end
  if k==4
    subplot(2,2,3)
    hold on
    colormap('default')
    cc = colormap;
    q=round(m/5); l = round(linspace(1,64,q));
    cll = [q:m];
    for r=1:q
      plot(t,y(:,cll(r))/max(y(:,cll(r))),'LineWidth',2,'Color',cc(l(r),:))
    end
    plot(t,sy(k,:),'color',[1 1 1]*0.8,'LineStyle','--','LineWidth',2)
    xlim([2 4])
    ylim([0 1.1])
    set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
    box off
    axis off
    text(3.7,-0.25,'2 sec','FontSize',16)
    text(1.95,0.25,'rate','FontSize',16,'rotation',90)
  end
end

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

