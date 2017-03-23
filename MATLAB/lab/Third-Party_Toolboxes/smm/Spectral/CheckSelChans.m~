function CheckSelChans(analDirs,varargin)
[fileExts runSpectDir remSpectDir] = DefaultArgs(varargin,{{'.eeg','_LinNearCSD121.csd'},...
    'CalcRunningSpectra11_noExp_MinSpeed0Win1250',...
    'CalcRemSpectra03_allTimes_Win1250'});
for j=1:length(analDirs)
    
    files = LoadVar([analDirs{j} 'FileInfo/MazeFiles']);
    for k=1:length(fileExts)
        selChanCell = Struct2CellArray(LoadVar([analDirs{j} 'ChanInfo/SelChan' fileExts{k}]));
        selChans = [selChanCell{:,end}];
        for m=1:length(files)
            cohSelCh = fieldnames(LoadField([analDirs{j} files{m} '/' runSpectDir fileExts{k} '/cohSpec.yo']));
            
            for n=1:length(selChans)
                if isempty(strfind(cohSelCh{n},num2str(selChans(n))))
                    fprintf('cohSelCh=%s,selChans=%s : %s\n',cohSelCh{n},num2str(selChans(n)),...
                        [analDirs{j} files{m} '/' runSpectDir fileExts{k}]);
                end
            end
        end
    end         
          
    files = LoadVar([analDirs{j} 'FileInfo/RemFiles']);
    for k=1:length(fileExts)
        selChanCell = Struct2CellArray(LoadVar([analDirs{j} 'ChanInfo/SelChan' fileExts{k}]));
        selChans = [selChanCell{:,end}];
        for m=1:length(files)
            cohSelCh = fieldnames(LoadField([analDirs{j} files{m} '/' remSpectDir fileExts{k} '/cohSpec.yo']));
            
            for n=1:length(selChans)
                if isempty(strfind(cohSelCh{n},num2str(selChans(n))))
                    fprintf('cohSelCh=%s,selChans=%s : %s\n',cohSelCh{n},num2str(selChans(n)),...
                        [analDirs{j} files{m} '/' remSpectDir fileExts{k}]);
                end
            end
        end
    end         
end