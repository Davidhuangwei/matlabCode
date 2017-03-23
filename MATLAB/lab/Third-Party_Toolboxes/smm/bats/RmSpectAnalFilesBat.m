% function RmSpectAnalFilesBat(fileBaseCell,SpectAnalBaseCell,fileExtCell,regExp,varargin)
% rmOptions = DefaultArgs(varargin,{''});
%             evalText = ['!rm ' rmOptions ' ' SC(fileBaseCell{k}) SC([SpectAnalBaseCell{m} fileExtCell{n}]) regExp];
% tag:rm
% tag:spectral

function RmSpectAnalFilesBat(fileBaseCell,SpectAnalBaseCell,fileExtCell,regExp,varargin)
rmOptions = DefaultArgs(varargin,{''});

for k=1:length(fileBaseCell)
    for m=1:length(SpectAnalBaseCell)
        for n=1:length(fileExtCell)
            evalText = ['!rm ' rmOptions ' ' SC(fileBaseCell{k}) SC([SpectAnalBaseCell{m} fileExtCell{n}]) regExp];
            EvalPrint(evalText,0)
        end
    end
end

