function PlaceCell=FindPlaceFields(FileBase, spiket, spikeind, spikepos, spikedir, spikeph, whl, trial, varargin);
[overwrite] = DefaultArgs(varargin,{0});

trials = trial(:,1:2);
trialdir = trial(:,3);

if ~FileExists([FileBase '.trl']) | overwrite

  figure;
  plfld = 0; %count place fileds
	
  numclus=max(unique(spikeind));
  whlplot = whl(find(whl(:,1)>0),[1:2]);
  
  %% loop only through good cells and sort out place cells
  Nrate = hist(spikeind,numclus)'/(max(spiket)-min(spiket))*20000;
  GoodClus = find(Nrate>0.1);
  for neu=GoodClus'
    for tdir = unique(trialdir(find(trialdir>1)))'
      indx = find(spikeind==neu&spikedir==tdir);
      
      clf;
      plot(whlplot(1:100:end,1),whlplot(1:100:end,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
      hold on
      scatter(spikepos(indx,1),spikepos(indx,2),30,(spikeph(indx))*180/pi);
      title(['neuron ' num2str(neu) '/' num2str(numclus) ' ' num2str(tdir)]);
      colorbar;
      
      numfield = input('How many place fields does this cell have? ');
            
      if numfield
	
	for numf=1:numfield
	  %% find all rat-locations within place field
	  [infield ply] = myClusterPoints(whl,0); 
	  tinfield = find(infield);
	  
	  %% find beginning and end of each place field crossing 
	  goodtrials = trials(trialdir==tdir,:);
	  for t=1:length(goodtrials)
	    spots = [];
	    spots = tinfield(find(WithinRanges(tinfield,goodtrials(t,:))));
	    
	    if isempty(spots)
	      continue;
	    end
	    intrial(t,:)=[min(spots) max(spots)];
	    
	    if length([min(spots):max(spots)]) > 1.25*length(spots)
	      cross = [min(spots); spots(find(diff(spots)>20)); max(spots)];
	      epis = reshape(sort([cross;cross(2:end-1)]'),2,length(cross)-1)';
	      gepis = find((epis(:,2)-epis(:,1))==max(epis(:,2)-epis(:,1)));
	      
	      if length(gepis)>1;
		ggepis = gepis(1);
	      else
		ggepis = gepis;
	      end
	      
	      intrial(t,:) = [epis(ggepis,1) epis(ggepis,2)];
	    end
	    
	  end
	  snewtrial = intrial(intrial(:,1)>0,:);
	  newtrial = snewtrial((snewtrial(:,2)-snewtrial(:,1))>0,:);
	  
	  plfld = plfld+1;
	  PlaceCell(plfld).ind = [neu tdir];
	  PlaceCell(plfld).trials = newtrial;
	  
	  %% average trace and linearized position
	  [smpos lin] = FindMainTraj(PlaceCell(plfld).trials,whl);
	  PlaceCell(plfld).mtrials = smpos;
	  PlaceCell(plfld).ltrials = lin;
	  
	end
      else
	continue;
      end
    end
  end
  save([FileBase '.trl'],'PlaceCell');
else
  load([FileBase '.trl'],'-MAT');
end
