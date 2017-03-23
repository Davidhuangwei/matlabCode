% function MakeSpectraVar(analDirs, fileBaseCell, spectVarName, spectVarEntry,  ...
%     fileExtCell, spectAnalDir)
% Makes a new mat file in spectraDirs of the same length as 'time.mat'
% containing the specified entry in all rows. 
function MakeSpectraVar( fileBaseCell, spectVarName, spectVarEntry,  ...
    fileExtCell, spectAnalDir)

% for j=1:length(analDirs)
%     cd(analDirs{j})
%     fileBaseCell = {};
%     for k=1:length(filesNameCell)
%         fileBaseCell = cat(1,fileBaseCell,LoadVar([analDirs{j} 'FileInfo/' filesNameCell{k}]));
%     end
    for k=1:length(fileBaseCell)
        fprintf('\n%s',fileBaseCell{k})
%         cd(fileBaseCell{k})
        for m=1:length(fileExtCell)
%             cd([spectAnalDir fileExtCell{m}])
            fprintf('\n%s',[spectAnalDir fileExtCell{m}])
            destDir = [analDirs{j} fileBaseCell{k} '/' spectAnalDir fileExtCell{m} '/'];
            times = LoadVar([destDir 'time']);
            if exist([destDir spectVarName],'file')
                in  = '-';
                while ~strcmp(in,'') & ~strcmp(in,'y') & ~strcmp(in,'n')
                    in = input(['\n' spectVarName ' exists. Overwrite? y/[n]: '],'s');
                end
            else
                in = 'y';
            end
            if strcmp(in,'y')
                temp = repmat(spectVarEntry,length(times),1);
                eval([spectVarName ' = temp;']);
                save([destDir spectVarName '.mat'],SaveAsV6,spectVarName);
            end           
        end
    end
% end
