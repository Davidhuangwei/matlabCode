function icassoCustom(sR_)
%
%function icassoCustom(sR_)
% 
% For creating customized action when clicking a cluster hull in cluster
% visualization graph. (the icassoShow Figure 1)
% 
% Currently obsolate, see source code for further instructions.


%%% Don't touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
persistent sR;

if nargin==1,
  sR=sR_;
  return;
end

INDEX=evalin('base','INDEX');
CLUSTER=evalin('base','CLUSTER');

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
%Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
%02111-1307, USA.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make your function here; sR contains the sR struct used to
% draw the image, INDEX contains the indices to the estimates that
% are in the cluster CLUSTER
%
% Note: Figures number 1-4 are reserved for Icasso

%This is an example...... take in use by removing the dummy if-clause
if 1==0,
  % Set
  % Note: Figures number 1-4 are reserved for Icasso
  figurenumber=CLUSTER+100;
  figure(figurenumber); 
  
  % Sapmples/second

  index2centrotype=icassoCentrotype(sR,'index',INDEX);
  source=icassoGet(sR,'source',index2centrotype);
  
  % Samples/sec.
  Fs=60;
  N=length(source); t=[1:N]/Fs;
  plot(t,source); xlabel('Time (s)'); 
  set(figurenumber,'numbertitle','off','name',['Icasso: Cluster ' ...
		    num2str(CLUSTER)]);
  title(['Cluster #' num2str(CLUSTER) ' centrotype']);
end
