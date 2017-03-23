function RippTrigAveComod(varargin)
[analDirs,fileExtCell,segLen,segRestrictionCell] = ...
    DefaultArgs(varargin,{{'./'},{'.eeg','_NearAveCSD1.csd','_LinNearCSD121.csd'},160,...
    {'single','first','last','all'}});

eegSamp = 1250;
cwd = pwd;
fileInfoDir = 'FileInfo/';
for k=1:length(fileExtCell)
    fileExt = fileExtCell{k};
    for j=1:length(analDirs)
        cd(analDirs{j})
        sleepFiles = LoadVar([fileInfoDir 'SleepFiles']);
        selChan = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']),[],1);
        for m=1:length(sleepFiles)
            for p=1:length(segRestrictionCell)
                inFile = [sleepFiles{m} '/RippTrigSegs_' segRestrictionCell{p} num2str(segLen) fileExt '.mat'];
                fprintf('processing: %s\n',inFile)

                ripp = load(inFile);
                
                for r=1:size(selChan,1)
                    comSpec.yo = [];
                    for n=1:size(ripp.segs,3)
                        for ch=1:size(ripp.segs,1)
                            [yoTemp period junk coi] = wtcm(squeeze(ripp.segs(selChan{r,2},:,n)),...
                                squeeze(ripp.segs(ch,:,n)));
keyboard
                            if isempty(comSpec.yo)
                                comSpec.yo = zeros([size(ripp.segs,1),size(yoTemp)]);
                            end
                            comSpec.yo(ch,:,:) = squeeze(comSpec.yo(ch,:,:)) + yoTemp/size(ripp.segs,3);
                        end
                    end
                    if isempty(ripp.time)
                        comSpec.coi = [];
                        comSpec.fo = [];
                    else
                        comSpec.coi = coi;
                        comSpec.fo = eegSamp./period;
                    end
                    comSpec.to = [-floor(segLen*eegSamp/1000/2):ceil(segLen*eegSamp/1000/2)-1]*1000/eegSamp;
                    comSpec.numSeg = size(ripp.segs,3);
                    %                 comSpec.yo = 10*log10(comSpec.yo);
                    outFile = [sleepFiles{m} '/RippTrigAveComod_' segRestrictionCell{p} num2str(segLen) ...
                        fileExt '.' selChan{r,1} '.mat'];
                    fprintf('Saving: %s\n',outFile)
                    save(outFile,SaveAsV6,'comSpec');
                end
            end
        end
    end
end

return