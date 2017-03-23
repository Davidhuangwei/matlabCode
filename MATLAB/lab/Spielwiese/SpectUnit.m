function SpectTr = SpectUnit(FileBase,Eeg,PlaceCell,whl,trial,spike,varargin)
[overwrite,Plotting] = DefaultArgs(varargin,{0,1});

%mtptchd_segs 

%if ~FileExists([FileBase '.spectTr']) | overwrite
  
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

  for neu = 1:size(Ind,1);
    if Ind(:,5)==2
      continue
    end
    
    spikeidx = (spike.ind==Ind(neu,1) & spike.good & WithinRanges(round(spike.t/RateFactor),trial.itv));
 
    Starts = [];Ends =[];
    Res = round(spike.t(find(spikeidx))/16);
    Clu = ones(size(Res));
    
    for tr=1:3
      
      %% loop thriugh all place cells and compute three spectra,
      %for 1st 2nd 3rd part. 
      
      Starts = ;
      Legth = ;
      [y,f,phi,yerr,phierr] = mtptchd_segs(x,Res,Clu,nFFT,Fs,[],nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset);
    end
    
    
    
  end
  
return;

