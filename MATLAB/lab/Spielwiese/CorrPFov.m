function CorrPFov(PlaceCell,FileName,spike,whl,trial);

RateFactor = 20000/whl.rate;
Ind = PlaceCell.ind;
neurons = unique(Ind(:,1));
Trials = PlaceCell.trials;

%% take all good spikes:
aindx = ismember(spike.ind,unique(Ind(:,1))) & spike.good & WithinRanges(round(spike.t/RateFactor),trial.itv);

gspiket = spike.t(aindx);
gspikeind = spike.ind(aindx);
[ccg, t] = CCG(gspiket,gspikeind,30,50,20000);

Name = ['PhasePrec_' FileName];
 
for n=1:length(neurons)
  %figure
  for nn=1:length(neurons)
    subplotfit(nn,length(neurons))
    bar(t,ccg(:,n,nn))
    xlim([-50 50]);
    title([num2str(n) ' || ' num2str(nn)]);
  end
  %waitforbuttonpress
  reportfig([],Name,[],['Neuron ' num2str(n)],150);
end


for n=1:length(neurons)
  clf
  for dire=[2 3]
    subplot(1,2,dire-1)
    indx = aindx & spike.ind==neurons(n) & spike.dir==dire;
    plot(spike.lpos(indx),spike.ph(indx),'.')
    hold on
    plot(spike.lpos(indx),spike.ph(indx)+2*pi,'.')
    plot(spike.lpos(indx),spike.ph(indx)+4*pi,'.')
    title([num2str(n) ': ' num2str(neurons(n)) ' | ' num2str(dire)]);
  end
  %waitforbuttonpress
  reportfig([],Name,[],['Neuron ' num2str(n)],150);
end
