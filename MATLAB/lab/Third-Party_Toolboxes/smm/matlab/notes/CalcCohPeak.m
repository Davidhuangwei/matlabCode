function CalcCohPeak(fileBaseMat,extCell,thetaFreqRange);

%dirBaseName = 'CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626';
dirBaseName = 'RemVsRun_noExp_MinSpeed0Win1250';

% oldDirBase = 'CalcRunningSpectra8';
% newDirBase = 'CalcRunningSpectra9';

%dirExtCell = {'_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'}

% dirExtCell = {'_noExp_MidPoints_MinSpeed0Win626.eeg';...
%           '_noExp_MidPoints_MinSpeed0Win626_LinNearCSD121.csd';...
%           %'_noExp_MidPoints_MinSpeed0Win626_NearAveCSD1.csd';...
%           '_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'};
currDir = pwd;
for j=1:size(fileBaseMat,1)
    fprintf('%s\n',fileBaseMat(j,:));
    for k=1:length(extCell)
        %selectedChannels = load(['ChanInfo/SelectedChannels' extCell{k} '.txt'])';
        
        cd(fileBaseMat(j,:))
        dirName = [dirBaseName extCell{k}];
        if ~exist(dirName,'dir')
            fprintf('\nERROR: %s not found\n',dirName)
        else
            cd(dirName);
            load('cohSpec.mat','-mat')
            load('thetaFreq.mat','-mat');

            for m=1:length(selChans)
                selChanName = ['ch' num2str(selChans(m))];
                for n=1:size(cohSpec.yo.(selChanName),1)
                    thetaCohPeakSelChF.(selChanName)(n,:) = cohSpec.yo.(selChanName)...
                        (n,:,find(abs(fs-thetaFreq(n,selChans(m)))==min(abs(fs-thetaFreq(n,selChans(m)))),1));
                end
            end
            for m=1:length(selChans)
                selChanName = ['ch' num2str(selChans(m))];
                for n=1:size(cohSpec.yo.(selChanName),1)
                    thetaCohPeakLMF.(selChanName)(n,:) = cohSpec.yo.(selChanName)...
                        (n,:,find(abs(fs-thetaFreq(n,selChans(3)))==min(abs(fs-thetaFreq(n,selChans(3)))),1));
                end
            end
            saveBase = '';
            save([saveBase 'thetaCohPeakSelChF' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohPeakSelChF');
            save([saveBase 'thetaCohPeakLMF' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohPeakLMF');
            clear thetaCohPeakSCF
            clear thetaCohPeakLMF
        end
        cd(currDir)
    end
end

return

%%%%%%% testing code %%%%%%%% 
baseNames = {'thetaPowPeak6-12Hz','thetaPowIntg6-12Hz','gammaPowPeak65-100Hz','gammaPowIntg65-100Hz'};
for j=1:length(baseNames)
    test = LoadVar(['Test_' baseNames{j} '.mat']);
    old = LoadVar([baseNames{j} '.mat']);
    if abs(test-old) > 10e-10
        fprintf('ERROR: %s failed 10e-10',baseNames{j});
    else
        fprintf('aok\n')
    end
end
baseNames = {'thetaCohMedian6-12Hz','thetaCohMean6-12Hz','thetaPhaseMean6-12Hz','gammaCohMedian65-100Hz','gammaCohMean65-100Hz','gammaPhaseMean65-100Hz'};
for j=1:length(baseNames)
    test = LoadVar(['Test_' baseNames{j} '.mat']);
    old = LoadVar([baseNames{j} '.mat']);
    fields = fieldnames(test);
    for k=1:length(fields)
        if test.(fields{k}) ~= old.(fields{k})
            fprintf('ERROR: %s failed 10e-10',baseNames{j});
        else
            fprintf('aok:%s%s\n',baseNames{j},fields{k})
        end
    end
end



