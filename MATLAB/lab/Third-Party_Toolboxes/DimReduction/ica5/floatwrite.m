%floatwrite() - Write data matrix to float file.
%
%   >> floatwrite(data,filename,[format]) 
%
%   Write matrix data to specified file as four-byte floating point numbers.
%
%   The option FORMAT argument specifies the storage format as
%   defined by fopen. Default format is 'native'.
%
%   See also floatread(), fopen.

% xx-07-98  written by Sigurd Enghoff, Salk Institute
% 07-08-99  modified by Sigurd Enghoff, FORMAT argument added.
% 02-08-00  new version included in toolbox -sm

function floatwrite(A,fname,fform)

if ~exist('fform')
	fform = 'native';
end

fid = fopen(fname,'wb',fform);
fwrite(fid,A,'float');
fclose(fid);
