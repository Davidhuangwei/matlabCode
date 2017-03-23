% imagelog(x,y,c)
% plots imagesc of (x,y,c)
% taking log2(y) and changing the Yticks accordingly
% to compensate for that 

function imagelog(x,y,c)


Yticks = 2.^(fix(log2(min(y))):fix(log2(max(y))));
imagesc(x,log2(y),c);
set(gca,'YLim',log2([min(y),max(y)]), ...
	'YDir','reverse', ...
	'YTick',log2(Yticks(:)), ...
	'YTickLabel',Yticks);

