% ImageXLog(x,y,c)
% plots imagesc of (x,y,c)
% taking log2(x) and changing the Xticks accordingly
% to compensate for that 

function imagelog(x,y,c)


Xticks = 2.^(fix(log2(min(x))):fix(log2(max(x))));
imagesc(log2(x),y,c);
set(gca,'XLim',log2([min(x),max(x)]), ...
	'XDir','reverse', ...
	'XTick',log2(Xticks(:)), ...
	'XTickLabel',Xticks);

