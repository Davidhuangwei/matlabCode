function [maxx maxt Idx] = MaxPeak(t,x,varargin)
%% function [maxx maxt Idx] = MaxPeak(t,x,varargin)
%% [intv,npln] = DefaultArgs(varargin,{[],1});
%%
%% computes the value of t at the maximum of x
%% 
%% IN: 
%%      t : x-axis variable
%%      x : y-axis variable (can be matrix, t is 1st dim)
%%   intv : find maximum with interval itv of t
%%  nspln : compute maximum by averaging over nspln lagresrt points
[intv,npln] = DefaultArgs(varargin,{[],1});

if isempty(intv)
  intv = [min(t) max(t)];
end

gt = find(t>intv(1) & t<intv(2));
[sx si] = sort(x(gt,:),1,'descend');

Idx = gt(si(1:npln,:));

if npln==1
  maxt = t(Idx);
else
  maxt = mean(t(Idx));
end
  
i1 = reshape(Idx,prod(size(Idx)),1);
i2 = reshape(repmat([1:size(Idx,2)],size(Idx,1),1),prod(size(Idx)),1);
maxx = mean(reshape(x(sub2ind(size(x),i1,i2)),size(Idx,1),size(Idx,2)));

return;