function [varargout] = UnitKWHelper(dataCell,varargin)
bonfFactor = DefaultArgs(varargin,{1});
for j=1:5
        col{j} = unique(dataCell(:,j));
end
pValCell = dataCell;
anovaTabCell = dataCell;
statsCell = dataCell;

length(col{1})*length(col{2})*length(col{3})*length(col{4})*bonfFactor
for j=1:length(col{1})
    for k=1:length(col{2})
        for m=1:length(col{3})
            for n=1:length(col{4})
                catData = [];
                catGroup = {};
                for p=1:length(col{5})
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    tempData = dataCell(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                         catData = cat(1,catData,tempData{1});
                        catGroup = cat(1,catGroup,repmat(col{5}(p),size(tempData{1})));
                    end
                end
                if all(isnan(catData))
                    pVal = NaN;
                else
                    [pVal anovaTab stats] = kruskalwallis(catData,catGroup,'off');
                    pVal = pVal*bonfFactor...
                        *length(col{1})*length(col{2})*length(col{3})*length(col{4});
                end
                for p=1:length(col{5})
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    tempData = dataCell(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        pValCell(dataIndexes,6) = {pVal};
                        anovaTabCell(dataIndexes,6) = {anovaTab};
                        statsCell(dataIndexes,6) = {stats};
                    end
                end
            end
        end
    end
end
varargout = {pValCell anovaTabCell statsCell};
varargout = varargout(1:nargout);