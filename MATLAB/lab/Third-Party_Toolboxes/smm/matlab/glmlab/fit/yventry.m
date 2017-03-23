%YVENTRY Coordinates the interactive entry of the y-variable in  glmlab

%Copyright 1997 Peter Dunn
%29/05/1997

S_=whos;
%Only allow double variables as options from which to choose:
if isempty(S_), opterr(1); return; end;
[A_, B_]=findmat(char(S_.class),'double');clear A_
B_=num2str(B_); %Convert to char to hide from var list
SNAME_=char(S_.name);
VL_=SNAME_(logical(str2num(B_)),:);
if isempty(VL_), opterr(1);return; end;
VARLIST_=VL_;
clear SNAME_ B_ S_ VL_

THISVAR_=lstr2cel(char(get(findobj('tag','HYV'),'String')));
if isempty(THISVAR_{1}),
   THISVAR_='';
end;

figure('tag','glmlab_varentry','DefaultUIControlUnits','normalized',...
 'WindowStyle','modal');
uicontrol(findobj('tag','glmlab_varentry'),...
 'Position',[0.05 0.65 0.9 0.2],'Style','Frame');

uicontrol(findobj('tag','glmlab_varentry'),...
 'Position',[0.1 0.7 0.8 0.1],'Style','Text','String','RESPONSE (Y) VARIABLE',...
 'FontWeight','bold');
uicontrol(findobj('tag','glmlab_varentry'),'Position',[0.05 0.1 0.35 0.5],...
 'Style','listbox','String',VARLIST_,'tag','masterlisttag','Value',1);
uicontrol(gcf,'Style','Text','String','Available Variables',...
 'Position',[0.1 0.7 0.3 0.05]);
uicontrol(findobj('tag','glmlab_varentry'),'Position',[0.6 0.1 0.35 0.5],...
 'Style','listbox','String',THISVAR_,'tag','chosenlisttag');
uicontrol(gcf,'Style','Text','String','Selected Variables',...
 'Position',[0.6 0.7 0.3 0.05]);

uicontrol(findobj('tag','glmlab_varentry'),'Style','Pushbutton','String','Add -->',...
 'Position',[0.43 0.5 0.14 0.1],'tag','addbutton',...
 'TooltipString','Add selected variable',...
 'Callback','varentry(''add'',1)');
uicontrol(findobj('tag','glmlab_varentry'),'Style','Pushbutton','String','<-- Take',...
 'Position',[0.43 0.3 0.14 0.1],'tag','takebutton',...
 'TooltipString','Remove selected variable',...
 'Callback','varentry(''take'',1)');
uicontrol(findobj('tag','glmlab_varentry'),'Style','Pushbutton','String','FINISHED',...
 'TooltipString','Close window',...
 'Position',[0.43 0.1 0.14 0.1],'Callback','varentry(''close'',1);');
if length(THISVAR_)==0,
   set(findobj('tag','takebutton'),'Enable','off');
end;
GLMLAB_INFO_=get(findobj('tag','glmlab_main'),'Userdata');
if strcmp(GLMLAB_INFO_{1},'binoml'),
   if length(THISVAR_)==2,
      set(findobj('tag','addbutton'),'Enable','off');
   end;
else
   if length(THISVAR_)==1,
      set(findobj('tag','addbutton'),'Enable','off');
   end;
end;

clear VARLIST_ THISVAR_
