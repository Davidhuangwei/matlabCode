function UnitSpectrumPlotHelper(dataCell,xVal,rateCell1,varargin)
[rateCell2 cellRateMin infoText xLimits colNamesCell screenHeight xyFactor] = ...
    DefaultArgs(varargin,{0,{'noInfo'},[],{},11,1.5});

for j=1:5
    if isempty(colNamesCell) | isempty(colNamesCell{j})
        col{j} = unique(dataCell(:,j));
    else
        [junk ia] = intersect(colNamesCell{j},unique(dataCell(:,j)));
        col{j} = colNamesCell{j}(sort(ia));
    end
end

plotColors = 'rgbk';

for j=1:length(col{1})
    for k=1:length(col{2})
        figure
        SetFigPos([],[0.5,0.5,screenHeight/length(col{3})*length(col{4})...
            *xyFactor,screenHeight])
        for m=1:length(col{3})
            for n=1:length(col{4})
                subplot(length(col{3}),length(col{4}),(m-1)*length(col{4}) + n)
                hold on
                titleText = {};
                nText = [];
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
                    rateIndexes1 = ...
                        (strcmp(rateCell1(:,1),col{1}{j}) | strcmp(rateCell1(:,1),'')) & ...
                        (strcmp(rateCell1(:,2),col{2}{k}) | strcmp(rateCell1(:,2),'')) & ...
                        (strcmp(rateCell1(:,3),col{3}{m}) | strcmp(rateCell1(:,3),'')) & ...
                        (strcmp(rateCell1(:,4),col{4}{n}) | strcmp(rateCell1(:,4),'')) & ...
                        strcmp(rateCell1(:,5),col{5}{p});
                    if ~isempty(rateCell2)
                    rateIndexes2 = ...
                        (strcmp(rateCell2(:,1),col{1}{j}) | strcmp(rateCell2(:,1),'')) & ...
                        (strcmp(rateCell2(:,2),col{2}{k}) | strcmp(rateCell2(:,2),'')) & ...
                        (strcmp(rateCell2(:,3),col{3}{m}) | strcmp(rateCell2(:,3),'')) & ...
                        (strcmp(rateCell2(:,4),col{4}{n}) | strcmp(rateCell2(:,4),'')) & ...
                        strcmp(rateCell2(:,5),col{5}{p});
                    rateIndexes = rateIndexes1 & rateIndexes2;
                    else
                    rateIndexes = rateIndexes1;
                    end
                    tempRate = rateCell1(rateIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        keptCells = find(tempRate{1} >= cellRateMin);
                        nText = cat(2,nText,[num2str(length(keptCells),3) ',']);
                        temp1 = mean(tempData{1}(keptCells,:),1);
                        plot(xVal,temp1,'color',plotColors(p))
                    end
                    xLimits = get(gca,'xlim');
                    if p==length(col{5})
                        title(SaveTheUnderscores(cat(1,titleText,nText)))
                    end
                    if n==1 & p==m
                        yLimits = get(gca,'ylim');
                        if isempty(xLimits)
                        end
                        text(xLimits(2)+0.05*xLimits(2),yLimits(1),col{5}{p},'color',plotColors(p))
                    end
                    if m==length(col{3})
                        xlabel(col{4}{n})
                    end
                    if n==1
                        ylabel(col{3}{m})
                    end
                    set(gca,'xlim',xLimits)
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