% function [] = ThetaWaveEEG(FileBase)
%
% -finds the troughs of theta of the EEG trace of one channel (reference trace) 
% -returns matrix of EEG segments 
%
% FileBase:    e.g 'sm9608_490';
% eegchan:     channel-number of the reference EEG trace (e.g. 56) 
% shank:       channel-numbers to segment (e.g. [49:64])
% nchan:       total number of channels (e.g. 97)
% EEgFs:       EEG sampling rate
% nFet:        number of datapoints per theta wave (e.g. 32)
%
% (c) Caroline Geisler  12/2004
%
%
% usage example: y=ThetaWavesEEG('sm9603m2_209_s1_252',56,56,[],[],[],[])
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [FRSegW]=ThetaWavesEEG(FileBase, varargin)

[eegchan, shank, nchan, EEegFs, nFet, filt] =  DefaultArgs(varargin, {56, [49:64], 97, 1250, 32, 1});

%FileBase = 'sm9603m2_209_s1_252';
%eegchan=56;
%shank=[49:64];
%nchan=97;
%EEegFs=1250;
%nFet=32;
%filt=1; (filter trace)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EegFileName = [FileBase '.eeg'];
EegChannel = int2str(eegchan);

% read in EEg-traces of one shank for detecting minima
if FileExists([FileBase '.wav.' EegChannel '.min'])
  Minima = load([FileBase '.wav.' EegChannel '.min']);
else
  REeg = readmulti(EegFileName, nchan, eegchan);
  t=[0:length(REeg)-1]/1250; 
  
  % determine minima from one trace:
  [b,a]=butter(2,[5 40]/625);
  FTeeg=filtfilt(b,a,REeg);
  Minima=LocalMinima(FTeeg,100,-50);
     
  save([FileBase '.wav.' EegChannel '.min'],'Minima','-ASCII');
end

%% number of segments:
nSeg = length(Minima)-1;


%% select good theta 
if ~FileExists([FileBase '.wav.' EegChannel '.gth'])
  'Warning: *.gth file does not exsist! Default: all is good!'
  GoodTheta = [];
else
  GoodTheta = load([FileBase '.wav.' EegChannel '.gth']);
end
  
%% select trials based on performance and maze-location
if ~FileExists([FileBase '.wav.' EegChannel '.gtr'])
  'Warning: *.gtr file does not exsist! Default: all is good!'

  %% get maze points from wheel-data
  GoodTrial = LoadMazeTrialTypes(FileBase,[1 1 1 1 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 1]);
  %% [LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP][rwp lwp  da Tj ca rga lga rra lra]
else
  GoodTrial = load([FileBase '.wav.' EegChannel '.gtr']);
end
  
if length(find(GoodTrial(:,1)>0))==0
  'no good trials'
  FRSegW = 0;
  return
end

%% Read all
x = readmulti(EegFileName, nchan, shank);
if filt
  [b,a]=butter(2,[5 40]/625);
  y=filtfilt(b,a,x);
else
  y = x;
end

%%%%%%%%%%%%%%%%%%%%%%%%%

nochan = length(shank);

for iCh=1:nochan
  iCh
  
  %% devide the theta wave into segs
  j=0;
  for i=1:nSeg
    
    if round(Minima(i)/1250*39.065)>0
    
      if GoodTrial(round(Minima(i)/1250*39.065))>0
	j=j+1;
	
	TMin(j) = Minima(i,1);
	TMin(j+1) = Minima(i+1,1);
	
	SegW = y(TMin(j):TMin(j+1),iCh);
	
	%resample data to make all segments same length
	RSegW(1:nFet,j,1)=resample(SegW,nFet,length(SegW));
	if length(shank)==1 
	  %normalized amplitude
	  RSegW(1:nFet,j,1)=RSegW(1:nFet,j,1)/(max(RSegW(1:nFet,j,1))-min(RSegW(1:nFet,j,1)));
	  % same starting point 
	  RSegW(1:nFet,j,1)=RSegW(1:nFet,j,1)-RSegW(1,j,1); 
	  % extra: period
	  RSegW(nFet+1,j,1) = (Minima(j+1,1)-Minima(j))/1250;
	  % extra: amplitude normalization
	  %RSegW(nFet+2,j,1) = (max(RSegW(1:nFet,j,1))-min(RSegW(1:nFet,j,1)));
	  
	  FRSegW(1:nFet+1,j,iCh) = RSegW(1:nFet+1,j,1);
	else
	  FRSegW(1:nFet,j,iCh) = RSegW(1:nFet,j,1);
	end
	
      end    
      clear SegW;
    end
  end
end

save([FileBase '.wav.eeg.seg'], 'FRSegW');
return

%>> j=0;
%>> for i=1:length(FileBase)
%[FRSegW]=ThetaWavesEEG(FileBase{i}, 56,56,[],[],[],[]);
%if FRSegW==0
%continue;
%end
%SEG(:,j+1:j+size(FRSegW,2)) = FRSegW;
%j=j+size(FRSegW,2);
%end%
%
%>> figure
%>> y(:,1) = mean(SEG,2);
%>> y(:,2) = std(SEG,0,2);
%>> plot(a,y(:,1),a,y(:,1)+y(:,2),a,y(:,1)-y(:,2))
