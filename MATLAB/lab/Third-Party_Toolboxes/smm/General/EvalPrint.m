% function EvalPrint(evalText,testBool)
% testBool = DefaultArgs(varargin,{0})
% prints evalText & evaluates if testBool=0
function EvalPrint(evalText,varargin)
testBool = DefaultArgs(varargin,{0});

fprintf('%s\n',evalText)
if ~testBool
    eval(evalText)
end