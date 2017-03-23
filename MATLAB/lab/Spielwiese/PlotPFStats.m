%% Plotting function for PFStats.m
function PlotPFStats(tx,Rat,SRat,spiket,spikeind,CQ,varargin)

[PLOT,REP] =  DefaultArgs(varargin,{[1:10], 0});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% inBins = {angle, direction, radius, speed}

inBins{1} = [0:10:360]'; 
inBins{2} = [2*min(SRat(:,2)):(max(SRat(:,2))-min(SRat(:,2)))/20:2*max(SRat(:,2))]';
inBins{3} = [min(SRat(:,3)):(max(SRat(:,3))-min(SRat(:,3)))/20:max(SRat(:,3))]';
inBins{4} = [1.5*min(SRat(:,4)):(max(SRat(:,4))-min(SRat(:,4)))/30:1.5*max(SRat(:,4))]';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% define cell groups:

PC = find(CQ(:,7)==1 & CQ(:,8)==1);
INT = find(CQ(:,7)==2 & CQ(:,8)==1);

CellGroups = {PC,INT};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot 1: rate vs. speed vs. position

if ~isempty(find(PLOT==1))

  ii=0;
  for c=1:length(CellGroups)
  
    clear Cells;
    
    Cells = CellGroups{c};
    
    for j=1:length(Cells)
      i=Cells(j);
      
      %% threshold for rate
      Thresh = 0;
      
      %% Instantaneous firing rate
      [Rate, Aspike]=InstFiringRate(tx,Rat,spiket(find(spikeind==i)));
      
      %% averaged firing rate
      avrate = length(Aspike(:,1))/(max(Aspike(:,1))-min(Aspike(:,1)))*40;
      rndavrate = round(avrate*100)/100;
      
      %% Trigeometric moments
      TriPhase = TriMoments(Aspike(:,2));
      
      RSRat = SRat(find(Rate>Thresh),:);
      FRate = Rate(find(Rate>Thresh));
      
      %% PLOT
      jj=ceil(j/9);
      cfigure(jj+ii)
      subplot(3,3,mod(j-1,9)+1)
      PlotThree(RSRat(:,1), RSRat(:,4),FRate,inBins{1}, inBins{4})
      title(['(' num2str(Cells(j)) ') eQu=' num2str(round(CQ(i,3))) '; f=' num2str(rndavrate) ...
	     '; N=' num2str(length(Aspike(:,1)))]);
      
    end
    ii = jj;
  end
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot 2: auto- and crosscorrelations between cells
if ~isempty(find(PLOT==2))

  cfigure(100)
  subplot(2,1,1)
  plot(Rat(:,1),Rat(:,2),'k-')
  hold on
  
  %for c=1:length(CellGroups)
  c=1;
    clear Cells;
    Cells = CellGroups{c};
    
    for j=1:length(Cells)
      i=Cells(j);
      
      %% Instantaneous firing rate
      [Rate, Aspike]=InstFiringRate(tx,Rat,spiket(find(spikeind==i)));
      
      %% PLOT
      cfigure(100)
      subplot(2,1,2)
      %scatter(Aspike(:,1),Aspike(:,2),5,ones(length(Aspike(:,1)),1)*j,'o')
      scatter(Aspike(:,1),ones(length(Aspike(:,1)),1)*j,5,ones(length(Aspike(:,1)),1)*j,'o')
      hold on
      
    end
  %end
  colorbar
  
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot 3: auto- and crosscorrelations between cells
if ~isempty(find(PLOT==3))
  
  cfigure(101)
  %subplot(1,2,1)
  %plot(Rat(:,2),Rat(:,1),'k-')
  %hold on
  
  %cfigure(102)
  %%subplot(1,2,2)
  %plot(Rat(:,2),Rat(:,1),'k-')
  %hold on
  
  %for c=1:length(CellGroups)
  c=1  
  clear Cells;
    Cells = CellGroups{c};
    
    for j=1:length(Cells)
      i=Cells(j);
      
      %% Instantaneous firing rate
      [Rate, Aspike]=InstFiringRate(tx,Rat,spiket(find(spikeind==i)));
      
      %% PLOT
      %cfigure(100+c)
      %subplot(1,2,c)
      scatter(Aspike(:,2),Aspike(:,1),20,ones(length(Aspike(:,1)),1)*j,'o')
      %scatter(Aspike(:,1),ones(length(Aspike(:,1)),1)*j,5,ones(length(Aspike(:,1)),1)*j,'o')
      %hold on
      
      colorbar
      
      waitforbuttonpress;
      
    end
  %end
  
end
  
