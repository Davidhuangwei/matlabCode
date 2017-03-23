function SingleColFig(height)
% SingleColFig(height)
%
% makes paper and screen window the right size for a single column figure
% of width 8.7cm and height given by the argument in cm.

set(gcf, 'Units', 'centimeters') 
Position = get(gcf, 'Position');
Position(3:4) = [8.7 height];
set(gcf, 'Position', Position);
set(gcf, 'PaperOrientation', 'Portrait');

set(gcf, 'PaperUnits', 'centimeters');
Position = get(gcf, 'PaperPosition');
Position(3:4) = [8.7 height];
Position(1:2) = (get(gcf, 'PaperSize')-Position(3:4))/2;
set(gcf, 'PaperPosition', Position);
