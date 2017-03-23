function varargout = UnitBarPlotHelper(dataCell,varargin)
[xLimits infoText figName colNamesCell reportFigBool saveDir alpha bonfFactor subplotHeight xyFactor] = ...
    DefaultArgs(varargin,{[],{'noInfo'},[],{},0,'./',0.05,1,2,1.0});

for j=1:5
    if isempty(colNamesCell) | isempty(colNamesCell{j})
        col{j} = unique(dataCell(:,j));
    else
        [junk ia] = intersect(colNamesCell{j},unique(dataCell(:,j)));
        col{j} = colNamesCell{j}(sort(ia));
    end
end

% colorOrder = get(gca,'colororder')
colorOrder = [...
    0 0 0;...
    1 0 0;...
    0 0.75 0.75;, ...
    ];
    
figHandles = [];
for j=1:length(col{1})
    for k=1:length(col{2})
        figHandles = cat(1,figHandles,figure);
        if ~isempty(figName)
            set(gcf,'name',figName)
        end      
%         SetFigPos([],[0.5,0.5,subplotHeight*length(col{4})...
%             *xyFactor,subplotHeight])
        SetFigPos([],[0.5,0.5,subplotHeight*length(col{4})...
            *xyFactor,subplotHeight*length(col{3})])
        for m=1:length(col{3})
            for n=1:length(col{4})
                 subplot(length(col{3}),length(col{4}),(m-1)*length(col{4}) + n)
%                 subplot(1,length(col{4}),n)
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
                        try
                        catData = cat(2,catData,tempData{1});
                        catch
                            keyboard
                        end
%                         keyboard
%                         medianErr = BsErrBars(@median,90,10000,@median,1,temp1,1);
%                         meanTemp1 = medianErr(1);
%                         barh(-p,meanTemp1)
%                         stdError = medianErr([2,3]);
% keyboard
%                         meanTemp1 = median(temp1);
%                         barh(-p,meanTemp1)
%                         stdError = [prctile(temp1,25) prctile(temp1,75)];
%                         errBarColor = [0.5 0.5 0.5];
%                         if meanTemp1 < 0
%                             plot([stdError(1) stdError(2)],[-p -p],'color',errBarColor)
%                         else
%                             plot([stdError(1) stdError(2)],[-p -p],'color',errBarColor)
%                         end
%                         pVal(p) = signrank(temp1)*length(col{5})*length(col{4})*length(col{3})*bonfFactor;
 
%                         catData = cat(1,catData,temp1);
%                         catGroup = cat(1,catGroup,repmat(col{5}(p),size(temp1)));
                    end
                end
%                 stdError = prctile(catData,[25 75],1)
%                 keyboard
                stdError = [];
                for p=1:size(catData,2)
                    stdError(:,p) = BsErrBars(@median,95,1000,@median,1,catData(:,p),1);
                end
                stdError(1,:) = [];
                hold on
                errBarLen = 0.08;
                offset = 0*(length(col{3})/2 - m);
                markerStyleOrder = {'s','v','o','x','d'};
%                 plotColor = colorOrder(mod(m,length(colorOrder))+1,:);

%                 plot(median(catData,1),[1:size(catData,2)]+offset,'color',plotColor,'linewidth',1)
%                 plot(median(catData,1),[1:size(catData,2)]+offset,'s','color',plotColor,'linewidth',2)
%                 plot(stdError,cat(1,[1:size(catData,2)],[1:size(catData,2)])+offset,'color',plotColor)
                
                plot(median(catData,1),[1:size(catData,2)]+offset,'color',[0.5 0.5 0.5],'linewidth',1)
                plot(stdError,cat(1,[1:size(catData,2)],[1:size(catData,2)])+offset,'color',[0.5 0.5 0.5])
                for p=1:size(catData,2)
                    plotColor = colorOrder(mod(p-1,length(colorOrder))+1,:);
                    markerStyle = markerStyleOrder{mod(p-1,length(markerStyleOrder))+1};
                    plot(median(catData(:,p)),p+offset,markerStyle,'color',plotColor,'linewidth',2)
                end
%                 plot(cat(1,stdError(1,:),stdError(1,:)),cat(1,[1:size(catData,2)]-errBarLen,[1:size(catData,2)]+errBarLen)+offset,...
%                     'color',plotColor)
%                 plot(cat(1,stdError(2,:),stdError(2,:)),cat(1,[1:size(catData,2)]-errBarLen,[1:size(catData,2)]+errBarLen)+offset,...
%                     'color',plotColor)
               
%                 keyboard
                if isempty(xLimits)
                    xLimits = get(gca,'xlim');
                    xLimits = [-max(abs(xLimits)) max(abs(xLimits))];
                    set(gca,'xlim',xLimits)
                else
                    set(gca,'xlim',xLimits)
                end
%                 for p=1:length(col{5})
%                     if pVal(p)<alpha
%                         plot(xLimits(2),-p,'r*')
%                 end
%                         text(xLimits(2),-p,num2str(pVal(p),3),'color','r')
%                 end
                set(gca,'ylim',[0 length(col{5})+1])
                set(gca,'ytick',[1:length(col{5})])
                set(gca,'yticklabel',[col{5}])
                
%                 textX = xLimits(1)+(xLimits(2)-xLimits(1)*0.6);
%                 textY = length(col{5}) + 1 - 0.4*m;
%                 text(textX,textY,[col{3}{m}],'color',plotColor)

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