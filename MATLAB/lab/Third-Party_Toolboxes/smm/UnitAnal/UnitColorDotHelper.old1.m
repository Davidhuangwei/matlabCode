function varargout = UnitColorDotHelper(dataCell,pValData,varargin)
[colorLimits commonCScale cSymetry cMap infoText figName colNamesCell reportFigBool saveDir figHeight xyFactor] = ...
    DefaultArgs(varargin,{[],1,0,LoadVar('ColorMapSean'),{'noInfo'},[],{},0,'./',2,1.5});

for j=1:5
    if isempty(colNamesCell) | isempty(colNamesCell{j})
        col{j} = unique(dataCell(:,j));
    else
        [junk ia] = intersect(colNamesCell{j},unique(dataCell(:,j)));
        col{j} = colNamesCell{j}(sort(ia));
    end
end

% plotMats = cell(length(col{1})*length(col{2})*length(col{5}),1);
figHandles = [];
for j=1:length(col{1})
    for k=1:length(col{2})
        figHandles = cat(1,figHandles,figure);
        colormap(cMap);
%         if cFlip
%             colormap(flipud(tempCMap));
%         end
        if ~isempty(figName)
            set(gcf,'name',figName)
        end
        SetFigPos([],[0.5,0.5,figHeight*xyFactor*length(col{5}),figHeight])
        for p=1:length(col{5})

            plotMat = NaN*zeros(length(col{3}),length(col{4}));
            subplot(1,length(col{5}),p)
            for m=1:length(col{3})
                for n=1:length(col{4})
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
                    tempP = pValData(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        plotMat(m,n) = tempData{1};
                        pValMat(m,n) = tempP{1};
                    end
                end
                %                 title(SaveTheUnderscores(cat(1,titleText,nText)))
                %                 if m==length(col{3})
                %                     xlabel(SaveTheUnderscores(col{4}{n}))
                %                 end
                %                 if n==1
                %                     ylabel(SaveTheUnderscores(col{3}{m}))
                %                 end[0 -1.5 -2 -3]
            end
            ImageScPvalDots(plotMat,log10(pValMat),colorLimits,[0 -1.3 -2 -3])
%             ImageScPvalDots(plotMat,log10(pValMat),colorLimits,[0 -1 -2 -3 -4 -5])
            set(gca,'xtick',[1:length(col{4})],'xticklabel',col{4})
            set(gca,'ytick',[1:length(col{3})],'yticklabel',col{3})
%             if isempty(colorLimits)
%                 calcCLim(p,:) = get(gca,'clim');
%             end
            title(STU(col{5}{p}))
            if p==1
                ylabel(STU(titleText))
            end
        end
%         for p=1:length(col{5})
%             if isempty(colorLimits)
%                 if commonCScale
%                     colorLimits = [min(calcCLim(:,1),[],1) max(calcCLim(:,2),[],1)];
%                     if cSymetry
%                         colorLimits = [-max(abs(colorLimits)) max(abs(colorLimits))];
%                     end
%                 end
%             end
%             subplot(1,length(col{5}),p)
%             if ~iscell(colorLimits)
%                 set(gca,'clim',colorLimits)
%             else
%                 set(gca,'clim',colorLimits{p})
%             end
%             colorbar
%         end
    end
end
if reportFigBool
    ReportFigSM(figHandles,saveDir);
end
varargout = {figHandles};
varargout=varargout(1:nargout);
return


% 
% figHandles = [];
% if reportFigBool
%     ReportFigSM(figHandles,saveDir);
% end
% varargout = {figHandles};
% varargout=varargout(1:nargout);
% return

% plan:



% orderCell - keep order but only use intersection
%
% 
% 
% col4 = subplot x
% col3 = subplot y
% col2 x col1 = figures