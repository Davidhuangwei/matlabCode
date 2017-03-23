function outStruct = TestNormality(inStruct)
% function outStruct = TestNormality(inStruct)
% return pvalues of jbtest of normality
    outStruct = [];
if isstruct(inStruct)
    fields = fieldnames(inStruct);
    for i=1:length(fields)
        outStruct.(fields{i}) = TestNormality(inStruct.(fields{i}));
    end
else
    try
        [h outStruct] = jbtest(inStruct);
    catch
        outStruct = 0;
    end
end
return
