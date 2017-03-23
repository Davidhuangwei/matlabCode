function Precess=FitPhasePrecTrial(FileBase,PlaceCell,whl,trial,spike,varargin)
[overwrite,Manual,Plotting] = DefaultArgs(varargin,{0,1,1});

fprintf('  linear fit of phase precession...\n');

RateFactor = 20000/whl.rate;

if ~FileExists([FileBase '.slopetr']) | overwrite
  
  Slope = [];
  Phase = [];
  for neu=1:length(PlaceCell.ind)
    if PlaceCell.ind(neu,5) ~= 1
      continue
    end
    
    fprintf([num2str(neu) '... ']);
    
    neuron = PlaceCell.ind(neu,1);
    dire = PlaceCell.ind(neu,4);
    trials = PlaceCell.trials(find(PlaceCell.trials(:,1)==neu),2:3);
    for tr = 1:length(trials)
      indx = find(spike.ind==neuron & spike.good & WithinRanges(round(spike.t/RateFactor),trials(tr,:)));
      
      if length(find(indx))<2 | unique(diff(spike.pos(indx)))==0
	continue;
      end
      
      %% unwrap the phase
      %% to come ...
      
      %% get slope from robust fit
      [slope b] = FitPhasePrec(spike.lpos,spike.ph,[],[],[],5);
      if trial.OneMeanTrial & dire == 3
      	slope(1) = -slope(1);
      end
      
      %%
      phase(:,3:4) = [spike.lpos(indx) spike.ph(indx)];
      phase(:,1) = neu;
      phase(:,2) = tr;
      Phase = [Phase; phase]; 
      phase = [];
      %%
      
      Slope = [Slope; neu tr slope b];
  
      %phdiff = max(keepit.b(2)*spikepos+keepit.b(1))-min(keepit.b(2)*spikepos+keepit.b(1));
    end
  end
  
  Precess.slope = Slope;
  Precess.phase = Phase;
  
  save([FileBase '.slopetr'],'Precess')
else
  load([FileBase '.slopetr'],'-MAT');
end

if Plotting
  %% prepare Phase for plotting
  neurons = unique(Precess.phase(:,1));
  Phase = Precess.phase;
  %% same matrix for all place fields:
  basics = Phase;
  basics(:,4) = 0;
  Bins = round([max(basics(:,2)) max(basics(:,3))]);
  for n=1:length(neurons)
    indx = Phase(:,1)==neurons(n);
    subplotfit(n,length(neurons))
    trials=[]; trials = unique(Phase(indx,2));
    phases=[]; basics(:,4) = 0;
    basics(find(indx),4) = Phase(find(indx),4);
    [phases phstd phbins] = MakeAvF(basics(:,2:3),180/pi*basics(:,4),Bins);
    smphase = phases;
    gtrials = find(max(phases'));
    intph=[];
    for tr=1:length(gtrials)
      goodph=[];tin=[];xintph=[];xfintph=[];
      goodph = phases(gtrials(tr),find(phases(gtrials(tr),:)>0));
      tin = find(phases(gtrials(tr),:)>0);
      [t,xintph,xfintph]=Interpol(tin',goodph',0);
      
      %intph(1:length(phases(gtrials(tr),:)),gtrials(tr))=-1;
      %intph(t,gtrials(tr))=xintph;      
      
      intph(1:length(phases(gtrials(tr),:)),gtrials(tr))=-1;
      intph(t,gtrials(tr))=smooth(xintph',10,'lowess');
    end
    imagesc(intph')
    title(num2str(PlaceCell.ind(n,1)));
    colorbar
  end
end

return;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
mat = Accumulate([round(Phase(indx,3)),Phase(indx,2)], Phase(indx,4),[max(round(Phase(indx,3))) max(Phase(indx,2))]); 
imagesc((mat)'); axis xy

indx = find(Phase(:,1)==1);
Ave = MakeAvF([round(Phase(indx,3)),Phase(indx,2)], 180/pi*Phase(indx,4),[max(round(Phase(indx,3))) max(Phase(indx,2))]);
imagesc((Ave)'); axis xy;
colorbar

Speed = Rate.whl(find(Rate.ind(:,1)==1));
Ind = Rate.ind(find(Rate.ind(:,1)==1),:);

[Ssort sind] = sort(Speed);
Allphase = [];
for n=1:length(sind)
  indx2=find(Phase(:,1)==1 & Phase(:,1)==sind(n));
  sortphase = [Phase(indx2,3) Phase(indx2,4)];
  Allphase = [Allphase;sortphase];
end

Ave2 = MakeAvF([round(Allphase(:,1)),[1:length(Allphase)]'], 180/pi*Allphase(:,2),[max(round(Allphase(:,1))) length(Allphase)]);
imagesc((Ave2)'); axis xy;
colorbar


%% Get the phase precession right!
for n=unique(Phase(:,1))'
  indx=find(Phase(:,1)==n);
  PlaceCell.ind(n,:)
  plot(Phase(indx,3),Phase(indx,4),'.',Phase(indx,3),Phase(indx,4)+2*pi,'.',Phase(indx,3),Phase(indx,4)+4*pi,'.')
  waitforbuttonpress
end
 
indx=find(Phase(:,1)==2);
for n=unique(Phase(indx,2))'
  n
  indx2=find(Phase(:,1)==1 & Phase(:,2)==n);
  %plot(Phase(indx2,3),Phase(indx2,4),'.','MarkerSize',20)
  plot(Phase(indx2,3),Phase(indx2,4),'.')
  waitforbuttonpress
end
