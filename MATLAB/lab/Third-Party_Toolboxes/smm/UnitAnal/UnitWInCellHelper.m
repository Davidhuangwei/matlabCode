function dataCell = UnitWInCellHelper(dataCell)
for j=1:5
        col{j} = unique(dataCell(:,j));
end

for j=1:length(col{1})
    for k=1:length(col{2})
        for m=1:length(col{3})
            for n=1:length(col{4})
                catData = [];
                for p=1:length(col{5})
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    tempData = dataCell(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        catData = cat(1,catData,shiftdim(tempData{1},-1));
%                         dataCell(dataIndexes,6) = {log10(tempData{1})};
                    end
                end
                if ~isempty(catData)
                    meanData = mean(catData,1);
                    for p=1:length(col{5})
                        dataIndexes = ...
                            strcmp(dataCell(:,1),col{1}{j}) & ...
                            strcmp(dataCell(:,2),col{2}{k}) & ...
                            strcmp(dataCell(:,3),col{3}{m}) & ...
                            strcmp(dataCell(:,4),col{4}{n}) & ...
                            strcmp(dataCell(:,5),col{5}{p});
%                         dataCell(dataIndexes,6) = {shiftdim(catData - ...
%                             repmat(meanData,[size(catData,1) ones(1,ndims(catData)-1)]),1)};
                        tempData = catData(p,:) - ...
                            meanData(1,:);
%                         if size(squeeze(reshape(tempData,size(meanData))),2) ==1
%                             keyboard
%                         end
                        dataCell(dataIndexes,6) = {shiftdim(reshape(tempData,size(meanData)),1)};
                    end
                end
            end
        end
    end
end
