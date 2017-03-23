function h = bseline(func, Bins, LineSpec)
% h=bseline(func, Bins, LineSpec, ...)
%   BSELINE superimposes the running bin smooth line on each line object
%   in the current axis (Except LineStyles '-','--','.-'.) with errorbars
%
%   H = MSLINE returns the handle to the line object(s) in H.
%   
%   See also BinSmoothE, MedianSmooth, MeanSmooth, bsline
%
%  func a function which calculates central tendency and confidence
%  intervals (eg binofit, MedianConf)
%  Bins is an optional argument passed to BinSmoothE.  It may
%  be a number of points per bin, or the specification of the left edges.
%  Default = 20.
%
% LineSpec is a LineSpec for the line.
%
% additional arguments are passed to func.

if (nargin<2)
	Bins = 20;
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
       
       [m, l, u, BinsO] = BinSmoothE(xdat, ydat, func, Bins);
%       BinsO
	   nBins = length(BinsO);
       % calculate x axis to plot as middles of each bin
       xCoord = [(BinsO(1:nBins-1) + BinsO(2:nBins))/2 , (BinsO(end)+ max(xdat) )/2];

       if nargin<3
           newline = errorbar(xCoord, m, l, u);
           set(newline, 'Color', datacolor);
       else
           newline = errorbar(xCoord, m, l, u, LineSpec);
       end

       if nargout == 1
           h = [h newline];    
       end
       
       [r, sig] = RankCorrelation(xdat, ydat);
       fprintf('Spearmans R: %f, sig %f\n', r, sig);
   end
end

if count == 0
   disp('No allowed line types found. Nothing done.');
end

if (holdstate==0)
	hold off
end;