% function MakeSpectraVar( fileBaseCell, spectVarName, spectVarEntry,  ...
%     fileExtCell, spectAnalBase)
% Makes a new mat file in spectraDirs of the same length as 'time.mat'
% containing the specified entry in all rows. 
% tag:make
% tag:spectral
% tag:var

function MakeSpectraVar(fileBaseCell, spectVarName, spectVarEntry,  ...
    fileExtCell, spectAnalBase)

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
%             cd([spectAnalBase fileExtCell{m}])
            fprintf('\n%s',[spectAnalBase fileExtCell{m}])
            destDir = [SC(fileBaseCell{k}) spectAnalBase fileExtCell{m} '/'];
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
                eval([GenFieldName(spectVarName) ' = temp;']);
                save([destDir spectVarName '.mat'],SaveAsV6,GenFieldName(spectVarName));
            end           
        end
    end
% end
