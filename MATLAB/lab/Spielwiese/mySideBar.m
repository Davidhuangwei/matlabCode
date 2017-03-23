% ax = SideBar(h)
%
% resizes the axes and creates a sidebar, in the same position as a typical
% MATLAB colorbar except you can choose what goes in it.  h is the axis handle
% of the plot you want to add a SideBar to (default: gca).
%
% ax = sidebar handle

function ax = mySideBar(h);

if nargin<1
	h = gca;
	hfig = gcf;
else
	hfig = get(h, 'parent');
end

legend('RestoreSize',h); %restore axes to pre-legend size
units = get(h,'units');
set(h,'units','normalized');
pos = get(h,'Position');
%[az,el] = view(haxes);
stripe = 0.075; edge = 0.02;
%if all([az,el]==[0 90])
	space = 0.05;
%else
%	space = .1;
%end
set(h,'Position',[pos(1) pos(2) pos(3)*(1-stripe-edge-space) pos(4)]);
legend('RecordSize',h); %set this as the new legend fullsize

rect = [pos(1)+(1-stripe-edge)*pos(3) pos(2) stripe*pos(3) pos(4)];
%ud.origPos = pos;

% Create axes for stripe and
% create DeleteProxy object (an invisible text object in
% the target axes) so that the colorbar will be deleted
% properly.
%ud.DeleteProxy = text('parent',h,...
%	'visible','off',...
%	'tag','ColorbarDeleteProxy',...
%	'HandleVisibility','off',...
%	'deletefcn','colorbar(''delete'',''peer'',get(gcbf,''currentaxes''))');

%axH = graph3d.colorbar('parent',hfig);
%set(axH,'position',rect,'Orientation','vert');
%ax = double(axH);
ax = axes('position', rect);

%setappdata(ax,'NonDataObject',[]); % For DATACHILDREN.M
%set(ud.DeleteProxy,'userdata',ax)
set(h,'units',units)

axes(ax);
