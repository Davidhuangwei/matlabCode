function RippTrigSegsSetDiff(analDirs,fileExtCell,segRestrictions,segLen,saveName)

for j=1:length(analDirs)
    sleepFiles = LoadVar([analDirs{j} 'FileInfo/SleepFiles']);
    for k=1:length(sleepFiles)
        for m=1:length(fileExtCell)
            rippSeg1 = load([analDirs{j} sleepFiles{k} '/RippTrigSegs_' ...
                segRestrictions{1} num2str(segLen) fileExtCell{m} '.mat']);
            rippSeg2 = load([analDirs{j} sleepFiles{k} '/RippTrigSegs_' ...
                segRestrictions{2} num2str(segLen) fileExtCell{m} '.mat']);

            infoStruct = rippSeg1.infoStruct;
            timeInc = rippSeg1.timeInc;
            timeExc = rippSeg1.timeExc;

            [time indexes] = setdiff(rippSeg1.time,rippSeg2.time);
            try
            segs = rippSeg1.segs(:,:,indexes);
            catch
                keyboard
            end
            saveDir = [analDirs{j} sleepFiles{k} '/RippTrigSegs_' ...
                saveName num2str(segLen) fileExtCell{m} '.mat'];

            fprintf('Saving %s\n',saveDir);
            save(saveDir,SaveAsV6,'infoStruct','time','timeInc','timeExc','segs');
        end
    end
end
