function varargout = sbswitch(varargin)
%SBSWITCH Function switch-yard.
%        SBSWITCH('FOO',ARG1,ARG2,...) is the same as
%        FOO(ARG1,ARG2,...).  This provides access to private
%        functions for Handle Graphics callbacks.

%        Copied from IMSWITCH.
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%        $Revision: 1.1 $  $Date: 1998/05/22 20:04:53 $

if (nargout == 0)
  feval(varargin{:});
else
  [varargout{1:nargout}] = feval(varargin{:});
end
