function [outSpec fo to coi outSeg] = LoadTrigAveCoh(animalDirs,filesNameCell,...
    fileExt,trigFileBase,varargin)
chanLocVersion = DefaultArgs(varargin,'Min');


% prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
%    'off', 'MATLAB:divideByZero'});
safetyFactor = 1000;
chanInfoDir = 'ChanInfo/';
cwd = pwd;
outStruct = [];
for k=1:length(animalDirs)
    for m=1:length(animalDirs{k})
        fprintf('\ncd %s\n',animalDirs{k}{m})
        cd(animalDirs{k}{m})
        
%         files = LoadVar('FileInfo/SleepFiles');
files = {};
        for j=1:length(filesNameCell)
            files = cat(1,files,LoadVar(['FileInfo/' filesNameCell{j}]));
        end
        files
        selChan = Struct2CellArray(LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),[],1);
        chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
        badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
        anatFields = fieldnames(chanLoc);

        try
            for r=1:size(selChan,1)
                % Sum Files w/in a day
                for j=1:length(files)
                    inFile = [files{j} '/' trigFileBase fileExt '.' selChan{r} '.mat'];
%                     inFile = [files{j} '/RippTrigAveCoh_' segRestriction num2str(segLen)...
%                         fileExt '.' selChan{r} '.mat'];
                    %             inFile = [files{j} '/' fileBase fileExt '.mat'];
                    fprintf('Loading %s\n',inFile);
                    inSpec = LoadVar(inFile);
                    if j==1 | isempty(tempSpec);
                        tempSpec = zeros(size(inSpec.yo));
                        numSegFiles = 0;
                    end
                    if ~isempty(inSpec.yo)
                        %                 tempSpec = tempSpec + 10.^((inSpec.yo)/10) * inSpec.numSeg / safetyFactor;
                        tempSpec = tempSpec + inSpec.yo * inSpec.numSeg / safetyFactor;
                        numSegFiles = numSegFiles + inSpec.numSeg / safetyFactor;
                    end
                end
                %         tempSpec = tempSpec / numSegFiles;
                for p=1:length(anatFields)
                    for q=1:length(chanLoc.(anatFields{p}))
                        % Average Chans w/in a Shank
                        goodChans = setdiff(chanLoc.(anatFields{p}){q},badChans);
                        %                         union(badChans,selChanNums(1:length(selChanNums)<=n)));
                        % Sum Files Across Days
                        if m==1
                            if isempty(goodChans)
                                numSegDays(r,p,q) = 0;
                                tempSpec2{r,p,q} = zeros(1,size(tempSpec,2),size(tempSpec,3));
                            else
                                numSegDays(r,p,q) = numSegFiles;
                                tempSpec2{r,p,q} = mean(tempSpec(goodChans,:,:),1); %* numSegFiles;
                            end
                        else
                            if ~isempty(goodChans)
                                numSegDays(r,p,q) = numSegDays(r,p,q) + numSegFiles;
                                tempSpec2{r,p,q} = tempSpec2{r,p,q} + mean(tempSpec(goodChans,:,:),1); %* numSegFiles;
                            end
                        end
                    end
                end
            end
        catch
            junk = lasterror
            junk.stack(1)
            keyboard
        end
    end
    clear tempSpec
    % Divide by Total Segs
    % Cat Across Animals/Shanks
    for r=1:size(selChan,1)
        for p=1:length(anatFields)
            if k==1
                outSpec{r,p} = [];
                outSeg{r,p} = [];
            end
            for q=1:length(chanLoc.(anatFields{p}))
                if numSegDays(r,p,q) ~= 0
                    %                 outSpec{r,p} = cat(1,outSpec{r,p},10*log10(tempSpec2{r,p,q} / numSegDays(r,p,q)));
                    outSpec{r,p} = cat(1,outSpec{r,p}, tempSpec2{r,p,q} / numSegDays(r,p,q) );
                    outSeg{r,p} = cat(1,outSeg{r,p},numSegDays(r,p,q)*safetyFactor);
                end
            end
        end
    end
end
clear tempSpec2
cd(cwd)
% keyboard
% outSpec = CatDiagMirror(outSpec);
% outSeg = CatDiagMirror(outSeg);
fo = inSpec.fo;
to = inSpec.to;
coi = inSpec.coi;


return

function inData = CatDiagMirror(inData)
for j=1:size(inData,1)
    for k=1:size(inData,2)
        if j~=k % don't duplicate diagonal measurements
            inData{j,k} = cat(1,inData{j,k},inData{k,j});
        end
    end
end
return

% function catData = CatDiagMirror(inData)
% catData = {};
% temp1 = inData;
% temp2 = flipud(rot90(temp1));
% for j=1:size(temp1,1)
%     for k=1:size(temp1,2)
%         if j==k % don't duplicate diagonal measurements
%             temp2{j,k} = [];
%         end
% %         if strcmp(depVarType,'phase') & (strcmp(analNames{q},'coeffs') | strcmp(analNames{q},'categMeans'))
% %             temp2{j,k} = -temp2{j,k}; % phases are opposite
% %         end
%         if isempty(find([j k] > size(catData)))
%             catData{j,k} = cat(1,catData{j,k},temp1{j,k},temp2{j,k});
%         else
%             catData{j,k} = cat(1,temp1{j,k},temp2{j,k});
%         end
%     end
% end
% return



% output{numAnatFields,numSelChan}(numAnimalsXnumShanks,freq,time)
% 
% ave(files)
% ave(goodChans)
% ave(days)
% cat(shanks)
% cat(animals)
        
        


