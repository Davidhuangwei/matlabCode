function	par=wdisp(par,str)

% [par] = wdisp(par,str);
% [par] = wdisp(par);
%			to create a command window <waitbar>
%
% par,str	:	parameter
%--------------------------------------------------------------------------------
%   0,str	:	display <str>	initializes proc
%  >0,str	:	display <str>	accumulates <str>-length+1
%  >0		:	erase	<str>s
%
% note		:
%		<str> must be a CHAR array (string)
%

% created:
%	us	12-Aug-2000
% modified:
%	us	09-Mar-2002 02:01:37	/ CSSM

if	~nargin & ~nargout
    help wdisp;
elseif	nargin == 1
    disp(repmat(char(8),1,par+1));
    par=0;
elseif	nargin == 2
    disp(str);
    par=par+length(str)+1;
else
    par=0;
end
return;


% example	:

t='-\|/';
for	i=1:40
   % tl = wdisp(1);
    tl=wdisp( 0,sprintf('time    %c %s',t(rem(i,4)+1),datestr(now)));
    tl=wdisp(tl,sprintf('count %3d %s',i,repmat('.',1,i)));
    pause(.1);
    tl=wdisp(tl);
end
