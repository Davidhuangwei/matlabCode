function newDataMatStruct = DeleteOutliers(dataMatStruct,outlierStruct)
% removes outliers designated by CalcOutliers
newDataMatStruct = [];
if ~isstruct(dataMatStruct)
    dataMatStruct(outlierStruct(:),:,:,:,:,:,:,:,:) = [];
    newDataMatStruct = dataMatStruct;
else
    fields = fieldnames(dataMatStruct);
    for i=1:length(fields)
        if isstruct(outlierStruct)
            newDataMatStruct.(fields{i}) = DeleteOutliers(dataMatStruct.(fields{i}),outlierStruct.(fields{i}));
        else
            newDataMatStruct.(fields{i}) = DeleteOutliers(dataMatStruct.(fields{i}),outlierStruct);
        end
    end
end
return