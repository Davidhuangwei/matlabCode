% CHANGEUNITS  
%
%     CHANGEUNITS takes a point in one axes and gives the position of the 
%        point as if plotted in another axes.
%
%     usage: newpoint = changeunits(point,axhandle1,axhandle2)
%
%          axhandle1 - is the axes the point is currently in
%          axhandle2 - is the new axes
%
%     note: axhandle2 can also be the handle of a figure.
%

% Written by Colin Humphries, Salk Institute
% Jan. 1998

function [newpnt] = changeunits(pnt,ax1,ax2)

if ~strcmp(get(ax1,'type'),'axes')
  error('Second argument must be an axes handle')
end

if strcmp(get(ax2,'type'),'axes')

  figh = get(ax1,'Parent');

  if figh ~= get(ax2,'Parent')
    error('Axes must be in the same figure.')
  end
  
  units1 = get(ax1,'Units');
  units2 = get(ax2,'Units');
  set(ax1,'Units','normalized')
  set(ax2,'Units','normalized')
  
  axpos1 = get(ax1,'Position');
  axpos2 = get(ax2,'Position');
  xlim1 = get(ax1,'Xlim');
  xlim2 = get(ax2,'Xlim');
  ylim1 = get(ax1,'Ylim');
  ylim2 = get(ax2,'Ylim');


  l1 = [xlim1(1) ylim1(1)];
  l2 = [xlim1(2) ylim1(2)];
  p1 = axpos1([1,2]);
  p2 = axpos1([3,4]);

  figpnt = (((pnt-l1)./(l2-l1)).*p2) + p1;

  l1 = [xlim2(1) ylim2(1)];
  l2 = [xlim2(2) ylim2(2)];
  p1 = axpos2([1,2]);
  p2 = axpos2([3,4]);

  newpnt = (((figpnt-p1)./p2).*(l2-l1)) + l1;

  set(ax1,'Units',units1)
  set(ax2,'Units',units2)
  
elseif strcmp(get(ax2,'type'),'figure')

  axpos1 = get(ax1,'Position');
  xlim1 = get(ax1,'Xlim');
  ylim1 = get(ax1,'Ylim');

  l1 = [xlim1(1) ylim1(1)];
  l2 = [xlim1(2) ylim1(2)];
  p1 = axpos1([1,2]);
  p2 = axpos1([3,4]);

  newpnt = (((pnt-l1)./(l2-l1)).*p2) + p1;

end



