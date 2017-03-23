% ColorBarAll
%
% Adds a color bar to ever sub plot of the current figure

function ColorBarAll()

for a=get(gcf, 'Children')';
	set(gcf, 'CurrentAxes', a);
	colorbar;
end;