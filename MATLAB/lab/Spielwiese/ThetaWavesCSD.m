% function [FRSegW] = ThetaWaveCSD(FileBase) 
%
% -calculates the CSD of one chunk 
% -finds the troughs of theta of the EEG trace of one channel (reference trace) 
% -returns matrix of CSD segments 
%
% FileBase:    e.g 'sm9608_490';
% eegchan:     channel-number of the reference EEG trace (e.g. 56) 
% shank:       channel-numbers to use for CSD (e.g. [49:64])
% nchan:       total number of channels (e.g. 97)
% EEgFs:       EEG sampling rate
% nFet:        number of datapoints per theta wave (e.g. 32)
%
% (c) Caroline Geisler  12/2004
%
%
% usage example: y=ThetaWavesCSD('sm9603m2_209_s1_252')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [FRSegW]=ThetaWavesCSD(FileBase, varargin)

[eegchan, shank, nchan, EEegFs, nFet] =  DefaultArgs(varargin, {56, [49:64], 97, 1250, 32});

%FileBase = 'sm9603m2_209_s1_252';
%eegchan=56;
%shank=[49:64];
%nchan=97;
%EEegFs=1250;
%nFet=32;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EegFileName = [FileBase '.eeg'];
EegChannel = int2str(eegchan);

% read in EEg-traces of one shank for detecting minima
if FileExists([FileBase '.wav.' EegChannel '.min'])
  Minima = load([FileBase '.wav.' EegChannel '.min']);
else
  MEeg = readmulti(EegFileName, nchan, eegchan);
  t=[0:length(MEeg)-1]/1250; 
  
  % determine minima from one trace:
  [b,a]=butter(2,[5 40]/625);
  FTeeg=filtfilt(b,a,MEeg);
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
  GoodTrial = LoadMazeTrialTypes(FileBase,[1 1 1 1 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 1 0 0 0]);
  %% [LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP][rwp lwp  da Tj ca rga lga rra lra]
else
  GoodTrial = load([FileBase '.wav.' EegChannel '.gtr']);
end
  
if length(find(GoodTrial(:,1)>0))==0
  'no good trials'
  FRSegW = 0;
  return
end

%%%%%%%%%%%%%%%%%%%%%


%% get data for csd		   
%CSDChannel = [int2str(shank(1)) '-' int2str(shank(end))];
if  ~FileExists([FileBase  '.csd']) 
  
  %% CHECK ALSO THAT THE CDS IS COMPUTED FROM THE SAME SHANK!!!!!
  
  %calculate the current density for one shank
  % output is FileBase.csd and FileBase.csd.ch
  FileCSD(FileBase,nchan,shank,[])
end

%read in the csd (loosing 2 channels on each side due to computations)
nshank = length(shank)-4;
x = bload([FileBase '.csd'],[nshank inf],0);

y=x';

%%% PLOT
%N=30000;
%ax=[1:2*N-1]/1250/2;
%ay=[1:2*12-1];
%figure
%pcolor(ax,ay,interp2(x(:,1:N),'linear'));
%shading interp
%caxis([-5 5]*1e3)

%calculate the covariant matrix
[du,ds,dv] = svd(x(:,1:1000),0);
%figure
%imagesc(du(:,1:3))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START SEGMENTATION

for iCh=1:nshank
  %iCh
  
  %% devide the theta wave into segs
  j=0;
  for i=1:nSeg

    if round(Minima(i)/1250*39.065)>0
      
      if GoodTrial(round(Minima(i)/1250*39.065))>0
	j=j+1;
	
	TMin(j,1) = Minima(i,1);
	TMin(j+1,1) = Minima(i+1,1);
	
	SegW = y(TMin(j):TMin(j+1),iCh);
	
	%resample data to make all segments same length
	RSegW(1:nFet,j,1)=resample(SegW,nFet,length(SegW));
	
	%add length of intervall
	%RSegW(nFet+1,j,1) = (TMin(j+1)-TMin(j))/1250;
	
	FRSegW(1:nFet,j,iCh) = RSegW(1:nFet,j,1);
	%FRSegW(1:nFet+1,j,iCh) = RSegW(1:nFet+1,j,1);
      end    
      
      clear SegW;
      
    end
  end
end
  
save([FileBase '.wav.csd.seg'], 'FRSegW');

return

%for i=1:length(FileBase)
%[FRSegW]=ThetaWavesEEG(FileBase{i},[],[],[],[],[]);
%if FRSegW==0
%continue;
%end
%SEG(:,j+1:j+size(FRSegW,2),:) = FRSegW;
%j=j+size(FRSegW,2);
%end

%figure
%avcsd = sq(mean(SEG,2));
%pcolor(avcsd'); shading interp;
%set(gca,'YDir','rev');
%ForAllSubplots('caxis([-1500        1500])');
