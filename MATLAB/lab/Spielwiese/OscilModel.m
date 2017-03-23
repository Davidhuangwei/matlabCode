function OscilModel

%%function [Pyy f y t] = OscilModel_F(varargin)
%%[speed,compress,freq,slope,plotting] = DefaultArgs(varargin,{30,0.0042,6.5,0.05,1});
%% speed = cm/s
%% compress = s/cm
%% freq = Hz 
%% slope = 1/[s cm]


%% default

[Pyy f y t] = OscilModel_F([],[],[],0);

figure(123);clf
subplot('position',[0.1 0.65 0.8 0.2])
colormap('default')
imagesc(t,[],y')
axis xy
ylabel('cell #','FontSize',16)
set(gca,'TickDir','out','FontSize',16,'XTick',[],'yTick',[])
xlim([0 2])
ylim([1 25])
box off
colormap('default')

subplot('position',[0.1 0.4 0.8 0.2])
hold on
%% 
cc = colormap('lines');
l = 1:3;
k=3; %l = round(linspace(1,64,k));
cl = [47:3:53];
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

figure(76263);clf
subplot('position',[0.1 0.15 0.8 0.8])
hold on
cc = colormap('lines');
l = 1:3;
k=3; %l = round(linspace(1,64,k));
cl = [47:3:53];
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
  
%% compute the phase of yy
gt = find(t>1 & t<=9);
t2 = t(gt)'-1;
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

figure(762345);clf
subplot('position',[0.1 0.15 0.8 0.8])
hold on
cc = colormap('lines');
l = 1:3;
k=3; %l = round(linspace(1,64,k));
cl = [47:3:53];
for n=1:k
  y2 = y(gt,cl(n))/max(y(gt,cl(n)));
  ry2 = (repmat(y2,1,50)).*rand(length(y2),50)*30;
  gy = mod(find(ry2>7.5),length(y2));
  gy(find(gy==0)) = length(y2);
  %% refractory
  
  
  rdt =  dt(gy)+(rand(size(gy))-0.5)*0.15;
  rph =  phi(gy)*180/pi + (rand(size(gy))-0.5)*20;
  
  plot(rdt,rph,'o','markersize',5,'markerfacecolor',cc(l(n),:),'markeredgecolor',cc(l(n),:))
  plot(rdt,rph+360,'o','markersize',5,'markerfacecolor',cc(l(n),:),'markeredgecolor',cc(l(n),:))
  
  
  %m=4;
  %rdt =  dt(gy);
  %rph =  phi(gy)*180/pi;
  %plot(rdt,rph,'o','markerfacecolor',cc(m,:),'markeredgecolor',cc(m,:))
  %plot(rdt,rph+360,'o','markerfacecolor',cc(m,:),'markeredgecolor',cc(m,:))
  
  %plot(t2,y2 * 360,'color',cc(l(n),:));
   
  ylabel('phase','FontSize',16)
  xlim([3 5])
  set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
  box off
  axis off
  text(2.95,360,'phase','FontSize',16,'rotation',90)
  text(4.8,-0.1,'2 sec','FontSize',16,'color',[1 1 1]*0.99)
end
PrintFig(['OscilModelScatchPh'],0)



figure(123)
subplot('position',[0.1 0.15 0.8 0.2])
hold on
colormap('default')
cc = colormap;
k=11; l = round(linspace(1,64,k));
cl = [40:2:60];
for n=1:k
  plot(t,y(:,cl(n))/max(y(:,cl(n))),'LineWidth',2,'Color',cc(l(n),:))
end
yy = sum(y,2);
plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
xlabel('time [sec]','FontSize',16)
ylabel('rate','FontSize',16)
xlim([4 6])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off
text(5.8,-0.25,'2 sec','FontSize',16)
text(3.95,0.25,'rate','FontSize',16,'rotation',90)

PrintFig('OscilModel.crt',0)



%% delay - compression factor

for a=0:20
  A = 0.0005*a;
  [Pyy f y t] = OscilModel_F([],A,[],[],0);
  [mf fi] = max(Pyy(2:end));
  
  ay = sum(y,2);
  amp = max(ay(200:end-200))-min(ay(200:end-200));
  DF(:,a+1) = [A; amp; f(fi)];
end

yy = sum(y,2);
  
figure(124);clf
subplot(321)
c = [0.5 0.5 1];
plot(DF(1,1:end-1)*1000,DF(3,1:end-1),'o','markeredgecolor',c,'markerfacecolor',c)
axis tight; box off
g=get(gca,'ylim');
ylim([floor(g(1)) ceil(g(2))])
set(gca,'TickDir','out','FontSize',16)
title('frequency','FontSize',16)
xlabel('delay [ms/cm]','FontSize',16)
ylabel('freqyuency [Hz]','FontSize',16)

subplot(322)
c = [0.5 0.5 1];
plot(DF(1,1:end-1)*1000,DF(2,1:end-1),'o','markeredgecolor',c,'markerfacecolor',c)
axis tight; box off
g=get(gca,'ylim');
ylim([floor(g(1)) ceil(g(2))])
set(gca,'TickDir','out','FontSize',16)
title('amplitude','FontSize',16)
xlabel('delay [ms/cm]','FontSize',16)
ylabel('amplitude','FontSize',16)

clear DF

%% frequency

for a=0:20
  A = 0.5*a+4;
  [Pyy f y t] = OscilModel_F(30,[],A,0.05,0);
  [mf fi] = max(Pyy(2:end));
  
  ay = sum(y,2);
  amp = max(ay(200:end-200))-min(ay(200:end-200));
  DF(:,a+1) = [30*0.05+A; amp; f(fi)];
end

yy = sum(y,2);
  
figure(124);
subplot(323)
%c = [0.5 1 0.5];
plot(DF(1,:),DF(3,:),'o','markeredgecolor',c,'markerfacecolor',c)
hold on
a1 = min(DF(1,:));
a2 = max(DF(1,:));
plot([a1 a2],[a1 a2],'Color',[1 1 1]*0.5,'LineStyle','--');
%title('frequency','FontSize',16)
xlabel('frequency [Hz]','FontSize',16)
ylabel('freqyuency [Hz]','FontSize',16)
axis tight; box off
g=get(gca,'ylim');
ylim([floor(g(1)) ceil(g(2))])
set(gca,'TickDir','out','FontSize',16)

subplot(324)
%c = [0.5 1 0.5];
plot(DF(1,:),DF(2,:),'o','markeredgecolor',c,'markerfacecolor',c)
%title('LFP vs. oscillator frequency','FontSize',16)
xlabel('frequency [Hz]','FontSize',16)
ylabel('amplitude','FontSize',16)
axis tight; box off
g=get(gca,'ylim');
ylim([floor(g(1)) ceil(g(2))])
set(gca,'TickDir','out','FontSize',16)

clear DF

%% speed

for a=1:20
  A = 5*a;
  [Pyy f y t] = OscilModel_F(A,[],[],[],0);
  [mf fi] = max(Pyy(2:end));
  
  ay = sum(y,2);
  amp = max(ay(200:end-200))-min(ay(200:end-200));
  DF(:,a) = [A; amp; f(fi)];
end

yy = sum(y,2);
  
figure(124);
subplot(325)
%c = [1 0.5 0.5];
plot(DF(1,1:end-5),DF(3,1:end-5),'o','markeredgecolor',c,'markerfacecolor',c)
%title('LFP frequency vs. speed','FontSize',16)
xlabel('speed [cm/s]','FontSize',16)
ylabel('freqyuency [Hz]','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
axis tight; box off
g=get(gca,'ylim');
ylim([floor(g(1)) ceil(g(2))])
subplot(326)
%c = [1 0.5 0.5];
plot(DF(1,1:end-5),DF(2,1:end-5),'o','markeredgecolor',c,'markerfacecolor',c)
%title('LFP amplitude vs. speed','FontSize',16)
xlabel('speed [cm/s]','FontSize',16)
ylabel('amplitude','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
axis tight; box off
g=get(gca,'ylim');
ylim([floor(g(1)) ceil(g(2))])



%%%%%%%%%%%%%%%%%
%% cross correlograms:

[C L] = xcorr(y(:,50),y(:,52));
L = L*t(1);
TRate = 1/t(1); 

figure(1235)
subplot(211)
plot(L,C)
MinC = LocalMinima(-C,1,-max(C)/20);
RMinC = 1/mean(diff(L(MinC)));
title(['Rate = ' num2str(RMinC)]);
subplot(212)
plot(t-5,y(:,[50 52]))
MinY1 = LocalMinima(-y(:,50),1,-max(y(:,50))/20);
MinY2 = LocalMinima(-y(:,52),1,-max(y(:,52))/20);
RMinY1 = 1/mean(diff(t(MinY1)))
RMinY2 = 1/mean(diff(t(MinY2)))
title(['Rate1 = ' num2str(RMinY1) ' and Rate2 = ' num2str(RMinY2)]);

ForAllSubplots('xlim([-1 1])')




%%%%%%%%%%%%%
%% plotting analytical function:

%% freqeuncy:
%f0 = [6:0.1:12];
%sig = [0.1:0.05:2]; 

%mf0 = repmat(f0',1,length(sig));
%msig = repmat(sig,length(f0),1);

%pf = mf0.*(1-1./(sqrt(2)*pi*msig.*mf0));

%figure(347357);clf
%imagesc(f0,sig,pf')
%axis xy
%colorbar

%% amplitude:




return


%%%%%%%%%%%%%%%%%%%%%%%%%

figure(666)
plot([1:length(whl.speed)]/39.0625,whl.speed)
[gx gy] = ginput(2);
ForAllSubplots(['xlim([' num2str(gx(1)) ' '  num2str(gx(2)) '])'])

figure(666)
subplot(411)
plot([1:length(whl.speed)]/39.0625,whl.speed)
axis tight
subplot(412)
plot(spike.t/20000,spike.ind,'.')
axis tight
subplot(413)
[H,HN] = hist(spike.t/20000,500000);
bar(HN,H);
subplot(414)
plot([1:length(Eeg)]/1250,Eeg)
axis tight
ForAllSubplots(['xlim([' num2str(gx(1)) ' '  num2str(gx(2)) '])'])

[gx gy] = ginput(2);
ForAllSubplots(['xlim([' num2str(gx(1)) ' '  num2str(gx(2)) '])'])



