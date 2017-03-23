function DoubleColFig(height, width, orientation)
% DoubleColFig(height, width, orientation)
%
% makes paper and screen window the right size for a double column figure
% of width and height given by the argument in cm.  default width = 17cm
%
% default orientation 'p' for portrait, other choice 'l' for landscape.

if nargin<2
	width = 17;
end

if nargin<3
    orientation='p';
end

set(gcf, 'Units', 'centimeters') 
Position = get(gcf, 'Position');
Position(3:4) = [width height];
set(gcf, 'Position', Position);

if orientation=='l'
    set(gcf, 'PaperOrientation', 'Landscape');
else
    set(gcf, 'PaperOrientation', 'Portrait');
end

set(gcf, 'PaperUnits', 'centimeters');
Position = get(gcf, 'PaperPosition');
Position(3:4) = [width height];
Position(1:2) = (get(gcf, 'PaperSize')-Position(3:4))/2;
set(gcf, 'PaperPosition', Position);
