function Spect = SpectInt(FileBase,Eeg,PlaceCell,whl,spike,trial,varargin)
[REPFIG,PLOT,overwrite] = DefaultArgs(varargin,{0,0,0});

%mtptchd_segs 
x=Eeg;
nFFT = 2^13;
Fs = 1250;
nOverlap = [];
NW = 3;  %% ~5 for gamma
Detrend = 'linear';
nTapers = [];
FreqRange = [1 100];
CluSubset = [];
pval = []; 

%%%%%%
RateFactor = 20000/whl.rate;
EegRateFac = 1250/whl.rate;

if ~FileExists([FileBase '.spect']) | overwrite
  
  CatPlaceCell = CatStruct(PlaceCell,[],1);
  
  count = 0;icount=0;
  for neu=1:length(CatPlaceCell.indall)
    if CatPlaceCell.indall(neu,5) ~=1
      continue;
     end

      fprintf([num2str(neu) '... ']);
    
      dire = CatPlaceCell.indall(neu,4);
      for dd = 1:size(PlaceCell(neu).lfield,1)
      
	count = count+1;
	Spect.ind(count,:) = [neu dire dd CatPlaceCell.indall(neu,5)];
	spikeidx1 = (spike.ind==CatPlaceCell.indall(neu,1) & spike.good ...
		   & WithinRanges(spike.lpos,PlaceCell(neu).lfield(dd,:))) & spike.dir==dire;
	spikeidx = spikeidx1.*WithinRanges(round(spike.t/RateFactor),trial.itv,[1:length(trial.itv)]','vector')';
      
	whlidx1 = WithinRanges(whl.lin, PlaceCell(neu).lfield(dd,:)) & whl.dir==dire;
	whlidx = whlidx1.*WithinRanges([1:length(whl.lin)]',trial.itv,[1:length(trial.itv)]','vector')';

	goodtrials = unique(spikeidx);
      
      
      %keyboard
      
      Starts = [];Ends =[];
      for tr=goodtrials(goodtrials>0)'
    	goodwhl = find(whlidx==tr);
        Starts(tr,1) = min(goodwhl)*EegRateFac;
    	Ends(tr,1) = max(goodwhl)*EegRateFac;
      end
      gStarts = Starts(Starts~=0);
      gEnds = Ends(Starts~=0);
      %% find fast,slow
      speeds = abs(diff(PlaceCell(neu).lfield(dd,:))./(gEnds-gStarts)*1250);
      
      [ntr indsp] = histcI(speeds,prctile(speeds,[0 50 100]));
      
      
      goodspikes = find(spikeidx);
      
      Res = round(spike.t(goodspikes)/16);
      Clu = ones(size(Res));
      WinLength = max(gEnds-gStarts);
 
      for j=1:2
        [y,f,phi,yerr,phierr]=mtptchd_segs(x,Res,Clu,nFFT,Fs,WinLength,nOverlap,...
					   NW,Detrend,nTapers,FreqRange,CluSubset,gStarts(indsp==j));
      
            Spect.yall(:,1,j,count) = sq(y(:,1,1));
            Spect.yall(:,2,j,count) = sq(y(:,2,2));
            Spect.yall(:,3,j,count) = sq(y(:,1,2));
            Spect.yall(:,4,j,count) = sq(phi(:,1,2));
            Spect.yalle(:,1,j,count) = sq(yerr(:,1,1));
            Spect.yalle(:,2,j,count) = sq(yerr(:,2,2));
	     Spect.yalle(:,3,j,count) = sq(yerr(:,1,2,1));
      end
      Spect.f = f;
      %dims: freq X what x speed x cell
      
      end
      
  end
  save([FileBase '.spect'],'Spect')
else
   load([FileBase '.spect'],'-MAT');
    
end




return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

RateFactor = 20000/RateWhl;
EegRateFac = 1250/RateWhl;


%% spectra of trials  
%% 

if ~FileExists([FileBase '.spect']) | overwrite 
  
  %% take ALL cells!! 
  for neu=1:length(PlaceCell)
    newtrials = PlaceCell(neu).trials;
    
    %keyboard
    
    %% calculate speed and rate for each trial|neuron
    for n=1:length(newtrials)
      spindx = find(WithinRanges(spike.t/RateFactor,newtrials(n,:)) & spike.ind==PlaceCell(neu).ind(1));
      numspikes(n) = length(spindx);
      
      %% firing rate
      if numspikes<3
	continue;
      end
      
      %% trial speed
      if ~TrSpeed     %% over all speed
	trialspeed(n) = mean(whl.speed([newtrials(n,1):newtrials(n,2)],1));
      elseif TrSpeed  %% only speeds of spike time (no spike: NaN)
	trialspeed(n) = mean(whl.speed(round(spike.t(spindx)/RateFactor),1));
      end
    end
    
    %%keyboard
    
    %% find fast/med/slow trials
    prctrial = prctile(trialspeed(numspikes>3),[33 67])
    slowtr = trialspeed<prctrial(1) & numspikes>3;
    medtr = trialspeed>=prctrial(1)&trialspeed<prctrial(2)  & numspikes>3;
    fasttr = trialspeed>=prctrial(2)  & numspikes>3;
    
    %keyboard
    
    %mtptchd_segs 
    x=Eeg;
    nFFT = 2^13;
    Fs = 1250;
    nOverlap = [];
    NW = 2;  %% ~5 for gamma
    Detrend = 1;
    nTapers = [];
    FreqRange = [1 40];
    CluSubset = [];
    pval = []; 
    
  
    %%Pyramidal cell
    for n=1:length(newtrials)
      %n;
      if numspikes(n)<3
	%yeeg(:,n) = zeros(
	%ycell(:,n)= y(:,2,2);
	continue;
      end
      
      spindx = find(WithinRanges(spike.t/RateFactor,newtrials(n,:)) & spike.ind==PlaceCell(neu).ind(1));
      %ALLspindx = find((WithinRanges(spike.t/RateFactor,newtrials(n,:)) & spike.ind==PlaceCell(neu).ind(1)) | INspikes);
      
      Res = round(spike.t(spindx)/16);
      Clu = spike.ind(spindx);
      Starts = newtrials(n,1)*EegRateFac;
      WinLength = diff(newtrials(n,:))*EegRateFac;
      [y,f,phi,yerr,phierr]=mtptchd_segs(x,Res, Clu, nFFT,Fs,WinLength,...
					 nOverlap,NW,Detrend,nTapers, FreqRange,CluSubset,Starts);
      
      yeeg(:,n) = y(:,1,1);
      ycell(:,n,1)= y(:,2,2);
      
      for int=1:length(Inter)
	Ispindx = find(WithinRanges(spike.t/RateFactor,newtrials(n,:)) & spike.ind==Inter(int));
	if length(Ispindx)<3
	  continue;
	end
	Res = round(spike.t(Ispindx)/16);
	Clu = spike.ind(Ispindx);
	[y,f,phi,yerr,phierr]=mtptchd_segs(x,Res, Clu, nFFT,Fs,WinLength,...
					   nOverlap,NW,Detrend,nTapers, FreqRange,CluSubset,Starts);
	
	ycell(:,n,1+int)= y(:,2,2);
      end
      
    end
    
    %keyboard;
    
    goodf = find(f>5 & f<15);
    eegslow = mean(yeeg(:,slowtr),2);
    eegmed  = mean(yeeg(:,medtr),2);
    eegfast = mean(yeeg(:,fasttr),2);
    
    maxfrq(1,1) = f(find(eegslow==max(eegslow(goodf))));
    maxfrq(1,2) = f(find(eegmed==max(eegmed(goodf))));
    maxfrq(1,3) = f(find(eegfast==max(eegfast(goodf))));
    
    
    for nn=1:length(Inter)+1
      cellslow(:,nn) = mean(ycell(:,slowtr,nn),2);
      cellmed(:,nn) = mean(ycell(:,medtr,nn),2);
      cellfast(:,nn) = mean(ycell(:,fasttr,nn),2);
      
      maxfrq(nn+1,1) = f(find(cellslow==max(cellslow(goodf,nn))));
      maxfrq(nn+1,2) = f(find(cellmed==max(cellmed(goodf,nn))));
      maxfrq(nn+1,3) = f(find(cellfast==max(cellfast(goodf,nn))));
      
      %end
      
      if PLOT
	figure
	subplot(211)
	plot(f,eegslow,f,eegmed,f,eegfast)
	ylabel('eeg power')
	xlabel('Frequency')
	box off
	subplot(212)
	plot(f,unity(cellslow(:,nn)),f,unity(cellmed(:,nn)),f,unity(cellfast(:,nn)))
	ylabel('cell power')
	xlabel('Frequency')
	box off
	
	figure
	subplot(311)
	plotyy(f,log(eegslow),f,cellslow(:,nn))
	title('slow trials')
	box off
	subplot(312)
	plotyy(f,log(eegmed),f,cellfast(:,nn))
	title('medium trials')
	box off
	subplot(313)
	plotyy(f,log(eegfast),f,cellfast(:,nn))
	title('fast trials')
	box off
      end
      
    end
    
    Spect(neu).maxf = maxfrq; 
    Spect(neu).cellslow = cellslow;
    Spect(neu).cellmed = cellmed;
    Spect(neu).cellfast = cellfast;
    Spect(neu).eeg = [eegslow eegmed eegfast];
    
  end
  save([FileBase '.spect'],'Spect');
else
  
  load([FileBase '.spect'],'-MAT');
  
end
return;  
