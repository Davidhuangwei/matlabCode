function CheckRemSpectraFiles01(outputFile,analDirs,fileExtCell,spectAnalBase)

%analDirs = {'/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/'};
%spectAnalBase = 'CalcRemSpectra03_allTimes_Win1250';

fid = fopen(outputFile,'a');
if ~fid
    ERROR_OPENING_FILE
else
    for j=1:length(analDirs)
        cd(analDirs{j});
        files = LoadVar(['FileInfo/RemFiles.mat']);

        for k=1:length(files)
            fileBase = files{k};
            cd(fileBase)
            for m=1:length(fileExtCell)
                selChansCell = Struct2CellArray(LoadVar(['../ChanInfo/SelChan' fileExtCell{m} '.mat']));

                existVar = {'infoStruct'};
                sameSizeVar = {...
                    ['cohSpec.yo.ch' num2str(selChansCell{1,2})],...
                    ['crossSpec.yo.ch' num2str(selChansCell{1,2})],...
                    'eegSegTime',...
                    ['gammaCohMean40-100Hz.ch' num2str(selChansCell{1,2})],...
                    ['gammaCohMedian40-100Hz.ch' num2str(selChansCell{1,2})],...
                    ['gammaPhaseMean40-100Hz.ch' num2str(selChansCell{1,2})],...
                    'gammaPowIntg40-100Hz',...
                    'gammaPowMean40-100Hz',...
                    'gammaPowPeak40-100Hz',...
                    ['phaseSpec.yo.ch' num2str(selChansCell{1,2})],...
                    'powSpec.yo',...
                    'rawTrace',...
                    'taskType',...
                    ['thetaCohMean4-12Hz.ch' num2str(selChansCell{1,2})],...
                    ['thetaCohMedian4-12Hz.ch' num2str(selChansCell{1,2})],...
                    ['thetaPhaseMean4-12Hz.ch' num2str(selChansCell{1,2})],...
                    'thetaPowIntg4-12Hz',...
                    'thetaPowMean4-12Hz',...
                    'thetaPowPeak4-12Hz',...
                    'thetaFreq4-12Hz',...
                    'time',...
                    };

                if ~exist([spectAnalBase fileExtCell{m}],'dir')
                    fprintf(fid,'Dir Missing: %s%s/%s%s\n',analDirs{j},fileBase,spectAnalBase,fileExtCell{m});
                else
                    cd([spectAnalBase fileExtCell{m}])
                    for n=1:length(existVar)
                        try test = LoadVar([existVar{n} '.mat']);
                        catch
                            fprintf(fid,'File Missing: %s%s/%s%s/%s\n',analDirs{j},fileBase,spectAnalBase,fileExtCell{m},existVar{n});
                        end
                    end
                    if ~exist('time.mat','file')
                        fprintf(fid,'File Missing: %s%s/%s%s/%s\n',analDirs{j},fileBase,spectAnalBase,fileExtCell{m},'time.mat');
                    else
                        goodLen = length(LoadVar('time.mat'));
                        for n=1:length(sameSizeVar)
                            try testSize = size(LoadField(sameSizeVar{n}),1);
                                if testSize ~= goodLen
                                    fprintf(fid,'Short File: %s%s/%s%s/%s: %i vs time=%i\n',analDirs{j},fileBase,spectAnalBase,fileExtCell{m},sameSizeVar{n},testSize,goodLen);
                                end
                            catch
                                fprintf(fid,'File Missing: %s%s/%s%s/%s\n',analDirs{j},fileBase,spectAnalBase,fileExtCell{m},sameSizeVar{n});
                            end
                        end
                    end
                    cd ..
                end
            end
            cd ..
        end
    end
    fclose(fid);
end
return
