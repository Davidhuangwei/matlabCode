% function outText = OverwriteCheck(oldFile,varargin)
% autoOverwrite = DefaultArgs(varargin,{0});
% If file exists queries user for overwrite command (y/n) else returns []
function outText = OverwriteCheck(oldFile,varargin)
autoOverwrite = DefaultArgs(varargin,{0});

outText = [];
if exist(oldFile,'file')
    if autoOverwrite
        outText = 'y';
    else
        while ~strcmp(outText,'y') & ~strcmp(outText,'n')
            outText = input(['FILE EXISTS: ' oldFile ' - Overwrite? (y/n) '],'s');
        end
    end
end

