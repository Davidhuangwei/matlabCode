function [log10data] = GlmResultsCalcLog10(analData)

prevWarn = SetWarnings({'off','MATLAB:log:logOfZero'});

analNames = fieldnames(analData);
for n=1:length(analNames)
    for j=1:size(analData.(analNames{n}),1)
        for k=1:size(analData.(analNames{n}),2)
            if iscell(analData.(analNames{n}))
                log10data.(analNames{n}){j,k} = log10(analData.(analNames{n}){j,k});
            else
                log10data.(analNames{n})(j,k) = log10(analData.(analNames{n})(j,k));
            end
        end
    end
end

SetWarnings(prevWarn);

return
        
