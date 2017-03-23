function OscilModelExplDV

NOPLOT = 0;
GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAZE
N=200;
%LF = 2*sqrt(-log(0.01));
LF = 3*sqrt(2);

FT = 8.0;                                        %% LFP frequency
%XS = linspace(0.5,10,N)/LF;                     %% place field size
XS = (rand(1,N)*5+0.3)/LF;                      %% place field size
%XS = ones(1,N)*0.5/LF;
%XF = FT+1./(sqrt(2)*pi.*XS);                     %% single neuron frequency
XF = FT+1./(LF.*XS);                     %% single neuron frequency

%XF = rand(1,N)*2+8.05;
%XS = 1./(XF-FT)/LF;

%XF = ones(1,N)*8.05;
%XS = 1./(XF-FT)/LF;


%XS = 1./(sqrt(2)*pi*(XF-FT));  %% place field size
XC = 1./(sqrt(2)*pi*XF.*XS);    %% calculated compression factor  
XC = 1./(XF.*XS*LF);    %% calculated compression factor  
%XC = 1./(XF.*XS*LF).*((rand(1,N)+0.5)*0.01+1);    %% calculated compression factor  

%% time
n=10;
t=[0:0.001:N/n]'; %% 10 sec

%% matrices for calculation
vt = repmat(t,1,N);
vf0 = repmat(XF,length(t),1);
vsig = repmat(XS,length(t),1);
vc = repmat(XC,length(t),1);

T = [1:N]/n;
vT = repmat(T,length(t),1);
tau = XC.*T;
vtau = repmat(tau,length(t),1);  

%y = (1+cos(2*pi*vf0.*(vt-vtau))).*exp(-(vt-vT).^2./vsig.^2) /sqrt(pi)./vsig/n;
y1 = (1+cos(2*pi*vf0.*(vt-vtau)));
y2 = exp(-(vt-vT).^2./vsig.^2)/sqrt(pi)./vsig/n;
y = y1.*y2;

A = (exp(-(pi*XC(1)*XS(1)*XF(1)).^2).*cos(2*pi*FT*t) + 1);%*sqrt(pi)*mean(XS);
%keyboard

figure(124);clf;
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

%%subplot('position',[0.15 0.65 0.8 0.2])
%subplot(512)
%plot(T,XC,'o','markersize',5,'color','k')
%hold on
%plot(T(kk),XC(kk),'o','markersize',5,'color','r','markerfacecolor','r')
%axis tight
%xlim([5 15])
%box off
%set(gca,'TickDir','out','XTickLabel',[],'FontSize',16,'XTick',[0 20])
%a = get(gca,'Ylim');
%ylabel('c','Fontsize',16,'position',[4.2 sum(a)/2])

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

%text(3.7,2.5,'C','FontSize',16)
%text(3.7,2,'D','FontSize',16)
%text(3.7,1.5,'E','FontSize',16)
%text(3.7,1,'F','FontSize',16)

%PrintFig('OscilModelExplDV',1)
%PrintFig('OscilModelExplDV2',0)

%keyboard
%%%%%%%%%%
ft = 8;
a = 3*sqrt(2);
sig = [0.2:0.2:10]; % [sec]
f0 = ft + 1./(sqrt(2)*pi*sig/a);    % [Hz]
cf = 1./(sqrt(2)*pi*sig.*f0/a); % dimension less 

%figure(2345);clf;
%subplot(8,2,[1 3])
subplot('position',[0.13 0.7 0.35 0.2])
%col = [0.5 0.5 1];
cc = colormap;
k = round(linspace(1,64,5));
col = cc(k([2 3 4]),:);
plot(sig,f0,'k')
hold on
m = [1 2 4];
%keyboard
for n=1:3
  plot(m(n),ft + 1./(sqrt(2)*pi*m(n)/a),'o', 'markeredgecolor',col(n,:),'markerfacecolor',col(n,:))
end
Lines([],8,'k','--');
set(gca,'TickDir','out','FontSize',16)
xlim([0 8])
ylim([7.5 10])
xlabel('place field size L [sec]','FontSize',16)
a = get(gca,'Ylim');
b = get(gca,'Xlim');
ylabel('frequency f_0 [Hz]','FontSize',16,'position',[-1.2 mean(a)])
text(1.2,9.1,'dorsal','FontSize',16)
text(2.2,8.6,'middle','FontSize',16)
text(4.2,8.4,'ventral','FontSize',16)
text(b(1)-diff(b)*0.06/0.2,a(2),'A','FontSize',16)
box off


%%% Hippocampus
%subplot(8,2,[2 4])
%subplot('position',[0.55 0.7 0.35 0.2])
%[ex, ey, ez] = ellipsoid(0,0,0,10,10,0,100);
%gx = (ex>1);
%grade = repmat([1:length(ex)]',1,length(ex)).*gx;
%imagesc(grade')
%axis xy
%cc = colormap;
%cc(1,:) = [1 1 1]; 
%colormap(cc);
%box off
%axis off
%ylim([20 80])
%Lines([30 70],[],[1 1 1]*0.01)
%ylim([-20 120])
%text(5,10,'dorsal','FontSize',16)
%text(40,10,'middle','FontSize',16)
%text(77,10,'ventral','FontSize',16)
%a = get(gca,'Ylim');
%b = get(gca,'Xlim');
%text(b(1)-diff(b)*0.1,a(2),'B','FontSize',16)

subplot('position',[0.55 0.7 0.35 0.2])
[ex, ey, ez] = ellipsoid(0,0,0,10,10,0,100);
gx = (ex>1);
grade = repmat([1:length(ex)]',1,length(ex)).*gx;
imagesc(grade)
cc = colormap;
cc(1,:) = [1 1 1]; 
colormap(cc);
box off
axis off
xlim([15 90])
Lines([],[30 70],[1 1 1]*0.01)
xlim([0 200])
text(100,20,'dorsal','FontSize',16)
text(100,50,'middle','FontSize',16)
text(100,85,'ventral','FontSize',16)
a = get(gca,'Ylim');
b = get(gca,'Xlim');
text(b(1)-diff(b)*0.1,a(1),'B','FontSize',16)


PrintFig('OscilModelExplDV3',0)



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
%% Example Figure

%% example neurons
cl = [23:2:27]*2;

%% plot position
ypos = (mm-1)*0.37;

figure(123)
subplot('position',[0.13 0.8-ypos 0.5 0.1])
hold on
%% 
yy = sum(y,2);
gg = find(t>=3 & t<=8);
plot(t(gg),[yy(gg)/max(yy(gg))],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
ylabel('rate','FontSize',16)
axis tight
xlim([3.5 6.5])
axis off
set(gca,'TickDir','out','FontSize',16,'XTick',[3.5:6.5],'XTickLabel',[0:3],'YTick',[])
box off


%subplot(312)
subplot('position',[0.13 0.6-ypos 0.5 0.2])
hold on
%% 
cc = colormap('lines');
l = 1:3;
k=3; %l = round(linspace(1,64,k));
for n=1:k
  plot(t,y(:,cl(n))/max(y(:,cl(n))),'LineWidth',2,'Color',cc(l(n),:))
end
yy = sum(y,2);
%plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
ylabel('rate','FontSize',16)
if mm==2
  xlabel('time [sec]','FontSize',16)
end
xlim([3.5 6.5])
set(gca,'TickDir','out','FontSize',16,'XTick',[3.5:6.5],'XTickLabel',[0:3],'YTick',[])
%set(gca,'TickDir','out','FontSize',16,'XTick',[3.5:6.5],'XTickLabel',[0:3],'YTick',[])
box off

subplot('position',[0.75 0.6-ypos 0.2 0.2])
% Plot single-sided amplitude spectrum.
gf = find(f>4 & f<=12);
plot(f(gf),mean(YY(gf,:),2),'k','LineWidth',2) 
[mx mt] = MaxPeak(f',mean(YY,2),[4 12],3);
mt
axis tight
xlim([6 10])
Lines(mt);
Lines(XF(mm),[],'g');
Lines(YF(mm),[],'b');
ylabel('power','FontSize',16)
if mm==2
  xlabel('freqeuncy [Hz]','FontSize',16)
end
set(gca,'TickDir','out','FontSize',16)
box off
hold on
%
subplot('position',[0.75 0.8-ypos 0.2 0.1])
hist(f0)
axis tight
xlim([6 10])
axis off
box off

PrintFig(['OscilModelExpl.crt' num2str(mm)],GoPrint)

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

