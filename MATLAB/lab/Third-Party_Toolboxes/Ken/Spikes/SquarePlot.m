% SquarePlot(Ph1, Ph2, nCyc, PlotArgs)
%
% plots a "phase coincidence plot" with phase of spikes of cell1 on x-axis 
% and cell 2 on y-axis, when both cells fire in a cycle.
%
% nCyc - number of cycles to plot
% PlotArgs - additional arguments to plot command, e.g. 'markersize', 1
% if this is 0, don't plot at all.
%
% optional argument Out gives a 2-column matrix having the plotted
% coordinates

function Out = SquarePlot(Ph1, Ph2, nCyc, varargin)

if nargin<3
    nCyc=3; % x-axis is this many cycles: y axis is this plus 2
end

if nargin==4 & varargin{1}==0
    Plot=0;
else
    Plot = 1;
end

T = [Ph1(:) ;  Ph2(:)];
G = [2*ones(length(Ph1),1); 3*ones(length(Ph2),1)];
[ccg t Pairs] = CCG(T, G, 2*(nCyc+1)*2*pi, 0);
GPairs = G(Pairs);
MyPairs = find(GPairs(:,1)==2 & GPairs(:,2)==3);
Phase1 = T(Pairs(MyPairs,1));
PhaseDiff = T(Pairs(MyPairs,2)) - Phase1;

List = [];
for i1=0:nCyc-1
    MyPoints = [mod(Phase1,2*pi)*180/pi + i1*360, ...
            (mod(Phase1,2*pi)+PhaseDiff)*180/pi + i1*360];
    List = [List; MyPoints];
end

if Plot
    cla; hold on;
    plot(List(:,1), List(:,2), '.', varargin{:});
	axis([0 nCyc*360 -360 360*(nCyc+1)]);
	hold on; plot([0 nCyc*360], [0 nCyc*360], 'k--');
	%set(gca, 'xtick', 0:90:nCyc*360); set(gca, 'ytick', -360:90:360*(nCyc+1));
	set(gca, 'xtick', 0:180:nCyc*360); set(gca, 'ytick', -360:180:360*(nCyc+1));
	xlabel('Neuron 1 Phase'); ylabel('Neuron 2 Phase');
end

if nargout>=1
    Out = List;
end