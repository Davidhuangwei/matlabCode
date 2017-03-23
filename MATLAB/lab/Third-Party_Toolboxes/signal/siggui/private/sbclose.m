function sbclose(fig)
%SBCLOSE Signal Browser close request function
%   This function is called when a browser window is closed.
%   SBCLOSE(FIG) closes the browser with figure handle FIG.
 
%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $

    if nargin<1
        fig = gcf;
    end

    ud = get(fig,'userdata');

    if ~isempty(ud.tabfig)
        delete(ud.tabfig)
    end
    
    delete(fig)

