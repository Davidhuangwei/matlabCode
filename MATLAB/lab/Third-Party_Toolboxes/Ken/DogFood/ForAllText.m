% ForAllText(Cmd)
%
% Evaluates Cmd all axis labels, titles, and tickmarks
% of current figure.  text handle is h, so you can run
% ForAllText('set(h,''fontsize'',2)');

function ForAllText(Cmd)

ax = get(gcf, 'children');

for a=ax(:)'
	h = a;
	eval(Cmd);
	h = get(a, 'title');
	eval(Cmd);
	h = get(a, 'xlabel');
	eval(Cmd);
	h = get(a, 'ylabel');
	eval(Cmd);
end
