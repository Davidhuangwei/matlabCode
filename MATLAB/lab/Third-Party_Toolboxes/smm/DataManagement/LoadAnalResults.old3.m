function outData = LoadSpectAnalResults01(animalDirs,spectAnalDir,fileExt,...
    depVar,glmVersion,analRoutine,varargin)
[selChanBool chanLocVersion catMethod subMedBool] = DefaultArgs(varargin,{0,'Min','trial',0});


% prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
%    'off', 'MATLAB:divideByZero'});
safetyFactor = 1000;
chanInfoDir = 'ChanInfo/';
cwd = pwd;
outStruct = [];
for k=1:length(animalDirs)
    for m=1:length(animalDirs{k})
        fprintf('cd %s\n',animalDirs{k}{m})
        cd(animalDirs{k}{m})
        load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])

        %sleepFiles = LoadVar('FileInfo/SleepFiles');
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
%         selChan = Struct2CellArray(LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),[],1);
%         selChanNums = [selChan{:,2}];
        if strcmp(chanLocVersion,'None')
            anatFields = {''};
        else
        chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
        badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
        anatFields = fieldnames(chanLoc);
        end

        %         try
        for r=1:length(selChanNames)
            try
                measVar = Struct2CellArray(LoadDesigVar(fileBaseCell,[spectAnalDir fileExt],...
                    [depVar selChanNames{r}],trialDesig),[],1);
            catch
                junk = lasterror
                junk.message
                junk.stack(1)
                keyboard
            end
            %         tempSpec = tempSpec / numSegFiles;
            for s=1:size(measVar,1)
                for p=1:length(anatFields)
                    if strcmp(anatFields,'')
                        if m==1
                            tempSpec2{s,r,p,1} = [];
                        end
                        tempSpec2{s,r,p,1} = cat(1,tempSpec2{s,r,p,1},...
                            squeeze(measVar{s,end}(:,:,:,:,:,:)));
                    else
                        for q=1:length(chanLoc.(anatFields{p}))
                            % Average Chans w/in a Shank
                            goodChans = setdiff(chanLoc.(anatFields{p}){q},...
                                union(badChans,selChanNums(1:length(selChanNums)<=r)));
                            %                         union(badChans,selChanNums(1:length(selChanNums)<=n)));
                            if m==1
                                tempSpec2{s,r,p,q} = [];
                            end
                            for t=1:length(goodChans)
                                switch catMethod
                                    case 'trial'
                                        tempVar = squeeze(measVar{s,end}(:,goodChans(t),:,:,:,:));
                                        if subMedBool
                                            meanVar = mean(tempVar,1);
                                            tempVar = tempVar - repMat(meanVar,[size(tempVar,1) ones(1,ndims(tempVar)-1)]);
                                        end
                                        tempSpec2{s,r,p,q} = cat(1,tempSpec2{s,r,p,q},...
                                            tempVar);
                                        %numSegDays(s,r,p,q) = size(measVar{s,end},1);
                                    case 'chan'
                                        tempSpec2{s,r,p,q} = cat(1,tempSpec2{s,r,p,q},...
                                            shiftdim(mean(measVar{s,end}(:,goodChans(t),:,:,:,:),1),1));
                                        %                                         squeeze(mean(measVar{s,end}(:,goodChans(t),:,:,:,:),1)));
                                        %numSegDays(s,r,p,q) = size(measVar{s,end},1);
                                    case 'shank'
                                        tempSpec2{s,r,p,q} = cat(1,tempSpec2{s,r,p,q},...
                                            shiftdim(mean(mean(measVar{s,end}(:,goodChans,:,:,:,:),1),2),1));
                                        %numSegDays(s,r,p,q) = size(measVar{s,end},1);
                                end
                            end
                        end
                    end
                end
                end
            end
%         catch
%             junk = lasterror
%             junk.stack(1)
%             keyboard
%         end
    end
%     keyboard
    % Divide by Total Segs
    % Cat Across Animals/Shanks
    for s=1:size(tempSpec2,1)
        for r=1:length(selChanNames)
            for p=1:length(anatFields)
                if k==1
                    outSpec{s,p,r} = [];
                    %                     outSeg{s,r,p} = [];
                end
                if strcmp(anatFields,'')
                    outSpec{s,p,r} = cat(1,outSpec{s,p,r}, tempSpec2{s,r,p,1});
                else
                    for q=1:length(chanLoc.(anatFields{p}))
                        outSpec{s,p,r} = cat(1,outSpec{s,p,r}, tempSpec2{s,r,p,q});
                    end
                end
            end
        end
    end
end
clear tempSpec2
cd(cwd)
for s=1:size(outSpec,1)
    outData.([measVar{s,1:end-1}]) = squeeze(outSpec(s,:,:));
end
return



