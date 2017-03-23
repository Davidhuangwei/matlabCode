% function outStruct = CatDesigVar(analDirs,dirName,depVar,analRoutine,varargin)
% [statsAnalFunc,catStructBool,catDim] = DefaultArgs(varargin,{'GlmWholeModel08',1,1});
% tag:cat
% tag:desig

function outStruct = CatDesigVar(analDirs,dirName,depVar,analRoutine,varargin)
[statsAnalFunc,catStructBool,catDim] = DefaultArgs(varargin,{'GlmWholeModel08',1,1});

cwd = pwd;
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' SC(statsAnalFunc) analRoutine]);
    outStruct(j) = LoadDesigVar(fileBaseCell,dirName,depVar,trialDesig);
%     dataCell = Struct2CellArray(LoadDesigVar(fileBaseCell,dirName,depVar,trialDesig),[],1);
%     for k=1:size(dataCell,1)
%         if j==1
%             catDataCell = dataCell;
%         else
%              catDataCell{k,end} = cat(1,catDataCell{k,end},dataCell{k,end});
%         end
%     end 
end
% outStruct = CellArray2Struct(catDataCell);
if catStructBool
    outStruct = num2cell(outStruct);
    outStruct = CatStruct(catDim,outStruct{:});
end

cd(pwd)
return