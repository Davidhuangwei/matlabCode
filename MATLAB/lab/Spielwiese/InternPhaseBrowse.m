function InterPhase = InternPhaseBrowse(FileBase,PlaceCell,spike,whl,trial,Tune,varargin)
[overwrite, RepFig] = DefaultArgs(varargin,{1,0});
AllFigs = 0

PC=(PlaceCell.ind(:,5)==1);
IN=(PlaceCell.ind(:,5)==2);

if isempty(IN)
  return
end

if ~FileExists([FileBase '.interprecess']) | overwrite
  count=0;
  for dire=unique(PlaceCell.ind(find(IN),4))';
    
    gdir = find(trial.dir==dire);
    fields = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==2);
    PCfields = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==1);
    [neurons nindx] = unique(PlaceCell.ind(fields,1));
    
    %keyboard
    
    for n=1:length(fields)
      gspikes = spike.ind==PlaceCell.ind(fields(n),1) & WithinRanges(round(spike.t/20000*whl.rate),trial.itv(gdir,:)) & spike.good;
      gpos = find(WithinRanges([1:size(whl.itv,1)],trial.itv(gdir,:)));
      
      Index(:,1) = [round(spike.lpos(gspikes))+1; round(spike.lpos(gspikes))+1];
      Index(:,2) = [round(spike.ph(gspikes)*180/pi)+1; round(spike.ph(gspikes)*180/pi+360)+1];
      Acc = Accumulate(Index,1,max(Index));
      Occ = Accumulate(round(whl.lin(gpos))+1,1,max(round(whl.lin(gpos))+1));
      smOcc = smooth(Occ,10,'lowess');
      smOcc([1:10]) = ones(10,1)*smOcc(10);
      smOcc([end-9:end]) = ones(10,1)*smOcc(end-9);
      smOcc = clip(smOcc,0.2*mean(smOcc),max(smOcc));
      for d=1:size(Acc,2)
	smAcc(:,d) = smooth(Acc(:,d),10,'lowess')./smOcc(1:max(Index(:,1)));
      end
      for d=1:size(Acc,1)
	smAcc(d,:) = smooth(smAcc(d,:),40,'lowess');
      end
      
      %if dire~=2
      %	continue
      %      end
      
      %% EXAMPLE
      figure(100);clf
      
      subplot(4,3,[1 2])
      gtrial = find(trial.dir(find(trial.dir>1))==dire);
      plot(mean(Tune.rate(gtrial,:,1)),'k','linewidth',2); hold on;
      
      subplot(4,3,[4 5  7 8 10 11])
      imagesc(unique(Index(:,1)),unique(Index(:,2)),smAcc')
      hold on
      ylabel('phase [deg]','FontSize',16);
      xlabel('distance [cm]','FontSize',16);
      set(gca,'YDir','normal','FontSize',16,'TickDir','out','YTick',[0:180:720])
      box off
      
      %% ccg with all pyramidal cells:
      
      for m=1:length(PCfields)
	
	col = [0 0 0];
	
	subplot(4,3,[1 2])
	plot(mean(Tune.rate(gtrial,:,m+1)),'Color',col,'linewidth',2);
	ylabel('rate [Hz]')
	set(gca,'FontSize',16,'XTick',[],'TickDir','out')
	axis tight; box off
	
	PCIntv = PlaceCell.trials(find(PlaceCell.trials(:,1)==PCfields(m)),2:3);	  
	PCSpikes = spike.ind==PlaceCell.ind(PCfields(m),1) & WithinRanges(round(spike.t/20000*whl.rate),PCIntv) & spike.good;	  
	BinsPC = [min(spike.lpos(PCSpikes)):2:max(spike.lpos(PCSpikes))];
	[mPC lPC uPC BinsPC] = BinSmoothE(spike.lpos(PCSpikes), spike.ph(PCSpikes), 'CircConf', BinsPC);
	
	subplot(4,3,[4 5 7 8 10 11])
	plot([BinsPC';BinsPC'], [mod(mPC*180/pi,360);mod(mPC*180/pi,360)+360],'.','color',col,'markersize',16);
	set(gca,'YDir','normal','FontSize',16)
      end
      
      %figure(101)
      %bar(t,ccg(:,find(Afields==PCfields(1)),find(Afields==PCfields(2))))

      waitforbuttonpress
      
      clear Index Acc smAcc;
    end
  end  
  InterPhase=[];
  %save([FileBase '.interprecess'],'InterPhase')
  
else
  load([FileBase '.interprecess'],'-MAT')
  
end

return

