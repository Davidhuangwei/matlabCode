function h = mnsline(Bins,LineSpec)
% h=msline(Bins,LineSpec) Add mean smooth line to scatter plot.
%   MNSLINE superimposes the running median line on each line object
%   in the current axis (Except LineStyles '-','--','.-'.)
% 
%   H = MNSLINE returns the handle to the line object(s) in H.
%   
%   See also MeanSmooth, msline
%
%  Bins is an optional argument passed to MeanSmooth.  It may
%  be a number of bins, or the specification of the left edges.
%  Default = 20.
%
% LineSpec is a LineSpec for the line.

if (nargin<1)
	Bins = 10;
end;

holdstate = ishold;
hold on;
lh = findobj(get(gca,'Children'),'Type','line');
if nargout == 1, 
   h = [];
end
count = 0;
for k = 1:length(lh)
    xdat = get(lh(k),'Xdata');
    ydat = get(lh(k),'Ydata');
    datacolor = get(lh(k),'Color');
    style = get(lh(k),'LineStyle');
    if ~strcmp(style,'-') & ~strcmp(style,'--') & ~strcmp(style,'-.')
       count = count + 1;
       
       [m BinsO] = MeanSmooth(xdat, ydat, Bins);
%       BinsO
	   nBins = length(BinsO);
       % calculate x axis to plot as middles of each bin
       xCoord = [(BinsO(1:nBins-1) + BinsO(2:nBins))/2 , (BinsO(end)+ max(xdat) )/2];

       if nargin<2
           newline = plot(xCoord, m, 'Color', datacolor);
       else
           newline = plot(xCoord, m, LineSpec);
       end

       if nargout == 1
           h(count) = newline;    
       end
   end
end

if count == 0
   disp('No allowed line types found. Nothing done.');
end

if (holdstate==0)
	hold off
end;