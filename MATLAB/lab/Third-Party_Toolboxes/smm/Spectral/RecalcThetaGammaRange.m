function RecalcThetaGammaRange(fileBaseMat,extCell,thetaFreqRange,gammaFreqRange);

dirBaseName = 'CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626';
%dirBaseName = 'RemVsRun_noExp_MinSpeed0Win1250';

% oldDirBase = 'CalcRunningSpectra8';
% newDirBase = 'CalcRunningSpectra9';

%dirExtCell = {'_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'}

% dirExtCell = {'_noExp_MidPoints_MinSpeed0Win626.eeg';...
%           '_noExp_MidPoints_MinSpeed0Win626_LinNearCSD121.csd';...
%           %'_noExp_MidPoints_MinSpeed0Win626_NearAveCSD1.csd';...
%           '_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'};
try
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
            load('powSpec.mat','-mat')
            powSpec.yo = 10.^(powSpec.yo./10);
            fo = powSpec.fo;

            if ~isempty(thetaFreqRange)
                thetaPowPeak = squeeze(10.*log10(max(powSpec.yo(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),[],3)));
                thetaPowIntg = squeeze(10.*log10(sum(powSpec.yo(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),3)));
            end
            if ~isempty(gammaFreqRange)
                gammaPowPeak = squeeze(10.*log10(max(powSpec.yo(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),[],3)));
                gammaPowIntg = squeeze(10.*log10(sum(powSpec.yo(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),3)));
            end
                                   
            load('cohSpec.mat','-mat')
            load('phaseSpec.mat','-mat')
            fo = cohSpec.fo;
            selectedChannels = fieldnames(cohSpec.yo);
            
            for m=1:length(selectedChannels)
                %selChanName = ['ch' num2str(selectedChannels(m))];
                selChanName = selectedChannels{m};
                waveCoh = cohSpec.yo.(selChanName);
                wavePhase = phaseSpec.yo.(selChanName);
                                
                if ~isempty(thetaFreqRange)
                    thetaCohMedian.(selChanName) = squeeze(median(waveCoh(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),3));
                    thetaCohMean.(selChanName) = squeeze(mean(waveCoh(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),3));
                    thetaPhaseMean.(selChanName) = squeeze(mean(wavePhase(:,:,find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))),3));
                end
                if ~isempty(gammaFreqRange)
                    gammaCohMedian.(selChanName) = squeeze(median(waveCoh(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),3));
                    gammaCohMean.(selChanName) = squeeze(mean(waveCoh(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),3));
                    gammaPhaseMean.(selChanName) = squeeze(mean(wavePhase(:,:,find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))),3));
                end

            end
            saveBase = '';
            if ~isempty(thetaFreqRange)
%                 save([saveBase 'thetaPowPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowPeak');
%                 save([saveBase 'thetaPowIntg' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowIntg');
%                 save([saveBase 'thetaCohMedian' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMedian');
                save([saveBase 'thetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMean');
%                 save([saveBase 'thetaPhaseMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPhaseMean');
            end
            if ~isempty(gammaFreqRange)
                save([saveBase 'gammaPowPeak' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowPeak');
                save([saveBase 'gammaPowIntg' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowIntg');
                save([saveBase 'gammaCohMedian' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMedian');
                save([saveBase 'gammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMean');
                save([saveBase 'gammaPhaseMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPhaseMean');
            end
            clear thetaPowPeak;
            clear thetaPowIntg;
            clear thetaCohMedian;
            clear thetaCohMean;
            clear thetaPhaseMean;
            clear gammaPowPeak;
            clear gammaPowIntg;
            clear gammaCohMedian;
            clear gammaCohMean;
            clear gammaPhaseMean;
        end
        cd(currDir)
    end
end
catch
fileBaseMat(j,:)
extCell{k}
    keyboard
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



