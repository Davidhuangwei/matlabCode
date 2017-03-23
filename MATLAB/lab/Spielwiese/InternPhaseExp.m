function InterPhase = InternPhaseExp(FileBase,PlaceCell,spike,whl,trial,varargin)
[overwrite, RepFig] = DefaultArgs(varargin,{1,0});

PC=(PlaceCell.ind(:,5)==1);
IN=(PlaceCell.ind(:,5)==2);

if isempty(IN)
  return
end

if ~FileExists([FileBase '.interprecess']) | overwrite
  count=0;
  field=0; 
  atrials = [];
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
    [ccg, t] = CCG(spike.t(find(nspikeind)),nspikeind(find(nspikeind)),20,50,20000,unique(nspikeind(find(nspikeind))));
    
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
      
      figure(1);clf
      imagesc(unique(Index(:,1)),unique(Index(:,2)),smAcc')
      hold on
      BinsIN = [0:2:max(Index(:,1))];
      [mIN lIN uIN BinsIN] = BinSmoothE(Index(:,1), Index(:,2)*pi/180, 'CircConf', BinsIN);
      %errorbar(BinsIN, mod(mIN*180/pi,360), lIN*180/pi, uIN*180/pi, '.k');
      %errorbar(BinsIN, mod(mIN*180/pi,360)+360, lIN*180/pi, uIN*180/pi, '.k');
      ylabel('phase [deg]','FontSize',16);
      xlabel('distance [cm]','FontSize',16);
      set(gca,'YDir','normal','FontSize',16)
      
      %% ccg with all pyramidal cells:
      Fig2=figure(3746);clf
      for m=1:length(PCfields)
	subplotfit(m,length(PCfields))
	bar(t,ccg(:,find(Afields==fields(n)),find(Afields==PCfields(m))))
	xlabel('time [ms]','FontSize',16)
	ylabel('rate [Hz]','FontSize',16)
	set(gca,'FontSize',16)
      end
      ForAllSubplots('axis tight')
      for d=1:size(Acc,2)
	smAcc(:,d) = smooth(Acc(:,d),10,'lowess')./smOcc(1:max(Index(:,1)));
      end
      for d=1:size(Acc,1)
	smAcc(d,:) = smooth(smAcc(d,:),40,'lowess');
      end
      
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
      	
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      fprintf('classify Interneurons: has place field (left), no place field (right) \n')
      waitforbuttonpress;
      whatbutton = get(gcf,'SelectionType');
      switch whatbutton
       case 'normal'   % left -- PF 
	celltype = 1
       case 'alt'      % right -- NOPF
	celltype = 2
       case 'extend'   % mid -- go back
	celltype = 0
       case 'open'     % double click -- go back
	celltype = 0;
      end
      
      if celltype == 1
	while 1
	  [dumx dumy button]=PointInput(1);
	  switch button(1)
	   case 1 % left button
	    field = field+1
	    [x y] = ginput(2)
	    pl(field,:) = sort(x');
	    if pl(field,1)<1
	      pl(field,1)=1;
	    end
	    trials = [];
	    trials(:,2:3) = TrialsWithin(whl.lin,pl(field,:),trial.itv(trial.dir==dire,:));
	    trials(:,1) = field;
	    atrials = [atrials; trials];
	    h(field,:)=Lines(x,[],{'g','r'}',{'-','-'},[2 2]);%spike.clu(tt,:)
	   case 2 % middle button
	    break;
	   case 3 %right button
	    delete(h(field,:));
	    field = field-1;
	  end
	end
      elseif celltype == 2
	%% place field full
	field = field+1;
	pl(field,:) = [min(spike.lpos(gspikes,1)) max(spike.lpos(gspikes,1))];
	if pl(field,1)<1
	  pl(field,1)=1;
	end
	trials = [];
	trials(:,2:3) = TrialsWithin(whl.lin,pl(field,:),trial.itv(trial.dir==dire,:));
	trials(:,1) = field;
	atrials = [atrials; trials];
      end  
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if RepFig
	reportfig(Fig1,'InterneuronPhase',[],['Interneuron' num2str(n)],150);
	reportfig(Fig2,'InterneuronPhase',[],['Interneuron' num2str(n) ': xcorrelogram between pyramidal cell and interneuron'],100);
	reportfig(Fig3,'InterneuronPhase',[],['Interneuron' num2str(n) ': mean phase of interneuron and pyramidal cells'],100);
	%reportfig(Fig1,InterneuronPhase,[],[],150);
      end
      
      
    
      clear Index Acc smAcc;
    end
  end  
  
  InterPhase.lfield = pl;
  InterPhase.trials = atrials;

  %save([FileBase '.interprecess'],'InterPhase')
    
else
  load([FileBase '.interprecess'],'-MAT')
  
end
%InterPhase = [];
  
