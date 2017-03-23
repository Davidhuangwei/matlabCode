function LoadRippTrigAveSegs(animalDirs,fileExt,segLen,chanLocVersion


cwd = pwd;
outStruct = [];
for k=1:length(animalDirs)
    tempSpec2 = {};
    for m=1:length(animalDirs{k})
        fprintf('\ncd %s',animalDirs{k}{m})
        cd(animalDirs{k}{m})
        
        sleepFiles = LoadVar('FileInfo/SleepFiles');
        chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
        badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
        anatFields = fieldnames(chanLoc);

        for j=1:length(sleepFiles)
            inFile = [sleepFiles{j} '/RippTrigAveSpec' num2str(segLen) fileExt '.mat'];
            fprintf('Loading %s\n',inFile);
            inSpec = LoadVar(inFile);
            if j==1;
                tempSpec = zeros(size(inSpec.yo));
                numSeg{m} = 0;
            end
            tempSpec = tempSpec + 10^((inSpec.yo)/10) * inSpec.numSeg;
            numSeg{m} = numSeg{m} + inSpec.numSeg;
        end
        tempSpec = tempSpec / numSeg{m};
        
        for p=1:length(anatFields)
            for q=1:length(chanLoc.(anatFields{p}))
                goodChans = setdiff(chanLoc.(anatFields{p}){q},badChans);               
%                         union(badChans,selChanNums(1:length(selChanNums)<=n)));  
                if m==1
                    tempSpec2{p,q} = mean(tempSpec(goodChans,:,:))*numSeg{m};
                    numSeg2{k} = numSeg{m};
                else
                    tempSpec2{p,q} = tempSpec2{p,q} + mean(tempSpec(goodChans,:,:)) * numSeg{m};
                    numSeg2{k} = numSeg2{k} + numSeg{m};
                end
            end
        end
    end
    for p=1:length(anatFields)
        for q=1:length(chanLoc.(anatFields{p}))
            if k==1
                outSpec{p} = tempSpec2{p,q} / numSeg2{k};
            else
                outSpec{p} = cat(1,outSpec{p},tempSpec2{p,q} / numSeg2{k});
            end
        end
    end
end
            
         
output{numAnatFields,numSelChan}(numAnimalsXnumShanks,freq,time)

ave(files)
ave(goodChans)
ave(days)
cat(shanks)
cat(animals)
        
        
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
            inFile = [sleepFiles{m} '/RippTrigAveSpec' num2str(segLen) fileExt '.mat']
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
%
output{numAnimals}{numAnatFields,numSelChan}
output{numAnatFields,numSelChan}(numAnimalsXnumShanks,freq,time)

ave(files)
ave(goodChans)
ave(days)
cat(shanks)
cat(animals)



       pcolor(powSpec.to,powSpec.fo,squeeze((powSpec.yo(ch,:,:)...
           -repmat(mean(powSpec.yo(ch,:,:),3),[1 1 2500]))...
           ./repmat(std(powSpec.yo(ch,:,:),[],3),[1 1 2500])))   
       shading interp
       set(gca,'ylim',[0 300])


