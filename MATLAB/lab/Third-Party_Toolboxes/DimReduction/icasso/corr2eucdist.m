function D=corr2eucdist(C);
%function D=corr2eucdist(C);
%
%PURPOSE
%
%To transforms a correlation matrix into 
%an Euclidean distance matrix D.
%
%INPUTS 
% 
%C (matrix) MxM similarity matrix whose elements must be in [-1,1]
%    for example, linear correlation coefficients.
%
%OUTPUTS 
%
% D  (matrix) MxM dissimilarity matrix
%
%DETAILS
%
% 1. Error, if some elements not in [-1,1]
% 2. Compute D=sqrt(2-2*C);
%
%SEE ALSO  
%  icassoSim2Dis.m
%  sim2dis.m
%  sim2dis2.m

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

if any(C(:)>1) | any(C(:)<-1),
  Error('Values must be in [-1,1]');
end

D=sqrt(2-2*C);

% Just to make sure that no complex values occur
D=abs(D);
