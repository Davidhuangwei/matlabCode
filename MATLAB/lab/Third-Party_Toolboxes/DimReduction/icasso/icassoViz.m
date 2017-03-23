function icassoViz(sR)
%function icassoViz(sR)
%
%PURPOSE
%
%To launche a wizard for exploring the Icasso estimates and clustering
%results. 
%
%EXAMPLE OF BASIC USE
%
%sR=icassoEst('randinit',sf12,10,'approach','symm'); % compute estimates...
%sR=icassoExp(sR);                                   % compute clusters...
%icassoViz(sR);                                      % launch wizard
%
%INPUT
%
% sR (Icasso result struct) 
%
%OUTPUT
%
%No output arguments, but creates workspace variables PARTITION,
%AVESCORE, nad MXSCORE after quitting.
%
%DETAILS
%
%There are four panels in the Icasso Wizard: 
%
%Upper-left panel: Selection of number of clusters
%-------------------------------------------------
%
%By left-clicking any point on this panel, the tool selects the
%number of clusters according to the x-location of click.
%This panel also shows two indices:
% "balance" that gets its maximum value for the partition that
% is most balanced with respect to the number of objects in each cluster
% and "R-index" whose minmum suggests "optimal" clustering according
% to a ceratin "cluster validity index".
%
%Upper-right panel: Visualize/Quit
%---------------------------------
%Shows selected number of clusters and 
%visualization parameters. 
%
%By left-clicking the text LEFT CLICK HERE
%the tool launches three additional figures
% 1: ICASSO: centrotype estimates
% 2: ICASSO: Cluster quality
% 3: ICASSO: Correlation graph
%
%See help in function icassoShow to get explanation for the Figures
%1-3. Icasso Wizard itself is Figure 4.
%
%By right clicking the text RIGHT CLICK HERE the you'll exit Icasso
%Wizard. Figures 1-3 remain, and the function creates the following
%workspace variables: PARTITION, AVESCORE, MXSCORE that contain the
%following results for the partition that you have selected:
%
%PARTITION contains a vector that shows how the estimates are
%divided into the cluster. Elements of PARTITION are integers 1,2,...,L.
%PARTITION(i) shows the cluster number of estimate i.
%
%For example, 
%
% index=find(PARTITION==3), 
% 
%gets indices for estimates
%that belong to cluster 3. Now, You can retrieve, for example, the ICA
%estimates by giving command s=icassoGet(sR, 'source', index);
%or plot the estimates by giving command icassoSourceplot(sR,index); 
%
%AVESCORE contain the ranking index using option 'mean' (see
%function icassoClusterRank) for each cluster, and MXSCORE the ranking
%index using option 'minmax'. AVESCORE(k) and MXSCORE(k) are the
%ranking indices for cluster k. See icassoClusterRank for more information.
% 
%In addition, if you click on any of the cluster hulls in Figure
%3, variable INDEX and CLUSTER are created to the workspace. They
%contain the cluster number and indices to the estimates belonging
%to that cluster. See icassoShow for more information.
%
%Lower-left panel: Thersholds for correlation graph 
%--------------------------------------------------
%
%By clicking a point here you select the thresholds for showing
%lines in the correlation graph plot; x-location selects the
%minimum similarity that there must be between estimates so that a
%line is drawn. y-location sets the limit for suppressing
%within-cluster lines. See icassoShow for more information
%
%Lower-right panel: Cluster ranking index
%----------------------------------------
%Shows the ranking index and ranking index for the selected number
%of clusters (AVESCORE will contain this index but ordered by
%cluster, not in rank order as here)
%See icassoClusterRank for more information.
%
%SEE ALSO
% icassoShow
% icassoGet
% icassoClusterRank
% icassoSourceplot


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


% Defaults
icassoVizFigure=4;
llimit=0.25;
hlimit=0.9;

% Get number of original signals
dim=size(sR.signal,1);

%% Get balance index
balance=sR.cluster.index.balance; balance=balance(:);
N=length(balance);

%%% Find extreme of balance
[tmp,ib]=max(balance);

%% Get R index
R=sR.cluster.index.R; R=R(:);

%% Get the point to which R is computed
n=max(find(isfinite(R)));

%%% normalize max to 1
R=R(1:n)./max(R);

%%% Find extreme of R smaller than dim (or n)
[tmp,ir]=min(R(1:min(dim,n)));
%[tmp,ir]=max(R);

close all; figure(icassoVizFigure); clf;
set(icassoVizFigure,'numbertitle','off','name','ICASSO Wizard');

%%% Cluster validity graph
h_validity=subplot(2,2,4);
[score,in_avg,ext_avg,in_min,ext_max]=...
    icassoClusterRank(sR,'simple',ib,'mean');

%%%% R and balance 

h_R=subplot(2,2,1); hold on;
set(patch([dim dim n+1 n+1],[0 1.1 1.1 0],[.9 .9 .9]),'edgecolor', ...
		  'none');
h_R_lines=plot([balance(1:n) R(1:n)],'.-');
set(plot(ib,balance(ib),'ro'),'markersize',8);
set(text(ib,balance(ib),['Most balanced: ' num2str(ib) ' clusters']),'vert','bottom','horiz','left','fontsize',12,'color','r');
set(plot(ir,R(ir),'ro'),'markersize',8);
set(text(ir,R(ir),['Best R: ' num2str(ir) ' clusters']),'vert','top','horiz','left','fontsize',12,'color','r');
level=ib;
xlabel('Number of clusters');
title({['Balance and R index for 2-' num2str(n) ' clusters'] 'Left-click to select number of clusters'});
axis([1.5 n+.5 0 1.05]);
legend(h_R_lines,{'balance' 'R'},0);
ax=axis; 
set(text(ax(1),ax(3),'Best R computed inside white area'),'fontsize',8,'horiz','left','vert','bot');

h_lines=subplot(2,2,3);
h_lines_marker=plot(llimit,hlimit,'rs');
h_lines_text=text(llimit,hlimit,[sprintf('%2.2f',llimit) ',' sprintf('%2.2f',hlimit)]);
set(h_lines_text,'vert','bot','horiz','left');
ylabel('Between cluster limit \geq');
xlabel('Graph line limit \geq');
title('Left-click to select graph limits.')
axis([0 1 0 1])

h_start=subplot(2,2,2);
h_start_text=text(0,2,''); 
axis([0 1 1 3]); textplot(h_start_text,level,llimit,hlimit);
axis off;

subplot(2,2,1);

while 1==1,
  figure(icassoVizFigure);
  [x,y,button]=ginput(1);

  if button~=1,
    assignin('base','PARTITION',sR.cluster.partition(level,:));
    assignin('base','AVESCORE',in_avg-ext_avg);
    assignin('base','MXSCORE',in_min-ext_max);
    break;
  end
  
  if gca==h_R %|gca==h_balance,
    level=round(x); 
    if level<1, 
      level=1;
    elseif level>N,
      level=N;
    end
  end
  
  if gca==h_lines
    llimit=x;
    hlimit=y;
    if llimit>1,
      limit=1;
    end
    if llimit<0,
      llimit=0;
    end
    if hlimit>1;
      hlimit=1;
    end
    if hlimit<0;
      hlimit=0;
    end
    %delete([h_lines_marker,h_lines_text]);
    set(h_lines_marker,'xdata',llimit,'ydata',hlimit);
    set(h_lines_text,'string', [sprintf('%2.2f',llimit) ',' sprintf('%2.2f',hlimit)]);
    set(h_lines_text,...
	'vert','bot',...
	'horiz','left',...
	'position',[llimit hlimit 0]); 
    axis([0 1 0 1]);
  end
  textplot(h_start_text,level,llimit,hlimit);
  if gca==h_start,
    icassoShow(sR,'level',level,'dense',hlimit,'limit',llimit);
  end
  mem=gca;
  axes(h_validity);
  [score,in_avg,ext_avg,in_min,ext_max]=icassoClusterRank(sR,'simple',level,'mean');
  axes(mem);
end

function textplot(h,level,llimit,hlimit);
NL=sprintf('\n');


set(h,'string', ['You have selected' NL NL ...
		 'Number of clusters: ' num2str(level) NL ...
		 'Hide {\it all} correlations \leq' sprintf('%2.2f',llimit) NL ...
		 'Hide also within-cluster correlations \geq' sprintf('%2.2f',hlimit) NL NL ...
		 'LEFT-click here          RIGHT-click here' NL ...
		 ' to VISUALIZE            to SAVE & EXIT  '],'fontsize',16);


