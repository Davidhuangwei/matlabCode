function [fontname,fontsize] = fixedfont
%FIXEDFONT Returns name and size of a fixed width font for this system.
%   Example usage:
%     [fontname,fontsize] = fixedfont;

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.2 $

fontname = get(0,'fixedwidthfontname');
fontsize = get(0,'defaultuicontrolfontsize');
