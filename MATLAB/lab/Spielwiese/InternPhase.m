function InterPhase = InternPhase(FileBase,PlaceCell,spike,whl,trial,Tune,varargin)
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
    [neurons nindx] = unique(PlaceCell.ind(fields,1));
    
    %keyboard
    
    %% ccg between cells during theta! 
    Afields = find(PlaceCell.ind(:,4)==dire);
    PCfields = find(PlaceCell.ind(:,4)==dire & PlaceCell.ind(:,5)==1);
    nspikeind = zeros(size(spike.ind));
    for n=1:length(Afields)
      pfindx = find(PlaceCell.trials(:,1)==Afields(n));
      spikeindx = spike.ind==PlaceCell.ind(Afields(n),1) & WithinRanges(round(spike.t/20000*whl.rate),PlaceCell.trials(pfindx,2:3)) & spike.good;
      nspikeind(find(spikeindx),1) = Afields(n); 
    end
    %[ccg, t] = CCG(spike.t(find(Agspikes)),nspikeind(find(Agspikes)),20,50,20000,unique(nspikeind(find(Agspikes))));
    %[ccg, t] = CCG(spike.t(find(nspikeind)),nspikeind(find(nspikeind)),200,500,20000,unique(nspikeind(find(nspikeind))));
    [ccg, t] = CCG(spike.t(find(nspikeind)),nspikeind(find(nspikeind)),80,20,20000,unique(nspikeind(find(nspikeind))));
    
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
      
      %% FIGURES
      if AllFigs
	figure(1);clf
	imagesc(unique(Index(:,1)),unique(Index(:,2)),smAcc')
	hold on
	BinsIN = [0:2:max(Index(:,1))];
	[mIN lIN uIN BinsIN] = BinSmoothE(Index(:,1), Index(:,2)*pi/180, 'CircConf', BinsIN);
	%errorbar(BinsIN, mod(mIN*180/pi,360), lIN*180/pi, uIN*180/pi, '.k');
	%errorbar(BinsIN, mod(mIN*180/pi,360)+360, lIN*180/pi, uIN*180/pi, '.k');
	ylabel('phase [deg]','FontSize',16);
	xlabel('distance [cm]','FontSize',16);
	title(['interneuron ' num2str(fields(n))]);
	set(gca,'YDir','normal','FontSize',16)
	
	%% ccg with all pyramidal cells:
	Fig2=figure(3746);clf
	for m=1:length(PCfields)
	  subplotfit(m,length(PCfields))
	  bar(t,ccg(:,find(Afields==fields(n)),find(Afields==PCfields(m))))
	  xlabel('time [ms]','FontSize',16)
	  ylabel('rate [Hz]','FontSize',16)
	  title(['Pyramidal Cell ' num2str(PCfields(m))]);
	  set(gca,'FontSize',16)
	end
	ForAllSubplots('axis tight')
	
	figure(3475);clf
	for m=1:length(PCfields)
	  Fig3=figure(3475)
	  subplotfit(m,length(PCfields))
	  PCIntv = PlaceCell.trials(find(PlaceCell.trials(:,1)==PCfields(m)),2:3);
	  PCSpikes = spike.ind==PlaceCell.ind(PCfields(m),1) & WithinRanges(round(spike.t/20000*whl.rate),PCIntv) & spike.good;
	  plot([spike.lpos(PCSpikes); spike.lpos(PCSpikes)],[spike.ph(PCSpikes); spike.ph(PCSpikes)+2*pi]*180/pi,'.')
	  hold on
	  BinsPC = [min(spike.lpos(PCSpikes)):2:max(spike.lpos(PCSpikes))];
	  [mPC lPC uPC BinsPC] = BinSmoothE(spike.lpos(PCSpikes), spike.ph(PCSpikes), 'CircConf', BinsPC);
	  errorbar(BinsPC, mod(mPC*180/pi,360), lPC*180/pi, uPC*180/pi, '.r');
	  errorbar(BinsPC, mod(mPC*180/pi,360)+360, lPC*180/pi, uPC*180/pi, '.r');
	  errorbar(BinsIN, mod(mIN*180/pi,360), lIN*180/pi, uIN*180/pi, '.g');
	  errorbar(BinsIN, mod(mIN*180/pi,360)+360, lIN*180/pi, uIN*180/pi, '.g');
	  xlabel('distance','FontSize',16)
	  ylabel('phase','FontSize',16)
	  set(gca,'YDir','normal','FontSize',16)
	  xlim([0 max(whl.lin)])
	  ylim([0 720])
	  
	  Fig1=figure(1)
	  plot([BinsPC';BinsPC'], [mod(mPC*180/pi,360);mod(mPC*180/pi,360)+360], '.k','markersize',16);
	  set(gca,'YDir','normal','FontSize',16)
	end
	
	figure(2);clf
	plot([spike.lpos(gspikes); spike.lpos(gspikes)],[spike.ph(gspikes)*180/pi; spike.ph(gspikes)*180/pi+360],'.');
      
	if RepFig
	  reportfig(Fig1,'InterneuronSpect',[],['Interneuron' num2str(n)],150);
	  reportfig(Fig2,'InterneuronSpect',[],['Interneuron' num2str(n) ': xcorrelogram between pyramidal cell and interneuron'],100);
	  %reportfig(Fig3,'InterneuronSpect',[],['Interneuron' num2str(n) ': mean phase of interneuron and pyramidal cells'],100);
	  %reportfig(Fig1,InterneuronPhase,[],[],150);
	  %else
	  %	waitforbuttonpress;
	end
      else 
	
	if dire~=2
	  continue
	end
	
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
	  
	  color = {'r' 'g'};
	  
	  subplot(4,3,[1 2])
	  plot(mean(Tune.rate(gtrial,:,m+1)),color{m},'linewidth',2);
	  ylabel('rate [Hz]')
	  set(gca,'FontSize',16,'XTick',[],'TickDir','out')
	  axis tight; box off
	  
	  subplot(4,3,[3 6]+(m-1)*6)
	  bar(t,ccg(:,find(Afields==fields(n)),find(Afields==PCfields(m))),color{m})
	  if m==2 
	    xlabel('time [ms]','FontSize',16)
	  end
	  ylabel('rate [Hz]','FontSize',16)
	  set(gca,'FontSize',16,'TickDir','out')
	  axis tight; %xlim([-50 50]);
	  box off

	  PCIntv = PlaceCell.trials(find(PlaceCell.trials(:,1)==PCfields(m)),2:3);	  
	  PCSpikes = spike.ind==PlaceCell.ind(PCfields(m),1) & WithinRanges(round(spike.t/20000*whl.rate),PCIntv) & spike.good;	  
	  BinsPC = [min(spike.lpos(PCSpikes)):2:max(spike.lpos(PCSpikes))];
	  [mPC lPC uPC BinsPC] = BinSmoothE(spike.lpos(PCSpikes), spike.ph(PCSpikes), 'CircConf', BinsPC);
	  
	  subplot(4,3,[4 5 7 8 10 11])
	  plot([BinsPC';BinsPC'], [mod(mPC*180/pi,360);mod(mPC*180/pi,360)+360],'.','color',color{m},'markersize',16);
	  set(gca,'YDir','normal','FontSize',16)
        end
      end
      
      figure(101)
      bar(t,ccg(:,find(Afields==PCfields(1)),find(Afields==PCfields(2))))

      
      clear Index Acc smAcc;
    end
  end  
  InterPhase=[];
  %save([FileBase '.interprecess'],'InterPhase')
  
else
  load([FileBase '.interprecess'],'-MAT')
  
end

return

