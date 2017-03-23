function RippTrigStdSpect(varargin)
[analDirs,fileExtCell,segLen,segRestrictionCell] = ...
    DefaultArgs(varargin,{{'./'},{'.eeg','_NearAveCSD1.csd','_LinNearCSD121.csd'},160,...
    {'single','first','last','all'}});

eegSamp = 1250;
cwd = pwd;
fileInfoDir = 'FileInfo/';
for j=1:length(analDirs)
    cd(analDirs{j})
    sleepFiles = LoadVar([fileInfoDir 'SleepFiles']);
    for m=1:length(sleepFiles)
        for k=1:length(fileExtCell)
            fileExt = fileExtCell{k};
            for p=1:length(segRestrictionCell)
                inFile = [sleepFiles{m} '/RippTrigSegs_' segRestrictionCell{p} num2str(segLen) fileExt '.mat'];
                meanFile = [sleepFiles{m} '/RippTrigAveSpec_' segRestrictionCell{p} num2str(segLen) fileExt '.mat'];
                
                fprintf('processing: %s\n',inFile)
                ripp = load(inFile);
                meanSpec = LoadVar(meanFile);
%                 meanSpec.yo = 10.^((meanSpec.yo)/10);

                stdSpec.yo = [];
                for n=1:size(ripp.segs,3)
                    for ch=1:size(ripp.segs,1)
                        [yoTemp period junk coi] = xwt(squeeze(ripp.segs(ch,:,n)),squeeze(ripp.segs(ch,:,n)));

                        if isempty(stdSpec.yo)
                            stdSpec.yo = zeros([size(ripp.segs,1),size(yoTemp)]);
                        end
                         stdSpec.yo(ch,:,:) = squeeze(stdSpec.yo(ch,:,:)) ...
                             + (10*log10(yoTemp) - squeeze(meanSpec.yo(ch,:,:))) .^ 2;
                    end
                end
                stdSpec.coi = coi;
                stdSpec.fo = eegSamp./period;
                stdSpec.to = [-floor(segLen*eegSamp/1000/2):ceil(segLen*eegSamp/1000/2)-1]*1000/eegSamp;
                stdSpec.numSeg = size(ripp.segs,3);
                stdSpec.yo = sqrt(stdSpec.yo / stdSpec.numSeg);
                outFile = [sleepFiles{m} '/RippTrigStdSpec_' segRestrictionCell{p} num2str(segLen) fileExt '.mat'];
                fprintf('Saving: %s\n',outFile)
                save(outFile,SaveAsV6,'stdSpec');
            end
        end
    end
end

return