function BackupChanFileInfo(analDirs,outDir)

for j=1:length(analDirs)
    if ~exist([outDir analDirs{j}],'dir')
        mkdir([outDir analDirs{j}])
    end
    evalText = ['!cp -r ' analDirs{j} 'ChanInfo/ ' outDir analDirs{j}];
    fprintf('%s\n',evalText)
    %     eval(evalText);%     eval(evalText);
    evalText = ['!cp -r ' analDirs{j} 'FileInfo/ ' outDir analDirs{j}];
    fprintf('%s\n',evalText)
    %     eval(evalText);%     eval(evalText);
    evalText = ['!cp -r ' analDirs{j} 'NewFigs/ ' outDir analDirs{j}];
    fprintf('%s\n',evalText)
    %     eval(evalText);%     eval(evalText);
end