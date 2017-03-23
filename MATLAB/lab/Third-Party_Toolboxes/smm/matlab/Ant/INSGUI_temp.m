function varargout = INSGUI(varargin)
% INSGUI M-file for INSGUI.fig
%      INSGUI, by itself, creates a new INSGUI or raises the existing
%      singleton*.
%
%      H = INSGUI returns the handle to a new INSGUI or the handle to
%      the existing singleton*.
%
%      INSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSGUI.M with the given input arguments.
%
%      INSGUI('Property','Value',...) creates a new INSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before INSGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to INSGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help INSGUI

% Last Modified by GUIDE v2.5 16-Aug-2005 13:22:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @INSGUI_OpeningFcn, ...
    'gui_OutputFcn',  @INSGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%OpenMenu_Callback(hObject);
%CCGPlotButton_Callback(hObject, eventdata, handles);



function TestInput(mystr)
fprintf('%s\n',mystr);
return

function CCGTitle(handles)
ListValue=get(handles.SuspiciousPairsList,'value');
handles.CurrentPair=handles.SuspiciousPairs(ListValue,:);       
axes(handles.axes1);
if handles.EIList(ListValue,1)==1
    titlestring=[num2str(handles.CurrentPair(1)) ' excites ' num2str(handles.CurrentPair(2))];
elseif handles.EIList(ListValue,1)==4
    titlestring=[num2str(handles.CurrentPair(1)) ' inhibits ' num2str(handles.CurrentPair(2))];
else titlestring=''; end;
if handles.EIList(ListValue,2)==1
    titlestring=[titlestring ' , ' num2str(handles.CurrentPair(2)) ' excites ' num2str(handles.CurrentPair(1))];
elseif handles.EIList(ListValue,2)==4
    titlestring=[titlestring ' , ' num2str(handles.CurrentPair(2)) ' inhibits ' num2str(handles.CurrentPair(1))];
end;
title(titlestring);
return

function CCGPlot(handles);
ListValue=get(handles.SuspiciousPairsList,'value');
handles.CurrentPair=handles.SuspiciousPairs(ListValue,:);
axes(handles.axes1);
b=bar(handles.t,handles.ccg(:,handles.CurrentPair(1),handles.CurrentPair(2)));xlim([-50 50]);
set(get(b,'children'),'facecolor','k');
set(get(b,'children'),'edgecolor','k');
if isfield(handles, 'EIList')
    if handles.EIList(ListValue,1)==1
        titlestring=[num2str(handles.CurrentPair(1)) ' excites ' num2str(handles.CurrentPair(2))];
        set(handles.LeftExcites,'value',1);
    elseif handles.EIList(ListValue,1)==4
        titlestring=[num2str(handles.CurrentPair(1)) ' inhibits ' num2str(handles.CurrentPair(2))];
        set(handles.LeftInhibits,'value',1);
    else
        titlestring='';     
        set(handles.LeftNothing,'value',1); 

    end
    
    if handles.EIList(ListValue,2)==1
        titlestring=[titlestring ' , ' num2str(handles.CurrentPair(2)) ' excites ' num2str(handles.CurrentPair(1))];
        set(handles.RightExcites,'value',1);
    elseif handles.EIList(ListValue,2)==4
        titlestring=[titlestring ' , ' num2str(handles.CurrentPair(2)) ' inhibits ' num2str(handles.CurrentPair(1))];
        set(handles.RightInhibits,'value',1);
    else
        set(handles.RightNothing,'value',1); 
    end

else
    titlestring='';     
    set(handles.LeftNothing,'value',1); 
    set(handles.RightNothing,'value',1); 
end;
title(titlestring);
axes(handles.axes2);
b=bar(handles.t,handles.ccg(:,handles.CurrentPair(1),handles.CurrentPair(1))); xlim([-50 50]);
set(get(b,'children'),'facecolor','k');
set(get(b,'children'),'edgecolor','k');
title(num2str(handles.CurrentPair(1)));
axes(handles.axes3);
b=bar(handles.t,handles.ccg(:,handles.CurrentPair(2),handles.CurrentPair(2))); xlim([-50 50]);
set(get(b,'children'),'facecolor','k');
set(get(b,'children'),'edgecolor','k');
title(num2str(handles.CurrentPair(2)));
return


function PlotScatter(hObject,handles);
axes(handles.axes1); cla; title('');
q2=handles.nq.eDist;
q2(q2>50)=50;
q2(q2<5)=5;
hold on;
%plot dummy points to generate legend
plot(0,0,'.','markersize',20,'color',[1 0 0]);
plot(0,0,'.','markersize',20,'color',[0 0 1]);
plot(0,0,'.','markersize',20,'color',[0 1 0]);
plot(0,0,'.','markersize',20,'color',[0 1 1]);
plot(0,0,'.','markersize',20,'color',[1 1 0]);
plot(0,0,'.','markersize',20,'color',[1 0 1]);
plot(0,0,'.','markersize',20,'color',[1 1 1]); % just to mask with white dummy points
% make a figure legend
legend('Exciting','Inhibiting','Excited','Excited and Inhibiting','Exciting and Excited (rare)','Exciting and Inhibiting (trouble)',...
        'location','SouthEastOutside');
for a0=1:handles.nClu
    mrkcol = bitget( handles.ExcInh(a0),[1:3]);
    if handles.SelectedCells(a0)==1 mrktype='x';mrksize=(q2(a0)+1)/2; 
    elseif handles.SelectedCells(a0)==2 mrktype='o';mrksize=(q2(a0)+1)/2; 
    else mrktype='.'; mrksize=q2(a0)+1;  end;
    h=plot(handles.CurrentAxis(a0,1),handles.CurrentAxis(a0,2),'markersize',mrksize,'markeredgecolor',mrkcol,'marker',mrktype);
    set(h,'ButtonDownFcn','INSGUI(''axes1_ButtonDownFcn'',gcbo,[],guidata(gcbo))');
end;
hold off;
xlabel(handles.Currentnq{1});
ylabel(handles.Currentnq{2});
if handles.nClu==1
    bord = reshape([0.8*handles.CurrentAxis; 1.2*handles.CurrentAxis],1,4);
else
    bord = reshape([min(handles.CurrentAxis); max(handles.CurrentAxis)],1,4);
end

if bord(1)==bord(2)
    bord(1)=bord(1)*0.8;bord(2)=bord(2)*1.2;
elseif bord(3)==bord(4)
    bord(3)=bord(3)*0.8;bord(4)=bord(4)*1.2;
end
incr = [[-0.2 0.2]*diff(bord(1:2)) [-0.2 0.2]*diff(bord(3:4))];
axis(bord+incr);

return


% --- Executes just before INSGUI is made visible.
function INSGUI_OpeningFcn(hObject, eventdata, handles)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to INSGUI (see VARARGIN)

% Choose default command line output for INSGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%display(varargin{:})
% UIWAIT makes INSGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
return

% --- Outputs from this function are returned to the command line.
function varargout = INSGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in SuspiciousPairsList.
function SuspiciousPairsList_Callback(hObject, eventdata, handles)
% hObject    handle to SuspiciousPairsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SuspiciousPairsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SuspiciousPairsList
CCGPlot(handles);


% --- Executes during object creation, after setting all properties.
function SuspiciousPairsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SuspiciousPairsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','');
set(hObject,'value',1);


% --- Executes on button press in PreviousButton.
function PreviousButton_Callback(hObject, eventdata, handles)
% hObject    handle to PreviousButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ListValue=get(handles.SuspiciousPairsList,'value');
if ListValue>1
    set(handles.SuspiciousPairsList,'value',ListValue-1);
    CCGPlot(handles);
end;


% --- Executes on button press in NextButton.
function NextButton_Callback(hObject, eventdata, handles)
% hObject    handle to NextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ListValue=get(handles.SuspiciousPairsList,'value');
ListStringLength=length(get(handles.SuspiciousPairsList,'string'));
if ListValue<ListStringLength
    set(handles.SuspiciousPairsList,'value',ListValue+1);
    CCGPlot(handles);
end;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'KeyPressFcn','INSGUI(''figure1_KeyPressFcn'',gcbo,[],guidata(gcbo))');

% --- Executes on button press in LeftExcites.
function LeftExcites_Callback(hObject, eventdata, handles)
% hObject    handle to LeftExcites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of LeftExcites
ListValue=get(handles.SuspiciousPairsList,'value');
handles.EIList(ListValue,1)=1;
CCGTitle(handles);
guidata(hObject,handles);


% --- Executes on button press in LeftInhibits.
function LeftInhibits_Callback(hObject, eventdata, handles)
% hObject    handle to LeftInhibits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of LeftInhibits
ListValue=get(handles.SuspiciousPairsList,'value');
handles.EIList(ListValue,1)=4;
CCGTitle(handles);
guidata(hObject,handles);


% --- Executes on button press in LeftNothing.
function LeftNothing_Callback(hObject, eventdata, handles)
% hObject    handle to LeftNothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LeftNothing
ListValue=get(handles.SuspiciousPairsList,'value');
handles.EIList(ListValue,1)=0;
CCGTitle(handles);
guidata(hObject,handles);


% --- Executes on button press in RightExcites.
function RightExcites_Callback(hObject, eventdata, handles)
% hObject    handle to RightExcites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of RightExcites
ListValue=get(handles.SuspiciousPairsList,'value');
handles.EIList(ListValue,2)=1;
CCGTitle(handles);
guidata(hObject,handles);



% --- Executes on button press in RightInhibits.
function RightInhibits_Callback(hObject, eventdata, handles)
% hObject    handle to RightInhibits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of RightInhibits
ListValue=get(handles.SuspiciousPairsList,'value');
handles.EIList(ListValue,2)=4;
CCGTitle(handles);
guidata(hObject,handles);


% --- Executes on button press in RightNothing.
function RightNothing_Callback(hObject, eventdata, handles)
% hObject    handle to RightNothing (see GCBfunction SaveMenu_Callback(hObject, eventdata, handles)O)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of RightNothing
ListValue=get(handles.SuspiciousPairsList,'value');
handles.EIList(ListValue,2)=0;
CCGTitle(handles);
guidata(hObject,handles);


% --- Executes on button press in CCGPlotButton.
function CCGPlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to CCGPlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CCGPlotButton
set(handles.ACGPanel,'visible','on');
set(handles.ListPanel,'visible','on');
set(handles.RightPanel,'visible','on');
set(handles.LeftPanel,'visible','on');
set(handles.SelectButtonPanel,'visible','off');
%set the list value to the last viewed point in ScatterPlot
if handles.ScatterPlotOn==1
    
    [ii,jj] = find(and(handles.SuspiciousPairs == handles.CurrentPoint, handles.EIList>0),1);
    if ~isempty(ii)
        set(handles.SuspiciousPairsList,'value',ii);    
    end
end

handles.ScatterPlotOn=0;

CCGPlot(handles);


% --- Executes on button press in ScatterPlotButton.
function ScatterPlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to ScatterPlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ScatterPlotButton
handles.ExcInh=zeros(handles.nClu,1);
for a0=1:size(handles.EIList,1)
    switch handles.EIList(a0,1)
        case 1
            handles.ExcInh(handles.SuspiciousPairs(a0,1))=bitor(handles.ExcInh(handles.SuspiciousPairs(a0,1)),1);
            handles.ExcInh(handles.SuspiciousPairs(a0,2))=bitor(handles.ExcInh(handles.SuspiciousPairs(a0,2)),2);
        case 4
            handles.ExcInh(handles.SuspiciousPairs(a0,1))=bitor(handles.ExcInh(handles.SuspiciousPairs(a0,1)),4);
            handles.ExcInh(handles.SuspiciousPairs(a0,2))=bitor(handles.ExcInh(handles.SuspiciousPairs(a0,2)),8);
    end;
    switch handles.EIList(a0,2)
        case 1
            handles.ExcInh(handles.SuspiciousPairs(a0,2))=bitor(handles.ExcInh(handles.SuspiciousPairs(a0,2)),1);
            handles.ExcInh(handles.SuspiciousPairs(a0,1))=bitor(handles.ExcInh(handles.SuspiciousPairs(a0,1)),2);
        case 4
            handles.ExcInh(handles.SuspiciousPairs(a0,2))=bitor(handles.ExcInh(handles.SuspiciousPairs(a0,2)),4);
            handles.ExcInh(handles.SuspiciousPairs(a0,1))=bitor(handles.ExcInh(handles.SuspiciousPairs(a0,1)),8);
    end;
end;
set(handles.ACGPanel,'visible','off');
set(handles.ListPanel,'visible','off');
set(handles.RightPanel,'visible','off');
set(handles.LeftPanel,'visible','off');
PlotScatter(hObject,handles);
% handles.ScatterPlot=sc;
handles.ScatterPlotOn=1;
set(handles.SelectButtonPanel,'visible','on');
handles.CurrentPoint =1;
handles.ElNumber = 1;
handles.CluNumber = 1;
guidata(hObject,handles);


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%this function will be responsible for the click catching! not
%waitforbuttonpress!
[x y button]=PointInput(0);
distances = squareform(pdist([x y; handles.CurrentAxis],'seuclidean'));
distances = distances(1,2:end);
[m handles.CurrentPoint]=min(distances);
guidata(hObject,handles);
ViewButton_Callback(hObject, [], handles);

% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(hObject,'CurrentCharacter')
    case 'q'
        figure1_DeleteFcn(hObject, eventdata, handles);
    case 'e'
        handles.UseElec=inputdlg('Enter electrodes to use','Electrode selection',1,num2str(handles.UseElec)); 
        handles.UseElec = str2num(handles.UseElec);
end
if ~handles.ScatterPlotOn
    switch get(hObject,'CurrentCharacter')
        case 'n'
            NextButton_Callback(hObject, [], handles);
        case 'p'
            PreviousButton_Callback(hObject, [], handles);
        end
end
if handles.ScatterPlotOn
    switch double(get(hObject,'CurrentCharacter'))
        case 28 %left arrow
            [xc sorti] = sort(handles.CurrentAxis(:,1));
            handles.CurrentPoint = max(sorti(find(sorti==handles.CurrentPoint)-1),1);
        case 29 %right
            [xc sorti] = sort(handles.CurrentAxis(:,1));
            handles.CurrentPoint = min(sorti(find(sorti==handles.CurrentPoint)+1),handles.nClu);
            
        case 31 %down
            [xc sorti] = sort(handles.CurrentAxis(:,2));
            handles.CurrentPoint = max(sorti(find(sorti==handles.CurrentPoint)-1),1);
        case 30 %up
            [xc sorti] = sort(handles.CurrentAxis(:,2));
            handles.CurrentPoint = min(sorti(find(sorti==handles.CurrentPoint)+1),handles.nClu);

    end
    ViewButton_Callback(hObject, [], handles);
end
guidata(hObject,handles);

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'EIList') && isfield(handles,'FileBase')
    EIList=handles.EIList;
% ExcInh=handles.ExcInh;
    save([handles.FileBase '.ei'],'EIList');
end

save([handles.FileBase '.nclass'],'handles');


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function OpenMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gINSGUI
if ~isempty(gINSGUI) & isfield(gINSGUI,'FileBase')
    FileBase =gINSGUI.FileBase;
else
    [file path0] = uigetfile({'*.dat;*.res;*.par;*.clu;*.msua'});
    file=[path0 file];
    f0=find(file=='.');
    FileBase=file(1:f0(end)-1);
end

handles.FileBase=FileBase;
handles.Par = LoadPar([FileBase '.par']);

w=warndlg('    Loading CCGs....');
load([FileBase '.s2s'],'-MAT');
load([FileBase '.NeuronQuality.mat']);
delete(w);

%select subset of cells to be used
if ~isempty(gINSGUI) & isfield(gINSGUI,'UseElec')
    myel = gINSGUI.UseElec;
else
    myel = [1:handles.Par.nElecGps];
end

%now, NeuronQuality may not contain #elements = to total #electrodes -
% those with no spikes and with bad spk file will be skipped.
% in case of bad spk file - can't do much, have to assign 0 to all the
% values for those units. can still find monosyn pairs for them, but from
% the with point of view they are undetermined

mycs2s = find(ismember(s2s.ElClu(:,1),myel));
myel = unique(s2s.ElClu(mycs2s,1)); % some electrodes have no clusters
s2sN = length(mycs2s);

handles.nClu = length(mycs2s);
handles.El = myel;
handles.ElecLoc = gINSGUI.ElecLoc;
handles.nqLabels = setdiff(fieldnames(OutArgs(1)),'AvSpk');
nq = CatStruct(OutArgs,handles.nqLabels,1);

%select only cells from myel
mycnq = find(ismember(nq.ElNum,myel));
%remove from the struct array cells from other electrodes
nq = SubsetStruct(nq, mycnq);
avspk = CatStruct(OutArgs,{'AvSpk'},1);
avspk = avspk.AvSpk; %waveshapes on larges channel
avspk = avspk(mycnq,:);

nqN=length(nq.ElNum);
nqEl = unique(nq.ElNum);
missEl = setdiff(myel,nqEl);
if ~isempty(missEl) || nqN~=s2sN%so there are more cells in s2s then nq
    fprintf('Missing elements in nq, filling with zeros\n');
    commonind = ismember(s2s.ElClu, [nq.ElNum nq.Clus],'rows');
    nq1=InitStructArray(handles.nqLabels,0);
    nq1=nq1(ones(s2sN,1));
    nq1(commonind) = StructArray(nq);
    handles.nq = StructArray(nq1);
    handles.Spk = zeros(s2sN, size(avspk,2));
    handles.Spk(commonind,:) = avspk;
    
else
    handles.nq = nq;
    handles.Spk = avspk;
end

handles.Currentnq={'SpkWidthR','FirRate'};
handles.CurrentAxis(:,1) = handles.nq.(handles.Currentnq{1});
handles.CurrentAxis(:,2) = handles.nq.(handles.Currentnq{2});

handles.ScatterPlotOn=0;
handles.SelectedCells=zeros(handles.nClu,1);
handles.ExcInh=zeros(handles.nClu,1);

set(handles.SelectXCoord,'String',handles.nqLabels);
set(handles.SelectYCoord,'String',handles.nqLabels);
set(handles.SelectYCoord,'Value', find(strcmp(handles.nqLabels,handles.Currentnq{2})));
set(handles.SelectXCoord,'Value', find(strcmp(handles.nqLabels,handles.Currentnq{1})));

handles.ccg=sq(s2s.ccg(:,mycs2s,mycs2s,4));
handles.t = s2s.tbin;
%handles.nClu = size(handles.ccg,2);

dr=dir([FileBase '.ei']);
if ~isempty(dr) load([FileBase '.ei'],'-MAT');
    handles.EIList=EIList;
else
    handles.EIList = []; 
end;

if handles.nClu>1

    % find asymmetric CCGs
    ratio = []; cell_pair=[];left=[];right=[];
    handles.SuspiciousPairs=[];
    for a0=1:handles.nClu
        for a1=a0+1:handles.nClu
            ccg2=handles.ccg(:,a0,a1)+30;
            middle=floor(length(ccg2)/2)+1;
            left(end+1)=sum(ccg2(middle-2:middle-1));
            right(end+1)=sum(ccg2(middle+1:middle+2));
            if left(end)>right(end)
                ratio(end+1) = left(end)/right(end);
            elseif  left(end)<right(end)
                ratio(end+1) = right(end)/left(end);
            else
                ratio(end+1)=1;
            end
            cell_pair(end+1,:) = [a0 a1];
            %         if left>right*1.4|right>left*1.4
            %             handles.SuspiciousPairs=[handles.SuspiciousPairs;a0 a1];
            %         end;
        end;
    end;
    h= figure;
    set(h,'Position',[ 127         121        1100         807]);
    set(h,'Name','Mono-pairs threshold selection','NumberTitle','off');

    curthr=log(1.4);
    subplot(221)
    lrat = log(ratio);
    %bin_edge = prctile(lrat,[0:5:100]);
    bin_edge = linspace(min(lrat)-0.01,max(lrat)+0.01,50);
    bin_center= (bin_edge(1:end-1)+bin_edge(2:end))/2;
    [hist_lrat binind] = histcI(lrat,bin_edge);
    bar(bin_center,hist_lrat);axis tight
    title('distr. of log(left/right)');
    hold on
    lh = Lines(curthr,[],'r');
    subplot(222)
    scatter(log(left), log(right),4,double(lrat>curthr));caxis([-1 1]);
    b=1;
    while b~=2
        subplot(221)
        [x,y,b] = PointInput(1);
        [dummy cli] = min(abs(bin_center-x));
        %     neg_bd = find(bin_center-x<0);
        curthr = bin_center(cli);bin_center= (bin_edge(1:end-1)+bin_edge(2:end))/2;

        delete(lh);
        lh = Lines(curthr,[],'r');
        title(num2str(curthr));
        subplot(212)
        ind1 = find(handles.t>-30 &handles.t<30);
        ind2= find(binind==cli);
        if isempty(ind2)
            continue;
        end

        sz = [length(ind1) length(ind2)];
        ccg_mat=zeros(sz);
        for jj=1:length(ind2)
            ccg_mat(:,jj) = sq(handles.ccg(ind1,cell_pair(ind2(jj),1),cell_pair(ind2(jj),2)));
        end
        ccg_mat = ccg_mat./repmat(mean(ccg_mat),size(ccg_mat,1),1);
        if b==1
            plot(handles.t(ind1),ccg_mat);
        else
            imagesc(handles.t,[1:length(ind2)],ccg_mat');
        end
        subplot(222)
        scatter(log(left), log(right),4,double(lrat>curthr));caxis([-1 1]);
        title(['pairs # : ' num2str(sum(lrat>curthr))]);
    end

    suspects = find(lrat>=curthr);

    handles.SuspiciousPairs=cell_pair(suspects,:);
    title(['Found ' num2str(length(suspects)) ' pairs']);
    %waitforbuttonpress;
    close(h);
    set(handles.SuspiciousPairsList,'string',num2str(handles.SuspiciousPairs));
    handles.EIList=zeros(size(handles.SuspiciousPairs,1),2);
    % set(hObject,'KeyPressFcn','INSGUI(''figure1_KeyPressFcn'',gcbo,[],guidata(gcbo))');  

    guidata(hObject,handles);
    CCGPlot(handles);

else
    handles.SuspiciousPairs=[];
    ScatterPlotButton_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in UnselectButton.
function UnselectButton_Callback(hObject, eventdata, handles)
% hObject    handle to UnselectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SelectedCells=zeros(handles.nClu,1);
PlotScatter(hObject,handles);
handles.ScatterPlotOn=1;
guidata(hObject,handles);


% --------------------------------------------------------------------
function SaveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savefn =[handles.FileBase '.type'];
if ~strcmp(handles.ElecLoc,'all') 
	 savefn=[savefn '-' handles.ElecLoc];
end
fil=fopen(savefn,'w');

for a0=1:handles.nClu
    if handles.SelectedCells(a0)==1 
        type='n'; 
    elseif handles.SelectedCells(a0)==2 
        type='w'; 
    else type='x'; 
    end; 
    fprintf(fil,'%d %d %s %d \n',handles.nq.ElNum(a0), handles.nq.Clus(a0),type,handles.ExcInh(a0));
end;
fclose(fil);


% --- Executes on button press in SelectWideButton.
function SelectWideButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectWideButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1,'ButtonDownFcn','');
line0=zeros(1000,2); linepos=1;
if handles.ScatterPlotOn
    axes(handles.axes1);
    sel = ClusterPoints(handles.CurrentAxis,0);
    handles.SelectedCells(sel)=2;
    drawnow;
end;
guidata(hObject,handles);
PlotScatter(hObject,handles);


% --- Executes on button press in SelectNarrowButton.
function SelectNarrowButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectNarrowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1,'ButtonDownFcn','');
line0=zeros(1000,2); linepos=1;
if handles.ScatterPlotOn
    axes(handles.axes1); 
    sel = ClusterPoints(handles.CurrentAxis,0);
    handles.SelectedCells(sel)=1;
    drawnow;
end;
guidata(hObject,handles);
PlotScatter(hObject,handles);


% --- Executes on button press in ViewButton.
function ViewButton_Callback(hObject, eventdata, handles)
% hObject    handle to ViewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.ScatterPlotOn
        set(handles.ACGPanel,'visible','on');
        axes(handles.axes3);cla
        myt = find(handles.t>-50 & handles.t<50);
        bar(handles.t(myt),handles.ccg(myt, handles.CurrentPoint, handles.CurrentPoint));
        %axis tight
        title( handles.CurrentPoint); 
        %xlim([-50 50]); DON'T USE = stupid matlab uses all the ACG_plot
        %axes when you use any xlim changes .. CRAZY!!!
        axes(handles.axes2);
        spklen = size(handles.Spk,2);
        spkm = round(spklen/2);
        plot(([1:spklen]-spkm)/40,handles.Spk(handles.CurrentPoint,:)); %xlim([-.5 1.5]);
        title(num2str([handles.CurrentAxis(handles.CurrentPoint,1) handles.CurrentAxis(handles.CurrentPoint,2)])); 
        axis tight
        
        %put circle around current point
        axes(handles.axes1);  
        if isfield(handles,'curptHandle')
            if ishandle(handles.curptHandle)
                delete(handles.curptHandle);
            end
        end
        hold on
        handles.curptHandle = plot(handles.CurrentAxis(handles.CurrentPoint,1),handles.CurrentAxis(handles.CurrentPoint,2),...
                'markersize',30,'markeredgecolor',[0 0 0],'marker','+');
        hold off
        set(handles.axes1,'ButtonDownFcn','INSGUI(''axes1_ButtonDownFcn'',gcbo,[],guidata(gcbo))');
   
        guidata(hObject,handles);
    
end;
return


% --- Executes on selection change in SelectXCoord.
function SelectXCoord_Callback(hObject, eventdata, handles)
% hObject    handle to SelectXCoord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns SelectXCoord contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectXCoord
%if handles.ScatterPlotOn
    %axes(handles.axes1); 
    newx = get(hObject, 'Value');
    handles.Currentnq{1} = handles.nqLabels{newx};
    handles.CurrentAxis(:,1) = handles.nq.(handles.Currentnq{1});
%end    
guidata(hObject,handles);
PlotScatter(hObject,handles);
ViewButton_Callback(hObject, [], handles);

% --- Executes during object creation, after setting all properties.
function SelectXCoord_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectXCoord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'String','x');
guidata(hObject,handles);


% --- Executes on selection change in SelectYCoord.
function SelectYCoord_Callback(hObject, eventdata, handles)
% hObject    handle to SelectYCoord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SelectYCoord contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectYCoord
%if handles.ScatterPlotOn
 %   axes(handles.axes1); 
    newy = get(hObject, 'Value');
    handles.Currentnq{2} = handles.nqLabels{newy};
    handles.CurrentAxis(:,2) = handles.nq.(handles.Currentnq{2});
%end    
guidata(hObject,handles);
PlotScatter(hObject,handles);


% --- Executes during object creation, after setting all properties.
function SelectYCoord_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectYCoord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'String','y');
guidata(hObject,handles);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


