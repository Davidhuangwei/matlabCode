function nranges = NoOverlapRanges(ranges)

% function nranges = NoOverlapRanges(ranges)
% output: non-overlapping ranges
% input:  ranges as two column vector [starts stops] of ranges

%% Sort Ranges
ranges = sort(ranges,2);
ranges = sortrows(ranges,1);
%% put into vectro:
Vranges = reshape(ranges',1,size(ranges,1)*2)';
%% find 'bad' intervals
BadInvs = diff(Vranges)<=0;

if isempty(find(BadInvs))
  nranges=ranges;
else
  
  AA = [];
  for n=1:size(ranges,1)
    AA = [AA [ranges(n,1):ranges(n,2)]];
  end
  AA = sort(AA);
  
  nranges(:,1) = [AA(1); AA(find(diff(AA)>1)+1)'];
  nranges(:,2) = [AA(find(diff(AA)>1))' ; AA(end)];
  
end

return;

