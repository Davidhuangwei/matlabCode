function whl = GetWhlLin(whl,trial)

fprintf('  linearized rat position....\n');

%% creates: whl.lin
%%          whl.dir

%% direction index for whl
whl.dir = zeros(length(whl.ctr),1);
for n=unique(trial.dir)'
  whlindx = find(WithinRanges([1:length(whl.ctr)],trial.itv(find(trial.dir==n),:)));
  whl.dir(whlindx) = n;
end

%% linearizing of whl
whl.lin = -10.0*ones(size(whl.ctr,1),1);
if ~trial.OneMeanTrial
  for n=unique(trial.dir)'
    if isempty(trial.mean(n).mean)
      continue
    end
    whl.lin(find(whl.dir==n),1) = GetSpikeLinPos(whl.ctr(find(whl.dir==n),:),trial.mean(n).mean,trial.mean(n).sclin);
  end
else
  n=2;
  whl.lin(find(whl.dir>1),1) = GetSpikeLinPos(whl.ctr(find(whl.dir>1),:),trial.mean(n).mean,trial.mean(n).lin);
end

%% smoothing of lin pos 
smlinpos = whl.lin;
whl.speedlin = zeros(size(whl.lin));
for tr=1:length(trial.itv)
  inx = find(WithinRanges(find(whl.ctr(:,1)),trial.itv(tr,:)));
  smlinpos(inx,1)=smooth(whl.lin(inx,1),10,'lowess');
  whl.speedlin(inx,1) = [0; diff(smlinpos(inx,1))*whl.rate];
  clear inx;
end

return;
