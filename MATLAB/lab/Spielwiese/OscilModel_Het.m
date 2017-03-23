function ARate = OscilModel_Het(varargin)
[speed,compress,freq,Fsigma,chunks,plotting] = DefaultArgs(varargin,{30,500,7.5,0.1,1,1});
%% 
%% speed : running speed [cm/s] 
%% compress : compression index [cm/s] (~ 30 cm / 0.06 sec = 500)
%% freq : mean frequency of units [Hz]  

%% PARAMETERS:

%% max time [sec]
T = 10;

%% number of time points per sec
M = 1000;

%% cell density (cells/sec)
nn = 100; 

%% number of cells:
N = M*T/round(M/nn);

%% Frequency distribution stdv
%Fsigma = 0.1;

%% place field size
Xsigma = 0.25;  

%% time
t = [1:T*M]/M;

%% distance
dt = t(1:M*T/N:end);
dist = dt*speed;

%% theta time lag
tau = dist/compress;

%y = [];
%for n=1:N
%  y(:,n) = (cos(2*pi*Fo(n)*(t-tau(n))) +1).*exp(-(t-dt(n)).^2/(Xsigma)^2);
%end


for n=1:chunks
  
  %% unit frequencies 
  Fo = random('norm',freq,Fsigma,1,N);
  %Fo = freq*ones(N,1);
  
  F = repmat(Fo,M*T,1);
  TT = repmat(t',1,N);
  TAU = repmat(tau,M*T,1);
  DT = repmat(dt,M*T,1);

  y = (cos(2*pi* F.*( TT - TAU)) +1) .* exp(- (TT -DT).^2/(Xsigma)^2);
    
  %% compute spectrum
  Spect = 1;
  X = sum(y(t>1&t<=T-1,:),2);
  L = length(X);
  nfft = 2^nextpow2(L);
  switch Spect
   case 1
    nfft = 2^13;
    Fs = M;
    nOverlap = [];
    NW = 1;  %% ~5 for gamma
    Detrend = 'linear';
    nTapers = [];
    FreqRange = [1 20];
    CluSubset = [];
    pval = []; 
    WinLength = nfft/2;%512;
    
    [mSp(:,n), f]=mtchd(X,nfft,Fs,WinLength,nOverlap,NW,Detrend,nTapers, FreqRange);
    
    %keyboard
    %case 2
    % fy = fft(sum(y,2),nfft)/L;
    % Pyy = abs(fy(1:nfft/2))*2;
    % f = M/2*linspace(0,1,nfft/2);
    % Sp = Pyy;
    % sSp = smooth(Sp,50,'lowess');
    % gf = find(f>5);
    % [mf fi] = max(sSp(gf));
    % maxf = f(gf(fi))
  end
  
end

%keyboard

Sp = mean(mSp,2);
sSp = Sp;
[mf fi] = max(Sp);
maxf = f(fi)

%% all max
[mf fi] = max(mSp);
amaxf = f(fi);


figure(34234);clf;
subplot(211)
a = round(N/2);
plot(t,y(:,[a-round(nn/2) a a+round(nn/2)])/2,'LineWidth',2)
hold on
plot(t,sum(y,2)/mean(sum(y,2)),'--','color',[1 1 1]*0.7,'LineWidth',2)
xlim([T/2-2 T/2+2]);
ylabel('normalized rate','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
box off
text(6,1.3,['f_o = ' num2str(freq)],'FontSize',16)
%
subplot(212)
plot(f,Sp,'k')
hold on
plot(f,sSp,'k','LineWidth',2)
Lines(maxf,[],'r','--',2);
xlabel('frequency [Hz]','FontSize',16)
ylabel('LFP power','FontSize',16)
set(gca,'TickDir','out','FontSize',16)
axis tight
xlim([4 12])
box off
%subplot(211)
text(10,max(sSp)/1.5*1.3,['f_{LFP} = ' num2str(round(maxf*100)/100)],'FontSize',16)


%figure(3475);clf
%hist(amaxf)



ARate.f = f;
ARate.Sp = Sp;
ARate.fmax = maxf;
ARate.afmax = amaxf;



return;



%%%% make look around function

FF = [7.71 8.61];
for m=1:length(FF)
  for k=1:20
    
    compf = k*50;
    
    ARate = OscilModel_Het([],compf,FF(m),0.1,10);
    %ARate = OscilModel_Het([],compf,FF(m),0.0001,1);
    
    fk(k,m) = ARate.fmax;
    
    mfk(k,m) = mean(ARate.afmax);
    sfk(k,m) = std(ARate.afmax);
  end
end

%% analytical prediction
aK = [100:1000]';
for n=1:length(FF)
  tau = mod(30./(FF(n)*aK),1/FF(n));
  tau(tau>1/FF(n)/2)=tau(tau>1/FF(n)/2)-1/FF(n);
  anf(:,n) = 1./(1/FF(n)+tau);
end
%% predict compression index
for n=1:2
  [xx xi yi] = NearestNeighbour(anf(:,n),Feeg(n));
  c(n) = aK(xi)/1000;
end

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