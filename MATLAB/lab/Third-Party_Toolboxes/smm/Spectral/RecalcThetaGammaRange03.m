function RecalcThetaGammaRange03(fileBaseCell,extCell,thetaFreqRange,gammaFreqRange,dirBaseName);
%function RecalcThetaGammaRange03(fileBaseCell,extCell,thetaFreqRange,gammaFreqRange,dirBaseName);


%dirBaseName = DefaultArgs(varargin,{'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8'});
%dirBaseName = 'RemVsRun_noExp_MinSpeed0Win1250';

% oldDirBase = 'CalcRunningSpectra8';
% newDirBase = 'CalcRunningSpectra9';

%dirExtCell = {'_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'}

% dirExtCell = {'_noExp_MidPoints_MinSpeed0Win626.eeg';...
%           '_noExp_MidPoints_MinSpeed0Win626_LinNearCSD121.csd';...
%           %'_noExp_MidPoints_MinSpeed0Win626_NearAveCSD1.csd';...
%           '_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'};

saveVarCell = {...
    'thetaPowPeak',...
    'thetaPowIntg',...
    'thetaPowMean',...
    'thetaCohMean',...
    'thetaPhaseMean',...
    'gammaPowIntg',...
    'gammaPowMean',...
    'gammaCohMean',...
    'gammaPhaseMean',...
    %     'gammaPowPeak',...
    %     'thetaCohMedian',...
    %     'gammaCohMedian',...
    };

infoStruct = [];

try
    currDir = pwd;
    for j=1:length(fileBaseCell)
        fprintf('%s\n',fileBaseCell{j});
        for k=1:length(extCell)
            %selectedChannels = load(['ChanInfo/SelectedChannels' extCell{k} '.txt'])';

            cd(fileBaseCell{j})
            dirName = [dirBaseName extCell{k}];
            if ~exist(dirName,'dir')
                fprintf('\nERROR: %s not found\n',dirName)
            else
                cd(dirName);
                load('powSpec.mat','-mat')
                powSpec.yo = 10.^(powSpec.yo./10);
                fo = powSpec.fo;

                %%% calculate bin size for performing integration %%%
                if fo(1) > fo(end)
                    diffSign = -1;
                else
                    diffSign = 1;
                end
                diff1 = diffSign*diff([fo(1) fo]);
                diff2 = diffSign*diff([fo fo(end)]);
                diffsum = diff1 + diff2;
                diffdiv = [1 2*ones(1,length(diffsum)-2) 1];
                binSize = permute(diffsum./diffdiv,[3 1 2]);

                if ~isempty(thetaFreqRange)
                    thetaPowPeak = squeeze(10.*log10(max(powSpec.yo(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[],3)));
                    thetaPowIntg = squeeze(10.*log10(sum(powSpec.yo(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                        .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(powSpec.yo,1),size(powSpec.yo,2),1]),3)));
                    thetaPowMean = squeeze(10.*log10(sum(powSpec.yo(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                        .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(powSpec.yo,1),size(powSpec.yo,2),1]),3)...
                        /sum(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)))));
                end
                if ~isempty(gammaFreqRange)
                    gammaPowPeak = squeeze(10.*log10(max(powSpec.yo(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[],3)));
                    gammaPowIntg = squeeze(10.*log10(sum(powSpec.yo(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))...
                        .*repmat(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[size(powSpec.yo,1),size(powSpec.yo,2),1]),3)));
                    gammaPowMean = squeeze(10.*log10(sum(powSpec.yo(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))...
                        .*repmat(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[size(powSpec.yo,1),size(powSpec.yo,2),1]),3)...
                        /sum(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)))));
                end


                load('cohSpec.mat','-mat')
                load('phaseSpec.mat','-mat')
                fo = cohSpec.fo;
                selectedChannels = fieldnames(cohSpec.yo);

                %%% calculate bin sizes for integration/mean calculation %%%
                if fo(1) > fo(end)
                    diffSign = -1;
                else
                    diffSign = 1;
                end
                diff1 = diffSign*diff([fo(1) fo]);
                diff2 = diffSign*diff([fo fo(end)]);
                diffsum = diff1 + diff2;
                diffdiv = [1 2*ones(1,length(diffsum)-2) 1];
                binSize = permute(diffsum./diffdiv,[3 1 2]);

                for m=1:length(selectedChannels)
                    %selChanName = ['ch' num2str(selectedChannels(m))];
                    selChanName = selectedChannels{m};
                    waveCoh = cohSpec.yo.(selChanName);
                    wavePhase = phaseSpec.yo.(selChanName);

                    if ~isempty(thetaFreqRange)
                        thetaCohMedian.(selChanName) = squeeze(median(waveCoh(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),3));
                        thetaCohMean.(selChanName) = squeeze(sum(waveCoh(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                            .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(waveCoh,1),size(waveCoh,2),1]),3)...
                            /sum(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))));
                        thetaPhaseMean.(selChanName) = squeeze(sum(wavePhase(:,:,fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))...
                            .*repmat(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),[size(wavePhase,1),size(wavePhase,2),1]),3)...
                            /sum(binSize(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2))));
                    end
                    if ~isempty(gammaFreqRange)
                        gammaCohMedian.(selChanName) = squeeze(median(waveCoh(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),3));
                        gammaCohMean.(selChanName) = squeeze(sum(waveCoh(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))...
                            .*repmat(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[size(waveCoh,1),size(waveCoh,2),1]),3)...
                            /sum(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))));
                        gammaPhaseMean.(selChanName) = squeeze(sum(wavePhase(:,:,fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))...
                            .*repmat(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),[size(wavePhase,1),size(wavePhase,2),1]),3)...
                            /sum(binSize(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2))));
                    end

                end
                saveBase = '';
                if ~isempty(thetaFreqRange)
                    if ~isempty(intersect(saveVarCell,'thetaPowPeak'))
                        save([saveBase 'thetaPowPeak' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowPeak');
                    end
                    if ~isempty(intersect(saveVarCell,'thetaPowIntg'))
                        save([saveBase 'thetaPowIntg' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowIntg');
                    end
                    if ~isempty(intersect(saveVarCell,'thetaPowMean'))
                        save([saveBase 'thetaPowMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPowMean');
                    end
                    if ~isempty(intersect(saveVarCell,'thetaCohMedian'))
                        save([saveBase 'thetaCohMedian' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMedian');
                    end
                    if ~isempty(intersect(saveVarCell,'thetaCohMean'))
                        save([saveBase 'thetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaCohMean');
                    end
                    if ~isempty(intersect(saveVarCell,'thetaPhaseMean'))
                        save([saveBase 'thetaPhaseMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],SaveAsV6,'thetaPhaseMean');
                    end
                end
                if ~isempty(gammaFreqRange)
                    if ~isempty(intersect(saveVarCell,'gammaPowPeak'))
                        save([saveBase 'gammaPowPeak' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowPeak');
                    end
                    if ~isempty(intersect(saveVarCell,'gammaPowIntg'))
                        save([saveBase 'gammaPowIntg' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowIntg');
                    end
                    if ~isempty(intersect(saveVarCell,'gammaPowMean'))
                        save([saveBase 'gammaPowMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPowMean');
                    end
                    if ~isempty(intersect(saveVarCell,'gammaCohMedian'))
                        save([saveBase 'gammaCohMedian' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMedian');
                    end
                    if ~isempty(intersect(saveVarCell,'gammaCohMean'))
                        save([saveBase 'gammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaCohMean');
                    end
                    if ~isempty(intersect(saveVarCell,'gammaPhaseMean'))
                        save([saveBase 'gammaPhaseMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.mat'],SaveAsV6,'gammaPhaseMean');
                    end
                end
                clear thetaPowPeak;
                clear thetaPowIntg;
                clear thetaPowMean;
                clear thetaCohMedian;
                clear thetaCohMean;
                clear thetaPhaseMean;
                clear gammaPowPeak;
                clear gammaPowIntg;
                clear gammaPowMean;
                clear gammaCohMedian;
                clear gammaCohMean;
                clear gammaPhaseMean;
            end
        end
    end
catch
    ReportError(['/u12/smm/BatchLogs/MatlabLog.txt'],...
        ['ERROR:  ' date '  mfilename  ' fileBaseCell{j} '  ' extCell{k} '  ' ...
        'theta=' num2str(thetaFreqRange) 'hz  gamma=' ...
        num2str(gammaFreqRange) '  ' dirBaseName '\n']);
    cd(currDir);
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

chan=37;
spectVar = 'powSpec.yo';
freqVar = 'powSpec.fo';
tfr = [6 12];
gfr = [40 60;40 100;40 120;50 100;50 120;60 120];
thetaPowVars = {...
    ['thetaPowMean' num2str(tfr(1)) '-' num2str(tfr(2)) 'Hz'],...
    ['thetaPowIntg' num2str(tfr(1)) '-' num2str(tfr(2)) 'Hz'],...
    };
for j=1:size(gfr,1)
gammaPowVars{j} = ['gammaPowMean' num2str(gfr(j,1)) '-' num2str(gfr(j,2)) 'Hz'];
%     ['gammaPowIntg' num2str(gfr(1)) '-' num2str(gfr(2)) 'Hz'],...
end
% gammaPowVars = {...
%     ['gammaPowMean' num2str(gfr(1)) '-' num2str(gfr(2)) 'Hz'],...
%     ['gammaPowIntg' num2str(gfr(1)) '-' num2str(gfr(2)) 'Hz'],...
%     };
for j=1:length(thetaPowVars)
    thetaPow{j} = LoadVar(thetaPowVars{j});
end
for j=1:length(gammaPowVars)
    gammaPow{j} = LoadVar(gammaPowVars{j});
end
yo = LoadField(spectVar);
fs = LoadField(freqVar);
for j=1:size(yo,1)
    figure(1)
    clf
    plot(fs,squeeze(yo(j,chan,:)),'k');
    hold on
    for k=1:length(thetaPow)
        plot(tfr,[thetaPow{k}(j,chan) thetaPow{k}(j,chan)])
    end
    for k=1:length(gammaPow)
        plot(gfr(k,:),[gammaPow{k}(j,chan) gammaPow{k}(j,chan)])
    end
    set(gca,'xlim',[0 150],'xtick',[0:20:140],'ylim',[40 90])
    grid on
    if ~isempty(input('any input breaks: ','s'))
        break
    end
end


