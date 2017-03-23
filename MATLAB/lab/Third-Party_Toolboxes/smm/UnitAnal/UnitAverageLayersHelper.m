function dataCell2 = UnitAverageLayersHelper(dataCell,averageStruct,averageColumn)
%keyboard
cols = 1:5;
cols(cols==averageColumn) = [];
for j=1:5
        col{j} = unique(dataCell(:,j));
end

dataCell2 = {};
averageNames = fieldnames(averageStruct);
for p=1:length(averageNames)
    averageInd = zeros(size(dataCell,1),1);
    for r=1:length(averageStruct.(averageNames{p}))
        averageInd = averageInd | strcmp(averageStruct.(averageNames{p}){r},dataCell(:,averageColumn));
    end
    for j=1:length(col{cols(1)})
        for k=1:length(col{cols(2)})
            for m=1:length(col{cols(3)})
                for n=1:length(col{cols(4)})
                    dataIndexes = ...
                        strcmp(dataCell(:,cols(1)),col{cols(1)}{j}) & ...
                        strcmp(dataCell(:,cols(2)),col{cols(2)}{k}) & ...
                        strcmp(dataCell(:,cols(3)),col{cols(3)}{m}) & ...
                        strcmp(dataCell(:,cols(4)),col{cols(4)}{n}) & ...
                        averageInd;
                    tempData = dataCell(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)>=1
                        catDim = ndims(tempData{1}) + 1;
                        tempData = cat(catDim,tempData{:});
                        tempRow = {};
                        tempRow{1,cols(1)} = col{cols(1)}{j};
                        tempRow{1,cols(2)} = col{cols(2)}{k};
                        tempRow{1,cols(3)} = col{cols(3)}{m};
                        tempRow{1,cols(4)} = col{cols(4)}{n};
                        tempRow{1,averageColumn} = averageNames{p};
                        tempRow{1,6} = mean(tempData,catDim);
                        dataCell2 = cat(1,dataCell2,tempRow);
                    end
                end
            end
        end
    end
end

