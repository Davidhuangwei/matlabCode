function xcorrl = SVMUccgWidth(FileBase,spiket,spikei,run,varargin)
[overwrite,PLOT,FileOut,EegRate,SampleRate,GPC,GIN,maxN,speed,speedrate] = DefaultArgs(varargin,{0,0,'.xcorrWidth',1250,20000,[],[],[],[],[]});

%% estimates the width of the place field: 
%% returns std assuming Gaussian exp(-x^2/(2*sigma^2)) 

%% inputs: 
%% FileBase  : to read and write saved files
%% spiket    : spike times
%% spikei    : spile identity (cluster  number)
%% run       : two column matrix containing beginning and end of trials
%%             (in EEG sampling rate)
%% overwrite : overwrite previously calculated and stored results
%% PLOT      : plot Gaussians
%% FileOut   : FileBase of output file
%% EegRate   : Eeg sampling rate
%% SampleRate: Spike sampling rate
%% GPC, GIN  : for plotting
%% maxN      : maximal number of clusters
%% speed     : vector with running speed - to convert time to distance
%%             (default is empty)
%% speedrate : speed sampling rate


if ~FileExists([FileBase FileOut]) | overwrite
  %%%%%%%%%%%%%%
  %% spikes - ALL
  gindx = find(WithinRanges(spiket/SampleRate*EegRate,run));
  dt = round(50/1000*SampleRate);

  l=0;
  for n=unique(spikei(gindx)')
    ix = spikei(gindx)==n;
    spt = spiket(gindx(ix));
    [ccg(:,n),t] =  CCG(spt,n,dt,60,SampleRate);
    %[ccg(:,n),t] =  CCG(spt,n,dt,60,SampleRate,n,'hz',run/EegRate*SampleRate);

    if max(ccg(:,n))==0
      continue;
    end
    l=n;
    sccg(:,n) = smooth(ccg(:,n),10,'lowess');
    in = find(sccg(:,n)>max(sccg(:,n))*exp(-1/2));
    gp(n) = max(t(in));
    
    %% how good is this estimate?? 
    %% difference between Gaussian and ccg: 
    x = exp(-t.^2/2/gp(n)^2)*max(sccg(:,n));
    gdness(n) = mean((x(in)'-sccg(in,n))/max(x(in)));
    
    %keyboard
    %figure(1);clf
    %bar(t,sccg(:,n))
    %hold on
    %plot(t,exp(-t.^2/2/gp(n)^2)*max(sccg(:,n)),'r','LineWidth',2)
    %WaitForButtonpress
    
    %% speed - translate time to distance
    if ~isempty(speed)
      %keyboard
      spd(n) = mean(speed(SmartRound(spiket(gindx(ix))/SampleRate*speedrate,[1 length(speed)])));
    else
      spd(n) = 0;
    end
  end
  
  if isempty(maxN)
    maxN=max(spikei)
  end
  
  if n<maxN
    m=maxN;
    ccg(:,n+1:m) = zeros(length(t),(m-n));
  end
  if l<maxN
    m=maxN;
    sccg(:,l+1:m) = zeros(length(t),(m-l));
    gp(l+1:m) = 0;
    spd(l+1:m) = 0;
    gdness(l+1:m) = 0;
  end
  
  
  %% save
  xcorrl.ccg = ccg;           %% auto-correlogtram
  xcorrl.sccg = sccg;         %% smoothed auto-correlogtram
  xcorrl.t = t;               %% time axis
  xcorrl.std = gp;            %% standard deviation of auto-correlogtram
  xcorrl.speed = spd;         %% mean speed
  xcorrl.goodness = gdness;   %% quality of fit 
  
  save([FileBase FileOut],'xcorrl');
else
  
  load([FileBase FileOut],'-MAT')
  
end
if PLOT
  
  t = xcorrl.t(61:end);
  X =  xcorrl.ccg(61:end,:);
  Y =  xcorrl.sccg(61:end,:);
  
  figure(333);clf
  subplot(311)
  NX = X(:,GPC)./repmat(X(1,GPC),61,1);
  NY = Y(:,GPC)./repmat(Y(1,GPC),61,1);
  plot(t,NY)
  hold on
  plot(t,mean(NY,2),'r','LineWidth',2)
  plot(t,mean(NY,2)+std(NY')','--r','LineWidth',2)
  plot(t,mean(NY,2)-std(NY')','--r','LineWidth',2)
  %
  subplot(312)
  NXI = X(:,GIN)./repmat(X(1,GIN),61,1);
  NYI = Y(:,GIN)./repmat(Y(1,GIN),61,1);
  plot(t,NYI)
  hold on
  plot(t,mean(NYI,2),'r','LineWidth',2)
  plot(t,mean(NYI,2)+std(NYI')','--r','LineWidth',2)
  plot(t,mean(NYI,2)-std(NYI')','--r','LineWidth',2)
  %
  subplot(313)
  plot(t,mean(NY,2),'g','LineWidth',2)
  hold on
  plot(t,mean(NYI,2),'r','LineWidth',2)
  Lines([],0.5);
  
  ForAllSubplots('xlim([0 2500]);ylim([0 1.5])')
  
end


return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


SP = ALL(f).spectM;
sig = ALL(f).xcorrlM.std;

gf = find(SP.f>5 & SP.f<12);

[mx mi] = max(SP.spunit(gf,:));
mspf = SP.f(gf(mi));

gsig = sig>0;
pred = mspf(gsig).*(1-1./(sqrt(2)*pi/1000*sig(gsig)'.*mspf(gsig)));

figure(1);clf
hist(pred,50)



    %lag = diff(spt(pair)')/SampleRate*1000;
    %[mu(n) sig(n) muci(:,n) sigci(:,n)] = normfit(lag); 
    %mlag(n) = mean(lag);
    %stlag(n) = std(lag);
    %if gp==0
    %  continue;
    %end
    %figure(1);clf
    %plot(t,sccg(:,n))
    %hold on
    %plot(t,max(sccg(:,n))*exp(-t.^2/gp(n)^2/2),'r')
    %plot(t,max(sccg(:,n))*exp(-t.^2/sig(n)^2),'g')
    %title(['n=' num2str(n)])
    %WaitForButtonpress
  
  %% smooth
  %syccg = reshape(smooth(ccg,10,'lowess'),size(ccg,1),size(ccg,2));
  %[ccg, t, pairs] = CCG(spiket(gindx),spikei(gindx),dt,60,SampleRate);  
  %cccg = GetDiagonal(ccg);
  %%% insert zeros for spike-less cells:
  %ncell = find(ismember(unique(spikei),unique(spikei(gindx))));
  %yccg = zeros(size(t,2),max(spikei));
  %yccg(:,ncell) = cccg;
  
