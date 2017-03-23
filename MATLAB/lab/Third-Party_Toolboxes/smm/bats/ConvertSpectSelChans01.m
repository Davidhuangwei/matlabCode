depVarCell = {...
'cohSpec',...
'crossSpec',...
'gammaCohMean40-100Hz',...
'gammaCohMedian40-100Hz',...
'gammaPhaseMean40-100Hz',...
'phaseSpec',...
'thetaCohMean6-12Hz',...
'thetaCohMedian6-12Hz',...
'thetaPhaseMean6-12Hz',...
}

varNames = {...
'cohSpec',...
'crossSpec',...
'gammaCohMean',...
'gammaCohMedian',...
'gammaPhaseMean',...
'phaseSpec',...
'thetaCohMean',...
'thetaCohMedian',...
'thetaPhaseMean',...
}


spectDirs = {...
    'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam4','MazeFiles';...
    'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8','MazeFiles';...
    %'RemVsRun02_noExp_MinSpeed0Win1250wavParam6','AllFiles';...
    }

analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    }
 fileExtCell = {...
                  '.eeg',...
                 '_LinNearCSD121.csd',...
%                   '_NearAveCSD1.csd',...
                }
            
            
fid = fopen('/u12/smm/BatchLogs/MatlabLog.txt','-a');
            
for j=1:length(analDirs)
    cd(analDirs{j})
    for k=1:length(fileExtCell)
        selChan = LoadVar(['ChanInfo/SelChan' fileExtCell{k} '.mat']);
        for n=1:size(spectDirs,1)
            files = LoadVar(['FileInfo/' spectDirs{n,2} '.mat']);
            for m=1:length(files);
                for p=1:length(depVarCell)
                    try
                        temp = LoadVar([files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p} '.mat']);
                        [files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p}]
                        newTemp = [];
                        newSelChanNames = fieldnames(selChan);
                        if isfield(temp,'fo')
                            for q=1:length(newSelChanNames)
                                newTemp.yo.(newSelChanNames{q}) = temp.yo.(['ch' num2str(selChan.(newSelChanNames{q}))]);
                            end
                            newTemp.fo = temp.fo;
                            %newTemp.yo
                        else
                            for q=1:length(newSelChanNames)
                                newTemp.(newSelChanNames{q}) = temp.(['ch' num2str(selChan.(newSelChanNames{q}))]);
                            end
                        end
                        %newTemp
                        [varNames{p} ' = newTemp']
                        eval([varNames{p} ' = newTemp;']);
                        save([files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p} '.mat'],SaveAsV6,varNames{p});
                    catch
                        junk = lasterror;
                        fprintf(fid,'ERROR: %s\n%s\n\n',[files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p} '.mat'],junk.message);
                    end
                end
            end
        end
    end
end

fclose(fid);

fid = fopen('/u12/smm/BatchLogs/MatlabLog.txt','a');

for j=1:length(analDirs)
    cd(analDirs{j})
    for k=1:length(fileExtCell)
        selChan = LoadVar(['ChanInfo/SelChan' fileExtCell{k} '.mat']);
        for n=1:size(spectDirs,1)
            files = LoadVar(['FileInfo/' spectDirs{n,2} '.mat']);
            for m=1:length(files);
                for p=1:length(depVarCell)
                    try
                        temp = LoadVar([files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p} '.mat']);
                        fprintf('%s\n',[files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p}]);
                        newSelChanNames = fieldnames(selChan);
                        if isfield(temp,'fo')
                            for q=1:length(newSelChanNames)
                                temp.yo.(newSelChanNames{q});
                            end
                            temp.fo;
                        else
                            for q=1:length(newSelChanNames)
                                temp.(newSelChanNames{q});
                            end
                        end
                    catch
                        junk = lasterror;
                        fprintf(fid,'ERROR: %s\n%s\n\n',[files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p} '.mat'],junk.message);
                    end
                end
            end
        end
    end
end
fclose(fid);


fid = fopen('/u12/smm/BatchLogs/MatlabLog.txt','a');
for j=1:length(analDirs)
    cd(analDirs{j})
    for k=1:length(fileExtCell)
        selChan = LoadVar(['ChanInfo/SelChan' fileExtCell{k} '.mat']);
        for n=1:size(spectDirs,1)
            files = LoadVar(['FileInfo/' spectDirs{n,2} '.mat']);
            for m=1:length(files);
                for p=1:length(depVarCell)
                    try
                        temp = LoadVar([files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p} '.mat']);
                        infoStruct = LoadVar([files{m} '/' spectDirs{n,1} fileExtCell{k} '/infoStruct.mat']);
                        [files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p}]
                        
                        newTemp = [];
                        newSelChanNames = fieldnames(selChan);
                        if isfield(temp,'fo')
                            for q=1:length(newSelChanNames)
                                temp.yo.(newSelChanNames{q});
                            end
                            temp.fo;
                        else
                            for q=1:length(newSelChanNames)
                                temp.(newSelChanNames{q});
                            end
                        end
                        newTemp = rmfield(temp,'selChan');
                        infoStruct.selChan = selChan;
                        
                        eval([varNames{p} ' = newTemp;']);
                        save([files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p} '.mat'],SaveAsV6,varNames{p});
                        save([files{m} '/' spectDirs{n,1} fileExtCell{k} '/infoStruct.mat'],SaveAsV6,'infoStruct');
                    catch
                        junk = lasterror;
                        fprintf(fid,'ERROR: %s\n%s\n\n',[files{m} '/' spectDirs{n,1} fileExtCell{k} '/' depVarCell{p} '.mat'],junk.message);
                    end
                 end
            end
        end
    end
end
fclose(fid);


