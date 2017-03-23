function fvmotion(toolnum)
%FVMOTION - Filter Viewer tool motion function for changing pointer.
%   regular mouse motion in figure - update cursor
%     fig - the figure number of the tool
 
%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $

    figname = prepender(['Filter Viewer']);
    fig = findobj('name',figname);
    if isempty(fig)
        return
    end    
    ud = get(fig,'userdata');

    switch ud.pointer
    case 0  % normal mode
        ptr = 'arrow';
    if ud.prefs.tool.ruler 
        ruler_curs = ruler('motion',fig);
        if ruler_curs == 1
            setptr(fig,'hand1')
            return
        elseif ruler_curs == 2
            setptr(fig,'hand2')
            return
        end
    end
    
    case 1  % zoom mode
        if ud.prefs.tool.ruler 
            sz = ud.sz;
            figpos = get(fig,'position') - [0 0 sz.rw 0];
        else
            figpos = get(fig,'position');            
        end
        fpos = get(ud.ht.frame1,'position');
        tpos = get(ud.toolbar.toolbar,'position');
        pt = get(fig,'currentpoint');
        if pt(1)>fpos(3) & pt(1)<figpos(3) & pt(2)<(tpos(2))
            ptr = 'cross';
        else
            ptr = 'arrow';
        end
    case 2  % help mode
        ptr = 'help';
    case -1  % watch cursor
        ptr = 'watch';
    otherwise
        ptr = 'arrow';
    end
   
    setptr(fig,ptr)

