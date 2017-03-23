function WheelCell=FindWheelFields(FileBase, spike, whl, wheel, varargin)
[PC,overwrite] = DefaultArgs(varargin,{[],0});
%%
%% returns structure with one entry per place field (PF). 
%%
%% WheelCell.ind = [cell cluster electrode dir celltype]; cell identification for each (PF)
%% WheelCell.lfield = [begin end]; beginning and and of PFs in linearized coordinates.
%% WheelCell.trials = [neuron begin end]; beginning and and of PFs in whl samples.
%%

fprintf('  find wheel fields....\n');

Par = LoadPar([FileBase '.par']);

RateFactor = Par.SampleRate/wheel.whlrate;

if ~FileExists([FileBase '.WheelCell']) | overwrite

  figure(859);clf
  
  %% loop through cells
  count = 0;                       %% count place fields
  if isempty(PC)                   %% neuron numbers
    neurons = unique(spike.ind);     
  else
    neurons = PC;
  end
  direct = unique(wheel.dir);      %% direction numbers
  spikedirw = zeros(size(spike.ind)); 
  for n=direct
    spikedirw(find(WithinRanges(spike.t/RateFactor,wheel.runs(find(wheel.dir==n),:))))=n;
  end
  
  field = 0;                       %% counts place fields
  atrials = [];

  
  %% spike count - Rate
  wheel.dist = wheel.dist/5;
  pos = round(wheel.dist);pos(pos==0)=1;
  gtrials = wheel.runs(find(wheel.dir>0),:);
  gtrialdir =  wheel.dir(find(wheel.dir>0));
  trialindwh = WithinRanges([1:length(wheel.dist)],gtrials,[1:length(gtrials)]','vector')';
  gpos = (pos>0 & trialindwh >0);
  T = round(spike.t/RateFactor);T(T==0)=1;
  %SpkCnt = Accumulate([T spike.ind],1,[length(wheel.dist) max(spike.ind)])*wheel.whlrate;
  %clear T
  
  P = round(pos(gpos)); P(P==0)=1;
  Occ = Accumulate([trialindwh(gpos) P],1);
  Occ(find(Occ==0))=1;
  clear P
  
    
  for n=1:length(neurons)
 
    %% spike count - Rate
    %[AvR StdR Bins] = MakeAvF([trialindwh(gpos) pos(gpos)],SpkCnt(gpos,neurons(n)),[max(trialindwh) max(pos)]);
    %clear SpkCnt
    ix = spike.ind == neurons(n) & WithinRanges(spike.t/RateFactor,wheel.runs) & spike.good;
    P = round(spike.wpos(ix)/5); P(P==0)=1;
    T = WithinRanges(spike.t(ix)/RateFactor,gtrials,[1:length(gtrials)]','vector')';
    AvR = Accumulate([T P],1,size(Occ))./Occ;
    smAvR = reshape(smooth(AvR',20,'lowess'),size(AvR,2),size(AvR,1))';
    clear AvR
    
    %% loop through directions
    for nn=1:length(direct)

      neu = neurons(n);
      dir = direct(nn);
      %if dir<2 
      %	continue;
      %      end
      
      %% indeces of spikes
      indx = find(ix & spikedirw==dir);
      
      [ccg, t] = CCG(spike.t(indx),1,20,50,20000);
      if mean(ccg)<2
	continue
      end
      
      if length(indx)>1000
	indx = indx([1:round(length(indx)/1000):length(indx)]);
      end
      
      clf
      %% plot spikes-phase 
      subplot(211)
      plot(spike.wpos(indx,1)/5,180/pi*spike.ph(indx,1),'.')
      hold on
      plot(spike.wpos(indx,1)/5,180/pi*spike.ph(indx,1)+360,'.')
      plot(spike.wpos(indx,1)/5,180/pi*spike.ph(indx,1)+720,'.')
      %Lines(trial.evtlin(find(trial.evtind(:,1)==nn)),[],'b','--',2*ones(size(trial.evtlin(find(trial.evtind(:,1)==nn)))));
      xlim([0 max(spike.wpos)]);
      title(['cell ' num2str(n) ' || direction ' num2str(dir) ' || ' num2str(spike.clu(neu,1)) '|' num2str(spike.clu(neu,2))]);
      hold off;
      axis tight
      xlim([0 size(smAvR,2)])
      ylim([0 1080])
      set(gca,'YTick',[0:360:1080])
      
      %% plot 2D scatter
      %subplot(234)
      %plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
      %	   'markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
      %      hold on;
      %      scatter(spike.pos(indx,1),spike.pos(indx,2),30,(spike.ph(indx))*180/pi);
      %      hold off;
      %% plot autocorrelogram
      subplot(235)
      bar(t,ccg);
      axis tight
      %% plot 2D rate
      subplot(236)
      %% spike count - Rate
      imagesc(smAvR(find(gtrialdir==dir),:));
  
      %% classify neurons: bad cell (0) / place cell (1) / interneuron (2)
      fprintf('classify neurons: place cell (left), interneuron (middle), bad cell (right)\n')
      %WaitForButtonpress;
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
	    trials(:,2:3) = TrialsWithin(wheel.dist,pl(field,:),wheel.runs(wheel.dir==dir,:));
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
	pl(field,:) = [min(spike.wpos(indx,1)) max(spike.wpos(indx,1))];
	if pl(field,1)<1
	  pl(field,1)=1;
	end
	trials = [];
	trials(:,2:3) = TrialsWithin(wheel.dist,pl(field,:),wheel.runs(wheel.dir==dir,:));
	trials(:,1) = field;
	atrials = [atrials; trials];
      end  
    end
  end  
  
  WheelCell.ind = identify;
  WheelCell.lfield = pl;
  WheelCell.trials = atrials;
      
  save([FileBase '.WheelCell'],'WheelCell');
else
  load([FileBase '.PlaceCell'],'-MAT');
end
  
return;


%subplot(222)
%%[Fspike Fx] = LinRate(whl,spike,n,nn);
%[FRate T FRate2 T2] = LinRate(whl,spike,n,nn);
%%bar(Fx,Fspike);
%plot(T,FRate,'r','LineWidth',2);%hold on;plot(T2,FRate2,'g','LineWidth',2);
%xlim([0 max(spike.wpos)]);
      
