temp1 = dir;
temp2 = MatStruct2StructMat(temp1,'name')
files = temp2.name(3:end)
files = {...
%     'UnitACG_wIn_-25-25ms_countBC_bin4',...
    'UnitACG_wIn_-25-25ms_countBC_bin8',...
%     'UnitACG_wIn_-250-250ms_countBC_bin4',...
    'UnitACG_wIn_-250-250ms_countBC_bin8',...
%     'UnitACG_wIn_-8-8ms_countBC_bin4',...
    'UnitACG_wIn_-8-8ms_countBC_bin8',...
%     'UnitCCG_wIn_-25-25ms_countBC_bin4',...
    'UnitCCG_wIn_-25-25ms_countBC_bin8',...
%     'UnitCCG_wIn_-250-250ms_countBC_bin4',...
    'UnitCCG_wIn_-250-250ms_countBC_bin8',...
%     'UnitCCG_wIn_-8-8ms_countBC_bin4',...
    'UnitCCG_wIn_-8-8ms_countBC_bin8',...
    'UnitRates_wIn',...
%     'UnitSpect_wIn_4-12Hz_tMin5_cMin7_tapers19',...
    'UnitSpect_wIn_4-12Hz_tMin5_cMin7_tapers5',...
    'UnitSpect_wIn_40-120Hz_tMin5_cMin7_tapers19',...
%     'UnitSpect_wIn_40-120Hz_tMin5_cMin7_tapers5',...
    'gammaCohMean40-120Hz_LinNearCSD121_csd',...
    'gammaPowIntg40-120Hz_LinNearCSD121_csd',...
    'gammaPowIntg40-120Hz_eeg',...
    'thetaCohMean4-12Hz_LinNearCSD121_csd',...
    'thetaFreq4-12Hz_LinNearCSD121_csd',...
    'thetaFreq4-12Hz_eeg',...
    'thetaPowIntg4-12Hz_LinNearCSD121_csd',...
    'thetaPowIntg4-12Hz_eeg',...
%     'unitFieldCoh_wIn_4-12Hz_tMin5_cMin7_orig_tapers19.eeg',...
%     'unitFieldCoh_wIn_4-12Hz_tMin5_cMin7_orig_tapers19_LinNearCSD121.csd',...
    'unitFieldCoh_wIn_4-12Hz_tMin5_cMin7_orig_tapers5.eeg',...
    'unitFieldCoh_wIn_4-12Hz_tMin5_cMin7_orig_tapers5_LinNearCSD121.csd',...
    'unitFieldCoh_wIn_40-120Hz_tMin5_cMin7_orig_tapers19.eeg',...
    'unitFieldCoh_wIn_40-120Hz_tMin5_cMin7_orig_tapers19_LinNearCSD121.csd',...
%     'unitFieldCoh_wIn_40-120Hz_tMin5_cMin7_orig_tapers5.eeg',...
%     'unitFieldCoh_wIn_40-120Hz_tMin5_cMin7_orig_tapers5_LinNearCSD121.csd',...
};

behaviors = [];
catCorrCell = {};
for j=1:length(files)
    dataCell = LoadVar(files{j});
    if isempty(behaviors)
    behaviors = unique(dataCell(:,end-1))
    elseif CellNE(behaviors,unique(dataCell(:,end-1))) ...
            & CellNE(CatCell(repmat({'behavior_'},size(behaviors)),behaviors,2),unique(dataCell(:,end-1))) ...
            & CellNE(behaviors,CatCell(repmat({'behavior_'},size(behaviors)),unique(dataCell(:,end-1)),2))
        bad
    else
      behaviors = unique(dataCell(:,end-1));
    end      
        
    catData = [];
    for k=1:length(behaviors)
        tempData = cat(1,dataCell{strcmp(dataCell(:,end-1),behaviors{k}),end});
        catData = cat(2,catData,tempData);
    end
    dataCell = dataCell(strcmp(dataCell(:,end-1),behaviors{1}),:);
    dataCell(:,end-1) = [];
    dataCell(:,end) = mat2cell(catData,ones(size(catData,1),1),size(catData,2));
    corrCell = [];
    for k=1:size(dataCell,1)
        corrCell{k,1} = cat(2,dataCell{k,1:end-1});
        corrCell{k,2} = dataCell{k,end};
    end
    catCorrCell = cat(1,catCorrCell,corrCell);
end
catCorrCell;

gobiData = cat(1,catCorrCell{:,2});
gobiData(~isfinite(gobiData)) = -100
xgobi(gobiData);

r = [];
p = [];
for j=1:size(catCorrCell,1)
  for k=1:size(catCorrCell,1)
      [tempR tempP] = corrcoef(catCorrCell{j,end}',catCorrCell{k,end}');
    r(j,k) = tempR(2,1);
    p(j,k) = tempP(2,1);
    
  end
end

% figure
clf
subplot(1,2,1)
title('r')
imagesc(tril(r))
colorbar
subplot(1,2,2)
title('p')
imagesc(log10(tril(p)))
set(gca,'clim',[-3 0])
colorbar

while 1
     [x y] = ginput(1);
     x = round(x);
     y = round(y);
     fprintf('x(%i)= %s \ny(%i)= %s\n\n',x,catCorrCell{x,1},y,catCorrCell{y,1})
end

cData = LoadTxtFile('thetaXGobi_noClust.colors');

cData = LoadTxtFile('thetaXGobi_grossClust.colors');
cData = LoadTxtFile('/u12/smm/xgobitemp05.colors');

colors = unique(cData)
excludedColors = {'OrangeRed1','DeepPink'}
figHandles = [];
catTempData = [];
catTempNames =[];
catTempNums = [];
tempNames = [];
tempNums = [];
for m=1:length(colors)
    if ~any(strcmp(excludedColors,colors{m}))
%         fprintf('%s\n',catCorrCell{strcmp(cData,colors{m}),1})
%         fprintf('\n')
        r = [];
        p = [];
        tempData = gobiData(strcmp(cData,colors{m}),:);
        catTempData = cat(1,catTempData,tempData);
        tempNames{m} = catCorrCell(strcmp(cData,colors{m}),1);
        catTempNames = cat(1,catTempNames,tempNames{m});
        tempNums{m} = find(strcmp(cData,colors{m}));
        catTempNums = cat(1,catTempNums,tempNums{m});
        for j=1:size(tempData,1)
            for k=1:size(tempData,1)
                [tempR tempP] = corrcoef(tempData(j,:)',tempData(k,:)');
                r(j,k) = tempR(2,1);
                p(j,k) = tempP(2,1);
            end
        end
        figHandles(m) = figure;
        colormap(LoadVar('ColorMapSean'))
        clf
%         subplot(1,2,1)
        imagesc(tril(r))
        title(cat(1,colors(m),' r'))
        set(gca,'xtick',1:size(tempNums{m}),'ytick',1:size(tempNums{m}))
        set(gca,'xticklabel',tempNums{m},'yticklabel',tempNums{m})
        set(gca,'clim',[-1 1])
        colorbar
%         subplot(1,2,2)
%         imagesc(-log10(tril(p)))
%         title('p')
%          set(gca,'clim',[-1 1])
%        set(gca,'clim',[0 1])
%         colorbar
    end
end
for j=1:size(catTempData,1)
    for k=1:size(catTempData,1)
        [tempR tempP] = corrcoef(catTempData(j,:)',catTempData(k,:)');
        r(j,k) = tempR(2,1);
        p(j,k) = tempP(2,1);
    end
end
figure
colormap(LoadVar('ColorMapSean'))
clf
imagesc(tril(r))
title(cat(1,colors(m),' r'))
set(gca,'fontsize',3)
set(gca,'xtick',1:size(catTempNums),'ytick',1:size(catTempNums))
set(gca,'xticklabel',catTempNums,'yticklabel',catTempNums)
set(gca,'clim',[-1 1])
colorbar


excludedNames = zeros(size(tempNames{figHandles==gcf}))
tempNames{figHandles==gcf}(~excludedNames)
tempNames{figHandles==gcf}(logical(excludedNames))

excludedNames = zeros(size(tempNames{figHandles==gcf}))
while 1
    [x y] = ginput(1);
    x = round(x);
    y = round(y);
    if x>=1 & x <= size(tempNames{figHandles==gcf},1)...
            & y>=1 & y<=size(tempNames{figHandles==gcf},1)
        fprintf('x(%i)= %s \ny(%i)= %s\n\n',x,tempNames{figHandles==gcf}{x,1},y,tempNames{figHandles==gcf}{y,1})
        
    excludedNames([x,y]) = 1;
    end
end


r = [];
p = [];
for j=1:size(catCorrCell,1)
  for k=1:size(catCorrCell,1)
      [tempR tempP] = corrcoef(catCorrCell{j,end}',catCorrCell{k,end}');
    r(j,k) = tempR(2,1);
    p(j,k) = tempP(2,1);
    
  end
end


