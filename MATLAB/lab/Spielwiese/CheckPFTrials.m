function PlaceCellIN = CheckPFTrials(FileBase,PlaceCellIN,whl,spike,varargin)
[checkstates] = DefaultArgs(varargin,{0});
%%
%%
%%
%%


%checkstates = input('do you want to check the trials [0/1]? ');

if checkstates
  
  Ind = PlaceCellIN.ind;
  
  NewTrials = [];
  for n=1:size(Ind,1)
    
    trials = PlaceCellIN.trials(find(PlaceCellIN.trials(:,1)==n),:);
    
    m=0;
    goodtrial = [];
    while m<size(trials,1);
      m=m+1;
      
      clf
      subplot(211)
      plot(whl.plot(1:100:end,1),whl.plot(1:100:end,2),'o','markersize',10,'markerfacecolor',[1 1 1]*0.9,'markeredgecolor',[1 1 1]*0.9)
      hold on
      plot(whl.ctr(trials(m,2):trials(m,3),1),whl.ctr(trials(m,2):trials(m,3),2),...
	   'o','markersize',5,'markerfacecolor',[1 0 0],'markeredgecolor',[1 0 0])
      axis tight
      title(['cell number: ' num2str(n) ' || trialnumber: ' num2str(m)]);
      subplot(212)
      plot(([trials(m,2):trials(m,3)]-trials(m,2))/whl.rate,whl.speed(trials(m,2):trials(m,3)),'.')
      ylim([0 100]);
            
      waitforbuttonpress
      whatbutton = get(gcf,'SelectionType');
      switch whatbutton
       case 'normal'   % left -- PC 
	goodtrial(m) = 1
       case 'alt'      % right -- bad
	goodtrial(m) = 0
       case 'extend'   % mid -- go back
	m=m-2;
	continue;
       case 'open'     % double click -- go back
	m=m-2;
	continue;
      end
            
      fprintf('hallo\n');
      
    end
    
    NewTrials = [NewTrials; trials(find(goodtrial),:)];
    
  end
  
  %keyboard
  
  PlaceCellIN.trials = NewTrials;
  save([FileBase '.PlaceCellIN'],'PlaceCellIN');
  
end

return;