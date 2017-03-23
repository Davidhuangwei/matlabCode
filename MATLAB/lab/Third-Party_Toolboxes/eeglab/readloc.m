% readloc() - read polar electrode positions from ICA toolbox .loc file
%             See >> topoplot example  for .loc file format. This function
%             is deprecated, see readlocs()
% Usage:
%   >> [eloc, elocnames, angles, norms] = readloc( filename );
%
% Inputs:
%   filename - name of the .loc file containing the electrode
%              locations in polar coordinates (See >> topoplot example)
% Outputs:
%   eloc      - structure containing the channel names and locations
%   elocnames - names of the electrodes
%   angles    - vector of polar angles of the electrodes 
%   norms     - vector of polar norms of the electrodes
%
% Author: Arnaud Delorme, CNL / Salk Institute, 28 Feb 2002
%
% See also: readelp(), topo2sph(), sph2topo(), cart2topo()

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) Arnaud Delorme, CNL / Salk Institute, 28 Feb 2002
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% $Log: readloc.m,v $
% Revision 1.3  2002/11/15 02:54:58  arno
% see readlocs
%
% Revision 1.2  2002/04/18 15:10:31  scott
% editted error msg -sm
%
% Revision 1.1  2002/04/05 17:36:45  jorn
% Initial revision
%

function [eloc, names, angle, norm] = readloc( filename ); 

if nargin < 1
	help readloc;
	return;
end;

% open file
% ---------
fid = fopen(filename, 'r');
if fid == -1
  disp('Cannot open specified file'); return;
end;

% scan file
% ---------
index = 1;
allinfos = fscanf(fid,'%d %f %f  %s',[7 Inf]);
for index = 1:size( allinfos,2)
  eloc(index).name  = char(allinfos(4:7,index)');
  eloc(index).name( find(eloc(index).name == '.' )) = ' ';
  eloc(index).angle = allinfos(2,index)';
  eloc(index).norm  = allinfos(3,index)';
end;  
angle = allinfos(2,:)';
norm  = allinfos(3,:)';

names = { eloc.name };
