% function comparison = GlmResultsMultCompare01(dataCell,varNames,varargin)
% [func displayArg] = defaultArgs(varargin,{'anovan','on'});
function comparison = GlmResultsMultCompare01(dataCell,varNames,varargin)
[func displayArg] = defaultArgs(varargin,{'anovan','on'});

includeBool = tril(ones(size(dataCell)));

catMat = [];
nameCell = {};
for j=1:size(dataCell,1)
    for k=1:size(dataCell,2)
        if includeBool(j,k)
            catMat = cat(1,catMat,dataCell{j,k}(:));
            if size(dataCell,2) > 1
                nameCell = cat(1,nameCell,...
                    repmat({[varNames{j} '-' varNames{k}]},length(dataCell{j,k}),1));
            else
                nameCell = cat(1,nameCell,...
                    repmat({[varNames{j}]},length(dataCell{j,k}),1));
            end
        end
    end
end
switch func
    case 'kruskalwallis'
        [p t stats] = kruskalwallis(catMat,nameCell,displayArg);
    case 'anovan'  
        [p t stats] = anovan(catMat,{nameCell},'display',displayArg);
    otherwise
        ERROR
end
comparison = multcompare(stats,'display',displayArg);

return