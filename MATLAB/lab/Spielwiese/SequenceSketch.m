function SequenceSketch

NOPLOT = 0;
GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% default parameters
sig = 0.32; % [sec]
sig = 0.2; % [sec]
f0 = 11;    % [Hz]
cf = 1/(3*sqrt(2)*sig*f0); % dimension less 

ft = f0*(1-cf);


%% generate place cell probability 
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
figure(1233);clf
set(gcf,'position',[1829 370 592 541])

%%
subplot('position',[0.1 0.55 0.8 0.25])
hold on
colormap('default')
cc = colormap;
k=8; l = round(linspace(1,64,k));
cll = [40:1:70];
for n=1:k
  plot(t,y2(:,cll(n))/max(y2(:,cll(n))),'LineWidth',2,'Color',cc(l(n),:))
  %plot(t,y(:,cll(n))/max(y(:,cll(n))),'LineWidth',1,'Color',cc(l(n),:))
  text(0.1*cll(n)-0.03,1.2,['P' num2str(n)],'FontSize',16,'color',cc(l(n),:))
end
yy = sum(y,2);
%plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
%xlabel('time [sec]','FontSize',16)
%ylabel('probability','FontSize',16)
Lines([3 5],2.1,'k','-',3)
xlim([3.95 4.8])
ylim([0 2.5])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off

for n=1:8
  annotation('arrow',[n*0.09+0.051 n*0.02+0.4],[0.7 0.75],'color',cc(l(n),:),'LineWidth',2,'HeadStyle','vback1','HeadLength',8,'HeadWidth',8);
end


subplot('position',[0.1 0.4 0.8 0.14])
hold on
colormap('default')
cc = colormap;
k=8; l = round(linspace(1,64,k));
cll = [40:1:70];
for n=1:k
  %plot(t,y2(:,cll(n))/max(y2(:,cll(n))),'LineWidth',2,'Color',cc(l(n),:))
  %plot(t,y(:,cll(n))/max(y(:,cll(n))),'LineWidth',2,'Color',cc(l(n),:))
  
  tau = cf*0.1*cll(n);
  LL = ([0:100])/f0+tau;
  PP = mod(2*pi*ft*LL-pi,2*pi);
  AA = 0.5*(1+cos(2*pi*f0*(LL-tau))).*exp(-(LL-0.1*cll(n)).^2/sig^2);
  gAA = find(AA>0.11);
  length(gAA)
  %Lines(LL(gAA),[0 0.3]-0.5+n*0.05,cc(l(n),:),[],AA(gAA)*5);
  for m=1:length(gAA)
    %Lines(LL(gAA(m)),[0 0.3]-0.5+n*0.05,cc(l(n),:),[],AA(gAA(m))*5);
    Lines(LL(gAA(m)),([0 0.3]+PP(gAA(m))/6-0.7),cc(l(n),:),[],AA(gAA(m))*5);
  end
  %y(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2);
end
yy = sum(y,2);
plot(t,-[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','-','LineWidth',2)
xlabel('time [sec]','FontSize',16)
axis tight
xlim([3.95 4.8])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off


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

