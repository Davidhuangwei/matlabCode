function outStruct = PopulateStruct(partialStruct,fullStruct)
outStruct = [];
if isstruct(partialStruct)
    fields = fieldnames(partialStruct);
    for i=1:length(fields)
        outStruct.(fields{i}) = PopulateStruct(partialStruct.(fields{i}),fullStruct.(fields{i}));
    end
else
    if isstruct(fullStruct)
        fields = fieldnames(fullStruct);
        for i=1:length(fields)
            outStruct.(fields{i}) = PopulateStruct(partialStruct,fullStruct.(fields{i}));
        end
    else
        outStruct = partialStruct;
    end
end
return