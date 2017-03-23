function h_lines=icassoSourceplot(sR,index,coord)
%function h_lines=icassoSourceplot(sR,index)
%
%PURPOSE
%
%To plot estimated sources, i.e., independent components from
%Icasso result struct. 
%
%EXAMPLE OF BASIC USE
%
%Generate estimates...
% load sf12
% sR=icassoEst('randinit',sf12,10)
%
%Plot source estimates 1,21 and 35.
%
% icassoSourceplot(sR,[1 21 35]);
%
%INPUTS
%
% sR     Icasso result struct   
% index (kx1 vector) indices of estimates to be shown
%
%OUTPUT
%
% h_line (vector) graphic handles to the line objects
%
%DETAILS
%
%Plots the independet components into active graphic axis.
%
%Only estimates must be generated (icassoEst). Similarirites and
%clustering results are not needed (icassoExp) 
%
%SEE ALSO
% icassoEst 
% icassoGet

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

N=length(index);

if nargin<3,
  coord=[zeros(N,1) [1:N]'];
end

S=icassoGet(sR,'source',index);
cla;
if N>1,
  h_lines=som_plotplane('rect',coord,S,'k');
  axis normal; axis on; 
  ax=axis; axis([ax(1:2) 0.5 N+0.5]);
else
  h_lines=plot(S); set(h_lines,'color','k');
end


