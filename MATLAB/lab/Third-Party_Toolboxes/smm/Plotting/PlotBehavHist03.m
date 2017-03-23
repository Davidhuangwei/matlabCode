function PlotBehavHist02(animalDirs,depVar,fileExt,spectAnalDir,analRoutine,varargin)
[nBins,xLimits,catMethod,smoothBool,saveDir,chanLocVersion,glmVersion,reportFigBool] ...
    = DefaultArgs(varargin,{10,[],'trial',0,'RemPaper','Sel','GlmWholeModel08',0});
chanDir = 'ChanInfo/';

cwd = pwd;
cd(animalDirs{1}{1});

if ~isempty([strfind(depVar,'Phase') strfind(depVar,'phase')])
    depVarType = 'phase';
    selChanBool = 1;
elseif ~isempty([strfind(depVar,'Coh') strfind(depVar,'coh')])
    depVarType = 'coh';
    selChanBool = 1;
elseif ~isempty([strfind(depVar,'Pow') strfind(depVar,'pow')]);
    depVarType = 'pow';
    selChanNames = {''};
    selChanBool = 0;
else
    depVarType = 'undef';
    selChanNames = {''};
    selChanBool = 0;
end
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
eegChanMat = LoadVar(['ChanInfo/ChanMat' '.eeg' '.mat']);
badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
offset = load(['ChanInfo/Offset' fileExt '.txt']);


selChansCell = Struct2CellArray(LoadVar([chanDir 'SelChan' fileExt '.mat']));

dirName = [spectAnalDir fileExt];
% dirName = [spectAnalDir midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];
% if ~isstruct(analRoutine)
%     load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
%     fileName = ParseStructName(depVar);
%     % fo = LoadField([fileBaseCell{1} '/' dirName '/' fileName{1} '.fo']);
% 
%     % depCell = Struct2CellArray(LoadDesigVar(fileBaseCell(1:4,:),dirName,depVar,trialDesig),[],1);
%     files = MatStruct2StructMat(dir('sm96*'),'name');
%     if ~exist('fileBaseCell','var')
%         fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
%     end
%     fileBaseCell = intersect(fileBaseCell,files.name);
% end
% fileBaseCell = fileBaseCell(1:3);
% depCell = LoadAnalResults(animalDirs,spectAnalDir,fileExt,depVar,glmVersion,...
%     analRoutine,selChanBool,chanLocVersion,catMethod);

depCell = LoadSpectAnalResults(animalDirs,spectAnalDir,fileExt,depVar,glmVersion,...
    analRoutine,selChanBool,catMethod,chanLocVersion);

if selChanBool
    depCell = Struct2CellArray(CatMirrorDiag(depCell,1),[],1);
else
    depCell = Struct2CellArray(depCell,[],1);
end
        
figure
clf
if isempty(xLimits)
    temp = cat(1,depCell{:,end});
    xLimits = [min(cat(1,temp{:})) max(cat(1,temp{:}))];
end
bins = HistBins(nBins,xLimits);
if size(depCell{1,end},1) == 1
xyRatio = 2;
else
xyRatio = 1;
end
SetFigPos([],[0.5 0.5 10/size(depCell{1,end},2)*size(depCell{1,end},1)*xyRatio 10]);
fileName = GenFieldName([depVar '_hist_' catMethod '_' chanLocVersion fileExt]);
set(gcf,'name',fileName)
plotColors = 'kcrbg';
for j=1:size(depCell{1,end},1)
    for k=1:size(depCell{1,end},2)
        catX = [];
        titleVec = [];
        for m=1:size(depCell,1)
            subplot(size(depCell{m,end},2),size(depCell{m,end},1),(k-1)*size(depCell{m,end},1)+j);
            hold on
            [n,x] = hist(depCell{m,end}{j,k},bins);
            catX = [catX; x];
            if smoothBool
                temp = n/size(depCell{m,end}{j,k},1);
                indexes = LocalMinima(-temp);
                plot(x(indexes),temp(indexes)/median(diff(x(indexes))),'color',plotColors(m));
%                 ind90 = find(cumsum(temp)>=.9,1);
%                 PlotVertLines(x(ind90),[0 1],'r');
%                 ind95 = find(cumsum(temp)>=.95,1);
%                 PlotVertLines(x(ind95),[0 1],'g');
            else
            plot(x,n/size(depCell{m,end}{j,k},1)/median(diff(x)),'color',plotColors(m))
            end
            if k==size(depCell{m,end},2) & selChanBool
                xlabel(selChansCell{j,1})
            end
            if j==1
                ylabel(selChansCell{k,1})
                if k==1
                    ylimits = get(gca,'ylim');
                    xlimits = get(gca,'xlim');
                    text(xlimits(1),...
                        ylimits(2)-(ylimits(2)-ylimits(1))/(size(depCell,1)+1)*m,...
                        [depCell{m,1}],...
                        'color',plotColors(m));
%                     text(xlimits(1),...
%                         ylimits(1)+(ylimits(2)-ylimits(1))/(size(depCell,1)+1)*m,...
%                         [depCell{m,1} ',n=' num2str(size(depCell{m,end}{j,k},1))],...
%                         'color',plotColors(m));
                end 
            end
            titleVec = cat(2,titleVec, ['n=' num2str(size(depCell{m,end}{j,k},1)) ',']);
        end
        title(titleVec)
        set(gca,'xlim',[min(catX(:)) max(catX(:))])
    end
end
if reportFigBool
    ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' ...
        SC(saveDir) SC(dirname) SC(chanLocVersion) SC(analRoutine) ...
        SC([spectAnalDir fileExt])]));
end
cd(cwd);
return

try
for j=1:size(selChansCell,1)
    for k=1:size(selChansCell,1)
        for m=1:size(depCell,1)
            if m==1
                catDep{j,k} = depCell{m,end}{j,k};
            else
                catDep{j,k} = cat(1,catDep{j,k},depCell{m,end}{j,k});
            end
        end
        if ~isempty(catDep{j,k})
            sizeDep(j,k) = size(catDep{j,k},1);
            meanDep(j,k) = mean(catDep{j,k},1);
        else
            sizeDep(j,k) = 0;
            meanDep(j,k) = NaN;
        end
    end
end
catch
    keyboard
end
figure(1)
clf
plot(angle(meanDep(:,2))*180/pi,-1*[1:size(selChansCell,1)])
 set(gca,'yticklabel',flipud(selChansCell(:,1)))
 set(gca,'xlim',[-180 180])
 title(['Mean ' depVar ' '  selChansCell{2,1} ' Ref'])
 set(gcf,'windowstyle','normal')
set(gcf,'name',depVar)


figure(2)
clf
keepInd = ~tril(ones(size(meanDep)));
meanDep = angle(meanDep);
meanDep(keepInd) = NaN;
% ImageScRmNaN(meanDep*180/pi,[-180 180],[0 0 1])
% colormap([autumn; flipud(autumn)])
% colormap(LoadVar('CircularColorMap.mat'))
colormap(flipud(hsv))
imagesc(meanDep*180/pi)
set(gca,'clim',[-180 180])
colorbar
set(gca,'yticklabel',selChansCell(:,1))
 set(gca,'xticklabel',[selChansCell(:,1) repmat({' *'},[size(selChansCell,1),1])])
set(gcf,'name',depVar)
 title(['Mean  ' depVar])
 for j=1:size(selChansCell,1)
    for k=1:size(selChansCell,1)
        if j<=k
        text(j,k,{'n=',num2str(sizeDep(j,k))},'HorizontalAlignment','center');
        end
    end
 end
 

figure(3)
clf
set(gcf,'name',depVar)
for j=1:size(selChansCell,1)
    for k=1:size(selChansCell,1)
        if j<=k
        subplot(size(selChansCell,1),size(selChansCell,1),(k-1)*size(selChansCell,1)+j)
        plotColors = 'krgb';
%         clf
        for m=1:size(depCell,1)
            if ~isempty(depCell{m,end}{j,k})
             [n x] = hist(angle(depCell{m,end}{j,k}),size(depCell{m,end}{j,k},1)...
                 /floor(size(depCell{m,end}{j,k},1)^(1/2.3)));
%                  /ceil(log2(size(depCell{m,end}{j,k},1))));
%              polar(x,n,plotColors(m))
             polar([x x+2*pi],[n/2 n/2],plotColors(m))
% [x n] = rose(angle(depCell{m,end}{j,k}),36);
% polar(x,n,plotColors(m))
            hold on
            end
        end
%         if j==k & j<=size(depCell,1)
%             title([depCell{j,1:end-1}],'color',plotColors(j))
%         end
        if k==size(selChansCell,1)
            xlabel([selChansCell{j,1} ' *'])
        end
        if j==1
            ylabel(selChansCell{k,1})
        end
        end
    end
end

figure(4)
clf
for j=1:size(selChansCell,1)
    for k=1:size(selChansCell,1)
        if j<=k
        subplot(size(selChansCell,1),size(selChansCell,1),(k-1)*size(selChansCell,1)+j)
        plotColors = 'krgb';
%         clf
        n=[];
        for m=1:size(depCell,1)
            if ~isempty(depCell{m,end}{j,k})
             [n x] = hist(angle(depCell{m,end}{j,k}),size(depCell{m,end}{j,k},1)...
                 /floor(size(depCell{m,end}{j,k},1)^(1/2.3)));
%                  /ceil(log2(size(depCell{m,end}{j,k},1))));
             plot(x/pi*180,n,plotColors(m))
            hold on
            end
        end
        set(gca,'xlim',[-180 180]);
        if j==k & j<=size(depCell,1)
            title([depCell{j,1:end-1}],'color',plotColors(j))
        end
        if k==size(selChansCell,1)
            xlabel([selChansCell{j,1} ' *'])
        end
        if j==1
            ylabel(selChansCell{k,1})
        end
        end
    end
end
ReportFigSM([1 2 3 4],Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir glmVersion '/' chanLocVersion '/' analRoutine '/' spectAnalDir fileExt '/']));
return

plot(sin(0:0.01:4*pi))                                      
hold on
plot(sin([0:0.01:4*pi]+3*pi/4),'g')                         
plot(sin([0:0.01:4*pi]+pi/2),'r')                           
text(1400,1,'CA1','color','b')       
text(1400,0,'CA3 center','color','r')
text(1400,-1,'CA3 other','color','g')


clf;
set(gcf,'name',depVar)
% if strcmp(depVarType,'phase')
%     try colormap(LoadVar('ColorMapSean6')); end
% %     try colormap(LoadVar('CircularColorMap.mat')); end
% else
%     try colormap(LoadVar('ColorMapSean6')); end
% end
if selChanBool
    try
        selChanNames = fieldnames(LoadVar([fileBaseCell{1} '/' dirName '/' depVar]));
    catch
        selChanNames = fieldnames(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
    end
else
    selChanNames = {''};
end
chanLoc = LoadVar(['ChanInfo/ChanLoc_Min' fileExt '.mat']);
for k=1:length(selChanNames)
    if ~isstruct(analRoutine)
        depCell = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,[depVar '.' selChanNames{k}],trialDesig),[],1);
    else
       depCell = Struct2CellArray(analRoutine,[],1);
    end
    subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+1)
    k = 2
    plotColors = 'krgb';
    clf
    for j=1:size(depCell,1)
    junk = depCell{j,end}(:,[chanLoc.(selChanNames{k}){:}]);
    [n x] = hist(angle(junk(:)),36)
    polar(x,n,plotColors(j))
        hold on
    end
    
     k = 2
    junk = depCell{1,end}(:,[chanLoc.(selChanNames{k}){:}])
    [n x] = hist(angle(junk(:)),18)
    polar(x,n)

    if strcmp(depVarType,'coh')
        grandMean = UnATanCoh(squeeze(mean(cat(1,depCell{:,end}))));
    elseif strcmp(depVarType,'phase')
        grandMean = angle(squeeze(mean(cat(1,depCell{:,end}))));
    else
        grandMean = squeeze(mean(cat(1,depCell{:,end})));
    end
    imagesc(Make2DPlotMat(grandMean,chanMat,badChan,interpFunc));
    
    if ~isempty(colorLimits)
        if iscell(colorLimits)
            if ~isempty(colorLimits{1})
                set(gca,'clim',colorLimits{1})
            end
        else
            set(gca,'clim',colorLimits)
        end
    end
    PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
    set(gca,'xtick',[],'ytick',[])
    title('GrandMean')
    colorbar;
    ylabel(selChanNames{k});
    for j=1:size(depCell,1)
        subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+j+1)
        if strcmp(depVarType,'coh')
            temp = UnATanCoh(squeeze(mean(depCell{j,end})));
        elseif strcmp(depVarType,'phase')
            temp = angle(squeeze(mean(depCell{j,end})));
        else
            temp = squeeze(mean(depCell{j,end}));
        end
        if subtractMeanBool
            if strcmp(depVarType,'phase')
                temp = angle(complex(cos(temp-grandMean),sin(temp-grandMean)));
            else
                temp = temp - grandMean;
            end
        end
        imagesc(Make2DPlotMat(temp,chanMat,badChan,interpFunc));

        if ~isempty(colorLimits)
            if iscell(colorLimits)
                if length(colorLimits)>=(j+1) & ~isempty(colorLimits{j+1})
                    set(gca,'clim',colorLimits{j+1})
                end
            else
                set(gca,'clim',colorLimits)
            end
        end
        PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
        set(gca,'xtick',[],'ytick',[])
        title([depCell{j,1:end-1}])
        colorbar;
    end
end
return
