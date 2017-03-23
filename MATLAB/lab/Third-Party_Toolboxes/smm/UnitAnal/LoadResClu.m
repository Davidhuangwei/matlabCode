% function [res clu] = LoadResClu(fileBase,varargin)
% [clusters epochs] = DefaultArgs(varargin,{[],[]});
% Loads res & clu files, optionally selecting clusters and epochs.

function [res clu] = LoadResClu(fileBase,varargin)
[clusters epochs] = DefaultArgs(varargin,{[],[]});
res = load([fileBase '.res']);
clu = load([fileBase '.clu']);
clu = clu(2:end);

if ~isempty(clusters)
    ind = ismember(clu,clusters);
    res = res(ind);
    clu = clu(ind);
end
if ~isempty(epochs)
    ind = zeros(size(res));
    for j=1:size(epochs,1)
        ind = ind | (res>=epochs(j,1) & res<=epochs(j,2));
    end
    res = res(ind);
    clu = clu(ind);
end

clu = cat(1,length(unique(clu)),clu);

return
% catch
%     junk = lasterror
%     keyboard
% end