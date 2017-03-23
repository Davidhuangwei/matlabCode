function varargout = testGui7(varargin)
% TESTGUI7 M-file for testGui7.fig
%      TESTGUI7, by itself, creates a new TESTGUI7 or raises the existing
%      singleton*.
%
%      H = TESTGUI7 returns the handle to a new TESTGUI7 or the handle to
%      the existing singleton*.
%
%      TESTGUI7('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI7.M with the given input arguments.
%
%      TESTGUI7('Property','Value',...) creates a new TESTGUI7 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testGui7_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testGui7_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help testGui7

% Last Modified by GUIDE v2.5 06-Oct-2005 02:01:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testGui7_OpeningFcn, ...
                   'gui_OutputFcn',  @testGui7_OutputFcn, ...
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


% --- Executes just before testGui7 is made visible.
function testGui7_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGui7 (see VARARGIN)


handles.mazeMeasStruct = varargin{1};

handles.fieldNames = cat(1,{'none'}, fieldnames(handles.mazeMeasStruct));
menus = [ ...
    getfield(handles,'xVarMenu') ...
    getfield(handles,'yVarMenu') ...
    getfield(handles,'cVarMenu') ...
    getfield(handles,'figVarMenu') ...
    getfield(handles,'subplotVarMenu') ...
    getfield(handles,'var1Menu') ...
    getfield(handles,'var2Menu') ...
    getfield(handles,'var3Menu')];
for i=1:length(menus)
    set(menus(i),'String',handles.fieldNames)
end
% Choose default command line output for testGui7
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testGui7 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testGui7_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in xVarMenu.
function xVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to xVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value')
str = get(hObject, 'String')
str{val}

size(getfield(handles,'mazeMeasStruct',str{val}))
handles.xVar = getfield(handles,'mazeMeasStruct',str{val});
guidata(hObject,handles)

% Hints: contents = get(hObject,'String') returns xVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xVarMenu


% --- Executes during object creation, after setting all properties.
function xVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in yVarMenu.
function yVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to yVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns yVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from yVarMenu


% --- Executes during object creation, after setting all properties.
function yVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in cVarMenu.
function cVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to cVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns cVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cVarMenu


% --- Executes during object creation, after setting all properties.
function cVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in figVarMenu.
function figVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to figVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns figVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from figVarMenu


% --- Executes during object creation, after setting all properties.
function figVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in subplotVarMenu.
function subplotVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to subplotVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns subplotVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subplotVarMenu


% --- Executes during object creation, after setting all properties.
function subplotVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subplotVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xIncInput_Callback(hObject, eventdata, handles)
% hObject    handle to xIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xIncInput as text
%        str2double(get(hObject,'String')) returns contents of xIncInput as a double


% --- Executes during object creation, after setting all properties.
function xIncInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function yIncInput_Callback(hObject, eventdata, handles)
% hObject    handle to yIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yIncInput as text
%        str2double(get(hObject,'String')) returns contents of yIncInput as a double


% --- Executes during object creation, after setting all properties.
function yIncInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cIncInput_Callback(hObject, eventdata, handles)
% hObject    handle to cIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cIncInput as text
%        str2double(get(hObject,'String')) returns contents of cIncInput as a double


% --- Executes during object creation, after setting all properties.
function cIncInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function figIncInput_Callback(hObject, eventdata, handles)
% hObject    handle to figIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figIncInput as text
%        str2double(get(hObject,'String')) returns contents of figIncInput as a double


% --- Executes during object creation, after setting all properties.
function figIncInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function subplotIncInput_Callback(hObject, eventdata, handles)
% hObject    handle to subplotIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subplotIncInput as text
%        str2double(get(hObject,'String')) returns contents of subplotIncInput as a double


% --- Executes during object creation, after setting all properties.
function subplotIncInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subplotIncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xExcInput_Callback(hObject, eventdata, handles)
% hObject    handle to xExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xExcInput as text
%        str2double(get(hObject,'String')) returns contents of xExcInput as a double


% --- Executes during object creation, after setting all properties.
function xExcInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function yExcInput_Callback(hObject, eventdata, handles)
% hObject    handle to yExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yExcInput as text
%        str2double(get(hObject,'String')) returns contents of yExcInput as a double


% --- Executes during object creation, after setting all properties.
function yExcInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cExcInput_Callback(hObject, eventdata, handles)
% hObject    handle to cExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cExcInput as text
%        str2double(get(hObject,'String')) returns contents of cExcInput as a double


% --- Executes during object creation, after setting all properties.
function cExcInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function figExcInput_Callback(hObject, eventdata, handles)
% hObject    handle to figExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figExcInput as text
%        str2double(get(hObject,'String')) returns contents of figExcInput as a double


% --- Executes during object creation, after setting all properties.
function figExcInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function subplotExcInput_Callback(hObject, eventdata, handles)
% hObject    handle to subplotExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subplotExcInput as text
%        str2double(get(hObject,'String')) returns contents of subplotExcInput as a double


% --- Executes during object creation, after setting all properties.
function subplotExcInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subplotExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in var1Menu.
function var1Menu_Callback(hObject, eventdata, handles)
% hObject    handle to var1Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns var1Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from var1Menu


% --- Executes during object creation, after setting all properties.
function var1Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var1Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in var2Menu.
function var2Menu_Callback(hObject, eventdata, handles)
% hObject    handle to var2Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns var2Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from var2Menu


% --- Executes during object creation, after setting all properties.
function var2Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in var3Menu.
function var3Menu_Callback(hObject, eventdata, handles)
% hObject    handle to var3Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns var3Menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from var3Menu


% --- Executes during object creation, after setting all properties.
function var3Menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var3Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function var1IncInput_Callback(hObject, eventdata, handles)
% hObject    handle to var1IncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var1IncInput as text
%        str2double(get(hObject,'String')) returns contents of var1IncInput as a double


% --- Executes during object creation, after setting all properties.
function var1IncInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var1IncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function var2IncInput_Callback(hObject, eventdata, handles)
% hObject    handle to var2IncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var2IncInput as text
%        str2double(get(hObject,'String')) returns contents of var2IncInput as a double


% --- Executes during object creation, after setting all properties.
function var2IncInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2IncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function var3IncInput_Callback(hObject, eventdata, handles)
% hObject    handle to var3IncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var3IncInput as text
%        str2double(get(hObject,'String')) returns contents of var3IncInput as a double


% --- Executes during object creation, after setting all properties.
function var3IncInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var3IncInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function var1ExcInput_Callback(hObject, eventdata, handles)
% hObject    handle to var1ExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var1ExcInput as text
%        str2double(get(hObject,'String')) returns contents of var1ExcInput as a double


% --- Executes during object creation, after setting all properties.
function var1ExcInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var1ExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function var2ExcInput_Callback(hObject, eventdata, handles)
% hObject    handle to var2ExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var2ExcInput as text
%        str2double(get(hObject,'String')) returns contents of var2ExcInput as a double


% --- Executes during object creation, after setting all properties.
function var2ExcInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2ExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function var3ExcInput_Callback(hObject, eventdata, handles)
% hObject    handle to var3ExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var3ExcInput as text
%        str2double(get(hObject,'String')) returns contents of var3ExcInput as a double


% --- Executes during object creation, after setting all properties.
function var3ExcInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var3ExcInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function subplotNumCol_Callback(hObject, eventdata, handles)
% hObject    handle to subplotNumCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subplotNumCol as text
%        str2double(get(hObject,'String')) returns contents of subplotNumCol as a double


% --- Executes during object creation, after setting all properties.
function subplotNumCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subplotNumCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in plot1d.
function plot1d_Callback(hObject, eventdata, handles)
% hObject    handle to plot1d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
%keyboard
incIn = str2num(get(handles.xIncInput,'String'));
excIn = str2num(get(handles.xIncInput,'String'));
toPlot = incIn(find(incIn~=excIn));
len = length(handles.xVar);
plot(handles.xVar(toPlot,1:len)',get(handles.plotStyle,'String'));

% --- Executes on button press in plot2d.
function plot2d_Callback(hObject, eventdata, handles)
% hObject    handle to plot2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plot3d.
function plot3d_Callback(hObject, eventdata, handles)
% hObject    handle to plot3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function plotStyle_Callback(hObject, eventdata, handles)
% hObject    handle to plotStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotStyle as text
%        str2double(get(hObject,'String')) returns contents of plotStyle as a double


% --- Executes during object creation, after setting all properties.
function plotStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in holdOnBool.
function holdOnBool_Callback(hObject, eventdata, handles)
% hObject    handle to holdOnBool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of holdOnBool


