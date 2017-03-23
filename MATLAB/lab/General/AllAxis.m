function AllAxis(axissize);
children = get(gcf, 'Children')';
for i=1:length(children)
	set(gcf, 'CurrentAxes', children(i));
    axis(axissize);
end
