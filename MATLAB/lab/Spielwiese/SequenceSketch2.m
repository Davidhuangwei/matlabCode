function SequenceSketch2

NOPLOT = 0;
GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% default parameters
sig = 0.32; % [sec]
sig = 0.3; % [sec]
f0 = 9;    % [Hz]
cf = 1/(3*sqrt(2)*sig*f0); % dimension less 

ft = f0*(1-cf)


%% generate place cell probability 
t=[1:0.001:10]'; %% 10 sec
for n=1:100
  %T = 0.1*n;
  T = 1/ft*n;
  tau = cf*T;
  y(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2);
  y2(:,n) = exp(-(t-T).^2/sig^2);
end

%% XLim
xcoor = [0 1]+4.8;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example Figure
figure(1233);clf
set(gcf,'position',[1829 370 592 541])
set(gcf,'color',[1 1 1])

%%
subplot('position',[0.1 0.49 0.8 0.37])
hold on
colormap('default')
cc = colormap;
k=8; l = round(linspace(1,64,k));
cll = [40:1:70];
cll2 = [35:1:39];
cll3 = [40+k:1:40+k+4];
for n=1:length(cll2)
  plot(t,y2(:,cll2(n))/max(y2(:,cll2(n))),'LineWidth',2,'Color',[1 1 1]*(11-n)/10)
end
for n=1:length(cll3)
  plot(t,y2(:,cll3(n))/max(y2(:,cll3(n))),'LineWidth',2,'Color',[1 1 1]*(n+5)/10)
end
for n=1:k
  plot(t,y2(:,cll(n))/max(y2(:,cll(n))),'LineWidth',2,'Color',cc(l(n),:))
  %plot(t,y(:,cll(n))/max(y(:,cll(n))),'LineWidth',1,'Color',cc(l(n),:))
  text(1/ft*cll(n)-0.03,1.2,['P' num2str(n)],'FontSize',16,'color',cc(l(n),:))
end
Lines(xcoor,2.1-0.25,'k','-',3);
xlim(xcoor);
ylim([0 2.5])
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off

for n=1:8
  annotation('arrow',[n*0.09+0.08 n*0.02+0.4],[0.7 0.75],'color',cc(l(n),:),'LineWidth',2,'HeadStyle','vback1','HeadLength',8,'HeadWidth',8);
end


subplot('position',[0.1 0.34 0.8 0.14])
hold on
colormap('default')
cc = colormap;
k=8; l = round(linspace(1,64,k));
%% loop though neurons
for n=1:k
  tau = cf/ft*cll(n);
  %% time of peak oscil of single neuron
  LL = [0:500]/f0+tau;
  %% phase of firing \w respect to POP
  PP = mod(2*pi*ft*LL-pi,2*pi);
  %% oscil ampl at LL
  AA = 0.5*(1+cos(2*pi*f0*(LL-tau))).*exp(-(LL-1/ft*cll(n)).^2/sig^2);
  gAA = find(AA>0.11);
  length(gAA)

  %% loop through circles
  for m=1:length(gAA)
    %Lines(LL(gAA(m)),[0 0.3]-0.5+n*0.05,cc(l(n),:),[],AA(gAA(m))*5);
    Lines(LL(gAA(m)),([0 0.3]+PP(gAA(m))/5-0.6),cc(l(n),:),[],AA(gAA(m))*3.8);
  end
  %y(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau))).*exp(-(t-T).^2/sig^2);
end
%% loop though EXTRA neurons
for n=1:length(cll2)
  tau = cf/ft*cll2(n);
  %% time of peak oscil of single neuron
  LL = [0:500]/f0+tau;
  %% phase of firing \w respect to POP
  PP = mod(2*pi*ft*LL-pi,2*pi);
  %% oscil ampl at LL
  AA = 0.5*(1+cos(2*pi*f0*(LL-tau))).*exp(-(LL-1/ft*cll2(n)).^2/sig^2);
  gAA = find(AA>0.11);
  length(gAA)
  %% loop through circles
  for m=1:length(gAA)
    Lines(LL(gAA(m)),([0 0.3]+PP(gAA(m))/5-0.6),[1 1 1]*(11-n)/10,[],AA(gAA(m))*3.8);
  end
end
for n=1:length(cll3)
  tau = cf/ft*cll3(n);
  %% time of peak oscil of single neuron
  LL = [0:500]/f0+tau;
  %% phase of firing \w respect to POP
  PP = mod(2*pi*ft*LL-pi,2*pi);
  %% oscil ampl at LL
  AA = 0.5*(1+cos(2*pi*f0*(LL-tau))).*exp(-(LL-1/ft*cll3(n)).^2/sig^2);
  gAA = find(AA>0.11);
  length(gAA)
  %% loop through circles
  for m=1:length(gAA)
    Lines(LL(gAA(m)),([0 0.3]+PP(gAA(m))/5-0.6),[1 1 1]*(n+5)/10,[],AA(gAA(m))*3.8);
  end
end
%%
yy = sum(y,2);
plot(t,-[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','-','LineWidth',2)
%plot(t,-cos(2*pi*ft*t)/2-0.5,'color',[1 0 0],'LineStyle','-','LineWidth',2)
xlabel('time [sec]','FontSize',16)
axis tight
xlim(xcoor)
set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
box off
axis off


PrintFig('FigForGyuri5',1);

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

