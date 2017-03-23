function OscilModelExplDV2d

NOPLOT = 0;
GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAZE
N=200;
M=10;
LF = 3*sqrt(2);
 

%% LFP frequency
FT = 8.0;

%% place field size
XS = repmat(linspace(0.5,10,M)/LF,N,1);

%% single neuron frequency
%XF = FT+1./(LF.*XS);                             
XF = 8.0 + repmat(rand(M,1),N,1);
%XS = 

%% comfression factor
XC = 1./(XF.*XS*LF);    

%% time
n=20;
t=[0:0.001:N/n]'; %% 10 sec

%keyboard
for m=1:M
  %% matrices for calculation
  vt = repmat(t,1,N)';
  vf0 = repmat(XF(:,m),1,length(t));
  vsig = repmat(XS(:,m),1,length(t));
  vc = repmat(XC(:,m),1,length(t));

  %% T and tau
  T = [1:N]'/n;
  vT = repmat(T,1,length(t));
  tau = XC(:,m).*T;
  vtau = repmat(tau,1,length(t));  
  
  y1 = (1+cos(2*pi*vf0.*(vt-vtau)));
  y2 = exp(-(vt-vT).^2./vsig.^2)/sqrt(pi)./vsig/n;
  y = y1.*y2;
  
  
  yexp(:,m) = y(N/2,:)';
  ysum(:,m) = sum(y,1);
  
  
  A = (exp(-(pi*XC(1,m)*XS(1,m)*XF(1,m)).^2).*cos(2*pi*FT*t) + 1);
  
end

gt = find(t>3 & t<7);

a = repmat(t(gt)',1,M);
b = reshape(repmat([1:M],length(t(gt)),1),1,M*length(gt));
c = reshape(ysum(gt,:),1,M*length(t(gt)));
d = reshape(yexp(gt,:),1,M*length(t(gt)));



keyboard



%%%%%%%%%%%%%%%%
%%%% FIGURE

figure(1242);clf;
set(gcf,'position',[1789           9         768         941])

k=20; ll=round(linspace(1,64,k)); kk=round(linspace(5*n,15*n,k));

%% color:
cc = colormap;
l = round((XS-min(XS))/(max(XS)-min(XS))*64);
l(find(l==0))=1;l(find(l>64))=64;
col = cc(l,:);

%subplot('position',[0.15 8.5 0.8 0.2])
subplot(814)
plot(T,XF,'o','markersize',5,'color','k')
hold on
for n=1:length(kk)
  plot(T(kk(n)),XF(kk(n)),'o','markersize',5,'color',col(kk(n),:),'markerfacecolor',col(kk(n),:))
end
axis tight
xlim([5 15])
ylim([8 11])
box off
set(gca,'TickDir','out','XTickLabel',[],'FontSize',16,'XTick',[0 20])
a = get(gca,'Ylim');
ylabel('f_0 [Hz]','Fontsize',16,'position',[4.3 sum(a)/2])
a = get(gca,'Ylim');
b = get(gca,'Xlim');
text(b(1)-diff(b)*0.135,a(2),'C','FontSize',16)

%subplot('position',[0.15 0.45 0.8 0.2])
subplot(815)
plot(T,XS*LF,'o','markersize',5,'color','k')
hold on
plot(T(kk),XS(kk)*LF,'o','markersize',5,'color','r','markerfacecolor','r')
for n=1:length(kk)
  plot(T(kk(n)),XS(kk(n))*LF,'o','markersize',5,'color',col(kk(n),:),'markerfacecolor',col(kk(n),:))
end
axis tight
xlim([5 15])
box off
set(gca,'TickDir','out','XTickLabel',[],'FontSize',16,'XTick',[0 20])
a = get(gca,'Ylim');
ylabel('L [sec]','Fontsize',16,'position',[4.2 sum(a)/2])
a = get(gca,'Ylim');
b = get(gca,'Xlim');
text(b(1)-diff(b)*0.135,a(2),'D','FontSize',16)


%subplot('position',[0.15 0.45 0.8 0.2])
subplot(816)
plot(t,A/mean(A),'-','color',[1 1 1]*0.7,'LineWidth',2)
hold on
plot(t,sum(y,2)/mean(sum(y,2)),'-','color',[1 1 1]*0,'LineWidth',1)
axis tight
xlim([5 15])
box off
set(gca,'TickDir','out','XTickLabel',[],'FontSize',16,'XTick',[0 20],'YTick',[1:3])
a = get(gca,'Ylim');
ylabel('R(t)','Fontsize',16,'position',[4.2 sum(a)/2])
a = get(gca,'Ylim');
b = get(gca,'Xlim');
text(b(1)-diff(b)*0.135,a(2),'E','FontSize',16)

subplot(8,1,[7 8])
hold on
colormap('default');
cc = colormap;
gt = find(t>=5&t<=15);
for m=1:k
  plot(t(gt),y(gt,[kk(m)]),'color',col(kk(m),:))
  plot(t(gt),y2(gt,[kk(m)])*2,'color',col(kk(m),:),'LineWidth',2)
end
axis tight
xlim([5 15])
box off
set(gca,'TickDir','out','FontSize',16,'XTick',[5:15],'XTickLabel',[0:10])
xlabel('time [sec]','Fontsize',16)
a = get(gca,'Ylim');
ylabel('R_n(t)','Fontsize',16,'position',[4.3 sum(a)/2])
a = get(gca,'Ylim');
b = get(gca,'Xlim');
text(b(1)-diff(b)*0.135,a(2),'F','FontSize',16)


PrintFig('OscilModelExplDV-2d',0)

return

