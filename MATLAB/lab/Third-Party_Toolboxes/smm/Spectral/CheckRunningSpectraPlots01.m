function CheckRunningSpectraPlots01(analDirs,varargin)
[fileExts spectAnalBase thetaFreqRange] = DefaultArgs(varargin,...
    {{'.eeg','_LinNearCSD121.csd'}, 'CalcRunningSpectra11_noExp_MinSpeed0Win1250',[4 12]});
cwd = pwd;

for j=1:length(analDirs)
    cd(analDirs{j})

    mazeFiles = LoadVar('FileInfo/MazeFiles.mat');
    for k=1:length(mazeFiles)
        whl = load([mazeFiles{k} '/' mazeFiles{k} '.whl']);
        for m=1:length(fileExts)
            selChansStruct = LoadVar(['ChanInfo/SelChan' fileExts{m} '.mat']);
            chanMat = LoadVar(['ChanInfo/ChanMat' fileExts{m} '.mat']);
            badChan = load(['ChanInfo/BadChan' fileExts{m} '.txt']);
            goodChan = setdiff(chanMat(:),badChan);
            anatFields = fieldnames(selChansStruct);
            for a=1:length(anatFields)
                selectedChannels(a) = selChansStruct.(anatFields{a});
            end
            for a=1:length(selectedChannels)
                selChanNames{a} = ['ch' num2str(selectedChannels(a))];
            end
            
            eegSamp = LoadField([mazeFiles{k} '/' spectAnalBase fileExts{m} '/infoStruct.eegSamp']); 
            whlSamp = LoadField([mazeFiles{k} '/' spectAnalBase fileExts{m} '/infoStruct.whlSamp']);
            winLength = LoadField([mazeFiles{k} '/' spectAnalBase fileExts{m} '/infoStruct.winLength']);
            position = LoadField([mazeFiles{k} '/' spectAnalBase fileExts{m} '/position.p0']);
            time = LoadVar([mazeFiles{k} '/' spectAnalBase fileExts{m} '/time.mat']);
            eegSegTime = LoadVar([mazeFiles{k} '/' spectAnalBase fileExts{m} '/eegSegTime.mat']);
            rawTrace = LoadVar([mazeFiles{k} '/' spectAnalBase fileExts{m} '/rawTrace.mat']);
            powSpec = LoadVar([mazeFiles{k} '/' spectAnalBase fileExts{m} '/powSpec.mat']);
            cohSpec = LoadVar([mazeFiles{k} '/' spectAnalBase fileExts{m} '/cohSpec.mat']);
            phaseSpec = LoadVar([mazeFiles{k} '/' spectAnalBase fileExts{m} '/phaseSpec.mat']);
            thetaFreq = LoadVar([mazeFiles{k} '/' spectAnalBase fileExts{m} '/thetaFreq' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat']);
            
            whlWinLen = winLength/eegSamp*whlSamp;
            
%             time
%             eegSegTime/eegSamp*whlSamp
%             time*whlSamp+whlWinLen/2
%             size(whl)
%             position
%             size(position)
%             size(time)
            try
            figure

             ResizeFigs(gcf,[16 11]);
            subplot(2,3,1)
            hold on
            plot(whl(:,1),whl(:,2),'y.')
            for n=1:size(position,1)
                plot(whl(round([time(n)*whlSamp-whlWinLen/2:time(n)*whlSamp+whlWinLen/2]),1),...
                    whl(round([time(n)*whlSamp-whlWinLen/2:time(n)*whlSamp+whlWinLen/2]),2),'r')
                plot(position(n,1),position(n,2),'g.')
            end
            
            subplot(2,3,2)
             title(SaveTheUnderscores([analDirs{j} '/' mazeFiles{k} '/' spectAnalBase fileExts{m}]))
            hold on
            plot(whl(:,1),whl(:,2),'y.')
            for n=1:size(position,1)
                plot(whl(round([eegSegTime(n)/eegSamp*whlSamp:eegSegTime(n)/eegSamp*whlSamp+whlWinLen])',1),...
                    whl(round([eegSegTime(n)/eegSamp*whlSamp:eegSegTime(n)/eegSamp*whlSamp+whlWinLen])',2),'r')
                plot(position(n,1),position(n,2),'g.')
            end

            subplot(2,3,3);
            hold on
            pcolor(1:length(time),powSpec.fo,squeeze(powSpec.yo(:,selectedChannels(2),:))');
            shading 'flat'
            set(gca,'clim',[35 75],'ylim',[0,100]);
            colorbar
            plot(0.5+[1:length(time)],median(thetaFreq(:,goodChan),2),'w')
            plot(0.5+[1:length(time)],thetaFreq(:,selectedChannels(4)),'k')

            subplot(2,3,4);
            pcolor(1:length(time),cohSpec.fo,squeeze(cohSpec.yo.(selChanNames{2})(:,selectedChannels(3),:))');
            shading 'flat'
            set(gca,'clim',[0 1],'ylim',[0,100]);
            colorbar

            subplot(2,3,5);
            pcolor(1:length(time),phaseSpec.fo,angle(squeeze(phaseSpec.yo.(selChanNames{2})(:,selectedChannels(3),:)))');
            shading 'flat'
            set(gca,'clim',[-pi pi],'ylim',[0,100]);
            colorbar
            
            subplot(2,3,6);
            plot(squeeze(rawTrace(1,selectedChannels(4),:)))
            catch
                fprintf('ERROR: %s\n',[analDirs{j} '/' mazeFiles{k} '/' spectAnalBase fileExts{m}])
            end
        end
    end
end
cd(cwd)

