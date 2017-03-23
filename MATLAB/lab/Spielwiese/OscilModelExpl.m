function OscilModelExpl

NOPLOT = 0;
GoPrint = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAZE
N=200;
%LF = 2*sqrt(-log(0.1));
LF = 3*sqrt(2);

XF = [8.75 7.8];               %% single neuron frequency
XS = [1.06 1.52]/LF;           %% place field size
YF = [8.09 7.32];              %% LFP frequency
XFF = [1.08 1.05];             %% relative unit frequency
XCm = [0.075 0.059];           %% measured compression factor

XC = 1./(XF.*XS*LF);           %% calculated compression factor  

YFc = XF.*(1-XCm);             %% calculated LFP frequency


figure(123);clf
set(gcf,'position',[1829         404         585         495])
LB = {'A' 'B'; 'C' 'D'};

figure(124);clf

for mm=[1 2]
  
  for m=1:1 % to average spectra
    
    f0 =  normrnd(XF(mm),0.2,N,1);    % [Hz]
    
    %% place field size 
    sig = 1./(XCm(mm)*f0*LF)*0.8;
    %sig = ones(N,1)*XS(mm);
        
    %% compression factor
    %cf = ones(size(f0))*XCm(mm);
    cf = 1-YFc(mm)./f0;
        
    %% for stats plot;
    mf0(:,m) = f0; 
    mcf(:,m) = cf;
    msig(:,m) = sig;
    
    %% time
    n=10;
    t=[0:0.001:N/n]'; %% 10 sec
    
    %% spect
    Fs = 1000;                    % Sampling frequency
    L = length(t);
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    f = Fs/2*linspace(0,1,NFFT/2);
    
    %% matrices for calculation
    vt = repmat(t,1,N);
    vf0 = repmat(f0',length(t),1);
    vsig = repmat(sig',length(t),1);
    
    T = [1:N]/n;
    vT = repmat(T,length(t),1);
    tau = cf'.*T;
    vtau = repmat(tau,length(t),1);  
    
    y = (1+cos(2*pi*vf0.*(vt-vtau))).*exp(-(vt-vT).^2./vsig.^2)/n;

    Y = fft(sum(y,2),NFFT)/L;
    YY(:,m) = 2*abs(Y(1:NFFT/2));
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Parameter Figure
  figure(124)
  subplot(2,3,1+(mm-1)*3)
  hist(mf0)
  dfg = mean(mf0);
  title(['f_0=' num2str(dfg)])
  
  subplot(2,3,2+(mm-1)*3)
  hist(mcf)
  dfg = mean(mcf);
  title(['c=' num2str(dfg)])

  subplot(2,3,3+(mm-1)*3)
  hist(msig*LF)
  dfg = mean(msig*LF);
  title(['L=' num2str(dfg)])

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Example Figure

  %% example neurons
  cl = [23:2:27]*2;
  
  %% plot position
  ypos = (mm-1)*0.37;

  figure(123);
  subplot('position',[0.12 0.8-ypos 0.5 0.1])
  yy = sum(y,2);
  gg = find(t>=3 & t<=8);
  plot(t(gg),yy(gg),'color',[1 1 1]*0.3,'LineStyle','-','LineWidth',2)
  ylabel('rate','FontSize',16)
  axis tight
  xlim([3.5 6.5])
  axis off
  set(gca,'TickDir','out','FontSize',16,'XTick',[3.5:6.5],'XTickLabel',[0:3],'YTick',[])
  box off
  text(3.37,0.15,'mPOP','FontSize',16,'rotation',90)
  
  subplot('position',[0.12 0.6-ypos 0.5 0.2])
  hold on
  %% 
  cc = colormap('lines');
  l = 1:3;
  k=3; %l = round(linspace(1,64,k));
  for n=1:k
    p=plot(t,y(:,cl(n))/max(y(:,cl(n))),'LineWidth',2,'Color',cc(l(n),:));
  end
  set(p,'color',[0.8 0 0])
  yy = sum(y,2);
  %plot(t,[yy/max(yy)],'color',[1 1 1]*0.2,'LineStyle','--','LineWidth',2)
  ylabel('probability','FontSize',16)
  if mm==2
    xlabel('time [sec]','FontSize',16)
  end
  xlim([3.5 6.5])
  set(gca,'TickDir','out','FontSize',16,'XTick',[3.5:6.5],'XTickLabel',[0:3],'YTick',[])
  box off
  
  subplot('position',[0.75 0.6-ypos 0.2 0.2])
  % Plot single-sided amplitude spectrum.
  gf = find(f>4 & f<=12);
  plot(f(gf),mean(YY(gf,:),2),'k','LineWidth',2) 
  [mx mt] = MaxPeak(f',mean(YY,2),[4 12],3);
  mt
  axis tight
  xlim([6 10])
  %Lines(mt);
  Lines(XF(mm),[],'r','--');
  Lines(YF(mm),[],'k','--');
  ylabel('power','FontSize',16)
  if mm==2
    xlabel('frequency [Hz]','FontSize',16)
  end
  set(gca,'TickDir','out','FontSize',16)
  box off
  hold on
  %
  subplot('position',[0.75 0.8-ypos 0.2 0.1])
  bin = [6:0.1:10];
  h=histcI(f0,bin);
  bar(bin(1:end-1)+mean(diff(bin))/2,h);
  axis tight
  Lines(XF(mm),[],'r','--');  
  Lines(YF(mm),[],'k','--');
  axis tight
  xlim([6 10])
  axis off
  box off

  a = get(gca,'YLim');
  
  text(-8.3,a(2)-diff(a)*0.1,LB(mm,1),'FontSize',16)
  text(3.9,a(2)-diff(a)*0.1,LB(mm,2),'FontSize',16)
  
end
  
  
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

