function moduleList = fdmodp(moduleList);
%FDMODP  Filtdes module registry.

%   Author: T. Krauss
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $

    moduleList = {moduleList{:} 'fdremez' 'fdfirls' 'fdkaiser' ...
                                'fdbutter' 'fdcheby1' ...
                                'fdcheby2' 'fdellip' ...
                                'fdpzedit'};
