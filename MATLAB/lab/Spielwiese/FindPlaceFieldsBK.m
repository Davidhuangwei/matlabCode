function PlaceCell=FindPlaceFields(FileBase, spike, whl, trial, varargin)
[overwrite] = DefaultArgs(varargin,{0});
%%
%% returns structure with one entry per place field (PF). 
%%
%% PlaceCell.ind = [cell cluster electrode dir celltype]; cell identification for each (PF)
%% PlaceCell.lfield = [begin end]; beginning and and of PFs in linearized coordinates.
%% PlaceCell.trials = [neuron begin end]; beginning and and of PFs in whl samples.
%%

fprintf('  find place fields....\n');
  
RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.PlaceCell']) | overwrite

  figure
  
  %% loop through cells
  count = 0;                     %% count place fields
  neurons = unique(spike.ind);   %% neuron numbers
  direct = unique(spike.dir);    %% direction numbers
  field = 0;                     %% counts place fields
  atrials = [];

  %% spike count - Rate
  pos = round(whl.lin);
  gtrials = trial.itv(find(trial.dir>1),:);
  gtrialdir =  trial.dir(find(trial.dir>1));
  trialindwh = WithinRanges([1:length(whl.lin)],gtrials,[1:length(gtrials)]','vector')';
  gpos = (pos>0 & trialindwh >0);
  SpkCnt = Accumulate([round(spike.t/RateFactor) spike.ind],1,[length(whl.lin) max(spike.ind)])*whl.rate;
  
  for n=1:length(neurons)
 
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
  end  
  
  PlaceCell.ind = identify;
  PlaceCell.lfield = pl;
  PlaceCell.trials = atrials;
      
  save([FileBase '.PlaceCell'],'PlaceCell');
else
  load([FileBase '.PlaceCell'],'-MAT');
end
  
return;


%subplot(222)
%%[Fspike Fx] = LinRate(whl,spike,n,nn);
%[FRate T FRate2 T2] = LinRate(whl,spike,n,nn);
%%bar(Fx,Fspike);
%plot(T,FRate,'r','LineWidth',2);%hold on;plot(T2,FRate2,'g','LineWidth',2);
%xlim([0 max(spike.lpos)]);
      
