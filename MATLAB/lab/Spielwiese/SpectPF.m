function Spect = SpectPF(FileBase,Eeg,PlaceCell,whl,trial,spike,varargin)
[overwrite,Plotting,RateThresh] = DefaultArgs(varargin,{0,1,5});

%mtptchd_segs 

if ~FileExists([FileBase '.spect']) | overwrite
  
  x=Eeg;
  nFFT = 2^13;
  Fs = 1250;
  nOverlap = [];
  NW = 1;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 100];
  CluSubset = [];
  pval = []; 
  
  %%%%%%
  RateFactor = 20000/whl.rate;
  EegRateFac = 1250/whl.rate;
  
  Ind = PlaceCell.ind;
  Trials = PlaceCell.trials;
  
  for neu = 1:size(Ind,1)
    gTrials = Trials(find(Trials(:,1)==neu),2:3);
  
    
    %if Ind(neu,5)==2
    %  keyboard
    %end
      
    spikeidx1 = (spike.ind==Ind(neu,1) & spike.good);
    spikeidx = spikeidx1.*WithinRanges(round(spike.t/RateFactor),gTrials,[1:length(gTrials)],'vector')';
    [numsp numspidx] = histcI(spikeidx,[0:1:length(gTrials)]+0.5);
    
    Rate = numsp;%./diff(gTrials')'*whl.rate;
    RateThresh = 10;
    
    ggTrials = gTrials(find(Rate>=RateThresh),:);
    if isempty(ggTrials) %| size(ggTrials,1)<10 %size(gTrials,1)/3
      [a b] = sort(Rate,'descend');
      ggTrials = gTrials(b(1:round(length(b)/3)),:);
    end
    
    Starts = [];Ends =[];
    Starts = ggTrials(:,1)*EegRateFac;
    Ends = ggTrials(:,2)*EegRateFac;
  
    speeds = abs(whl.lin(ggTrials(:,1),1)-whl.lin(ggTrials(:,2),1))./(ggTrials(:,2)-ggTrials(:,1))*whl.rate;
    [ntr indsp] = histcI(speeds,prctile(speeds,[0 50 100]));
    %[ntr indsp] = histcI(speeds,prctile(speeds,[0 45 55 100]));
    
    %if length(unique(indsp))<3
    %  [cc dd] = sort(speeds);
    %  indsp(dd(1:round(length(dd)/2))) = 1;
    %  indsp(dd(round(length(dd)/2)+1:length(dd))) = 3;
    %end
      
    Res = round(spike.t(find(spikeidx))/16);
    Clu = ones(size(Res));
    WinLength = 512;
    
    for j=1:2
      %[y,f,phi,yerr,phierr]=mtptchd_segs(x,Res,Clu,nFFT,Fs,WinLength,nOverlap,...
      %					 NW,Detrend,nTapers,FreqRange,CluSubset,Starts(indsp==j));
      
      [y,f]=mtptcsd(x,Res,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset,round(ggTrials(indsp==j,:)*EegRateFac));

      Spect.yall(:,1,j,neu) = sq(y(:,1,1));
      Spect.yall(:,2,j,neu) = sq(y(:,2,2));
      Spect.yall(:,3,j,neu) = sq(y(:,1,2));
      %Spect.yall(:,4,j,neu) = sq(phi(:,1,2));
      %Spect.yalle(:,1,j,neu) = sq(yerr(:,1,1));
      %Spect.yalle(:,2,j,neu) = sq(yerr(:,2,2));
      %Spect.yalle(:,3,j,neu) = sq(yerr(:,1,2,1));
    end
    Spect.f = f;
    Spect.speed(neu,:) = [mean(speeds(indsp==1)) mean(speeds(indsp==2))];
  end
  %%%%%%%%%%
  
  save([FileBase '.spect'],'Spect')
else
  load([FileBase '.spect'],'-MAT');
end

%% Plotting
if Plotting
  Ind = PlaceCell.ind;
  PlotSpectPF(Ind,Spect,1);
end

return;

