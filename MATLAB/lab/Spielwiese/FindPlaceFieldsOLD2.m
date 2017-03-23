function PlaceCell=FindPlaceFieldsNEW(FileBase, spike, whl, trial, varargin)
[overwrite] = DefaultArgs(varargin,{0});

fprintf('  find place fields....\n');
  
if ~FileExists([FileBase '.PlaceCell']) | overwrite

  figure
  %% loop through cells
  neurons = unique(spike.ind);
  tt = 0;
  neuron = 0;
  while tt < length(neurons)
    tt = tt+1;
    n = neurons(tt);
    
    %% loop through directions
    for nn=[2 3]
      
      pl = [];
      indx = find(spike.ind==n & spike.dir==nn & spike.good);
      
      [ccg, t] = CCG(spike.t(indx),1,20,50,20000);
      
      if length(indx>0)>2000
	indx = indx([1:round(length(indx)/2000):length(indx)]);
      end
      
      clf
      subplot(211)
      plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1),'.')
      hold on
      plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+360,'.')
      plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+720,'.')
      %Lines(trial.evtlin(find(trial.evtind(:,1)==nn)),[],'b','--',2*ones(size(trial.evtlin(find(trial.evtind(:,1)==nn)))));
      Lines(trial.evtlin(find(trial.evtind(:,1)==2)),[],'b','--',2*ones(size(trial.evtlin(find(trial.evtind(:,1)==2)))));
      xlim([0 max(spike.lpos)]);
      hold off;
      
      
      title(['cell ' num2str(n) ' || direction ' num2str(nn)]);
      
      subplot(223)
      plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o', ...
	   'markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
      hold on;
      scatter(spike.pos(indx,1),spike.pos(indx,2),30,(spike.ph(indx))*180/pi);
      %title(['neuron ' num2str(neu) '/' num2str(numclus) ' ' num2str(tdir)]);
      hold off;
      
      subplot(224)
      bar(t,ccg);
      xlim([min(t) max(t)]);
      
      fprintf('classify neurons: place cell (left), interneuron (middle), bad cell (right)\n')
      
      %% bad cell (0) / place cell (1) / interneuron (2)
      waitforbuttonpress;
      whatbutton = get(gcf,'SelectionType');
      switch whatbutton
       case 'normal'  % left -- PC 
	celltype = 1
	
       case 'alt'      % right -- bad
	celltype = 0
	
       case 'extend'     % mid -- go back 
	celltype = 2
	
       case 'open'     % double click -- go back 
	tt=tt-1;
      end
      
      %% select place fields
      if celltype == 1 
	
	%figure(100)
	%clf
	%plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1),'.')
	%hold on
	%plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+360,'.')
	%plot(spike.lpos(indx,1),180/pi*spike.ph(indx,1)+720,'.')
	
	field = 1;
	while 1
	  [dumx dumy button]=PointInput(1);
	  switch button(1)
	   case 1 % left button
	    [x y] = ginput(2)
	    pl(field,:)= sort(x');
	    h(field,:)=Lines(x,[],{'g','r'}',{'-','-'},[2 2]);spike.clu(tt,:)
	    field = field+1
	   case 2 % middle button
	    break;
	   case 3 %right button
	    field = field-1;
	    delete(h(field,:));
	  end
	end
      end  
      
      %%% redo the description files:
      %% PlaceCell - one for each direction
      %% PlaceCell(n).ind = [cell# elec kluster direc celltype]
      %%             .lfield = [beginning end] of place field in x 
      %%             .trials = [beginning end] of trial segs of PF
      neuron = neuron+1;
      PlaceCell(neuron).lfield = pl;
      
      PlaceCell(neuron).indall = [n spike.clu(n,:) nn celltype];
      if celltype==1
	PlaceCell(neuron).ind = [n spike.clu(n,:) nn celltype];
      else
	PlaceCell(neuron).ind = [];
      end
    end
  end  
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
      
