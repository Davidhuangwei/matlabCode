function [h outbins] = HistOv(x,bin,overlap,varargin)
range = DefaultArgs(varargin,{[min(x) max(x)]});

Bins(:,1) = [range(1):bin-overlap:range(2)]';
Bins(:,2) = Bins(:,1) + bin;

for n=1:size(Bins,1)
  h(n) = length(find(x>=Bins(n,1) & x<Bins(n,2)));  
end

outbins = mean(Bins,2);
h=h';

return;