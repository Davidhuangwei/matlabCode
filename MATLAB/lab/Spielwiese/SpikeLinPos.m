function spike = SpikeLinPos(spike,trial,varargin)
[whlrate,states,samplerate] = DefaultArgs(varargin,{39.0625,[],20000});
%%
%%
%%

spike = setfield(spike,'lpos',zeros(length(spike.t),1));

if isempty(states)
  ind = zeros(length(trial),1); 
else
  ind = states.ind;
end

for segs=1:length(trial)
  
  for n=2:size(trial(segs).mean,2)
    
    if trial(segs).OneMeanTrial
      indx = find(WithinRanges(spike.t/samplerate*whlrate,trial(segs).itv) & spike.dir > 1);
    else
      indx = find(WithinRanges(spike.t/samplerate*whlrate,trial(segs).itv) & spike.dir == n);
    end
    
    %newpos = spike.pos(indx,:);
    
    %keyboard
    
    spike.lpos(indx,1) = GetSpikeLinPos(spike.pos(indx,:),trial(segs).mean(n).mean,trial(segs).mean(n).sclin);
    
  end
end

  
return;

