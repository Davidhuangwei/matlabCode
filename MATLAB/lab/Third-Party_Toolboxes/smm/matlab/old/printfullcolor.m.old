function printfullcolor(figurenummat,colorbool,fullpagebool,portrait)
% function printfullcolor(figurenummat,colorbool,fullpagebool,portrait)
% DEFAULTS:
% figurenummat = gcf
% colorbool = 0 (print in BW)
% fullpagebool = 1 (full page)
% portrait = 1 (portrait)

if ~exist('figurenummat', 'var')
    figurenummat = gcf;
end
if ~exist('portrait', 'var')
    portrait = 1;
end
if ~exist('fullpagebool', 'var')
    fullpagebool = 1;
end
if ~exist('colorbool', 'var')
    colorbool = 0;
end
for i=1:length(figurenummat)
    figure(figurenummat(i));
    
    if fullpagebool
        if portrait == 1
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'PaperPosition',[0,0,8.5,11]);
            set(gcf, 'Units', 'inches')       
            set(gcf, 'Position', [0 0 8.5 11])
        else
            set(gcf,'PaperOrientation','landscape');
            set(gcf,'PaperPosition',[0,0,11,8.5]);
            set(gcf, 'Units', 'inches')       
            set(gcf, 'Position', [0 0 11 8.5])
        end
    end
    if portrait == 1
        set(gcf,'PaperOrientation','portrait');
    end
    if colorbool
        set(gcf, 'inverthardcopy', 'off')
        oldcolor = get(gcf, 'color');
        set(gcf, 'color', [1 1 1]);
        
        print -Pbuzphaser -dpsc2
        
        set(gcf, 'color', oldcolor);
    else
        print -Pbuzphaser -dps2
    end
end