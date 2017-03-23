function varargout = UnitBarPlotHelper(dataCell,varargin)
[xLimits infoText figName colNamesCell reportFigBool saveDir alpha bonfFactor subplotHeight xyFactor,errorBarsCell] = ...
    DefaultArgs(varargin,{[],{'noInfo'},[],{},0,'./',0.05,1,2,1.0,0});

for j=1:5
    if isempty(colNamesCell) | isempty(colNamesCell{j})
        col{j} = unique(dataCell(:,j));
    else
        [junk ia] = intersect(colNamesCell{j},unique(dataCell(:,j)));
        col{j} = colNamesCell{j}(sort(ia));
    end
end

figHandles = [];
for j=1:length(col{1})
    for k=1:length(col{2})
        figHandles = cat(1,figHandles,figure);
        if ~isempty(figName)
            set(gcf,'name',figName)
        end      
        SetFigPos([],[0.5,0.5,subplotHeight*length(col{4})...
            *xyFactor,subplotHeight*length(col{3})])
        for m=1:length(col{3})
            for n=1:length(col{4})
                subplot(length(col{3}),length(col{4}),(m-1)*length(col{4}) + n)
                hold on
                titleText = {};
                nText = ['n='];
                catData = [];
                catGroup = {};
                pVal = NaN*ones(length(col{5}),1);
                for p=1:length(col{5})
                    if m==1 & n==1 & p==1
                        titleText = cat(1,[col{1}{j} ',' col{2}{k}],infoText,['p<' num2str(alpha,2)]);
                    end
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    tempData = dataCell(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        nText = cat(2,nText,[num2str(sum(~isnan(tempData{1}),1),3) ',']);
                        temp1 = tempData{1};
%                         keyboard
%                         medianErr = BsErrBars(@median,90,10000,@median,1,temp1,1);
%                         meanTemp1 = medianErr(1);
%                         barh(-p,meanTemp1)
%                         stdError = medianErr([2,3]);

                        meanTemp1 = median(temp1);
                        barh(-p,meanTemp1)
%                         stdError = [prctile(temp1,25) prctile(temp1,75)];
                        if iscell(errorBarsCell)
                            tempErr = errorBarsCell(dataIndexes,6);
                            stdError = tempErr{1};
                            stdError = stdError - repmat(stdError(1),[size(stdError,1) 1]);
                        else
                            stdError = BsErrBars(@median,95,1000,@median,1,temp1) - meanTemp1;
                        end
                        stdError(1) = [];
                        errBarColor = [0.5 0.5 0.5];
                        if meanTemp1 < 0
                            plot([stdError(1) stdError(2)] + meanTemp1,[-p -p],'color',errBarColor)
                        else
                            plot([stdError(1) stdError(2)] + meanTemp1,[-p -p],'color',errBarColor)
                        end
                        pVal(p) = signrank(temp1)*length(col{5})*length(col{4})*length(col{3})*bonfFactor;
 
%                         catData = cat(1,catData,temp1);
%                         catGroup = cat(1,catGroup,repmat(col{5}(p),size(temp1)));
                    end
                end
                if ~isempty(tempData) & length(tempData)==1
                    if isempty(xLimits)
                        xLimits = get(gca,'xlim');
                        xLimits = [-max(abs(xLimits)) max(abs(xLimits))];
                        set(gca,'xlim',xLimits)
                    else
                        set(gca,'xlim',xLimits)
                    end
                    for p=1:length(col{5})
                        if pVal(p)<alpha
                            plot(xLimits(2),-p,'r*')
                        end
                        text(xLimits(2),-p,num2str(pVal(p),3),'color','r')
                    end
                end
                set(gca,'ylim',[-length(col{5})-1 0])
                set(gca,'ytick',[-length(col{5}):-1])
                set(gca,'yticklabel',flipud([col{5}]))

%                 try 
%                     barh(catData,catGroup);
%                end
                title(SaveTheUnderscores(cat(1,titleText,nText)))
                if m==length(col{3})
                    xlabel(SaveTheUnderscores(col{4}{n}))
                end
                if n==1
                    ylabel(SaveTheUnderscores(col{3}{m}))
                end
            end
        end
    end
end
if reportFigBool
    ReportFigSM(figHandles,saveDir);
end
varargout = {figHandles};
varargout=varargout(1:nargout);
return

% plan:



% orderCell - keep order but only use intersection
%
% 
% 
% col4 = subplot x
% col3 = subplot y
% col2 x col1 = figures