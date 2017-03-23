% LogTicks(Axis, Base)
%
% sets tickmarks on the axis for data displayed as logs
% but where you didn't use matlab's own logscale
%
% you get ticks at log of 1,2..9,10,20..90,100,200... etc
% and tick labels at 1,10,100, etc.
%
% Axis is 'x', 'y', or 'xy'
% Base gives base to which logs were computed
%
% e.g. if you did hist(log(x)), you would do 
% LogTicks('x', exp(1));

function LogTicks(Axis, Base)

EightNulls = {'','','','','','','',''};

if ismember('x', Axis)
    l = xlim;        
    % find which decades to label over
    MinDec = floor(l(1)*log10(Base));
    MaxDec = floor(l(2)*log10(Base));
    
    ticks = []; lab = {};
    for d=MinDec:MaxDec
        for n=1:9
            Val = n*10^d;
            LogVal = log(Val)/log(Base);
            if LogVal>=l(1) & LogVal<=l(2)
                ticks = [ticks, LogVal];
                if n==1
                    lab = {lab{:}, sprintf('10^%d', d)};
                else
                    lab = {lab{:}, ''};
                end
            end
        end
    end
    set(gca, 'xtick', ticks);
    set(gca, 'xticklabel', lab);
end

if ismember('y', Axis)
    l = ylim;        
    % find which decades to label over
    MinDec = floor(l(1)*log10(Base));
    MaxDec = floor(l(2)*log10(Base));
    
    ticks = []; lab = {};
    for d=MinDec:MaxDec
        for n=1:9
            Val = n*10^d;
            LogVal = log(Val)/log(Base);
            if LogVal>=l(1) & LogVal<=l(2)
                ticks = [ticks, LogVal];
                if n==1
                    lab = {lab{:}, sprintf('10^%d', d)};
                else
                    lab = {lab{:}, ''};
                end
            end
        end
    end
    set(gca, 'ytick', ticks);
    set(gca, 'yticklabel', lab);
end

