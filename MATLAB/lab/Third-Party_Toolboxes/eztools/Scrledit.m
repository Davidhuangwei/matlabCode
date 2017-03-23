function hout=scrledit(cmd,Par1,txt)
%h=scrledit(cmd,POS,STRING_MAT)
% create a scrolling edit window with a slide bar
%
% INPUT:
%	  cmd	- the user should use only cmd='init';
%	  POS = [x1 y1 dx dy]	define the location of the edit box + slider
%		in nomalized units
%	  STRING_MAT - MATLAB String matrix, text to  fill the edit box and to be scrolled
%
% OUTPUT (optional)
%	h - a vector of handles used when closing a specific scrledit
%		scrledit('clode',h); % closes the specific scrledit
%------------------------------------------------------
%  by: I. Bucher (R)    Email : i.bucher@ic.ac.uk  
%------------------------------------------------------
%
% EXAMPLE:
%		S=readstr('scrledit.m'); % create a large string
%		scrledit('init',[.01 .01 .45 .92],S);
% or
% EXAMPLE to fit in a window where there is an existing plot
%
%	figure, subplot(2,1,1), plot(rand(20,1))
%	 scrledit('init',[.01 .01 .92 .4],S)
%
% or 
%	h1=scrledit('init',[.01 .01 .32 .4],S);
%	h2=scrledit('init',[.51 .01 .22 .4],S);
%	 scrledit('close',h1); % closes the first scrledit
% 	 scrledit('close',h3); % closes the second scrledit
%
%      scrledit('close') % will close every scrledit(s) in the current figure (gcf)

if nargin<1, cmd='init'; figure; Par1=[.1 .1 .8 .8]; end

if strcmp(cmd,'init'),
	figure('Color','w','NumberTitle','off','Name',...
	'EZTOOLS Help',...
	'Units','Normalized',...
        'Menubar','none',...
	'Position',[.2 .3 .6 .6]);
figure(gcf)
	P=Par1;  dx=P(3)/50; dy=P(4)/20; dw=P(3)/20;
	 MaxLines=40;
	[n m]=size(txt);
	 h(1)=uicontrol('style','frame',...
         'units','normal',...	
         'position',[P(1) P(2) P(3)  P(4)],...
			'backgroundcolor',[.5  .5 .5]);
	 h(2)=uicontrol('style','edit',...
         'units','normal', ...
         'position',[P(1)+dx P(2)+dy P(3)-dw P(4)-2*dy],...
			'BackgroundColor',[1 1 1],'max',MaxLines,...	
			'userdata',txt);
	 h(3)=uicontrol('style','slider',...
			'units','normal',...
         'position',[P(1)+P(3)  P(2) dw P(4)],...
         'value',n,...
			'min',1,'max',n,...
			'backgroundcolor','b',...
			 'callback','scrledit(''slide'')' ...
			  );
	uicontrol('style','pushbutton',...
			'string','Done',...
			'units','normalized',...
			'position',[.4 .02 .2 .07],...
			'callback','delete(gcf)');
	set(h(3),'userdata',h);
	set(gcf, 'CurrentObject',h(3));
	scrledit('slide'); 
		if nargout>0, hout=h; end
elseif strcmp(cmd,'slide'),			
	hs=gco;	% get slider's handle
	h=get(hs,'userdata');
	 i1=round(get(h(3),'value')); 	
	txt=get(h(2),'userdata'); [n m]=size(txt);
        pos=n:-1:1;i1=pos(i1);
	i2=i1+40;
	if i2>n, i2=n; end
	 set(h(2),'string',txt(i1:i2,:));
elseif strcmp(cmd,'close'),
  if nargin>1,	% handles given
	close(Par1);
  else,			% close all slider with length(userdata)=3
  	hs=findobj(gcf,'style','slider'); % find all sliders
	 for q=1:length(hs),
		UD=get(hs(q),'userdata');
		if length(UD)==3, 
			h=get(hs(q),'userdata');
			close(h), 
		end
	end
  end
	
  
else
	disp(' illegal command in scrledit')
end
