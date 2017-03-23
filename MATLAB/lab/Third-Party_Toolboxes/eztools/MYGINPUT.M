function [x,y]=myginput
%
%
%
h=get(gca,'Title');
tempstr=get(h,'String');
while 1 ~= 0
   [x,y,button]=ginput(1);
   if button ~= 1
     set(h,'String',sprintf('x =  %8.2f    y =  %8.2f',x,y))     
   else
	set(h,'String',tempstr);
        return
   end
end
%eof

