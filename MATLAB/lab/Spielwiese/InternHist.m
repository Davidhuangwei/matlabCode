function  InternHist(FileBase,Par,Rips,nThetInt,ThPhase);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute the histogramms etc.
fprintf('---------------------------\n');
fprintf('Compute (phase-) histogramms...\n');

Plot = 1; %% plot histograms 

%% Read in units
[spiket, spikeind, numclus, spikeph, ClustByEl] = ReadEl4CCG(FileBase,[1:Par.nElecGps]);

%% Identify cell types 
[type.elec type.cell type.type type.act]  = textread([FileBase '.type'],'%d%d%s%d');
[clu, strlist] = String2Clu(type.type);

%%% Identify bad electrodes (missmatch of Clu and Fet)
if ~FileExists([FileBase '.cfl'])
  BadCluLen = [];
else
  CFL = load([FileBase '.cfl']);
  BadCluLen = find((CFL(:,2)-CFL(:,1))~=0);
end

%% identify Interneurons [electrode custer], take out cells from bad electrodes
allIN = [type.elec(find(clu==1)) type.cell(find(clu==1))];
IN = allIN(find(~ismember(allIN(:,1),BadCluLen)),:);
nIN = length(IN);

%% assign cluster number
for j=1:nIN
  CluIN(j,1) = find(ClustByEl(:,1)==IN(j,1)&ClustByEl(:,2)==IN(j,2));
end

%% get spike times...
xspiket = spiket(ismember(spikeind,CluIN));
xspikeind = spikeind(ismember(spikeind,CluIN));

%% get spike times within theta periods
ThetSpkT = xspiket(find(WithinRanges(xspiket/16,nThetInt)));
ThetSpkInd = xspikeind(find(WithinRanges(xspiket/16,nThetInt)));

%j=1;
%while j<=nIN
%close all

for j=1:nIN
  
  %% spike time for neuron j
  cspiket = xspiket(find(xspikeind==CluIN(j)));
  cspikeind = xspikeind(find(xspikeind==CluIN(j)));
  
  %% xcorrgram of ripple peak and spikes
  [Ccg Ccgt Ccgpairs] = Trains2CCG({Rips.t, round(cspiket/16)},{1,cspikeind},20,50,1250);
  [ccg ccgt ccgpairs] = Trains2CCG({Rips.t, round(cspiket/16)},{1,cspikeind},1,50,1250);
  %[Ccg Ccgt Ccgpairs] = Trains2CCG({Rips.t, round(xspiket/16)},{1,xspikeind},20,50,1250);
  %[ccg ccgt ccgpairs] = Trains2CCG({Rips.t, round(xspiket/16)},{1,xspikeind},1,100,1250);
  
  %% theta phase for spikes in theta period
  aphaseIN = ThPhase(round(ThetSpkT(find(ThetSpkInd==CluIN(j)))/16));
  phaseIN = [aphaseIN; aphaseIN+2*pi]/pi*180 -180; %%% 0 is the TROUGH of theta!!
  
  %%  
  xcorr(:,j+1) = Ccg(:,1,2);
  
  
  
  
  
  %%%%%%%%%%%%%%%%%%%
  %%% PLOT
  if Plot
    clf
    figure(100)
    
    subplot(2,2,1)
    %bar(Ccgt,Ccg(:,j,j));
    bar(Ccgt,Ccg(:,2,2));
    xlim([min(Ccgt) max(Ccgt)]);
    
    subplot(2,2,2)
    %bar(ccgt,ccg(:,j,j));
    bar(ccgt,ccg(:,2,2));
    xlim([min(ccgt) max(ccgt)]);
    
    subplot(2,2,3)
    %bar(Ccgt,Ccg(:,1,j))
    bar(Ccgt,Ccg(:,1,2))
    xlim([min(Ccgt) max(Ccgt)]);
    
    subplot(2,2,4)
    hist(phaseIN,100)
    xlim([-360 360]);
    
    suptitle([FileBase ' (' num2str(IN(j,1)) '/' num2str(IN(j,2)) ')']);
    
    waitforbuttonpress
  end
end

xcorr(:,1) = Ccgt;

save([FileBase '.r2s'],xcorr) 




return
