% function SetFigPos(varargin)
% [figs position units] = DefaultArgs(varargin,{gcf,[],'inches'});
function SetFigPos(varargin)
[figs position units] = DefaultArgs(varargin,{gcf,[],'inches'});

for j=1:length(figs)
    set(figs(j), 'Units', units)
    if isempty(position)
        set(figs(j), 'Position', get(figs(j), 'Position'));
    else
        set(figs(j), 'Position', position);
    end
    set(figs(j),'PaperPosition',get(figs(j),'Position'));
end
return