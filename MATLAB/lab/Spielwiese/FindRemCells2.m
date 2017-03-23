function RemCell=FindRemCells2(FileBase, spike, Eeg, varargin)
[overwrite] = DefaultArgs(varargin,{0});
%%
%% returns structure with one entry per place field (PF). 
%%
%% RemCell.ind = [cell cluster electrode dir celltype]; cell identification for each (PF)
%% RemCell.lfield = [begin end]; beginning and and of PFs in linearized coordinates.
%% RemCell.trials = [neuron begin end]; beginning and and of PFs in whl samples.
%%

fprintf('  find REM cells....\n');
%RateFactor = 20000/whl.rate;
%EegRateFac = 1250/whl.rate;

if ~FileExists([FileBase '.RemCell']) | overwrite
  
  %% for spectrum
  x=Eeg;
  nFFT = 2^13;
  Fs = 1250;
  nOverlap = [];
  NW = 1;  %% ~5 for gamma
  Detrend = 'linear';
  nTapers = [];
  FreqRange = [1 40];
  CluSubset = [];
  pval = []; 
  
  yallEeg=[];
  yallCell=[];
  yallxCE=[];
  

  %% loop through cells
  count = 0;                     %% count place fields
  neurons = unique(spike.ind);   %% neuron numbers
  atrials = [];

  sleep = load([FileBase '.sts.REM']);
  
  RemInt = load([FileBase '.sts.REM']);
  EegIndx = WithinRanges([1:length(Eeg)],RemInt);
  
  RemCell = [];
  for n=[57]%[2 29 31 33 39 40 43 54 55 57]%1:length(neurons)

    n
    
    neu = neurons(n);
    indx = find(spike.rem & spike.ind==neu);
    indxR = find(spike.run & spike.ind==neu);
    
    figure(111);clf
    
    subplot(311)
    plot(spike.t(indx)/20000,spike.ph(indx)*180/pi,'o','markersize',5,'markerfacecolor',[1 1 1]*0.7,'markeredgecolor',[1 1 1]*0.7)
    hold on
    plot(spike.t(indx)/20000,spike.ph(indx)*180/pi+360,'o','markersize',5,'markerfacecolor',[1 1 1]*0.7,'markeredgecolor',[1 1 1]*0.7)
    xlabel('time [s]','FontSize',16)
    ylabel('phase [deg]','FontSize',16)
    set(gca,'TickDir','out','FontSize',16,'YTick',[0:180:720])
    axis tight
    ylim([0 720])
    xlim([4104 4122]);
    box off

    subplot(323)
    [ccg, t] = CCG(spike.t(indx),1,20,50,20000);
    bar(t/1000,ccg(:,1,1))
    title('auto-correlogram','FontSize',16)
    xlabel('time [ms]','FontSize',16)
    ylabel('rate [Hz]','FontSize',16)
    set(gca,'TickDir','out','FontSize',16)
    axis tight
    box off
    
    subplot(324)
    hist(spike.ph(indx)*180/pi,60)
    axis tight
    
    subplot(325)
    [ccgPh, tPh] = CCG(spike.uph(indx)*180/pi,1,20,100,1000);
    bar(tPh,ccgPh(:,1,1))
    title('phase auto-correlogram','FontSize',16)
    xlabel('phase [deg]','FontSize',16)
    ylabel('rate [deg^{-1}]','FontSize',16)
    set(gca,'TickDir','out','FontSize',16,'XTick',[0:360:1440])
    axis tight
    xlim([0 1440])
    Lines([360:360:1440]);
    box off
        
    %%  Spectrum
    waitforbuttonpress
    whatbutton = get(gcf,'SelectionType');
    switch whatbutton
     case 'normal'   % left -- PC 
      celltype = 1
     case 'alt'      % right -- bad
      celltype = 0
      continue;
     case 'extend'   % mid -- interneuron
      celltype = 2
      continue;
     case 'open'     % double click -- go ba
      celltype = 0;
    end
    
    RemCell = [RemCell n]
    
    Res = round(spike.t(indx)/16);
    Clu = ones(size(Res));
    WinLength = 1250;
    resInt = WithinRanges(Res,RemInt,[1:size(RemInt,1)],'vector');
    goodRemInt = RemInt(unique(resInt(find(resInt))),:);
    for tt=1:size(goodRemInt,1)
      [xy,f]=mtptcsd(x,Res,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset,goodRemInt(tt,:));
      myf = find(f>5 & f<10);
      
      if length(size(xy))<3
	y(:,1,1) = xy;
	y(:,1,2) = zeros(size(xy));
	y(:,2,1) = zeros(size(xy));
	y(:,2,2) = zeros(size(xy));
      else
	y=xy;
      end
      yallEeg = [yallEeg; y(:,1,1)'];
      yallCell = [yallCell; y(:,2,2)'];
      yallxCE = [yallxCE; y(:,1,2)'];
      
    end

    subplot(324)
    plot(f(myf),log(mean(yallCell(:,myf))),'color',[0 0 0],'linewidth',2)
    title('power spectra','FontSize',16)
    set(gca,'TickDir','out','FontSize',16)
    ylabel('Unit power','FontSize',16)
    axis tight
    [mmax, b] = max(log(mean(yallCell(:,myf))));
    Lines(f(myf(b)),[],[0 0 0],'--',2)
    text(8.5,-5.8,[num2str(round(f(myf(b))*100)/100) ' Hz'],'FontSize',16)
    box off
    
    subplot(326)
    plot(f(myf),log(mean(yallEeg(:,myf))),'color',[0 0 0],'linewidth',2)
    xlabel('frequency [Hz]','FontSize',16)
    ylabel('LFP power','FontSize',16)
    set(gca,'TickDir','out','FontSize',16)
    axis tight
    [mmax, b] = max(log(mean(yallEeg(:,myf))));
    Lines(f(myf(b)),[],[0 0 0],'--',2)
    text(8.5,10,[num2str(round(f(myf(b))*100)/100) ' Hz'],'FontSize',16)
    box off
    
    waitforbuttonpress
      
  end
end

return

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

