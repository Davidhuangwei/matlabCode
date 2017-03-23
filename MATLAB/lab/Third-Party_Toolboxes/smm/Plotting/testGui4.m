function varargout = testGui4(varargin)
% TESTGUI4 Application M-file for testGui4.fig
%   TESTGUI4, by itself, creates a new TESTGUI4 or raises the existing
%   singleton*.
%
%   H = TESTGUI4 returns the handle to a new TESTGUI4 or the handle to
%   the existing singleton*.
%
%   TESTGUI4('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in TESTGUI4.M with the given input arguments.
%
%   TESTGUI4('Property','Value',...) creates a new TESTGUI4 or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before testGui4_OpeningFunction gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to testGui4_OpeningFcn via varargin.
%
%   *See GUI Options - GUI allows only one instance to run (singleton).
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testGui4

% Last Modified by GUIDE v2.5 05-Oct-2005 05:15:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',          mfilename, ...
                   'gui_Singleton',     gui_Singleton, ...
                   'gui_OpeningFcn',    @testGui4_OpeningFcn, ...
                   'gui_OutputFcn',     @testGui4_OutputFcn, ...
                   'gui_LayoutFcn',     [], ...
                   'gui_Callback',      []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    varargout{1:nargout} = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before testGui4 is made visible.
function testGui4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGui4 (see VARARGIN)

%Create the data to plot
handles.ten2one = [10:-1:1];
handles.one2ten = [1:10].^2;

handles.xaxis = handles.ten2one;
handles.yaxis = handles.one2ten;
figure(1)

plot(handles.xaxis,handles.yaxis,'.')

% Choose default command line output for testGui4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
% Call the popup menu callback to set the handles.current_data 
% field to the current value of the popup
%plot_popup_Callback(handles.plot_popup,[],handles)
%plot_popup_Callback(handles.popupmenu5,[],handles)
%popupmenu5_Callback(handles.popupmenu5,[],handles)
% --------------------------------------------------------------------
    
% UIWAIT makes testGui4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testGui4_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function varargout = surf_pushbutton_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to surf_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
plot(handles.xaxis,handles.yaxis,'.')
keyboard

% --------------------------------------------------------------------
function varargout = mesh_pushbutton_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to mesh_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
plot(handles.xaxis,handles.yaxis,'.')


% --------------------------------------------------------------------
function varargout = contour_pushbutton_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to contour_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
plot(handles.xaxis,handles.yaxis,'.')



% --------------------------------------------------------------------
function varargout = plot_popup_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to plot_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
hObject
set(hObject,'String','junk');
val = get(hObject,'Value')
str = get(hObject, 'String')
switch str{val};
case 'ten2one'
	handles.xaxis = handles.ten2one;
case 'one2ten'
	handles.xaxis = handles.one2ten;
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function plot_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu5.
function varargout = popupmenu5_Callback(hObject, eventdata, handles,varargin)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
hObject
set(hObject,'String','junk');
val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
case 'ten2one'
	handles.yaxis = handles.ten2one;
case 'one2ten'
	handles.yaxis = handles.one2ten;
end
    
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


