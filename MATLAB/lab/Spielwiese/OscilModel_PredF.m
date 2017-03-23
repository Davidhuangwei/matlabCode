function OscilModel_PredF(varargin)
[overwrite,PLOT,freq] = DefaultArgs(varargin,{0,0,[7.71 8.61]});
%%
%%
%% IN - all optional
%%  freq: vector of single cell freqeuncy
%% 

keyboard


%FF = freq; %%[7.71 8.61];
for m=1:1%length(FF)
  for k=1:10
    
    FF(k) = 6+k*0.5;
    
    ARate = OscilModel_Het([],500,FF,0.05,10);
    %ARate = OscilModel_Het([],compf,FF(m),0.0001,1);
    
    fk(k,m) = ARate.fmax;
    
    mfk(k,m) = mean(ARate.afmax);
    sfk(k,m) = std(ARate.afmax);
  end
end

%% analytical prediction
aK = 500;%[100:1000]';
for n=1:length(FF)
  tau = mod(30./(FF(n)*aK),1/FF(n));
  tau(tau>1/FF(n)/2)=tau(tau>1/FF(n)/2)-1/FF(n);
  anf(:,n) = 1./(1/FF(n)+tau);
end
%% predict compression index
%for n=1:2
%  [xx xi yi] = NearestNeighbour(anf(:,n),Feeg(n));
% c(n) = aK(xi)/1000;
%end

figure(4576);clf;
K = [1:20]*50/1000;
Feeg = [7.32 7.93];
%
for n=1:2
  subplot(1,2,n)
  hold on
  xlim([0 1])
  ylim([6 10])
  Lines([],FF(n),[1 1 1]*0.8,'--',2);
  Lines([],Feeg(n),[0 0 1],'--',2);
  plot(aK/1000,anf(:,n),'--','color',[1 0 0],'LineWidth',2)
  h=errorbar(K,mfk(:,n),sfk(:,n))
  set(h,'color',[0 0 0],'LineWidth',1);
  box off
  xlabel('compression factor [cm/ms]','FontSize',16)
  ylabel('frequency [Hz]','FontSize',16)
  text(0.7,9.5,['f_o = ' num2str(FF(n)) ' Hz'],'FontSize',16)
  set(gca,'TickDir','out','FontSize',16,'XTick',[0:0.2:1])
end

for n=1:2
  [xx(n) xi(n) yi(n)] = NearestNeighbour(anf(:,n),Feeg(n));
  c(n) = aK(xi)/1000;
end

PrintFig('OsciModelStats')