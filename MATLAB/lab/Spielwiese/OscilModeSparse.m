function OscilModeSparse

NOPLOT = 0;
GoPrint = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAZE
N=200;
LF = 3*sqrt(2);

XF = [8.6 7.8];               %% single neuron frequency
XS = [1.5 1.52]/LF;           %% place field size
YF = [8.0 7.32];              %% LFP frequency
XCm = [0.075 0.059];           %% measured compression factor

XC = 1./(XF.*XS*LF);           %% calculated compression factor  

YFc = XF.*(1-XCm);             %% calculated LFP frequency


fprintf(['f0=' num2str(XF(1)) ' c=' num2str(XC(1)) ' ft=' num2str(YFc(1)) '\n']);


figure(983);clf
set(gcf,'position',[1829         115         696         854])
LB = {'A' 'B'; 'C' 'D'};
  
%% time
MT = 20;
t=[0:0.001:MT]'; %% 10 sec

%% spect
Fs = 1000;                    % Sampling frequency
L = length(t);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2);

nm=[10:10:240];
nn = [2 4 length(nm)];
SPYY = zeros(NFFT/2,length(nm));
for km=1:10

  cnt = 0;xcnt=0;
  YY = [];
  for mm=1:length(nm)
    
    %% number of cells
    N = nm(mm);
    
    %% cell density
    D = N/MT;
    
    %% f_0
    f0 =  normrnd(XF(1),0.1,N,1); 
    %% f_\theta
    fth = sort(normrnd(YFc(1),0.1,N,1));
    %% c
    cf = 1-fth./f0;
    cf = cf+(rand(size(cf))-0.5)*mean(cf)*0.1;
    %% sigma
    sig = 1./(cf.*f0*LF);
    sig = sig + (rand(size(sig))-0.5)*mean(sig)*0.3;
    %cf = XCm(1);
    %cf = 1-YFc(1)./(ones(size(f0))*XF(1));
    
    %% matrices for calculation
    vt = repmat(t,1,N);
    vf0 = repmat(f0',length(t),1);
    vsig = repmat(sig',length(t),1);
    
    %T = [1:N]/D;
    T = sort(rand(1,N)*MT);
    
    if mm==2
      T = sort([1:N]/1.25 + (N-N/1.25)/2+ (rand(1,N)-0.5));
      % keyboard
    end
    
    
    vT = repmat(T,length(t),1);
    tau = cf'.*T;
    vtau = repmat(tau,length(t),1);  
    
    %amp = repmat((rand(1,N)+0.5)*1,length(t),1);
    amp = repmat((rand(1,N)+0.5)*1,length(t),1);
    y = amp.*(1+cos(2*pi*vf0.*(vt-vtau))).*exp(-(vt-vT).^2./vsig.^2)/D;
    
    %[YY(:,mm) f] = MyPow(t,sum(y,2),Fs,round(length(t)/10),round(length(t)/20));
    [YY(:,mm) f] = MyPow(t,sum(y,2),Fs,round(length(t)/1),1);
    SPYY(:,mm) = SPYY(:,mm)+YY(:,mm);
  
    
    
    [mx mt] = MaxPeak(f',mean(YY,2),[4 12],3);
    YYT(km,mm) = mt;
    
    if (mm==2 | mm==length(nm)) & km==2
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% Example Figure
      figure(983);
      %% example neurons
      cl = [N/2-1 N/2 N/2+1];
      
      %% plot position
      cnt = cnt+1;
      ypos = (cnt-1)*0.2;
      xpos = (cnt-1)*0.2;
      
      subplot('position',[0.12 0.901-ypos 0.8 0.05])
      yy = sum(y,2);
      gg = find(t>=2 & t<=9);
      plot(t(gg),yy(gg),'color',[1 1 1]*0.3,'LineStyle','-','LineWidth',2)
      ylabel('rate','FontSize',16)
      axis tight
      xlim([3.5 7.5])
      axis off
      set(gca,'TickDir','out','FontSize',16,'XTick',[3.5:7.5],'XTickLabel',[0:4],'YTick',[])
      box off
      text(3.4,0.15,'mPOP','FontSize',16,'rotation',90)
      %ax = get(gca,'YLim');
      %Lines([],ax(1),'k','-',2);
      
      subplot('position',[0.12 0.801-ypos 0.8 0.1])
      hold on
      colormap('default');
      cc = colormap;
      gT = find(T>2.5 & T<7.5);
      if mm==2
	gT = find(T>2.5 & T<8.5);
      end
      k=length(gT); l = round(linspace(1,64,k));
      for n=1:k
	hold on
	%p=plot(t,y(:,gT(n))/max(y(:,gT(n))),'LineWidth',2,'Color',cc(l(n),:));
	p=plot(t,y(:,gT(n)),'LineWidth',2,'Color',cc(l(n),:));
      end
      ylabel('probability','FontSize',16)
      if mm==length(nm)
	xlabel('time [sec]','FontSize',16)
      end
      axis tight
      xlim([3.5 7.5])
      set(gca,'TickDir','out','FontSize',16,'XTick',[3.5:6.5],'XTickLabel',[0:3],'YTick',[])
      box off
      
    end
      
    
    if (mm==nn(1) | mm==nn(2) | mm==nn(3)) & km==2
      xcnt = xcnt+1;
      xpos = (xcnt-1)*0.3;
     
      subplot('position',[0.12+xpos 0.501 0.2 0.03])
      bin = [6:0.1:10];
      h=histcI(f0,bin);
      sum(h)
      bar(bin(1:end-1)+mean(diff(bin))/2,h);
      axis tight
      xlim([6 10])
      axis off
      box off
      %Lines([],0,'k','-',2);

    end

    
  end
  
  

  figure(983);
  subplot('position',[0.12 0.12 0.8 0.2])
  plot(nm/MT,YYT,'o','markersize',5,'markeredgecolor',[0.5 0.5 1],'markerfacecolor',[0.5 0.5 1])
  hold on
  %mYYT = mean(YYT);
  %sYYT = std(YYT);
  Lines([],[XF(1) YFc(1)],[0.6 0 0],'--',2);
  set(gca,'TickDir','out','FontSize',16)
  box off
  xlabel('place field density [cell/sec]','FontSize',16)
  ylabel('frequency [Hz]','FontSize',16)
  ylim([7.8 9]);
  
end
plot(nm/MT,mean(YYT),'o','markersize',7,'markeredgecolor',[1 1 1]*0.3,'markerfacecolor',[1 1 1]*0.3)
plot(nm/MT,mean(YYT),'-','color',[1 1 1]*0.3,'LineWidth',2)

text(-1.4,12.8,'A','FontSize',16)
text(-1.4,11.6,'B','FontSize',16)
text(-1.4,10.3,'C','FontSize',16)
text(-1.4,9,'D','FontSize',16)

%keyboard


figure(983)

xcnt=0;
for n=1:3
  xcnt = xcnt+1;
  xpos = (xcnt-1)*0.3;

  subplot('position',[0.12+xpos 0.4 0.2 0.1])
  % Plot single-sided amplitude spectrum.
  gf = find(f>4 & f<=12);
  plot(f(gf),mean(SPYY(gf,nn(n)),2),'k','LineWidth',2) 
  [mx mt] = MaxPeak(f(gf)',mean(SPYY(gf,nn(n)),2),[4 12],3);
  mt
  axis tight
  xlim([6 10])
  %Lines(mt);
  ax = get(gca,'YLim');
  ylabel('power','FontSize',16,'position',[4.8 ax(1)+mean(ax)])
  xlabel('frequency [Hz]','FontSize',16)
  set(gca,'TickDir','out','FontSize',16,'YTick',[0:0.5:1.5])
  box off
  %
end


%keyboard

  
PrintFig(['OscilModelSparse.crt'],0)
  
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

