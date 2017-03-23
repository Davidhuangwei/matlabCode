function UnitBoxPlotHelper(dataCell,xVal,varargin)
[xMeanRange infoText colNamesCell figName screenHeight xyFactor] = ...
    DefaultArgs(varargin,{[min(xVal) max(xVal)],{'noInfo'},{},[],11,1.5});

for j=1:5
    if isempty(colNamesCell) | isempty(colNamesCell{j})
        col{j} = unique(dataCell(:,j));
    else
        [junk ia] = intersect(colNamesCell{j},unique(dataCell(:,j)));
        col{j} = colNamesCell{j}(sort(ia));
    end
end


for j=1:length(col{1})
    for k=1:length(col{2})
        figure
        if ~isempty(figName)
            set(gcf,'name',figName)
        end        
        SetFigPos([],[0.5,0.5,screenHeight/length(col{3})*length(col{4})...
            *xyFactor,screenHeight])
        for m=1:length(col{3})
            for n=1:length(col{4})
                subplot(length(col{3}),length(col{4}),(m-1)*length(col{4}) + n)
                hold on
                titleText = {};
                nText = [];
                catData = [];
                catGroup = {};
                for p=1:length(col{5})
                    if m==1 & n==1 & p==1
                        titleText = cat(1,[col{1}{j} ',' col{2}{k}],infoText);
                    end
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    tempData = dataCell(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        nText = cat(2,nText,[num2str(size(tempData{1},1),3) ',']);
                        xIndexes = xVal>=xMeanRange(1) & xVal<=xMeanRange(2);
                        temp1 = mean(tempData{1}(:,xIndexes),2);
                        catData = cat(1,catData,temp1);
                        catGroup = cat(1,catGroup,repmat(col{5}(p),size(temp1)));

%                         plot(xVal,temp1,'color',plotColors(p))
                    end
                end
                try 
                    boxplot(catData,catGroup);
               end
                title(SaveTheUnderscores(cat(1,titleText,nText)))
                if m==length(col{3})
                    xlabel(col{4}{n})
                end
                if n==1
                    ylabel(col{3}{m})
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