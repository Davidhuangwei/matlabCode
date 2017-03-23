function RemCell=FindRemCells(FileBase, spike, Eeg, varargin)
[overwrite] = DefaultArgs(varargin,{0});
%%
%% returns structure with one entry per place field (PF). 
%%
%% RemCell.ind = [cell cluster electrode dir celltype]; cell identification for each (PF)
%% RemCell.lfield = [begin end]; beginning and and of PFs in linearized coordinates.
%% RemCell.trials = [neuron begin end]; beginning and and of PFs in whl samples.
%%

fprintf('  find REM cells....\n');
  
if ~FileExists([FileBase '.RemCell']) | overwrite

  %% loop through cells
  count = 0;                     %% count place fields
  neurons = unique(spike.ind);   %% neuron numbers
  atrials = [];

  sleep = load([FileBase '.sts.REM']);
  
  RemInt = load([FileBase '.sts.REM']);
  EegIndx = WithinRanges([1:length(Eeg)],RemInt);
  
  for n=1:length(neurons)

    neu = neurons(n);
    indx = find(spike.rem & spike.ind==neu);
    indxR = find(spike.run & spike.ind==neu);
    
    figure(111);clf
    
    subplot(411)
    %plot(find(EegIndx)/1250,Eeg(find(EegIndx))/max(abs(Eeg(find(EegIndx))))*1000)
    plot(spike.t(indx)/20000,spike.ph(indx)*180/pi,'r.')
    hold on
    plot(spike.t(indx)/20000,spike.ph(indx)*180/pi+360,'r.')
    plot(spike.t(indxR)/20000,spike.ph(indxR)*180/pi,'.')
    plot(spike.t(indxR)/20000,spike.ph(indxR)*180/pi+360,'.')
    %Lines(sleep(:,1)/1250,[],'g','-',1);
    %Lines(sleep(:,2)/1250,[],'r','-',1);
    %%Lines(spike.t(indx)/20000);
    axis tight
    xlim([0 max(spike.t)/20000]);

    subplot(423)
    [ccg, t] = CCG(spike.t(indx),1,20,50,20000);
    bar(t,ccg(:,1,1))
    axis tight
    
    subplot(425)
    hist(spike.ph(indx)*180/pi,60)
    axis tight
    
    subplot(427)
    [ccgPh, tPh] = CCG(spike.uph(indx)*180/pi,1,20,100,1000);
    bar(tPh,ccgPh(:,1,1))
    axis tight
    xlim([0 1440])
    Lines([360:360:1440]);
    
    %%%%%%%%%%
    subplot(424)
    [ccg, t] = CCG(spike.t(indxR),1,20,50,20000);
    bar(t,ccg(:,1,1))
    axis tight
    
    subplot(426)
    hist(spike.ph(indxR)*180/pi,60)
    axis tight
    
    subplot(428)
    [ccgPh, tPh] = CCG(spike.uph(indxR)*180/pi,1,20,100,1000);
    bar(tPh,ccgPh(:,1,1))
    axis tight
    xlim([0 1440])
    Lines([360:360:1440]);
    
    
    
    waitforbuttonpress
      
  end
end

RemCell = [];
    
return

    %% spike count - Rate
    [AvR StdR Bins] = MakeAvF([trialindwh(gpos) pos(gpos)],SpkCnt(gpos,neurons(n)),[max(trialindwh) max(pos)]);
    for tr=1:size(AvR,1)
      smAvR(tr,:) = smooth(AvR(tr,:),15,'lowess');
    end
    
    %% loop through directions
    for nn=1:length(direct)
    
     neu = neurons(n);
     dir = direct(nn);
     if dir<2 
    	continue;
     end
    
    % indeces of spikes
      indx = find(spike.ind==neu & spike.dir==dir & spike.good);
      
      [ccg, t] = CCG(spike.t(indx),1,20,50,20000);
      
      if length(indx)>1000
	indx = indx([1:round(length(indx)/1000):length(indx)]);
      end
      
      clf
      %% plot spikes-phase 
      subplot(211)
      plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1),'.')
      hold on
      plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+360,'.')
      plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+720,'.')
      %Lines(trial.evtlin(find(trial.evtind(:,1)==nn)),[],'b','--',2*ones(size(trial.evtlin(find(trial.evtind(:,1)==nn)))));
      xlim([0 max(spike.lpos)]);
      title(['cell ' num2str(n) ' || direction ' num2str(dir) ' || ' num2str(spike.clu(neu,1)) '|' num2str(spike.clu(neu,2))]);
      hold off;
      %% plot 2D scatter
      subplot(234)
      plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
	   'markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
      hold on;
      scatter(spike.pos(indx,1),spike.pos(indx,2),30,(spike.ph(indx))*180/pi);
     hold off;
      %% plot autocorrelogram
      subplot(235)
      bar(t,ccg);
      xlim([min(t) max(t)]);
      %% plot 2D rate
      subplot(236)
      %% spike count - Rate
      imagesc(smAvR(find(gtrialdir==dir),:));
  
      
      
      %% classify neurons: bad cell (0) / place cell (1) / interneuron (2)
      fprintf('classify neurons: place cell (left), interneuron (middle), bad cell (right)\n')
      waitforbuttonpress;
      whatbutton = get(gcf,'SelectionType');
      switch whatbutton
       case 'normal'   % left -- PC 
	celltype = 1
       case 'alt'      % right -- bad
	celltype = 0
       case 'extend'   % mid -- interneuron
	celltype = 2
       case 'open'     % double click -- go ba
	celltype = 0;
      end
      
      %% select place fields
      if celltype == 1
	while 1
	  [dumx dumy button]=PointInput(1);
	  switch button(1)
	   case 1 % left button
	    field = field+1
	    identify(field,:) = [neu spike.clu(neu,:) dir celltype];
	    [x y] = ginput(2)
	    pl(field,:) = sort(x');
	    if pl(field,1)<1
	      pl(field,1)=1;
	    end
	    trials = [];
	    trials(:,2:3) = TrialsWithin(whl.lin,pl(field,:),trial.itv(trial.dir==dir,:));
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
	identify(field,:) = [neu spike.clu(neu,:) dir celltype];
	pl(field,:) = [min(spike.lpos(indx,1)) max(spike.lpos(indx,1))];
	if pl(field,1)<1
	  pl(field,1)=1;
	end
	trials = [];
	trials(:,2:3) = TrialsWithin(whl.lin,pl(field,:),trial.itv(trial.dir==dir,:));
	trials(:,1) = field;
	atrials = [atrials; trials];
      end  
    end
  %end  
  
  RemCell.ind = identify;
  RemCell.lfield = pl;
  RemCell.trials = atrials;
      
  save([FileBase '.RemCell'],'RemCell');
%else
%  load([FileBase '.RemCell'],'-MAT');
%end
%  
%return;

