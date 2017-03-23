function whl = LinPos(whl,trial,varargin)
%%
%%
%%
[overwrite] = DefaultArgs(varargin,{0});


fprintf('  linearized rat position....\n');

if ~isfield(whl,'lin') | overwrite

  whl.dir = zeros(length(whl.ctr),1);
  whl.lin = -10.0*ones(size(whl.ctr,1),1);
  
  for t=1:size(trial,2)

    DIR = zeros(length(whl.ctr),1);
    for n=unique(trial(t).dir)'
      whlindx = find(WithinRanges([1:length(whl.ctr)],trial(t).itv(find(trial(t).dir==n),:)));
      whl.dir(whlindx) = n;
      DIR(whlindx) = n; 
    end
    
    if ~trial(t).OneMeanTrial
      for n=unique(trial(t).dir)'
	if isempty(trial(t).mean(n).mean)
	  continue
	end
	whl.lin(find(DIR==n),1) = GetSpikeLinPos(whl.ctr(find(DIR==n),:),trial(t).mean(n).mean,trial(t).mean(n).sclin);
      end
    else
      n=2;
      whl.lin(find(DIR>1),1) = GetSpikeLinPos(whl.ctr(find(DIR>1),:),trial(t).mean(n).mean,trial(t).mean(n).lin);
    end
      
  end

  %% smoothing of lin pos
  smlinpos = whl.lin;
  whl.speedlin = zeros(size(whl.lin));
  for t = 1:size(trial,2)
    for tr=1:length(trial(t).itv)
      inx = find(WithinRanges(find(whl.ctr(:,1)),trial(t).itv(tr,:)));
      smlinpos(inx,1)=smooth(whl.lin(inx,1),10,'lowess');
      whl.speedlin(inx,1) = [0; diff(smlinpos(inx,1))*whl.rate];
      clear inx;
    end
  end
  
end

return;
