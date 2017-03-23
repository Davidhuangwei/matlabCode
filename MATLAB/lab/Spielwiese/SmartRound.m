function y = SmartRound(x,varargin)
%% function y = SmartRound(x,varargin)
%%[bound] = DefaultArgs(varargin,{round([])});
%%
%% round array and allows a lower and upper bound 
[bound] = DefaultArgs(varargin,{round([])});

xx = round(x);

if isempty(bound)
  bound(1) = min(xx(:));
  bound(2) = max(xx(:));
end

id1 = find(xx<bound(1));
id2 = find(xx>bound(2));

xx(ind2sub(size(xx),id1))=bound(1);
xx(ind2sub(size(xx),id2))=bound(2);

y=xx;
return;
