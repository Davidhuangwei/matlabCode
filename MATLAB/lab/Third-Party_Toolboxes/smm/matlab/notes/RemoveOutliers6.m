function [newDataMatStruct outlierStruct] = RemoveOutliers6(dataMatStruct,depthVar,nStdDev)

cellConvertBool = 0;
if ~iscell(dataMatStruct)
    dataMatStruct = {dataMatStruct};
    cellConvertBool = 1;
end
[outlierStruct tempCounter] = CalcOutliers(dataMatStruct,depthVar,nStdDev);
for i=1:length(dataMatStruct)
    newDataMatStruct{i} = DeleteOutliers(dataMatStruct{i},outlierStruct);
end
if cellConvertBool
    newDataMatStruct = cell2mat(newDataMatStruct);
end
return

function [outlierStruct counter] = CalcOutliers(dataMatStruct,depthVar,nStdDev)
% Decends into a cell array of structs (identical tree) for which the conclusion of
% each branch is a vector. Calculates outliers of each of these vectors.
% depthVar determines how far up the tree the outliers are "shared"
% nStdDev determines # of stds is considered an outlier
if ~isstruct(dataMatStruct{1})
    outlierStruct = zeros(size(dataMatStruct{1}));
    for i=1:length(dataMatStruct)
        upperLim = mean(dataMatStruct{i}) + nStdDev*std(dataMatStruct{i});
        lowerLim = mean(dataMatStruct{i}) - nStdDev*std(dataMatStruct{i});
        outlierStruct = outlierStruct | (dataMatStruct{i} > upperLim) | (dataMatStruct{i} < lowerLim);
    end
    counter = 1;
    return
else
    fields = fieldnames(dataMatStruct{1});
    for i=1:length(fields)
        for j=1:length(dataMatStruct)
            inDataMatStruct{j} = dataMatStruct{j}.(fields{i});
        end
        [tempOutliers counter] = CalcOutliers(inDataMatStruct,depthVar,nStdDev);
        if counter > depthVar
            outlierStruct.(fields{i}) = tempOutliers;
        else
            if ~exist('outlierStruct','var')
                outlierStruct = tempOutliers;
            else
                outlierStruct = outlierStruct | tempOutliers;
            end
        end
    end
    counter = counter + 1;
    return
end

function newDataMatStruct = DeleteOutliers(dataMatStruct,outlierStruct)
% removes outliers designated by CalcOutliers
newDataMatStruct = [];
if ~isstruct(dataMatStruct)
    dataMatStruct(outlierStruct) = NaN;
    newDataMatStruct = dataMatStruct;
    return
else
    fields = fieldnames(dataMatStruct);
    for i=1:length(fields)
        if isstruct(outlierStruct)
            newDataMatStruct.(fields{i}) = DeleteOutliers(dataMatStruct.(fields{i}),outlierStruct.(fields{i}));
        else
            newDataMatStruct.(fields{i}) = DeleteOutliers(dataMatStruct.(fields{i}),outlierStruct);
        end
    end
    return
end
