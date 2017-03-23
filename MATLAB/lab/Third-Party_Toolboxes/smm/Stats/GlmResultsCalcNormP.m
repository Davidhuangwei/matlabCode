function [p] = GlmResultsCalcNormP(analData)

analNames = fieldnames(analData);
for n=1:length(analNames)
    % calc stats
     for j=1:size(analData.(analNames{n}),1)
         for k=1:size(analData.(analNames{n}),2)
             ttestData = analData.(analNames{n}){j,k};
             ttestData = ttestData(isfinite(ttestData));
             if isempty(ttestData) | length(ttestData)<4
                 p.(analNames{n})(j,k) = NaN;
             else
                 try
                     [h p.(analNames{n})(j,k)] = jbtest(ttestData);
                 catch
                        junk = lasterror
                        junk.stack(1)
                     keyboard
                 end
                 p.(analNames{n})(j,k) = p.(analNames{n})(j,k);
             end
         end
     end
end

return