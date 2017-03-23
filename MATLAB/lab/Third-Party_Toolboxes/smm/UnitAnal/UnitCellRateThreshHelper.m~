function dataCell = UnitCellRateThreshHelper(dataCell,cellRateMin,rateCell1,varargin)
[simBehN] = ...
    DefaultArgs(varargin,{0});

for j=1:5
        col{j} = unique(dataCell(:,j));
end

for j=1:length(col{1})
    for k=1:length(col{2})
        for m=1:length(col{3})
            for n=1:length(col{4})
                for p=1:length(col{5})
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    tempData = dataCell(dataIndexes,6);
                    rateIndexes = ...
                        (strcmp(rateCell1(:,1),col{1}{j}) | strcmp(rateCell1(:,1),'')) & ...
                        (strcmp(rateCell1(:,2),col{2}{k}) | strcmp(rateCell1(:,2),'')) & ...
                        (strcmp(rateCell1(:,3),col{3}{m}) | strcmp(rateCell1(:,3),'')) & ...
                        (strcmp(rateCell1(:,4),col{4}{n}) | strcmp(rateCell1(:,4),'')) & ...
                        strcmp(rateCell1(:,5),col{5}{p});
                    tempRate = rateCell1(rateIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        if simBehN
                            if p==1
                                simInd = logical(tempRate{1}>= cellRateMin);
                            else
                                simInd = simInd & (tempRate{1}>= cellRateMin);
                            end
                        else
                            simInd = logical(tempRate{1}>= cellRateMin);
                            if ~any(simInd)
                                dataCell(dataIndexes,:) = [];
                            else
                                dataCell(dataIndexes,6) = {tempData{1}(simInd,:)};
                            end
                        end
                    end
                end
                if simBehN
                    for p=1:length(col{5})
                        dataIndexes = ...
                            strcmp(dataCell(:,1),col{1}{j}) & ...
                            strcmp(dataCell(:,2),col{2}{k}) & ...
                            strcmp(dataCell(:,3),col{3}{m}) & ...
                            strcmp(dataCell(:,4),col{4}{n}) & ...
                            strcmp(dataCell(:,5),col{5}{p});
                        tempData = dataCell(dataIndexes,6);
                        if ~isempty(tempData) & length(tempData)==1
                            if ~any(simInd)
                                dataCell(dataIndexes,:) = [];
                            else
                                dataCell(dataIndexes,6) = {tempData{1}(simInd,:)};
                            end
                        end
                    end
                end
            end
        end
    end
end

% plan:



% orderCell - keep order but only use intersection
%
% 
% 
% col4 = subplot x
% col3 = subplot y
% col2 x col1 = figures