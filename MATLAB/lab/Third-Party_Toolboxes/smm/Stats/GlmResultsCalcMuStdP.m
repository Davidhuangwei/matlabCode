function [mu stDev p] = GlmResultsCalcMuStdP(analData,varargin)
[stdErrBool bonfFactor] = DefaultArgs(varargin,{0,1});

analNames = fieldnames(analData);
for n=1:length(analNames)
    % calc stats
    if size(analData.(analNames{n}),1) > size(analData.(analNames{n}),2)
        bonferroniN = bonfFactor*(length(analNames)-1)*(size(analData.(analNames{n}),1)*(size(analData.(analNames{n}),2)+1)/2);
    else
        bonferroniN = bonfFactor*(length(analNames)-1)*(size(analData.(analNames{n}),2)*(size(analData.(analNames{n}),1)+1)/2);
    end
     for j=1:size(analData.(analNames{n}),1)
         for k=1:size(analData.(analNames{n}),2)
             ttestData = analData.(analNames{n}){j,k};
             ttestData = ttestData(isfinite(ttestData));

             if isempty(ttestData)
                 p.(analNames{n})(j,k) = NaN;
                 mu.(analNames{n})(j,k) = NaN;
                 stDev.(analNames{n})(j,k) = NaN;
             else
                 %%%%% calc pval %%%%%
                 if strcmp(analNames{n},'Constant')
                     p.(analNames{n})(j,k) = NaN;
                 else
                     [h p.(analNames{n})(j,k)] = ttest(ttestData);
                     p.(analNames{n})(j,k) = clip(p.(analNames{n})(j,k)*bonferroniN,-inf,1);
                 end
                 %%%%% calc means %%%%%
                 mu.(analNames{n})(j,k) = mean(ttestData);
                 stDev.(analNames{n})(j,k) = std(ttestData);
                 if stdErrBool
                     stDev.(analNames{n})(j,k) = stDev.(analNames{n})(j,k)./sqrt(length(ttestData));
                 end
             end
         end
     end
end
return
