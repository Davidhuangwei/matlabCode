% function CpFile(fromFileName,toFileName,varargin)
% [autoOverwrite testBool] = DefaultArgs(varargin,{0,0});
% copies from -> to after OverwriteCheck if testBool=0
function CpFile(fromFileName,toFileName,varargin)
[autoOverwrite testBool] = DefaultArgs(varargin,{0,0});

if exist(fromFileName,'file')
    in = OverwriteCheck(toFileName,autoOverwrite);
    if ~strcmp(in,'n')
        if strcmp(in,'y')
            evalText = ['!rm ' toFileName]; % handles overwriting sym links
            EvalPrint(evalText,testBool);
        end
        evalText = ['!cp ' fromFileName ' ' toFileName];
        EvalPrint(evalText,testBool);
    end
else
    warning([mfilename ':FileDoesNotExist'],...
        ['FILE DOES NOT EXIST: ' fromFileName ' - Skipping...']);
end
