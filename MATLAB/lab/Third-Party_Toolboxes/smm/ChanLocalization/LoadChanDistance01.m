function outData = LoadSpectAnalResults01(animalDirs,fileExt,varargin)
[selChanBool chanLocVersion chanMat xElecDist yElecDist] = DefaultArgs(varargin,{0,'Min',ChanMat(fileExt),0.3,0.1});


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
        %         load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])

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
        chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
        badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
        anatFields = fieldnames(chanLoc);

        %         try
        for r=1:length(selChanNames)
            %                 try
            %                 measVar = Struct2CellArray(LoadDesigVar(fileBaseCell,[spectAnalDir fileExt],...
            %                     [depVar selChanNames{r}],trialDesig),[],1);
            %                 catch
            %                     junk = lasterror
            %                     junk.message
            %                     junk.stack(1)
            %                 keyboard
            %                 end
            %         tempSpec = tempSpec / numSegFiles;
            for p=1:length(anatFields)
                for q=1:length(chanLoc.(anatFields{p}))
                    % Average Chans w/in a Shank
                    goodChans = setdiff(chanLoc.(anatFields{p}){q},...
                        union(badChans,selChanNums(1:length(selChanNums)<=r)));
                    %                         union(badChans,selChanNums(1:length(selChanNums)<=n)));
                    if m==1
                        tempSpec2{r,p,q} = [];
                    end
                    for t=1:length(goodChans)

                        eDistance = CalcChanDistance([selChanNums(r) goodChans(t)],chanMat,xElecDist,yElecDist);
                        tempSpec2{r,p,q} = cat(1,tempSpec2{r,p,q},eDistance(1,2));
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
    for r=1:length(selChanNames)
        for p=1:length(anatFields)
            if k==1
                outSpec{p,r} = [];
                %                     outSeg{s,r,p} = [];
            end
            for q=1:length(chanLoc.(anatFields{p}))
                outSpec{p,r} = cat(1,outSpec{p,r}, tempSpec2{r,p,q});
            end
        end
    end
end
clear tempSpec2
cd(cwd)
outData = squeeze(outSpec(:,:));
return



