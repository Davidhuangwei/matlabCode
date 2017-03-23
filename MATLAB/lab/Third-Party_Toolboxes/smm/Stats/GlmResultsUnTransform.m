function [outdata] = GlmResultsUnTransform(analData,depVarType)
analNames = fieldnames(analData);
for n=1:length(analNames)
    for j=1:size(analData.(analNames{n}),1)
        for k=1:size(analData.(analNames{n}),2)
            if strcmp(depVarType,'coh')
                outdata.(analNames{n})(j,k) = UnATanCoh(analData.(analNames{n})(j,k));
            elseif strcmp(depVarType,'phase')
                outdata.(analNames{n})(j,k) = 180/pi*analData.(analNames{n})(j,k);
            else
                outdata.(analNames{n})(j,k) = analData.(analNames{n})(j,k);
            end
        end
    end
end
return
        
