% function CpSpectAnalFilesBat(fileBaseCell,fromSpectAnalDir,toSpectAnalDir,regExp)
% [toFileName testBool] = DefaultArgs(varargin,{[],0});
% Use with AnalDirBat for maximum pleasure
% tag:cp
% tag:spectral
% 
function CpSpectAnalFilesBat(fileBaseCell,fromSpectAnalDir,toSpectAnalDir,regExp,varargin)
[toFileName testBool] = DefaultArgs(varargin,{[],0});
if isempty(toFileName)
    toText = regExp;
else
    toText = toFileName;
end
% for j=1:length(analDirs)
%     for m=1:length(fileBaseNames)
%         fileBaseCell = LoadVar([analDirs{j} 'FileInfo/' fileBaseNames{m}]);
        for k=1:length(fileBaseCell)
            if exist([SC(fileBaseCell{k}) SC(toSpectAnalDir) toText],'file')
                fprintf('File Exists: %s\n',[SC(fileBaseCell{k}) SC(toSpectAnalDir) toText])
                intext = 'empty';
                while ~strcmp(intext,'y') &  ~strcmp(intext,'n') & ~strcmp(intext,'')
                    intext = input('Overwrite? [n]/y : ','s');
                end
            else
                intext = 'y';
            end
            
            if ~strcmp(intext,'n')
                evalText = ['!cp ' SC(fileBaseCell{k}) SC(fromSpectAnalDir) regExp ' '...
                    SC(fileBaseCell{k}) SC(toSpectAnalDir)];
                if ~isempty(toFileName)
                    evalText = [evalText toFileName];
                end
                EvalPrint(evalText,testBool)
            end
        end
%     end
% end