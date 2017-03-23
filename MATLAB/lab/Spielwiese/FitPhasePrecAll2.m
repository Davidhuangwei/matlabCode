function PlaceCell=FitPhasePrec2(FileBase,PlaceCell,spike)


%figure;

Win=40

for neu=1:length(PlaceCell)
  if PlaceCell(neu).ind(5) ~=1
    continue;
  end
  
  dire = PlaceCell(neu).ind(4);

  neu
  
  %keyboard
  
  for dd = 1:size(PlaceCell(neu).lfield,1) 
    
    clear intv
    intv = PlaceCell(neu).lfield(dd,:);
    indx = (WithinRanges(spike.lpos,intv) & spike.ind==PlaceCell(neu).ind(1) & spike.dir==dire & spike.good);

    spikeph = spike.ph(indx,:);
    spikelpos = spike.lpos(indx,:);
    
    [spikelpos dummy] = sort(spikelpos);
    spikeph = spikeph(dummy);
    
    for k=1:abs(diff(intv))-Win
      indx2 = WithinRanges(spikelpos,[(k-1):(k-1)+Win]+intv(:,1));
      if isempty(find(indx2))
	continue;
      else
	%mphase = mod(circmean(spikeph(find(indx2))),2*pi);
	mphase = mod(circmean(spikeph(find(indx2))),2*pi);
	mmm(k,1) = mean(spikelpos(find(indx2)));
	mmm(k,2) = mphase;
	break;
      end
    end
    
    %keyboard
    
    for kk=k+1:abs(diff(intv))%-Win
      indx2 = WithinRanges(spikelpos,[(kk-1):(kk-1)+Win]+intv(:,1));
      if isempty(find(indx2))
	mmm(kk,1) = mmm(kk-1,1);
	mmm(kk,2) = mmm(kk-1,2);
	continue;
      end
      %differ = abs(spikeph-mphase)>pi;
      %indx3 = find(differ&indx2);
      %spikeph(indx3) = spikeph(indx3)+2*pi*sign(mphase-spikeph(indx3));%- 2*pi*floor((mphase-spikeph(indx3))/(2*pi));
      
      %spikeph(find(indx2)) = mod(abs(spikeph(find(indx2))-mphase),2*pi)+mphase*sign(spikeph(find(indx2))-mphase);
      spikeph(find(indx2)) = mod(spikeph(find(indx2))-mphase-pi,2*pi)+pi;%+mphase*sign(spikeph(find(indx2))-mphase);
      
      %mphase = mod(circmean(spikeph(find(indx2))),2*pi);
      mphase = mod(mmm(kk-1,2)-mphase-pi,2*pi)+pi;%+mmm(kk-1,2);%*sign(mphase-mmm(kk-1,2));
							    
      %if abs(mphase-mmm(kk-1,2))>pi
      %	mphase = mphase + 2*pi*sign(mmm(kk-1,2)-mphase);% - 2*pi*floor((mmm(kk-1,2)-mphase)/(2*pi));
      %     end
	
      mmm(kk,1) = mean(spikelpos(find(indx2)));
      mmm(kk,2) = mphase;
    end
    
    [B stats] = robustfit(spikelpos,spikeph);
    
    %keyboard
    
    %subplot(211)
    clf
    plot(spikelpos,spikeph,'.');
    hold on;
    plot(spike.lpos(indx,:),spike.ph(indx,:),'ro');
    plot(spikelpos,B(2)*spikelpos+B(1));
    plot(mmm(:,1),mmm(:,2),'.-g')
        
    %%PlaceCell(neu).slope = ;
    %PlaceCell(neu).slope(dd,:) = [keepit.b' keepit.stats.p'];
    
    waitforbuttonpress;
    clf
    clear pp B stats.p mmm;
    
    
  end
end
%save([FileBase '.PlaceCell'],'PlaceCell')



return;


