function printfullcolor2(figureNumMat,colorBool,plotSize,portrait,printer)
% function printfullcolor(figureNumMat,colorBool,plotSize,portrait)
% plotSize: two element vector for width and height
% DEFAULTS:
%   figureNumMat = gcf
%   colorBool = 0 (print in BW)
%   plotSize = matlab default
%   portrait = 1 (portrait)
%   printer = buzphaser

if ~exist('figureNumMat', 'var') | isempty(figureNumMat)
    figureNumMat = gcf;
end
if ~exist('portrait', 'var') | isempty(portrait)
    portrait = 1;
end
if ~exist('colorBool', 'var') | isempty(colorBool)
    colorBool = 0;
end
if ~exist('printer', 'var') | isempty(printer)
    printer = 'buzphaser';
end
if strcmp(printer,'buzlaser')
    colorBool = 0;
end


for i=1:length(figureNumMat)
    figure(figureNumMat(i));
    
    if exist('plotSize', 'var') & ~isempty(plotSize)
        if portrait == 1
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'PaperPosition',[(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)]);
            set(gcf, 'Units', 'inches')       
            set(gcf, 'Position', [(8.5-plotSize(1))/2,(11-plotSize(2))/2,plotSize(1),plotSize(2)])
        else
            set(gcf,'PaperOrientation','landscape');
            set(gcf,'PaperPosition',[(11-plotSize(1))/2,(8.5-plotSize(2))/2,plotSize(1),plotSize(2)]);
            set(gcf, 'Units', 'inches')       
            set(gcf, 'Position', [(11-plotSize(1))/2,(8.5-plotSize(2))/2,plotSize(1),plotSize(2)])
        end
    end
    if portrait == 1
        set(gcf,'PaperOrientation','portrait');
    end
    if colorBool
        set(gcf, 'inverthardcopy', 'off')
        oldcolor = get(gcf, 'color');
        set(gcf, 'color', [1 1 1]);
        
        print(['-P' printer], '-dpsc2')
        
        set(gcf, 'color', oldcolor);
    else
        print(['-P' printer], '-dps2')
    end
end