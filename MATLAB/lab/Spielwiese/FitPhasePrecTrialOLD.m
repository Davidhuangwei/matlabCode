function Trials=FitPhasePrecTrial(FileBase,PlaceCell,whl,trial,spike,varargin)
[overwrite,Manual] = DefaultArgs(varargin,{0,1});

fprintf('  linear fit of phase precession...\n');

if ~FileExists([FileBase '.slopetr']) | overwrite
  
  figure;
  count=0;
  for neu=1:length(PlaceCell)
    if PlaceCell(neu).indall(5) ~=1
      continue;
    end
    
    
    dire = PlaceCell(neu).indall(4);
    for dd = 1:size(PlaceCell(neu).lfield,1) 
      
      trials = trial.itv(find(trial.dir==dire),:);
      for tr=1:length(trials)
	
	indx = find(WithinRanges(spike.lpos,PlaceCell(neu).lfield(dd,:)) & WithinRanges(round(spike.t/20000*whl.rate),trials(tr,:)) & spike.ind==PlaceCell(neu).indall(1) & spike.dir==dire & spike.good);
	
	Time = length(find(WithinRanges(whl.lin,PlaceCell(neu).lfield(dd,:)) & WithinRanges(find(whl.ctr(:,1)),trials(tr,:)))); 
	Speed = abs(diff(PlaceCell(neu).lfield(dd,:)))/Time*whl.rate;
	
	if length(find(indx))<2
	  continue;
	end
	
	[dummy idx] = sort(spike.lpos(indx,1));
	
	spikepos = spike.lpos(indx(idx),1);
	spikeph = 180/pi*spike.ph(indx(idx),1);
	
	if length(find(indx))==2
	  B(2,1)=diff(spikeph)/diff(spikepos);
	  B(1,1) = -B(2,1)*spikepos(1) + spikeph(1);
	  stats.p = [0 0]';
	  keepit.b = B;
	  keepit.stats.p = stats.p;
	else
	  [B stats] = robustfit(spikepos,spikeph);
	  
	  ff=1;
	  pp(1) = 1;
	  while ff
	    
	    ff=ff+1;
	  
	    differ = (B(2)*spikepos+B(1)-spikeph);
	    dinx = find(abs(differ)>180);
	    spikeph(dinx) = spikeph(dinx) + 360*sign(differ(dinx)); %+ 360*floor(differ(dinx)/360);
	    
	    clf
	    subplot(211)
	    plot(spikepos,spikeph,'.')
	    hold on
	    plot(spikepos,B(2)*spikepos+B(1));
	    plot(spike.lpos(indx,1),spike.ph(indx,1)*180/pi,'ro');
	    title(['cell ' num2str(PlaceCell(neu).indall(1)) ' | dir ' num2str(dire) ' | field ' num2str(dd) ' | trial ' num2str(tr)])
	  
	    [B stats] = robustfit(spikepos,spikeph);
	    
	    pp(ff,1) = stats.p(2);
	    
	    subplot(212)
	    plot(log(pp(2:end)),'.-');
	    
	    
	    if (ff>5 & log(pp(ff))>=log(min(pp(1:ff-1)))) | ff>100

	      if Manual
		waitforbuttonpress;
		whatbutton = get(gcf,'SelectionType');
		switch whatbutton
		 case 'normal'  % left -- PC 
		  break;
		 case 'alt'      % right -- bad
		  [x y] = ginput(2);
		  B(2) = (y(2)-y(1))/(x(2)-x(1));
		  B(1) = y(1) - B(2)*x(1); 
		  ff=1;
		 case 'extend'     % mid -- go back 
		  ff=ff-1;
		 case 'open'     % double click -- go back 
		  ff=ff-1;
		end
	      else
		break
	      end
	    end
	  end
	    
	  keepit.b = B;
	  keepit.stats = stats;
	  
	end
	subplot(211)
	plot(spikepos,keepit.b(2)*spikepos+keepit.b(1),'r');
	[B' stats.p']
	phdiff = max(keepit.b(2)*spikepos+keepit.b(1))-min(keepit.b(2)*spikepos+keepit.b(1));

	%%%%%
	count = count+1;
	%keyboard
	if trial.OneMeanTrial & dire == 3
	    keepit.b(2) = -keepit.b(2);
	end
	%%               [   neuron number      field trial [b slope] stats     num spikes phasediff
	Trials(count,:)= [PlaceCell(neu).indall(1) dd tr keepit.b' ...
			  keepit.stats.p' length(find(indx))  phdiff Speed];
	
	%Indx = find(spike.ind==PlaceCell(neu).indall(1) & spike.dir==dire & spike.good);
	%PlaceCell(neu).spikes = [spike.ind(Indx,1) spike.dir(Indx,1) spike.t(Indx,1) spike.lpos(Indx,1) spike.ph(Indx,1)];
	%%%%
	
	clear pp B stats.p;
      end
    end
  end
  save([FileBase '.slopetr'],'Trials')
  
else
  load([FileBase '.slopetr'],'-MAT');
end

return;
  
  
  