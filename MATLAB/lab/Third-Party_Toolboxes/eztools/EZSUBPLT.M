function ezsubplt(z)
%  uasage ----> ezsubplt
%  allows for EZ selection of the current subplot
%  R. Cobb Nov 96
global sub_handle
if nargin == 0
sibs=fliplr(get(gcf,'children'));
axhan=[]; found=1;
for i=1:length(sibs);
 if strcmp(get(sibs(i),'type'),'axes')
   axhan(found)=sibs(i);
   found=found+1;
 end
end
if length(axhan)==1
 disp('only one set of axes found')
 return
end
sub_handle(1)=uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[0 .95 .05 .05],...
			'String','Sub ',...
			'BackGroundColor',[0 .7 .7],...
			'Callback','ezsubplt(''next'')');
sub_handle(2)=uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[0 .9 .05 .05],...
			'String','Quit ',...
			'BackGroundColor',[0 .7 .7],...
			'Callback','ezsubplt(''quit'')');
set(sub_handle(1),'UserData',axhan);
set(axhan(1),'Xcolor','r','Ycolor','r');
elseif strcmp(z,'next')
axhan = get(sub_handle(1),'UserData');
  indx=1;
  while (sum(get(axhan(indx),'Xcolor')) ~= 1) & (indx <= length(axhan))
   indx=indx+1;
  end
if indx == length(axhan) 
  set(axhan(1),'Xcolor','r','Ycolor','r');
  set(axhan(indx),'Xcolor','k','Ycolor','k');
  subplot(axhan(1));
else
  set(axhan(indx+1),'Xcolor','r','Ycolor','r');
  set(axhan(indx),'Xcolor','k','Ycolor','k');
  subplot(axhan(indx + 1));
end
else
axhan = get(sub_handle(1),'UserData');
  indx=1;
  while (sum(get(axhan(indx),'Xcolor')) ~= 1) & (indx <= length(axhan))
   indx=indx+1;
  end
  set(axhan(indx),'Xcolor','k','Ycolor','k');
  subplot(axhan(indx));
  set(axhan(indx),'nextplot','replace');
  delete(sub_handle);
end
%eof  
