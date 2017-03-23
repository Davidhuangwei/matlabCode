%
%
%  GetText
%
%  This function prints a dialog box on screen and waits for the user to enter
%     a string. There is a cancel button which returns a value of [].
%
%  out = gettext(label1,label2,...,label7);
%
%

% written by Colin Humphries, Salk Institute 1997
%


function out = gettext(label1,label2,label3,label4,label5,label6,label7);

global is_text_entered
is_text_entered = 0;

for i = 1:nargin
   eval(['leng(i) = length(label',num2str(i),');'])
end
figurelength = 15*1.0*max(leng);

if figurelength < 240
   figurelength = 290;
end

figureheight = 80+nargin*18;
% Set figure

figure('Position',[302 396 figurelength figureheight],'color',[.6 .6 .6],'NumberTitle','off')
f1 = gcf;

ax = axes('Units','Pixels','Position',[0 0 figurelength figureheight],'Visible','off','XLim',[0 figurelength],'YLim',[0 figureheight]);

for i = 1:nargin

   eval(['text(figurelength/2,',num2str(figureheight-(i-1)*18-20),',label',num2str(i),',''color'',''k'',''FontSize'',16,''HorizontalAlignment'',''center'')'])

end
% Set up uicontrols

TIMESTRING = ['global is_text_entered;is_text_entered = 1;clear is_text_entered'];

u = uicontrol('Style','Edit','Units','Pixels','Position',[15 20 figurelength-95 25],'HorizontalAlignment','left','Callback',TIMESTRING);

TIMESTRING = ['global is_text_entered;is_text_entered = 2;clear is_text_entered'];
v = uicontrol('Style','Pushbutton','Units','Pixels','Position',[figurelength-70 20 55 25],'String','Cancel','Callback',TIMESTRING);


while(is_text_entered == 0)
   drawnow
end


if is_text_entered == 1
   out = get(u,'string');
else
   out = [];
end


clear is_text_entered
delete(f1)

