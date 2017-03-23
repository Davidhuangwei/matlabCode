function [outdata] = GlmResultsSubtractConst(analData,constantMat)
analNames = fieldnames(analData);
for n=1:length(analNames)
    for j=1:size(analData.(analNames{n}),1)
        for k=1:size(analData.(analNames{n}),2)
            if iscell(constantMat)
                tempConst = constantMat{j,k};
            else
                tempConst = constantMat(j,k);
            end
            if iscell(analData.(analNames{n}))
                outdata.(analNames{n}){j,k} = analData.(analNames{n}){j,k} - tempConst;
            else
                outdata.(analNames{n})(j,k) = analData.(analNames{n})(j,k) - tempConst;
            end
        end
    end
end
return
        
