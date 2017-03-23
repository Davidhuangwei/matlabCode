function D=sim2dis(S)
%function D=sim2dis(S);
%
%PURPOSE
%
%To transform elements of a similarity matrix (in [-1,1]) 
%into distances D=1-S.
%
%INPUTS
%
%S (matrix) MxM similarity matrix whose elements must be in [-1,1],
%    for example, absolute values of linear correlation coefficients.
%
%OUTPUTS 
%
% D  (matrix) MxM dissimilarity matrix
%
%DETAILS
%
% 1. Error, if some elements of S not in [-1,1].
% 2. Compute D=1-S.
%
%SEE ALSO
%  icassoSim2Dis.m
%  sim2dis2.m
%  corr2eucdist.m

%COPYRIGHT NOTICE
%This function is a part of Icasso software library
%Copyright (C) 2003 Johan Himberg
%
%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program; if not, write to the Free Software
%Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

if any(S(:)>1) | any(S(:)<-1),
  error('Values must be in [-1,1]');
end

D=1-S;

