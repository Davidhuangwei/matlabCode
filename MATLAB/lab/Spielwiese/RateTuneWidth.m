function [Width ATrials] = RateTuneWidth(FileBase,PlaceCell,whl,trial,Tune,varargin)
[overwrite] = DefaultArgs(varargin,{0});

if ~FileExists([FileBase '.ratetunewidth']) | overwrite
  
  zellen = unique(PlaceCell.ind(:,1)); 
  ATrials = [];
  for n=1:size(PlaceCell.ind,1)
    
    Rate = Tune.mrate(:,find(zellen==PlaceCell.ind(n,1)),PlaceCell.ind(n,4)-1);  
    
    if PlaceCell.ind(n,5)==1
      
      %keyboard
      
      grate = [round(PlaceCell.lfield(n,1)):round(PlaceCell.lfield(n,2))];
      [Max MaxInd] = max(Rate(grate));
      
      High = find((Rate < 0.1*Max & [1:length(Rate)]' > grate(MaxInd)));
      Low = find((Rate < 0.1*Max & [1:length(Rate)]' < grate(MaxInd)));
      
      if ~isempty(High)
	WidthMax = min([min(High) PlaceCell.lfield(n,2)]);
      else
	WidthMax = PlaceCell.lfield(n,2);
      end
      
      if ~isempty(Low)
	WidthMin =  max([max(Low) PlaceCell.lfield(n,1)]);
      else
	WidthMin =  PlaceCell.lfield(n,1);
      end
      
      Width(n,:) = [WidthMin WidthMax];
      trials(:,2:3) = TrialsWithin(whl.lin,Width(n,:),trial.itv(trial.dir==PlaceCell.ind(n,4),:));
      trials(:,1) = n;
    
    elseif PlaceCell.ind(n,5)==2
      Width(n,:) = PlaceCell.lfield(n,:);
      trials = PlaceCell.trials(find(PlaceCell.trials(:,1)==n),:);
    end
    
    ATrials = [ATrials; trials];
    
    n
    PlaceCell.lfield(n,:)
    figure(1);clf
    plot(Rate)
    Lines(Width(n,:));
    Lines(PlaceCell.lfield(n,:),[],'r');
    
    
    pause(1)
    %waitforbuttonpress
    
    clear trials;
  end
  
  save([FileBase '.ratetunewidth'],'Width','ATrials')
  
  
else
  load([FileBase '.ratetunewidth'],'-MAT')
end

return;