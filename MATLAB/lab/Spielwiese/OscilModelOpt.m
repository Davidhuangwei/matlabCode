function OscilModelOpt

NOPLOT = 0;
GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% default parameters

sig = 0.35; % [sec]
f0 = 8;    % [Hz]
cf = 1/(sqrt(2)*pi*sig*f0); % dimension less 

L = sig;

ft = f0*(1-cf);

t=[1:0.001:10]'; %% 10 sec
for n=1:100
  T = 0.1*n;
  tau = cf*T;
  y(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2);
end

%% example neurons
cl = [23:2:27]*2;

fprintf(['f0=' num2str(f0) 'c=' num2str(cf) ' L=' num2str() '\n']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example Figure
figure(123);clf
set(gcf,'position',[1829         370         592         541])

subplot('position',[0.15 0.75 0.7 0.15])
hold on
%% 
yy = sum(y,2);
plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
cc = colormap('lines');
l = 1:3;
k=3; %l = round(linspace(1,64,k));
%cl = [47:3:53];
%cl = [23:2:27];
for n=1:k
  plot(t,y(:,cl(n))/max(y(:,cl(n))),'LineWidth',2,'Color',cc(l(n),:))
end
ylabel('rate','FontSize',16)
xlim([4 6])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off
text(3.9,0.05,'probability','FontSize',16,'rotation',90)

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

%text(3.65,3.5,'A','FontSize',16);
text(3.65,2.2,'A','FontSize',16);
text(3.65,1,'B','FontSize',16);


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

%figure(762346);clf
subplot('position',[0.15 0.15 0.7 0.3])
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
sig = 0.33; % [sec]
a = sqrt(-log(0.01));
f0 = 8;    % [Hz]
cf = 1/(sqrt(2)*pi*sig*f0); % dimension less 

ft = f0*(1-cf);

t=[1:0.001:10]'; %% 10 sec

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
  dphitau(m,:) = 4*pi*a *f0 *cfm(m) *sig *180/pi;
  % f0
  sy = sum(yf0,2)/max(sum(yf0,2));
  ampf0(m) = diff([min(sy(gt)) max(sy(gt))]);
  ftf0(m) = f0m(m)*(1-cf);
  %dphif0(m,:) = OscilModelOpt_funcPhi(sig,cf,f0m(m),ftf0(m),50*0.1);
  dphif0(m,:) = 4*pi*a *f0m(m) *cf *sig *180/pi;
  % sig
  sy = sum(ysig,2)/max(sum(ysig,2));
  ampsig(m) = diff([min(sy(gt)) max(sy(gt))]);
  ftsig(m) = f0*(1-cf);
  sigma = sigm*sqrt(-log(0.1))*2;
  %dphisig(m,:) = OscilModelOpt_funcPhi(sigm(m),cf,f0,ftsig(m),50*0.1);
  dphisig(m,:) = 4*pi*a *f0 *cf *sigm(m) *180/pi;
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
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('compression factor c','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75])
ylabel('popul. freq. [Hz]','FontSize',16,'position',[mean(a)-diff(a)*0.7 mean(b)])
%
subplot('position',[0.44 0.75 0.2 0.2]) %% 332
plot(cfm,amptau,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16)
axis tight 
ylim([0 1])
box off
Lines(cf,[],[],'--');
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('compression factor c','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75]) 
ylabel('amplitude A','FontSize',16,'position',[mean(a)-diff(a)*0.7 mean(b)])
%
subplot('position',[0.75 0.75 0.2 0.2]) %% 333
plot(cfm,dphitau,'o','markeredgecolor',c,'markerfacecolor',c)
%set(gca,'TickDir','out','FontSize',16,'YTick',[0:180:720])
set(gca,'TickDir','out','FontSize',16,'YTick',[0:360:1080])
axis tight 
ylim([0 1160])
box off
Lines(cf,[],[],'--');
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('compression factor c','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75])
ylabel('tot. phase \Delta\Phi [deg]','FontSize',16,'position',[mean(a)-diff(a)*0.8 mean(b)])
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
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('frequency f_0 [Hz]','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75])
ylabel('popul. freq. [Hz]','FontSize',16,'position',[mean(a)-diff(a)*0.7 mean(b)])
%
subplot('position',[0.44 0.45 0.2 0.2]) %% 335
plot(f0m,ampf0,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16,'XTick',[4:2:12])
axis tight 
xlim([4 12])
ylim([0 1])
box off
Lines(f0,[],[],'--');
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('frequency f_0 [Hz]','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75])
ylabel('amplitude A','FontSize',16,'position',[mean(a)-diff(a)*0.7 mean(b)])
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
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('frequency f_0 [Hz]','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75])
ylabel('tot. phase \Delta\Phi [deg]','FontSize',16,'position',[mean(a)-diff(a)*0.8 mean(b)])
%
%
subplot('position',[0.15 0.15 0.2 0.2]) %% 337
plot(sigma,ftsig,'o','markeredgecolor',c,'markerfacecolor',c);
set(gca,'TickDir','out','FontSize',16,'YTick',[4:2:12])
axis tight 
ylim([4 12])
box off
Lines(sig*sqrt(-log(0.1))*2,[],[],'--');
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('field size L [s]','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75])
ylabel('popul. freq. [Hz]','FontSize',16,'position',[mean(a)-diff(a)*0.7 mean(b)])
%
subplot('position',[0.44 0.15 0.2 0.2]) %% 338
plot(sigma,ampsig,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16)
axis tight 
ylim([0 1])
box off
Lines(sig*sqrt(-log(0.1))*2,[],[],'--');
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('field size L [s]','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75])
ylabel('amplitude A','FontSize',16,'position',[mean(a)-diff(a)*0.7 mean(b)])
%
subplot('position',[0.75 0.15 0.2 0.2]) %% 339
plot(sigma,dphisig,'o','markeredgecolor',c,'markerfacecolor',c)
set(gca,'TickDir','out','FontSize',16,'YTick',[0:360:1260])
axis tight 
ylim([0 1160]);
box off
Lines(sig*sqrt(-log(0.1))*2,[],[],'--');
a = get(gca,'XLim');
b = get(gca,'YLim');
xlabel('field size L [s]','FontSize',16,'position',[mean(a) mean(b)-diff(b)*0.75])
ylabel('tot. phase \Delta\Phi [deg]','FontSize',16,'position',[mean(a)-diff(a)*0.8 mean(b)])


text(-11.3,4600,'D','FontSize',16);
text(-11.3,2850,'E','FontSize',16);
text(-11.3,1150,'F','FontSize',16);



PrintFig(['OscilModel.var'],GoPrint)







return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Suppl: cell density
sig = 0.33; % [sec]
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

