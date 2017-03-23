function prevWarnSettings = SetWarnings(warnSettings)
%function prevWarnSettings = SetWarnings(warnSettings)
% sets warning states and returns struct array of previous states.
% warnSettings can be an n x 2 cell array where column 1 desgnates states and
% column 2 designates warnings. 
% Alternatively, warnSettings can be a struct array with fields "state" and
% "identifier".
if iscell(warnSettings)
    for j=1:size(warnSettings,1)
        prevWarnSettings(j) = warning(warnSettings{j,1},warnSettings{j,2});
    end
else
    for j=1:length(warnSettings)
        prevWarnSettings(j) = warning(warnSettings(j).state, warnSettings(j).identifier);
    end
end
return