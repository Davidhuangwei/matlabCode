
function RavanaBatchCalcSpectra(analDirs,varargin)
% [sftpCommand scpOptions]= DefaultArgs(varargin,{'smm@urethane','-l 2000 -c "blowfish"'});
[files,sftpCommand scpOptions sftpOptions]= DefaultArgs(varargin,{[],'smm@urethane','','-B 1000'});



for j=1:length(analDirs)
    if ~exist('analysis','dir')
        mkdir('analysis')
    end
    %     if ~exist('processed','dir')
    %         mkdir('processed')
    %     end
    cd('analysis')
    if ~exist('ChanInfo','dir')
        mkdir('ChanInfo')
    end
    if ~exist('FileInfo','dir')
        mkdir('FileInfo')
    end

    eval(['!scp ' scpOptions ' ' sftpCommand ':' analDirs{j} 'FileInfo/* ./FileInfo/']);
    eval(['!scp ' scpOptions ' '  sftpCommand ':' analDirs{j} 'ChanInfo/* ./ChanInfo/']);
    mazeFiles = LoadVar('FileInfo/MazeFiles');
    if ~isempty(files)
        mazeFiles = intersect(mazeFiles,files);
    end
    for k=1:length(mazeFiles)
        mkdir(mazeFiles{k})
        eval(['!echo "mget ' analDirs{j} mazeFiles{k} '/* ' mazeFiles{k} '" > sftpBatchFile']);
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);

        midPointBool = 0;
        if midPointBool
            midPtext = '_MidPoints';
        else
            midPtext = '';
        end
        winLength = 1250;
        description = 'noExp';
        analName = 'CalcRunningSpectra11';

        CalcRunningSpectra11(description,mazeFiles(k),'.eeg',97,winLength,midPointBool,[4 12],[40 100])
        saveDir = [mazeFiles{k} '/' analName '_' description midPtext '_MinSpeed0' ...
            'Win' num2str(winLength) '.eeg'];
        eval(['!echo "mkdir ' analDirs{j} saveDir '" > sftpBatchFile']);
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);
        eval(['!echo "mput ' saveDir '/* ' analDirs{j} saveDir '" > sftpBatchFile'])
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);


        CalcRunningSpectra11(description,mazeFiles(k),'_LinNearCSD121.csd',72,winLength,midPointBool,[4 12],[40 100])
         saveDir = [mazeFiles{k} '/' analName '_' description midPtext '_MinSpeed0' ...
            'Win' num2str(winLength) '_LinNearCSD121.csd'];
        eval(['!echo "mkdir ' analDirs{j} saveDir '" > sftpBatchFile']);
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);
        eval(['!echo "mput ' saveDir '/* ' analDirs{j} saveDir '" > sftpBatchFile'])
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);
        
        eval(['!rm -r ' mazeFiles{k}])
    end
    remFiles = LoadVar('FileInfo/RemFiles');
    if ~isempty(files)
        remFiles = intersect(remFiles,files);
    end
    for k=1:length(remFiles)
        mkdir(remFiles{k})
        eval(['!echo "mget ' analDirs{j} remFiles{k} '/* ' remFiles{k} '" > sftpBatchFile']);
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);
        
        winLength = 1250;
        description = 'alltimes';
        analName = 'CalcRemSpectra03';

        CalcRemSpectra03('allTimes',remFiles(k),'.eeg',97,winLength,[4 12],[40 100])
        saveDir = [remFiles{k} '/' analName '_' description '_Win' num2str(winLength) '.eeg'];
        eval(['!echo "mkdir ' analDirs{j} saveDir '" > sftpBatchFile']);
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);
        eval(['!echo "mput ' saveDir '/* ' analDirs{j} saveDir '" > sftpBatchFile'])
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);

        CalcRemSpectra03('allTimes',remFiles(k),'_LinNearCSD121.csd',72,winLength,[4 12],[40 100])
        saveDir = [remFiles{k} '/' analName '_' description '_Win' num2str(winLength) '_LinNearCSD121.csd'];
        eval(['!echo "mkdir ' analDirs{j} saveDir '" > sftpBatchFile']);
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);
        eval(['!echo "mput ' saveDir '/* ' analDirs{j} saveDir '" > sftpBatchFile'])
        eval(['!sftp ' sftpOptions ' -b sftpBatchFile ' sftpCommand]);
        
        eval(['!rm -r ' remFiles{k}])
    end
    cd ..
    eval('!rm -r analysis')
end
% for j=1:length(analDirs)
%     remFiles = LoadVar('FileInfo/RemFiles');
%     for k=1:length(remFiles)
%         CalcRemSpectra03('allTimes',remFiles{k},'.eeg',97,winLength,[4 12],[40 100])
%         CalcRemSpectra03('allTimes',remFiles{k},'_LinNearCSD121.csd',72,winLength,[4 12],[40 100])
%     end
% end

return
analDirs = {...
    '/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    }
analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
}
