function printfullcolor(figurenum,colorbool,orientation)
% function printfullcolor(figurenum,orientation,colorbool)
% DEFAULTS:
% figurenum = gcf
% colorbool = print in BW
% orientation = 'portrait'

if ~exist('figurenum', 'var')
    figurenum = gcf;
end
if ~exist('orientation', 'var')
     orientation = 'portrait';
end
if ~exist('colorbool', 'var')
    colorbool = 0;
end

figure(figurenum);

set(gcf,'PaperOrientation',orientation);
set(gcf,'PaperPosition',[0,0,8.5,11]);
set(gcf, 'Units', 'inches')       
set(gcf, 'Position', [0 0 8.5 11])
if colorbool
    set(gcf, 'inverthardcopy', 'off')
    oldcolor = get(gcf, 'color');
    set(gcf, 'color', [1 1 1]);
    
    print -Pbuzphaser -dpsc2
    
    set(gcf, 'color', oldcolor);
else
    print -Pbuzphaser -dpsc2
end