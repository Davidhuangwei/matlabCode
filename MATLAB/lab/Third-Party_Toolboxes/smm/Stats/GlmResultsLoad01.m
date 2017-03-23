function outStruct = GlmResultsLoad01(depVar,chanLocVersion,spectAnalDir,fileExt,inNameNote,animalDirs,varargin)

[statsDir selChanBool] = DefaultArgs(varargin,{'GlmWholeModel08',0});
chanInfoDir = 'ChanInfo/';
%var{average#{selChans X chanLocs}
% animalDirs = {...
% %     {'/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
% %     '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
% %     '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
% %     '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/'},...
% %     {'/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
% %     '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/'},...
%     {'/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
%     '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/'},...
%     {'/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
%    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/'},...
%     }
% chanLocVersion = 'Full';
% %  depVar = 'thetaPowIntg4-12Hz';
% depVar = 'gammaPowIntg40-100Hz';
% %depVar = 'gammaCohMean40-100Hz';
% selChanBool = 0;
% % fileExt = '.eeg';
% fileExt = '_LinNearCSD121.csd';
% inNameNote = 'RemVsMaze_Beh_01';
cwd = pwd;
outStruct = [];
for k=1:length(animalDirs)
    for m=1:length(animalDirs{k})
        fprintf('\ncd %s',animalDirs{k}{m})
        cd(animalDirs{k}{m})
        if  selChanBool == 0
            selChan = {''};
            selChanNames = {''};
            selChanNums = 0;
        else
            selChanStruct = LoadVar([chanInfoDir 'SelChan' fileExt '.mat']);
            selChan = fieldnames(selChanStruct);
            for n=1:length(selChan)
                selChanNames{n} = cat(2,'.',selChan{n});
                selChanNums(n) = selChanStruct.(selChan{n});
            end
        end
        for n=1:length(selChan)
            fprintf('\nLoading %s',[statsDir '/' inNameNote '/' spectAnalDir fileExt '/' depVar selChanNames{n} '.mat'])
            load([statsDir '/' inNameNote '/' spectAnalDir fileExt '/' depVar selChanNames{n} '.mat']);
%             chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
            chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
            badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
            for ch=1:length(modelStats)
                numObs(ch) = length(modelStats(ch).resid); % keep track of n for averaging across days
            end
            anatFields = fieldnames(chanLoc);
            for p=1:length(anatFields)
%                 if length(chanLoc.(anatFields{p}))<size(chanMat,2)
%                     fprintf('ERROR: %s, chanLoc.%s%s\n',animalDirs{k}{m},anatFields{p},fileExt);
%                     exit
%                 end
                for q=1:length(chanLoc.(anatFields{p})) % num shanks
                    goodChans = setdiff(chanLoc.(anatFields{p}){q},...
                        union(badChans,selChanNums(1:length(selChanNums)<=n)));
%                     keyboard
%                     if ~isempty(goodChans)
%                         fprintf('%s, sh:%i, %s\n',anatFields{p},q,num2str(goodChans));
%                     else fprintf('%s, sh:%i, empty\n',anatFields{p},q);
%                     end
                    if ~isempty(goodChans)
                        meanObs{k}(m,p,n,q) = mean(numObs(goodChans));
                    else
                        meanObs{k}(m,p,n,q) = NaN;
                    end

                    %%%%%%% coeffs %%%%%%%%
                    varNames = model.coeffNames;
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.coeffs.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* model.coeffs(r,goodChans));
                        else
                            outStruct.coeffs.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                    %%%%%%% categMeans %%%%%%%%
%                     keyboard
                    if isempty(model.categMeans)
                    tempCategMeans = [];
                    varNames = [];
                    else
                    tempCategMeans = cat(1,model.categMeans{:});
                    varNames = cat(1,model.categNames{:});
                    end
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.categMeans.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* tempCategMeans(r,1,goodChans));
                        else
                            outStruct.categMeans.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                    %%%%% rSqs %%%%%%
                    varNames = model.rSqNames;
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.rSqs.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* model.rSq(r,goodChans));
                        else
                            outStruct.rSqs.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                    %%%%% pVals %%%%%%
                    varNames = model.varNames;
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.pVals.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* model.pVals(r,goodChans));
                        else
                            outStruct.pVals.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                    %%%% residNormPs %%%%%
                    tempData = MatStruct2StructMat(assumTest.residNormPs);
                    cellData = Struct2CellArray(tempData,[],1);
                    tempData = cat(1,cellData{:,end});
                    clear varNames;
                    for r=1:size(cellData,1)
                        varNames{r,1} = cat(2,cellData{r,1:end-1});
                    end
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.residNormPs.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* tempData(r,goodChans));
                        else
                            outStruct.residNormPs.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                    %%%% residMeanPs %%%%%
                    tempData = MatStruct2StructMat(assumTest.residMeanPs);
                    cellData = Struct2CellArray(tempData,[],1);
                    tempData = cat(1,cellData{:,end});
                    clear varNames;
                    for r=1:size(cellData,1)
                        varNames{r,1} = cat(2,cellData{r,1:end-1});
                    end
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.residMeanPs.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* tempData(r,goodChans));
                        else
                            outStruct.residMeanPs.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                    %%%% contDwPvals %%%%%
                    tempData = MatStruct2StructMat(assumTest.contDwPvals);
                    cellData = Struct2CellArray(tempData,[],1);
                    tempData = cat(1,cellData{:,end});
                    clear varNames;
                    if size(cellData,1)>1
                        for r=1:size(cellData,1)
                            varNames{r,1} = cat(2,cellData{r,1:end-1});
                        end
                    else
                        varNames{1,1} = 'none';
                    end
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.contDwPvals.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* tempData(r,goodChans));
                        else
                            outStruct.contDwPvals.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                    %%%% categDwPvals %%%%%
                    tempData = MatStruct2StructMat(assumTest.categDwPvals);
                    cellData = Struct2CellArray(tempData,[],1);
                    tempData = cat(1,cellData{:,end});
                    clear varNames;
                    for r=1:size(cellData,1)
                        varNames{r,1} = cat(2,cellData{r,1:end-1});
                    end
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.categDwPvals.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* tempData(r,goodChans));
                        else
                            outStruct.categDwPvals.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                    %%%% prllPvals %%%%%
                    tempData = MatStruct2StructMat(assumTest.prllPvals);
                    cellData = Struct2CellArray(tempData,[],1);
                    tempData = cat(1,cellData{:,end});
                    clear varNames;
                    if size(cellData,1)>1
                        for r=1:size(cellData,1)
                            varNames{r,1} = cat(2,cellData{r,1:end-1});
                        end
                    else
                        varNames{1,1} = 'none';
                    end
                    for r=1:length(varNames);
                        if ~isempty(goodChans)
                            outStruct.prllPvals.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                mean(numObs(goodChans) .* tempData(r,goodChans));
                        else
                            outStruct.prllPvals.(GenFieldName(varNames{r})){k}{p,n}(q,m) = ...
                                NaN;
                        end
                    end
                end
            end
        end
    end
end
outStruct = AverageDays(outStruct,meanObs,0);
cd(cwd);
return

function outStruct = AverageDays(inStruct,meanObs,catAnimals)
outStruct = inStruct;
fields = fieldnames(inStruct);
for j=1:length(fields)
    varNames = fieldnames(inStruct.(fields{j}));
    for r=1:length(varNames)
        %         if catAnimals
        %             outStruct.(fields{j}).(varNames{r}) = cell(size(inStruct.(fields{j}).(varNames{r}){1}));
        %         end
        for k=1:length(inStruct.(fields{j}).(varNames{r}))
            for n=1:size(inStruct.(fields{j}).(varNames{r}){k},1)
                for p=1:size(inStruct.(fields{j}).(varNames{r}){k},2)
                    %                     if catAnimals
                    %                         for q=1:size(inStruct.(fields{j}).(varNames{r}){k}{n,p},1)
                    %                             goodMeas = find(~isnan(meanObs{k}(:,n,p,q)));
                    %                             if ~isempty(goodMeas)
                    %                                 outStruct.(fields{j}).(varNames{r}){n,p} = ...
                    %                                     cat(1,outStruct.(fields{j}).(varNames{r}){n,p},...
                    %                                     sum(inStruct.(fields{j}).(varNames{r}){k}{n,p}(q,goodMeas)) ...
                    %                                     / sum(meanObs{k}(goodMeas,n,p,q)));
                    %                             end
                    %                         end
                    %                     else
                    outStruct.(fields{j}).(varNames{r}){k}{n,p} = [];
                    for q=1:size(inStruct.(fields{j}).(varNames{r}){k}{n,p},1)
                        goodMeas = find(~isnan(meanObs{k}(:,n,p,q)));
                        if ~isempty(goodMeas)
                            outStruct.(fields{j}).(varNames{r}){k}{n,p} = ...
                                cat(1,outStruct.(fields{j}).(varNames{r}){k}{n,p},...
                                sum(inStruct.(fields{j}).(varNames{r}){k}{n,p}(q,goodMeas)) ...
                                / sum(meanObs{k}(goodMeas,n,p,q)));
                        end
                    end
                end
            end
        end
    end
end
% end
return
