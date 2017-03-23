% h = ScaleBar(Left,Bottom,Width,Height,xlabel,ylabel, options)
%
% Draws a scale bar on the current plot
% bottom left corner is (x0,y0)
% size is (Width, Height)
% labels given by xlabel, ylabel
%
% options gives optional arguments to the text command, eg {'fontsize', 4', 'color', 'k'}
function h = ScaleBar(Left,Bottom,Width,Height,xlabel,ylabel, options)

if nargin<7
    options = {};
end

HoldState = ishold;

hold on



% Plot x line
hx = plot([Left, Left+Width], [Bottom, Bottom], 'k-');

% x label
hxl = text(Left + Width/2, Bottom, xlabel, ...
		'HorizontalAlignment', 'center', ...
		'VerticalAlignment', 'top', options{:});
		
% Plot y line
hy = plot([Left, Left], [Bottom, Bottom+Height], 'k-');

% y label
hyl = text(Left, Bottom + Height/2, ylabel, ...
		'HorizontalAlignment', 'right', ...
		'VerticalAlignment', 'middle', options{:});

if (HoldState==0)
	hold off
end

h = [hx hy hxl hyl];