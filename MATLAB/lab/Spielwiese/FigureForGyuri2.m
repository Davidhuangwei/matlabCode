function FigureForGyuri2

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
  y2(:,n) = exp(-(t-T).^2/sig^2);
end

%% example neurons
cl = [23:2:27]*2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example Figure
figure(123);clf
set(gcf,'position',[1829 370 592 541])


%%
subplot('position',[0.15 0.7 0.7 0.15])
hold on
%% 
yy = sum(y,2);
%plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
cc = colormap('lines');
l = 1:3;
k=3;
for n=1:k
  plot(t,y2(:,cl(n))/max(y2(:,cl(n))),'-','LineWidth',1,'Color',[1 1 1]*0.7)
end
for n=1:k
  plot(t,y(:,cl(n))/max(y(:,cl(n))),'LineWidth',2,'Color',cc(l(n),:))
end
ylim([0 1.01])
Lines([0.1*cl(1) 0.1*cl(2)],[],'k','-',1);
Lines(4.755,[0 0.9],'k','-',1);
Lines(4.8,[0 0.9],'k','-',1);
%Lines(4.755,[0.8 0.9],'k','-',2);
%Lines(4.8,[0.64 0.9],'k','-',2);
Lines([4.755 4.8],0.85,'k','-',1);
ylabel('rate','FontSize',16)
xlim([4 6])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off
text(3.9,0.05,'probability','FontSize',16,'rotation',90)

subplot('position',[0.15 0.85 0.7 0.05])
xlim([4 6])
ylim([0 1])
Lines([0.1*cl(1) 0.1*cl(2)],[],'k','-',1);
ylim([0 1])
a1=annotation('doublearrow',[0.36 0.5],[0.89 0.89]);
set(a1,'Head1Style','vback1','Head2Style','vback1','Head1Length',5,'Head1Width',5,'Head2Length',5,'Head2Width',5)
text(4.75,1.4,'T','FontSize',24);
a2=annotation('arrow',[0.44 0.425],[0.855 0.835]);
set(a2,'HeadStyle','vback1','HeadLength',5,'HeadWidth',5)
text(4.85,0.3,'\tau','FontSize',24)
axis off


%%
subplot('position',[0.15 0.5 0.7 0.15])
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
%text(5.7,-0.25,'2 sec','FontSize',16)
text(3.9,0.05,'probability','FontSize',16,'rotation',90)
text(6.06,0.6,'2A','FontSize',16);
b=0.05;
annotation('line',[0.875 0.875]+0.01,[0.67 0.695]-b,'LineWidth',2);
annotation('line',[0.875 0.875]+0.01,[0.59 0.62]-b,'LineWidth',2);

annotation('line',[0.87 0.88]+0.01,[0.59 0.59]-b,'LineWidth',2);
annotation('line',[0.87 0.88]+0.01,[0.695 0.695]-b,'LineWidth',2);


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
PrintFig('FigGyuri3',GoPrint)


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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
