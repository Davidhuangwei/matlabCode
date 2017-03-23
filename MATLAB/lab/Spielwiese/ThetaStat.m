%%% get the segments of theta from the eeg


%%%%% GoThroughDb


function [dmins,dmaxs]=ThetaStat(FileBase,varargin)
%FileBase='sm9608_495';

if FileExists([FileBase '.states.res']) & FileExists([FileBase ...
		    '.states.clu']) & FileExists([FileBase ...
		    '.states.par']) ;

  quest = input('Do you want to re-Kluster? (1/0)  ');
  
  if quest
    [Eeg,Seg,SegClu,Window]=myEegSegmentation(FileBase);
  else
    com=sprintf('Seg=load([FileBase ''.states.res''])') %--load spike raster
    eval(com)
    com=sprintf('SegClu=load([FileBase ''.states.clu''])') %--load spike raster
    eval(com)
    com=sprintf('Window=load([FileBase ''.states.par''])') %--load spike raster
    eval(com)
    
    %% ACHTUNG!! hard wired channel numbers!!!
    Eeg = readmulti([FileBase '.eeg'],97,55); 
  end
    
else 
  [Eeg,Seg,SegClu,Window]=myEegSegmentation(FileBase);
end
  
%% REM is 1:
SegTheta(:,1)=Seg(find(SegClu==1),1)-Window/2+1;
SegTheta(:,2)=Seg(find(SegClu==1),2)+Window/2+1;

SegLen = diff(SegTheta,1,2);
nSeg = size(SegTheta,1);
EegThM = zeros(max(SegLen),nSeg);
%% difine filter
[b,a]=butter(2,[5 15]/625)

for i=1:nSeg
  EegThM(1:SegLen(i)+1,i) = Eeg(SegTheta(i,1):SegTheta(i,2))';
  EegTh(1:SegLen(i)+1,1) = ([SegTheta(i,1):SegTheta(i,2)])'/1250;
  EegTh(1:SegLen(i)+1,2) = Eeg(SegTheta(i,1):SegTheta(i,2))';
  if i==1
    EegThC=EegTh;
  else 
    EegThC=cat(1,EegThC,EegTh);
  end
  clear EegTh;
end

% filtered eeg trace
FTeeg=filtfilt(b,a,EegThC(:,2));
%detect troughs:
mins=LocalMinima(FTeeg,100,-50);
dmins=1./diff(mins)*1250;
dmins(length(mins))=mean(dmins);
%detect maxs:
maxs=LocalMinima(-FTeeg,100,-50);
dmaxs=1./diff(maxs)*1250;
dmaxs(length(maxs))=mean(dmaxs);



%eegstd = std(Eeg(mins-100*1250:mins+100*1250,1));

%%% SAVE 
msave([FileBase '.states.min'], EegThC(mins,1), 'w');
msave([FileBase '.states.max'], maxs, 'w');


%%% FIGURES
figure
PlotTraces(EegThM)

figure 
subplot(3,1,1)
plot([0:length(Eeg)-1]/1250,Eeg)%,Eeg(:,1),FTeeg,EegThC(mins,1),0,'ro');
subplot(3,1,2)
plot(EegThC(:,1),EegThC(:,2),EegThC(:,1),FTeeg,EegThC(mins,1),0,'ro');
subplot(3,1,3)
plot(EegThC(mins,1),dmins,'ro',EegThC(maxs,1),dmaxs,'bo')
%axis([0,max(time),0,400])

figure 
hist(dmins,50)
figure 
hist(dmaxs,50)



clear mins EegThC 

return;
