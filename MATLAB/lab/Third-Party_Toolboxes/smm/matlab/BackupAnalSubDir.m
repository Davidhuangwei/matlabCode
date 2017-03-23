% function BackupAnalSubDir(analDirs,outDir,varargin)
% backupDirCell = DefaultArgs(varargin,{{'ChanInfo/','FileInfo/','NewFigs/'}});
function BackupAnalSubDir(analDirs,outDir,varargin)
backupDirCell = DefaultArgs(varargin,{{'ChanInfo/','FileInfo/','NewFigs/'}});

for j=1:length(analDirs)
    if ~exist([outDir analDirs{j}],'dir')
        mkdir([outDir analDirs{j}])
    end
    for k=1:length(backupDirCell)
        evalText = ['!cp -r ' analDirs{j} backupDirCell{k} ' ' outDir analDirs{j}];
        fprintf('%s\n',evalText)
         eval(evalText);
    end
%     evalText = ['!cp -r ' analDirs{j} 'FileInfo/ ' outDir analDirs{j}];
%     fprintf('%s\n',evalText)
%     %     eval(evalText);
%     evalText = ['!cp -r ' analDirs{j} 'NewFigs/ ' outDir analDirs{j}];
%     fprintf('%s\n',evalText)
%     %     eval(evalText);
end