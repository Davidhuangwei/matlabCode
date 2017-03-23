function ans = eq(obj1,obj2)
%EQ  '==' method for fdmeas / fdspec objects

%   Author: T. Krauss
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $

s1 = struct(obj1);
s2 = struct(obj2);

ans = [s1.h] == [s2.h];
