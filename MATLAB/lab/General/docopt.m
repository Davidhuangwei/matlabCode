function [doccmd,options,docpath] = docopt
%DOCOPT Web browser defaults.
%	DOCOPT is an M-file that you or your system manager can edit
%	to specify the web browser to use, and also the location of
%	the MATLAB online documentation, for those platforms that do
%	not support the Java-based Desktop GUIs.  (See the Release
%	Notes for information about these platforms.)  Normally, the
%	Desktop's Help browser is used by the DOC and WEB functions
%	to display HTML content, and the documentation location is
%	specified in the Desktop's Preferences window.  DOCOPT also
%	can be used to specify the web browser to use when the WEB
%	function is issued with the -BROWSER option.  DOCOPT is
%	applicable on Unix platforms only.
%
%	[DOCCMD,OPTIONS,DOCPATH] = DOCOPT returns three strings DOCCMD,
%	OPTIONS, and DOCPATH.
%	DOCCMD is a string containing the command that DOC or WEB uses
%	to invoke a web browser (in place of the Desktop's Help browser).
%	Its default is:
%
%	   Unix:      netscape
%	   Windows:   -na-
%
%	OPTIONS is a string containing additional configuration options
%	that are to accompany the invocation of DOCCMD when the DOC
%	command is called. Its default is:
%
%	   Unix:      ''
%	   Windows:   -na-
%
%	DOCPATH is a string containing the path to the MATLAB online
%	documentation files. If DOCPATH is empty, the DOC function
%	looks for help files in the default location.
%
%       Configuration on Unix:
%       ---------------------
%       1. For global defaults edit and replace this file, i.e.
%              $MATLAB/toolbox/local/docopt.m
%       2. For personal preferences which override the values set
%          in 1. copy this file, i.e.
%              $MATLAB/toolbox/local/docopt.m
%          to
%              $HOME/matlab/docopt.m
%          and make your changes there.  In MATLAB, the Unix commands
%          to make the directory and do the copy are:
%
%               !mkdir $HOME/matlab
%               !cp $MATLAB/toolbox/local/docopt.m $HOME/matlab
%
%          For the changes to take effect in the current MATLAB
%          session, be sure that $HOME/matlab is on your MATLABPATH.
%          This will be the case if this directory existed prior to
%          starting up MATLAB.  If it does not exist on your path in
%          the current session type:
%
%               addpath([getenv('HOME') '/matlab'])
%
%          to add it to the beginning of your MATLABPATH.
%
%	See also DOC.

% $Revision: 1.19 $  $Date: 2001/03/02 16:21:43 $

% Intialize options to empty matrices
doccmd = []; options = []; docpath = [];

% This file automatically defaults to the options and doccmd shown above
% in the online help text. If you would like to set the options or doccmd
% default to be different from those shown above, enter it after this
% paragraph.

%---> Start of your own changes to the defaults here (if needed)
%
cname = computer;

if isunix                       % UNIX
   doccmd = 'mozilla';
%   options = '';
%   docpath = '';
elseif ispc                     % PC
%   doccmd = '';
%   options = '';
%   docpath = '';
else                            % other
%   doccmd = '';
%   options = '';
%   docpath = '';
end
%---> End of your own changes to the defaults here (if needed)

% ----------- Do not modify anything below this line ---------------
% The code below this line automatically computes the defaults 
% promised in the table above unless they have been overridden.

cname = computer;

if isempty(doccmd)

	% For Unix
	if isunix, doccmd = 'netscape'; end

	% For Windows
	if ispc, doccmd = ''; end

end

if isempty(options)

	% For Unix
	options = '';

	% For Windows
	if ispc, options = ''; end

end

if isempty(docpath)
	docpath = '';
end
