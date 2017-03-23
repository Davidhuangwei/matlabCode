function s = clusize(c,ii)

% function s = clusize(c,ii)
% gives size of cellarray along raw ii

t = cellfun('length',c);
s = [];
for jj=1:size(t,1)
    s(jj) = max(find(t(jj,:)~=0));
end
if nargin==2
    s=s(ii);
end

