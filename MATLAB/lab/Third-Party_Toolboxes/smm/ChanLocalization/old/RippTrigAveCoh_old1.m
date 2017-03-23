function RippTrigAveCoh(varargin)
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
                    cohSpec.yo = [];
                    for n=1:size(ripp.segs,3)
                        for ch=1:size(ripp.segs,1)
                            [yoTemp period junk coi] = wtc(squeeze(ripp.segs(selChan{r,2},:,n)),...
                                squeeze(ripp.segs(ch,:,n)));

                            if isempty(cohSpec.yo)
                                cohSpec.yo = zeros([size(ripp.segs,1),size(yoTemp)]);
                            end
                            cohSpec.yo(ch,:,:) = squeeze(cohSpec.yo(ch,:,:)) + ATanCoh(yoTemp)/size(ripp.segs,3);
                        end
                    end
                    if isempty(ripp.time)
                        cohSpec.coi = [];
                        cohSpec.fo = [];
                    else
                        cohSpec.coi = coi;
                        cohSpec.fo = eegSamp./period;
                    end
                    cohSpec.to = [-floor(segLen*eegSamp/1000/2):ceil(segLen*eegSamp/1000/2)-1]*1000/eegSamp;
                    cohSpec.numSeg = size(ripp.segs,3);
                    %                 cohSpec.yo = 10*log10(cohSpec.yo);
                    outFile = [sleepFiles{m} '/RippTrigAveSpec_' segRestrictionCell{p} num2str(segLen) ...
                        fileExt '.' selChan{r,1} '.mat'];
                    fprintf('Saving: %s\n',outFile)
                    save(outFile,SaveAsV6,'cohSpec');
                end
            end
        end
    end
end

return