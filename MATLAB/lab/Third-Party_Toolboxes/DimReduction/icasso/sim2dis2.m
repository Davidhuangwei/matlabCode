function D=sim2dis2(S,p);
%function D=sim2dis2(S,[p]);
%
%PURPOSE 
%
%To transform elements (in [-1,1]) of a similarity matrix S into
%distances by 
%
% D=sqrt(1-abs(S).^p); 
%
%Default value of p=1.
%
%INPUTS []'s mean optional
% 
%S   (matrix) MxM similarity matrix whose elements must be in [-1,1]
%      for example, absolute values of linear correlation coefficients.
%[p] (scalar) default value = 1 (if left out or empty)
%
%OUTPUTS 
%
% D  (matrix) MxM dissimilarity matrix
%
%DETAILS
%
% 1. Error, if some elements not in [-1,1].
% 2. Compute D=sqrt(1-abs(S).^p);
%
%SEE ALSO
%  icassoSim2Dis.m
%  sim2dis.m
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

if nargin<2|isempty(p),
  p=1;
end

S=abs(S);
if any(S(:))>1,
  Error('Values must be in [-1,1]');
end

D=sqrt(1-S.^p);

% Just to make sure that no complex values occur
D=abs(D);
