% axcopy() - move, resize, or copy Matlab axes using the mouse
%
% Usage:           >> selaxiscopy
%                  >> selaxiscopy(fig)
%
%     Clicking the left mouse button on an axis and copy
%     the objects in the axis to another figure. 

% 3-16-00 Tzyy-Ping Jung & Scott Makeig, CNL / Salk Institute, La Jolla
% requires copyaxes.m

function axcopy(fig)

if ~exist('fig') | isempty(fig) | fig == 0 
   fig = gcf;
end

hndl= findobj('parent',fig,'type','axes');
offidx=[];
for a=1:length(hndl)                    % make all axes visible
  set(findobj('parent',hndl(a)),'ButtonDownFcn','copyaxis');
end
figure(fig);
set(hndl,'ButtonDownFcn','copyaxis');

