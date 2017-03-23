function sbcmplx
%SBCMPLX  Signal Browser Complex Popup callback routine.
%   Internal function.
 
%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $

%   TPK 12/5/95

ud = get(gcf,'userdata');

pop = findobj(gcf,'tag','complexpopup');
pv = get(pop,'value');  % new popup value
pv_old = get(pop,'userdata');  % old popup value
if isequal(pv,pv_old)
    return
end
set(pop,'userdata',pv)  % save value

for i = 1:length(ud.lines)
    var = ud.lines(i).data;
    switch pv
    case 1    % real
        var = real(var);
    case 2    % imaginary
        var = imag(var);
    case 3    % magnitude
        var = abs(var);
    case 4    % angle
        var = angle(var);
    end
    for j = 1:length(ud.lines(i).h)
        set(ud.lines(i).h(j),'ydata',var(:,j))
        if ud.prefs.tool.panner
            set(ud.lines(i).ph(j),'ydata',var(:,j))
        end
    end

end

if length(ud.lines)>0
    set(ud.mainaxes,'ylimmode','auto')  % auto range ylimits
    if ud.prefs.tool.ruler
        set(ud.ruler.lines,'visible','off')   % don't let these lines effect the
                                              % ylimit computation
        set(ud.ruler.markers,'visible','off')
    end
    ylim = get(ud.mainaxes,'ylim');
    set(ud.mainaxes,'ylim',ylim)  % set ylimmode to maunal
    ud.limits.ylim = ylim;
    set(gcf,'userdata',ud)

    if ud.prefs.tool.panner
        panaxes = ud.panner.panaxes;
        set(panaxes,'xlim',ud.limits.xlim,'ylim',ylim)
        panner('update')
    end

    % update the ruler lines
    if ud.prefs.tool.ruler
        ruler('showlines',gcf)
        ruler('newlimits')
        ruler('newsig')
    end

end

