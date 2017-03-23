function SpectTr = SpectDTr(FileBase,Eeg,PlaceCell,whl,trial,spike,varargin)
[overwrite,Plotting] = DefaultArgs(varargin,{0,1});

%mtptchd_segs 

if ~FileExists([FileBase '.spectTr']) | overwrite
  
  x=Eeg;
  nFFT = 2^13;
  Fs = 1250;
  nOverlap = [];
  NW = 2;  %3 %% ~5 for gamma
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
  
  yallEeg=[];
  yallCell=[];
  yallxCE=[];
  allind=[];
  StatEegT=[];
  StatCellT=[];
  StatEegR=[];
  StatCellR=[];
  for neu = 1:size(Ind,1)
    gTrials = Trials(find(Trials(:,1)==neu),2:3);
    TrialIndx = find(Trials(:,1)==neu);
    
    spikeidx1 = (spike.ind==Ind(neu,1) & spike.good);
    spikeidx = spikeidx1.*WithinRanges(round(spike.t/RateFactor),gTrials,[1:length(gTrials)],'vector')';
 
    Starts = [];Ends =[];  
    Starts = gTrials(:,1)*EegRateFac;
    Ends = gTrials(:,2)*EegRateFac;
  
    %speeds = abs(whl.lin(gTrials(:,1),1)-whl.lin(gTrials(:,2),1))./(gTrials(:,2)-gTrials(:,1))*whl.rate;
    %[ntr indsp] = histcI(speeds,prctile(speeds,[0 50 100]));
    
    Res = round(spike.t(find(spikeidx))/16);
    Clu = ones(size(Res));
    %WinLength = max(Ends-Starts);
    
    
    for tr=1:size(gTrials,1)
      [y,f,phi,yerr,phierr]=mtptchd_segs(x,Res,Clu,nFFT,Fs,Ends(tr)-Starts(tr),nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset,Starts(tr));
      
      yallEeg = [yallEeg; y(:,1,1)'];
      yallCell = [yallCell; y(:,2,2)'];
      yallxCE = [yallxCE; y(:,1,2)'];
      allind = [allind; [neu TrialIndx(tr)]];
    
      %% get Spect-Stats:
      %myf = find(f>5 & f<14);
      %myf2 = find(f>=14);
      myf = find(f>7 & f<12);
      myf2 = find(f>=12);
      
      
      %keyboard
      
      %% width of theta-peak
      [MaxEeg MaxEegIndx] = max(y(myf,1,1));
      dfminE=max(f(find(y(:,1,1)<MaxEeg/2 & f<f(myf(MaxEegIndx)))));
      dfmaxE=min(f(find(y(:,1,1)<MaxEeg/2 & f>f(myf(MaxEegIndx)))));
      [MaxCell MaxCellIndx] = max(y(myf,2,2));
      dfminC=max(f(find(y(:,2,2)<MaxCell/2 & f<f(myf(MaxCellIndx)))));
      dfmaxC=min(f(find(y(:,2,2)<MaxCell/2 & f>f(myf(MaxCellIndx)))));
      
      if isempty(dfmaxE-dfminE)
	 StatEegT = [StatEegT; [max(y(myf,1,1)) 0]];
      else
	StatEegT = [StatEegT; [max(y(myf,2,2)) dfmaxE-dfminE]];
      end
      if isempty(dfmaxC-dfminC)
	StatCellT = [StatCellT; [max(y(myf,2,2)) 0]];
      else
	StatCellT = [StatCellT; [max(y(myf,2,2)) dfmaxC-dfminC]];
      end
      
      StatEegR = [StatEegR; [mean(y(myf2,1,1)) std(y(myf2,1,1))]];
      StatCellR = [StatCellR; [mean(y(myf2,2,2)) std(y(myf2,2,2))]];
    end
    SpectTr.f = f;
  end
  SpectTr.yEeg  = yallEeg;
  SpectTr.yCell = yallCell;
  SpectTr.yCxE = yallxCE;
  SpectTr.ind   = allind;
  SpectTr.statEegT  = StatEegT;
  SpectTr.statCellT = StatCellT;
  SpectTr.statEegR  = StatEegR;
  SpectTr.statCellR = StatCellR;

  %%%%%%%%%%
  
  save([FileBase '.spectTr'],'SpectTr')
else
  load([FileBase '.spectTr'],'-MAT');
end

%% Plotting
%if Plotting
%  Ind = PlaceCell.ind;
%  PlotSpectPF(Ind,SpectTr,1);
%end

return;

