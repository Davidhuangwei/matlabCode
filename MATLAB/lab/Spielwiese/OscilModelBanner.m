function OscilModelBanner

NOPLOT = 0;
GoPrint = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% default parameters
a = 3*sqrt(2);
ft = 8.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Example Figure
figure(123);clf
set(gcf,'position',[1829         135         800        837])
set(gcf,'position',[1829         135         1000        200])
set(gcf,'color',[1 1 1]*0.3)

AL = ([5])*0.35+0.15;
for m=1:length(AL)
  %%
  
  L = AL(m);
  
  sig = L/a; % [sec]
  f0 = ft+1/L;
  cf = 1/(L*f0); % dimension less 
  
  t=[-5:0.001:5]'; %% 10 sec

  T = [-2.5:0.05:2.5]*m^0.5;
  tau = cf*T;
  
  for n=1:length(T);
    y(:,n) = 0.5*(1+cos(2*pi*f0*(t-tau(n)))).*exp(-(t-T(n)).^2/sig^2);
  end
  
  
  %subplot('position',[0 0.9-(m-1)*0.09 1 0.5])
  subplot('position',[0 0.2 1 0.5])
  hold on
  colormap('default')
  cc = colormap;
  k=22; l = round(linspace(1,64,k));
  cll = [40:1:70];
  for n=1:k
    plot(t,y(:,cll(n))/max(y(:,cll(n))),'LineWidth',1,'Color',cc(l(n),:))
  end
  %keyboard
  gt = round((-0.5/(m^0.5)+2.5)/0.05);
  %plot(t,y(:,cll(11)),'color',[1 1 1]*0.2,'LineStyle','-','LineWidth',2)
  %plot(t,y(:,gt+1),'color',[1 1 1]*1,'LineStyle','-','LineWidth',2)
  plot(t,y(:,gt+1),'color',[1 1 1]*1,'LineStyle','-','LineWidth',2)
  yy = sum(y,2);
  %plot(t,[yy/max(yy)],'color',[1 1 1]*0.5,'LineStyle','--','LineWidth',2)
  xlabel('time [sec]','FontSize',16)
  ylabel('probability','FontSize',16)
  xlim([-0.5 0.5])
  set(gca,'TickDir','out','FontSize',16,'XTick',[],'YTick',[])
  box off
  axis off

end


PrintFig(['SVMUBanner'],0)

return



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

