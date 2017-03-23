function WhlCell=FindWhlCell2(FileBase, spike, whl, trial, Eeg, varargin)
[overwrite] = DefaultArgs(varargin,{0});
%%
%% returns structure with one entry per place field (PF). 
%%
%% WhlCell.ind = [cell cluster electrode dir celltype]; cell identification for each (PF)
%% WhlCell.lfield = [begin end]; beginning and and of PFs in linearized coordinates.
%% WhlCell.trials = [neuron begin end]; beginning and and of PFs in whl samples.
%%

fprintf('  find place fields....\n');
  
RateFactor = 20000/whl.rate;
EegRateFac = 1250/whl.rate;

if ~FileExists([FileBase '.WhlCell']) | overwrite

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
  neurons = unique(spike.ind(find(spike.good)));   %% neuron numbers

  %% spike count - Rate
  gtrials = trial.itv;
  gtrialdir =  trial.dir;
  trialindwh = WithinRanges([1:length(whl.itv(:,1))],gtrials,[1:length(gtrials)]','vector')';

  %% speed 
  newtrials = [];
  for tr=1:size(trials.itv,1)
    newtrials = [newtrials; []];
  end
  %
  %
  spikespeed = abs(whl.rotspeed(round(spike.t/RateFactor)));
  findspeed = prctile(abs(whl.rotspeed(find(WithinRanges([1:length(whl.turn)],gtrials)))),[50])
  
  %% Time: CCG - all
  [ccg,t] = CCG(spike.t(find(spike.good)),spike.ind(find(spike.good)),10,50,20000); 

  %% phase: CCG - all
  [ccgph,tph] = CCG(spike.uph(find(spike.good))*180/pi,spike.ind(find(spike.good)),20,100,1000); 
    
  %% spike dir
  for dire=unique(trial.dir)'
    spikeidxD(:,dire) = WithinRanges(round(spike.t/RateFactor),trial.itv(find(trial.dir==dire),:));
  end
  
  for n=7%1:length(neurons)
    n 
    spikeidx = spike.ind==neurons(n) & spike.good;
    
    figure(654);clf
    subplot(411)
    plot([1:length(whl.turn)]/whl.rate,whl.extra)
    subplot(412)
    plot([1:length(whl.turn)]/whl.rate,whl.turn)
    subplot(413)
    plot([1:length(whl.turn)]/whl.rate,whl.rotspeed)
    subplot(414)
    plot(spike.t(spikeidx & spikespeed<=findspeed)/20000,spike.ph(spikeidx & spikespeed<=findspeed),'.')
    hold on
    plot(spike.t(spikeidx & spikespeed>findspeed)/20000,spike.ph(spikeidx & spikespeed>findspeed),'.r')
    ForAllSubplots('axis tight');
    
    for tr=1:size(trial.itv,1)
      a = trial.itv(tr,1);
      b = trial.itv(tr,2);
      spiketr = WithinRanges(round(spike.t/RateFactor),trial.itv(tr,:));
      figure(654);clf
      subplot(311)
      plot(whl.itv([1:50:end],1),whl.itv([1:50:end],2),...
	   ... 'o','markersize',5,'markerfacecolor',[1 1 1]*0.7,'markeredgecolor',[1 1 1]*0.7) 
      hold on
      plot(whl.itv([a:b],1),whl.itv([a:b],2),'o','markersize',5,'markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0]) 
      %scatter(spike.pos(spikeidx & spiketr,1),spike.pos(spikeidx & spiketr,2),30,spike.ph(spikeidx & spiketr)); 
      plot(spike.pos(spikeidx & spiketr,1),spike.pos(spikeidx & spiketr,2),...
	   ... 'o','markersize',5,'markerfacecolor',[0 1 0],'markeredgecolor',[0 1 0]) 
      axis tight
      
      subplot(312)
      plot([a:b]/whl.rate,whl.extra(a:b))
      axis tight
      
      subplot(313)
      plot(spike.t(spikeidx & spiketr)/20000,spike.ph(spikeidx & spiketr)*180/pi,...
	   ... 'o','markersize',5,'markerfacecolor',[1 1 1]*0.7,'markeredgecolor',[1 1 1]*0.7)
      hold on
      plot(spike.t(spikeidx & spiketr)/20000,spike.ph(spikeidx & spiketr)*180/pi+360,...
	   ... 'o','markersize',5,'markerfacecolor',[1 1 1]*0.7,'markeredgecolor',[1 1 1]*0.7)
      axis tight
      xlim([a b]/whl.rate)
      
      waitforbuttonpress
      
    end
    
    
    %% Rate map
    figure(333);clf
    subplot(221)
    myPlaceField(spike.t(spikeidx), whl.itv);
    title('place map including all spikes','FontSize',16)
    xlabel('distance [cm]','FontSize',16)
    ylabel('distance [cm]','FontSize',16)
    set(gca,'TickDir','out','FontSize',16)
    box off
    
    subplot(223)
    bar(t,ccg(:,n,n));
    axis tight
    title('auto-correlogram','FontSize',16)
    xlabel('time [ms]','FontSize',16)
    ylabel('rate [Hz]','FontSize',16)
    set(gca,'TickDir','out','FontSize',16)
    box off
        
    subplot(222)
    bar(tph,ccgph(:,n,n));
    axis tight
    xlim([0 1440])
    Lines([360:360:1440]);
    title('phase auto-correlogram','FontSize',16)
    xlabel('phase [deg]','FontSize',16)
    ylabel('rate [deg^{-1}]','FontSize',16)
    set(gca,'TickDir','out','FontSize',16,'XTick',[0:360:1440])
    box off
    
    for dire=unique(trial.dir)'
      idx = find(spikeidx & spikeidxD(:,dire));
      idxS = find(spikeidx & spikeidxD(:,dire) & spikespeed<=findspeed);
      idxF = find(spikeidx & spikeidxD(:,dire) & spikespeed>findspeed);
            
      if length(idx)>2000
	plotidx = idx([1:round(length(idx)/2000):end]);
      else
	plotidx = idx;
      end

      figure(555);clf
      subplot(4,3,dire)
      plot(whl.itv([1:50:end],1),whl.itv([1:50:end],2),...
	   ... 'o','markersize',5,'markerfacecolor',[1 1 1]*0.7,'markeredgecolor',[1 1 1]*0.7) 
      hold on
      scatter(spike.pos(plotidx,1),spike.pos(plotidx,2),30,spike.ph(plotidx)); 
      axis tight
      title(['direction ' num2str(dire)]);
            
      %% Time: CCG - all
      subplot(4,3,dire+3)
      [Sccg,t] = CCG(spike.t(idx),1,10,50,20000); 
      bar(t,Sccg(:,1,1));
      axis tight
      
      %% phase: CCG - fast/slow
      subplot(4,3,dire+6)
      [Sccgph,tph] = CCG(spike.uph(idxS)*180/pi,1,20,100,1000); 
      bar(tph,Sccgph(:,1,1));
      axis tight
      xlim([0 1440])
      Lines([360:360:1440]);
      title('slow')
      subplot(4,3,dire+9)
      [Sccgph,tph] = CCG(spike.uph(idxF)*180/pi,1,20,100,1000); 
      bar(tph,Sccgph(:,1,1));
      axis tight
      xlim([0 1440])
      Lines([360:360:1440]);
      title('fast')
      
      
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
      
      
      Res = round(spike.t(find(spikeidx))/16);
      Clu = ones(size(Res));
      WinLength = 1250;
      for n=1:size(gtrials,1)
	[xy,f]=mtptcsd(x,Res,Clu,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange,CluSubset,round(gtrials(n,:)*EegRateFac));
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

	figure(444);clf
	subplot(311)
	plot(f,y(:,1,1))
	xlim([5 12])
	
	subplot(312)
	plot(f,y(:,2,2))
	xlim([5 12])
	
	%waitforbuttonpress
	
      end
      
      figure(333)%;clf
      %subplot(224)
      %plot(f,yallEeg)
      
      %subplot(312)
      %plot(f,yallCell)
      
      subplot(426)
      plot(f(myf),log(mean(yallCell(:,myf))),'color',[0 0 0],'linewidth',2)
      title('place map including all spikes','FontSize',16)
      set(gca,'TickDir','out','FontSize',16,'XTick',[])
      axis tight
      [mmax, b] = max(log(mean(yallCell(:,myf))));
      Lines(f(myf(b)),[],[0 0 0],'--',2)
      text(8.5,-5.6,[num2str(round(f(myf(b))*100)/100) ' Hz'],'FontSize',16)
      box off
      
      subplot(428)
      plot(f(myf),log(mean(yallEeg(:,myf))),'color',[0 0 0],'linewidth',2)
      xlabel('frequency [Hz]','FontSize',16)
      ylabel('power','FontSize',16)
      set(gca,'TickDir','out','FontSize',16,'YTick',[11 12])
      axis tight
      [mmax, b] = max(log(mean(yallEeg(:,myf))));
      Lines(f(myf(b)),[],[0 0 0],'--',2)
      text(8.5,12,[num2str(round(f(myf(b))*100)/100) ' Hz'],'FontSize',16)
      box off

      %waitforbuttonpress
      %keyboard
      
    end
    
  end
  WhlCell = [];

end


return
    
    
  %SpkCnt = Accumulate([round(spike.t/RateFactor) spike.ind],1,[length(whl.itv(:,1)) max(spike.ind)])*whl.rate;
  %gpos = (whl.itv(:,1)>0 & whl.itv(:,2)>0);
  
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
      
      %% indeces of spikes
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
%  end  
  
  PlaceCell.ind = identify;
  PlaceCell.lfield = pl;
  PlaceCell.trials = atrials;
      
  save([FileBase '.PlaceCell'],'PlaceCell');
%else
  load([FileBase '.PlaceCell'],'-MAT');
%end
  
return;


%subplot(222)
%%[Fspike Fx] = LinRate(whl,spike,n,nn);
%[FRate T FRate2 T2] = LinRate(whl,spike,n,nn);
%%bar(Fx,Fspike);
%plot(T,FRate,'r','LineWidth',2);%hold on;plot(T2,FRate2,'g','LineWidth',2);
%xlim([0 max(spike.lpos)]);
      
