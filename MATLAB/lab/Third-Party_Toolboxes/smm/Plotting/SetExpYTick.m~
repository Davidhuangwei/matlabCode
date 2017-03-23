function SetExpYTick(varargin)
[yLimits, e] = DefaultArgs(varargin,{get(gca,'ylim'),1/2)

ticks = 5/2*2.^[0:10];
ticks = ticks(ticks>=yLimits(1) & ticks<=yLimits(2));
set(gca,'ytick',(ticks)^e)
set(gca,'yticklabel',ticks)
set(gca,'ylim',(yLimits)^e)