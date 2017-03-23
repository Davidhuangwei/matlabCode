function [categVarPs categVarZs contVarPs] = TestHomoScedasticity(residuals,categData,contData,contNames)

residStruct = CellArray2Struct(cat(2,categData,mat2cell(residuals,repmat(1,size(residuals,1),1),1)));


categVarPs = TestHomoVar(residStruct);
categVarZs = TestHomoVarMult(residStruct);

if isempty(contData)
    contVarPs = NaN;
else
    %% if var(resid) is related to cont resid.^2 vs cont will have non-zero
    %% slope
    results = ols(residuals.^2, contData);

    %% two-tailed ttest
    contPs = tcdf(-abs(results.tstat),length(residuals)-1)*2;
    for j=1:length(contNames)
        contVarPs.(GenFieldName(contNames{j})) = contPs(j);
    end
end
return

