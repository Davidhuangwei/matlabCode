% function n = CountSpectTrials(fileBaseCell,spectAnalDir,varargin)
% [varName fprintBool] = DefaultArgs(varargin,{'time',1});
% tag:spectral
% tag:count
% tag:trials
function n = CountSpectTrials(fileBaseCell,spectAnalDir,varargin)
[varName fprintBool] = DefaultArgs(varargin,{'time',1});

for j=1:length(fileBaseCell)
    n(j) = size(LoadVar([fileBaseCell{j} '/' SC(spectAnalDir) varName]),1);
    if fprintBool
    fprintf('%s %s n=%i\n',fileBaseCell{j},varName,n(j));
    end
end
return