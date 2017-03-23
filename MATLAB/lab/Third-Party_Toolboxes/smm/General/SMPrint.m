function SMPrint(figureNumMat,colorBool,plotSize,portrait,printToFileBool,printLocation)
% function SMPrint(figureNumMat,colorBool,plotSize,portrait,printToFileBool,printLocation)
% plotSize: two element vector for width and height
% DEFAULTS:
%   figureNumMat = gcf
%   colorBool = 0 (print in BW)
%   plotSize = matlab default
%   portrait = 1 (portrait)
%   printToFileBool = 0
%   printLocation = buzphaser 

if ~exist('figureNumMat', 'var') | isempty(figureNumMat)
    figureNumMat = gcf;
end
if ~exist('portrait', 'var') | isempty(portrait)
    portrait = 1;
end
if ~exist('colorBool', 'var') | isempty(colorBool)
    colorBool = 0;
end
if ~exist('printLocation', 'var') | isempty(printLocation)
    printLocation = 'buzphaser';
end
if ~exist('printToFileBool', 'var') | isempty(printToFileBool)
    printToFileBool = 0;
end
if strcmp(printLocation,'buzlaser')
    colorBool = 0;
end


for i=1:length(figureNumMat)
    figure(figureNumMat(i));
    
    if exist('plotSize', 'var') & ~isempty(plotSize)
        if portrait
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
    if portrait
        set(gcf,'PaperOrientation','portrait');
    end
    if colorBool
        set(gcf, 'inverthardcopy', 'off')
        oldcolor = get(gcf, 'color');
        set(gcf, 'color', [1 1 1]);
        if printToFileBool == 1
            print('-dpsc2', printLocation)
        else
            print(['-P' printLocation], '-dpsc2')
        end
        set(gcf, 'color', oldcolor);
    else
        if printToFileBool == 1
            print('-dps2', printLocation)
        else
            print(['-P' printLocation], '-dps2')
        end
    end
end