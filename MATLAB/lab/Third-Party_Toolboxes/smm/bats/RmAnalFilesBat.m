% function RmAnalFilesBat(fileBaseCell,regExp,varargin)
% rmOptions = DefaultArgs(varargin,{''});
%     evalText = ['!rm ' rmOptions ' ' SC(fileBaseCell{k}) regExp];
% tag:rm
% tag:anal
% tag:data management
function RmAnalFilesBat(fileBaseCell,regExp,varargin)
rmOptions = DefaultArgs(varargin,{''});

for k=1:length(fileBaseCell)
    evalText = ['!rm ' rmOptions ' ' SC(fileBaseCell{k}) regExp];
    EvalPrint(evalText,0)
end
