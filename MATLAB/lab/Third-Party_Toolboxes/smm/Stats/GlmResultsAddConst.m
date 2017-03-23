function [outdata] = GlmResultsAddConst(analData,contant)
analNames = fieldnames(analData);
for n=1:length(analNames)
    for j=1:size(analData.(analNames{n}),1)
        for k=1:size(analData.(analNames{n}),2)
            if size(contant) == size(analData.(analNames{n}))
                outdata.(analNames{n})(j,k) = analData.(analNames{n})(j,k) + contant(j,k);
            else
                outdata.(analNames{n})(j,k) = analData.(analNames{n})(j,k) + contant;
            end
        end
    end
end
return
        
