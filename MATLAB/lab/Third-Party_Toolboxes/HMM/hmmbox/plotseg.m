function [] = plotseg(Xseries,s,y,T,ns,y_lower,y_upper,dleft,dright,sec_offset)

% function [] = plotseg(Xseries,s,y,T,ns,y_lower,y_upper,dleft,dright,sec_offset)
% Xseries       original data
% s             state
% y             other variable
% T             length of series in seconds
% ns            sampling rate
% y_lower       axis scaling
% y_upper       more axis scaling
% dleft         left movement cue
% dright        right movement cue

% Check arguments
if nargin < 4, error('plothmm6 needs at least four arguments'); end
if nargin < 5 | isempty(ns), ns=125; end
if nargin < 6 | isempty(y_lower), y_lower=0; end
if nargin < 7 | isempty(y_upper), y_upper=8; end
if ~exist('sec_offset'), sec_offset=0; end

figure
figs=4;
t=[1/ns:1/ns:T];
for i=1:figs,
    subplot(figs,1,i);
    start=(i-1)*T/figs*ns+1;
    stop=start+T/figs*ns-1;
    dstart=start+sec_offset*ns;
    dstop=stop+sec_offset*ns;
    plot(t(start:stop)+sec_offset,Xseries(start:stop)+6);
    hold on
    if length(s)>0
	    plot(t(start:stop)+sec_offset,s(start:stop));
    end
    if length(y)>0
	    plot(t(start:stop)+sec_offset,y(start:stop),'-');
    end
    axis([start/ns+sec_offset stop/ns+sec_offset y_lower y_upper]);
    if exist('dleft')
      plot(t(start:stop)+sec_offset,15*dleft(dstart:dstop)'-5,'b:');
    end
    if exist('dright')
      plot(t(start:stop)+sec_offset,15*dright(dstart:dstop)'-5,'b:');
    end
    set(gca,'YTickMode','manual','YTick',[]);
    set(gca,'Fontsize',18);
end
