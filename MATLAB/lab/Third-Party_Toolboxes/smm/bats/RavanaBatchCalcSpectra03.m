
function RavanaBatchCalcSpectra03(analDirs,varargin)
% [sftpCommand scpOptions]= DefaultArgs(varargin,{'smm@urethane','-l 2000 -c "blowfish"'});
[files,fileExts,sftpCommand,rsyncOptions]= DefaultArgs(varargin,{[],{'.eeg',97;'_LinNearCSD121.csd',72},'smm@urethane','-LB 1000'})

for j=1:length(analDirs)
    if ~exist('analysis','dir')
        mkdir('analysis')
    end
    cd('analysis')
    eval(['!rsync -r ' rsyncOptions ' ' sftpCommand ':' analDirs{j} 'FileInfo .']);
    eval(['!rsync -r ' rsyncOptions ' ' sftpCommand ':' analDirs{j} 'ChanInfo .']);
    
    %%%%%%%%%%% maze files %%%%%%%%%%%%
    mazeFiles = LoadVar('FileInfo/MazeFiles');
    if ~isempty(files)
        mazeFiles = intersect(mazeFiles,files);
    end
    for k=1:length(mazeFiles)
        mkdir(mazeFiles{k})

        rsyncFiles = {[mazeFiles{k} '.whl'],[mazeFiles{k} '_whl_indexes.mat']};
        for m=1:size(fileExts,1)
            rsyncFiles = cat(2,rsyncFiles,[mazeFiles{k} fileExts{m,1}]);
        end
        rsyncFiles
        for m=1:length(rsyncFiles)
            eval(['!rsync ' rsyncOptions ' ' ...
                sftpCommand ':' analDirs{j} mazeFiles{k} '/' rsyncFiles{m} ' ' mazeFiles{k}]);
        end
     
        midPointsBool = 0;
        winLength = 1250;
        description = 'noExp';
        
        for m=1:size(fileExts,1)        
            CalcRunningSpectra11(description,mazeFiles(k),fileExts{m,1},fileExts{m,2},winLength,midPointsBool,[4 12],[40 100])
        end
        %CalcRunningSpectra11(description,mazeFiles(k),'_LinNearCSD121.csd',72,winLength,midPointsBool,[4 12],[40 100])
% mkdir([mazeFiles{k} '/CalcRunningSpectra11_junk'])
% eval(['!> ' mazeFiles{k} '/CalcRunningSpectra11_junk/junk'])
        eval(['!rsync -r ' rsyncOptions ' ' ...
            mazeFiles{k} '/CalcRunningSpectra11* ' sftpCommand ':' analDirs{j} mazeFiles{k}]);
        
        eval(['!rm -r ' mazeFiles{k}])
    end
    
    %%%%%%%%%%%%% rem files %%%%%%%%%%%%%
    remFiles = LoadVar('FileInfo/RemFiles');
    if ~isempty(files)
        remFiles = intersect(remFiles,files);
    end
    for k=1:length(remFiles)
        mkdir(remFiles{k})

        rsyncFiles = {'RemTimes.mat'};
        for m=1:size(fileExts,1)
            rsyncFiles = cat(2,rsyncFiles,[remFiles{k} fileExts{m,1}]);
        end
        rsyncFiles
        for m=1:length(rsyncFiles)
            eval(['!rsync ' rsyncOptions ' ' ...
                sftpCommand ':' analDirs{j} remFiles{k} '/' rsyncFiles{m} ' ' remFiles{k}]);
        end

        winLength = 1250;
        description = 'alltimes';

        for m=1:size(fileExts,1)
            CalcRemSpectra03('allTimes',remFiles(k),fileExts{m,1},fileExts{m,2},winLength,[4 12],[40 100])
        end
        % mkdir([remFiles{k} '/CalcRemSpectra03_junk'])
% eval(['!> ' remFiles{k} '/CalcRemSpectra03_junk/junk'])
        eval(['!rsync -r ' rsyncOptions ' ' ...
            remFiles{k} '/CalcRemSpectra03* ' sftpCommand ':' analDirs{j} remFiles{k}]);
       
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
files = {...
    'sm9601m3_084_s1_139',...
    'sm9601m3_101_s1_159',...
    'sm9601m3_124_s1_187',...
    'sm9601m3_138_s1_204',...
    'sm9601m3_077_s1_132',...
    }
fileExts = {...
    '.eeg',81;...
    }


