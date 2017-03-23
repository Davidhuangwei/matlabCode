function varargout = DefaultParam(params,paramFileName,defaultParams)
% function varargout = DefaultParam(params,paramFileName,defaultParams)
% Allows a parameter file to specify "local" default parameters that will 
% be used before resorting to "global" defaultParams.
% POSSIBLE USE:
% A Param directory can be created for each experiment containing
% FunctionName.param files for each desired function. If this directory is
% loaded into the matlab path, these files will specify "local" parameters that 
% will be used before the "global" defaults specified in the function.
% REQUIRES:
% LoadVar.m - useful function for loading single varible .mat files
% DefaultArgs.m - useful function for specifying default args

varargout = cell(1,nargout);

[varargout{:}] = DefaultArgs(params,varargout);

if exist(paramFileName,'file')
    fileParams = LoadVar(paramFileName);
    [varargout{:}] = DefaultArgs(varargout,fileParams);
else
    warning([mfilename ':usingDefaultParam'],...
        ['FILE NOT FOUND: ' paramFileName ' - USING DEFAULT PARAMS'])
end

[varargout{:}] = DefaultArgs(varargout,defaultParams);

