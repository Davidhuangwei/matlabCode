function [med conf95 p] = GlmResultsCalcMedC95P(analData,varargin)
[bonfFactor] = DefaultArgs(varargin,{1});

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
                 med.(analNames{n})(j,k) = NaN;
                 conf95.(analNames{n}){j,k} = NaN;
             else
                 %%%%% calc pval %%%%%
                 if strcmp(analNames{n},'Constant')
                     p.(analNames{n})(j,k) = NaN;
                 else
%                      [h p.(analNames{n})(j,k)] = ttest(ttestData);
                     [p.(analNames{n})(j,k)] = signtest(ttestData);
%                      [p.(analNames{n})(j,k)] = BsTest(@median,0,nResamp,@median,1,ttestData);
                     p.(analNames{n})(j,k) = clip(p.(analNames{n})(j,k)*bonferroniN,-inf,1);
                 end
                 %%%%% calc means %%%%%
                 tempStats = BsErrBars(@median,95,1000,@median,1,ttestData);
                 med.(analNames{n})(j,k) = tempStats(1);
                 conf95.(analNames{n}){j,k} = tempStats([2,3]);
%                  if stdErrBool
%                      stDev.(analNames{n})(j,k) = stDev.(analNames{n})(j,k)./sqrt(length(ttestData));
%                  end
             end
         end
     end
end
return
