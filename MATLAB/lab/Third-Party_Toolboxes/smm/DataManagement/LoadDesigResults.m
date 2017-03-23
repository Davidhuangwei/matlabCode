% function desigResults = LoadDesigResults(analDirs,dirName,depVar,trialDesig)
function desigResults = LoadDesigResults(analDirs,dirName,depVar,glmVersion,analRoutine)

desigResults = [];
 cwd = pwd;
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' glmVersion '/' analRoutine '.mat'])

%     fileBaseCell
%     dirName
%     depVar
%     trialDesig
    fprintf([analDirs{j} '\n'])
%     fileBaseCell = {};
%     for k=1:length(filesNameCell)
%         fileBaseCell = cat(1,fileBaseCell,LoadVar(['FileInfo/' filesNameCell{k}]));
%     end
    desigResults = CatStruct(1,desigResults,LoadDesigVar(fileBaseCell,dirName,depVar,trialDesig));
end
cd(cwd);
return   

    
    
    