function CpAnalFilesBat(analDirs,fileBaseNames,regExp)

for j=1:length(analDirs)
    for m=1:length(fileBaseNames)
        fileBaseCell = LoadVar([analDirs{j} 'FileInfo/' fileBaseNames{m}]);
        for k=1:length(fileBaseCell)
            if exist([analDirs{j} fileBaseCell{k} '/' regExp],'file')
                fprintf('File Exists: %s\n',[analDirs{j} fileBaseCell{k} '/' toSpectAnalDir '/' regExp])
                intext = 'empty';
                while ~strcmp(intext,'y') &  ~strcmp(intext,'n') & ~strcmp(intext,'')
                    intext = input('Overwrite? [n]/y','s')
                end
            else
                intext = 'y';
            end
            if ~strcmp(intext,'n')
                evalText = ['!cp ' analDirs{j} fileBaseCell{k} '/' fromSpectAnalDir '/' regExp ' '...
                    analDirs{j} fileBaseCell{k} '/' toSpectAnalDir '/'];
                fprintf('%s\n',evalText)
                eval(evalText);
            end
        end
    end
end