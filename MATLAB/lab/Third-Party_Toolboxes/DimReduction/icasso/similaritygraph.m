function [limits,h_example,h_text,h_graph]=similaritygraph(coord,S,mode,r)
%function [limits,h_example,h_text,h_graph]=similaritygraph(coord,[S],[mode],[r])
%
%PURPOSE
%
%To visualize a similarity matrix as a weighted graph.
% 
%INPUT []'s mean optional
%
% coord  (Mx2 matrix) coordinates
% [S]    (MxM matrix) (hopefully sparse) similarity matrix; 
%          values must be in [0,1].
%          Default: if this is not given, no lines are 
%          drawn, only vertices.
% [mode] (string) 'linear', 'equalized', or 'sqrt'
% [r]    (Mx1 vector) individual diameter (in points) for each 
%          vertex marker (circles), Default is 12 for all vertex markers.
%
%OUTPUT
%
% limits    (vector) contains similarity limits for different gray values
% h_example (vector) contains one example (graphic handle) of each
%             different line; needed for legend 
% h_text    (cell array of strings) contains labels for lines in h_example
%             legend(h_example,h_text) sets proper legend for the
%             line colors
% h_graph   (vector) graphic handles to all lines
% h_node    (vector) graphic handles to all vertices
%
%DETAILS
%
% Draws a weighted graph; vertex as red points and edged as gray lines
% between them. Three different gray levels are used. The gray
% level is detemined by dividing values of S (the weights) into
% three bins between the minimum (zeros excluded) and maximum
% value. Three kinds of limits for bins may be used 
% 'linear'  linear division 
% 'sqrt':   bin width grow smaller on higher values 
% 'equalized': there are equal number of lines of the same gray shade.
%
%SEE ALSO
% icassoShow

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

if nargin<4|isempty(r)
  MARKERSIZE=3;
else
  MARKERSIZE=r;
end

if nargin<3|isempty(mode),
  mode='linear';
end

if nargin<2,
  S=zeros(size(coord,1));
end

% Change this to alter vertex color and line attrib.
MARKERCOLOR=[0.5 0 0];
LINEWIDTH=1;

% We consider the abs. values...
S=abs(S);
N=size(S,1);

% Maximum and minimum non-zero similarity
MAX=max(max(S));
MIN=min(S(S>0));

if all(S(:)==0),
  isLines=0;
else
  isLines=1;
end

%split limit into three slots 

if isLines,
  Nclass=3;
  switch mode
   case 'equalized'
    r=S(:); r(r==0)=[];
    r=sort(r); ix=ceil(linspace(1,length(r),Nclass+1)); 
    limits=r(ix);
   case 'linear'
    limits=linspace(MIN,MAX,Nclass+1);
   case 'sqrt'
    limits=linspace(MIN.^2,MAX.^2,Nclass+1);
    limits=sqrt(limits);
  end
  i=1;
  while i<length(limits)-1,
    if ~any( S(:)>limits(i) & S(:)<=limits(i+1)),
      limits(i+1)=[];
    else
      i=i+1;
    end
  end
  Nclass=length(limits)-1;
  
  linecolors(:,1:3)=repmat(linspace(0.7,0,Nclass)',1,3);
  linecolors=linecolors.^.7;

  for i=1:Nclass, 
    S_=S;
    S_(S_<=limits(i) | S_>limits(i+1))=0; 
    links(:,:,i)=S_;
    hold on;
    [dummy,dummy,h]=som_grid(S_,[N 1],'coord',coord,'marker','none', ...
			     'linecolor',linecolors(i,:),'linewidth',i.*LINEWIDTH);
    h_example(i)=h(1); h_graph{i}=h;
    h_text{i}=[sprintf('%0.2f',limits(i)) '<s_{ij}\leq ' sprintf('%0.2f',limits(i+1))]; 
  end
  

  [dummy,h_node]=som_grid(S_,[N 1],'coord',coord,'marker','o','line','none',...
			    'markercolor',MARKERCOLOR,'markersize',MARKERSIZE);
else

  [dummy,h_node]=som_grid('rect',[N 1],'coord',coord,'marker','o','line','none',...
			    'markercolor',MARKERCOLOR,'markersize', ...
			  MARKERSIZE); 
  h_graph=[];
end

if length(MARKERSIZE)==N,
  set(h_node,'markerfacecolor','none');
end

hold off; 
