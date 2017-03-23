function delete(obj)

%   Author: T. Krauss
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $

obj = struct(obj);
for i = 1:length(obj)
    ax = get(obj(i).h,'parent');
    fig = get(ax,'parent');
    ud = get(fig,'userdata');
    
    ind = find(obj(i).h == [ud.Objects.fdline.h]);
    if isempty(ind)
        error('Not a valid object')
    end
        
    objud = get(obj(i).h,'userdata');
    
    delete(obj(i).h)
    
    ud.Objects.fdline(ind) = [];
    
    set(fig,'userdata',ud)
end

