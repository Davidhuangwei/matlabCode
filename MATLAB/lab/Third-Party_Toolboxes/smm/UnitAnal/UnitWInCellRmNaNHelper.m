function dataCell = UnitWInCellRmNaNHelper(dataCell)
for j=1:5
        col{j} = unique(dataCell(:,j));
end

for j=1:length(col{1})
    for k=1:length(col{2})
        for m=1:length(col{3})
            for n=1:length(col{4})
                catData = [];
                nans = [];
                for p=1:length(col{5})
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    tempData = dataCell(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        if isempty(nans)
                            nans = isnan(tempData{1});
                        else
                            nans = nans | isnan(tempData{1});
                        end
                    end
                end
                if ~isempty(catData)
%                     meanData = mean(catData,2);
                    for p=1:length(col{5})
                        dataIndexes = ...
                            strcmp(dataCell(:,1),col{1}{j}) & ...
                            strcmp(dataCell(:,2),col{2}{k}) & ...
                            strcmp(dataCell(:,3),col{3}{m}) & ...
                            strcmp(dataCell(:,4),col{4}{n}) & ...
                            strcmp(dataCell(:,5),col{5}{p});
                        tempData = dataCell(dataIndexes,6);
                        dataCell(dataIndexes,6) = {tempData{1}(~nans)};
                    end
                end
            end
        end
    end
end
