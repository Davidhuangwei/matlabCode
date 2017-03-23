%
% moveaxes() - move, resize, or copy Matlab axes using the mouse
%
% Usage:           >> moveaxes
%                  >> moveaxes(fig)
%                  >> moveaxes off 
%
% Note: clicking the left mouse button selects an axis
%       dragging the left mouse button resizes a selected axis
%       dragging the right mouse button copies a selected axis
%       clicking the middle mouse button deselects a selected axis
%

% Colin Humphries & Scott Makeig, CNL / Salk Institute, La Jolla

function moveaxes(fig)

if nargin<1
  fig = gcf;
end

if ~isstr(fig)
   tmp = findobj('tag','moveaxes');
   if ~isempty(tmp)   % turn off previous moveaxes Tags 
      ax = get(tmp,'children');
      set(ax,'ButtonDownFcn','','Selected','Off');
      set(tmp,'Tag','','UserData',[]);
   end

   ax = findobj('parent',fig,'type','axes');
   for a=1:length(ax)                    % make all axes visible
     axvis = get(ax(a),'visible');
     set(ax(a),'visible','on','UserData',axvis);
   end

   set(ax,'ButtonDownFcn','selectmoveresize');
   set(fig,'UserData',ax,'Tag','moveaxes');

elseif strcmp(fig,'off')
   fig=findobj('Tag','moveaxes');
   ax = get(fig,'UserData');
   for a=1:length(ax)                    % reset original axis visibility
     axvis= get(ax(a),'UserData')
     set(ax(a),'visible',axvis);
   end
   set(ax,'ButtonDownFcn','','Selected','off');
   set(fig,'Tag','','UserData',[]);
end
   
   
