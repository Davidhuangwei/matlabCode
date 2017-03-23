function glhelp(title,page1, page2, page3);
%GLHELP Display the glmlab help information

%Peter Dunn
%Last revision: 27 April 1998
%Inspired by  xppage.m

%check inputs
if nargin<2,
   error('Need at least two arguments!');
end
%end error checks

npages=nargin-1;

hfig=figure('Name',title);

%%%Divide into two section:  help window and buttons

%%First, help window:
top=0.90;
left=0.05;
right=0.75;
bottom=0.05;
labelHt=0.05;
xspace=0.005;
% First, the Window frame
border=0.02; %otherwise text obscures frame
%Add title
uicontrol('Style','text','Units','normalized',...
   'Position',[left, top, right-left, 0.05], 'String',title,...
   'BackgroundColor',[.8 .8 .8 ],'FontSize',12);
 
%Add frame
uicontrol('Style','frame','Units','normalized',...
   'Position',[left-0.01, bottom-0.01, right-left+0.02, top-bottom+0.01]);

%%Now add text itself into the window

%do all pages, and change visibility property as required.
handles = [];

for i=1:npages

   page = eval( ['page',num2str(i)] );
   htext = uicontrol('Style','text','HorizontalAlignment','left',...
      'Units','normalized',...
      'Position',[left, bottom, right-left, top-bottom-0.01],...
      'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0],...
      'String',page,'Visible','off'); 
   %Now, store these handles so we can refer to them for
   %turning visibility on and off
   handles = [get(hfig,'UserData'), htext];
   set(gcf,'UserData',handles);

end

%Now, set page one as visible
set(handles(1),'Visible','on');


%Now, do the buttons
%Need one for each page (max 2 at present) and
%one for email, manual, Web page, close.  So we need room
%for six buttons, preferably seven.


% Information for all buttons
top = 0.95;
left= 0.78;
btnWid = 0.20;
btnHt = 0.10;
%note:  bottom  can stay the same
xspace = 0.02; %space between buttons

if npages>1

   for i=1:npages

      %buttons for jumping to pages
      btntext = ['Page ',num2str(i)];
      cback = [  'txtHndl=get(gco,''UserData'');' ...
                 'handles=get(gcf,''UserData'');' ...
                 'set(handles,''Visible'',''off'');' ...
                 'set(txtHndl,''Visible'',''on'');'       ];
      %callback sets current page invisible, and given page as visible.
      uicontrol('Style','pushbutton', 'String',btntext, ...
         'Units','normalized', ...
         'TooltipString',['Jump to Page ',num2str(i)],...
         'Position',[left top-btnHt-(i-1)*(btnHt+xspace) btnWid btnHt], ...
         'UserData',handles(i), 'Callback',cback);

   end;

end;

%The CLOSE button
uicontrol('Style','pushbutton', 'Units','normalized', ...
   'Position',[left bottom btnWid btnHt], ...
   'TooltipString','Close Help Window',...
   'String','Close','Callback','close(gcf)');

%The EMAIL button
uicontrol( 'Style','pushbutton', 'Units','normalized',...
   'Position',[left bottom+btnHt+xspace btnWid btnHt], ...
   'TooltipString','Send email to the Author',...
   'String','Email','Callback','web(''mailto: dunn@usq.edu.au'');' );

%The WEBPAGE button
uicontrol('Style','pushbutton', 'Units','normalized',...
   'Position',[left bottom+2*btnHt+2*xspace btnWid btnHt], ...
   'String','Web Page',...
   'TooltipString','Go to the glmlab Home Page',...
   'Callback','web(''http://www.sci.usq.edu.au/staff/dunn/glmlab/glmlab.html'');');

%The MANUAL button
uicontrol('Style','pushbutton', 'Units','normalized',...
   'Position',[left bottom+3*btnHt+3*xspace btnWid btnHt], ...
   'String','Manual',...
   'TooltipString','Go to the glmlab On-Line Manual',...
   'Callback','web(''http://www.sci.usq.edu.au/staff/dunn/glmlab/glhtml/html/gli.html'');');
