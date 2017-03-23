function varargout = Demog(varargin)
% DEMOG M-file for Demog.fig
%      DEMOG, by itself, creates a new DEMOG or raises the existing
%      singleton*.
%
%      H = DEMOG returns the handle to a new DEMOG or the handle to
%      the existing singleton*.
%
%      DEMOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMOG.M with the given input arguments.
%
%      DEMOG('Property','Value',...) creates a new DEMOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Demog_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Demog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Demog

% Last Modified by GUIDE v2.5 10-May-2005 19:20:43

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Demog_OpeningFcn, ...
                   'gui_OutputFcn',  @Demog_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Demog is made visible.
function Demog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Demog (see VARARGIN)

% Choose default command line output for Demog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Demog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

ShowStep(handles,1);


% --- Outputs from this function are returned to the command line.
function varargout = Demog_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function TypeSource_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TypeSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in TypeSource.
function TypeSource_Callback(hObject, eventdata, handles)
% hObject    handle to TypeSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns TypeSource contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TypeSource

ShowStep(handles,1);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function SourceNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourceNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in SourceNumber.
function SourceNumber_Callback(hObject, eventdata, handles)
% hObject    handle to SourceNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SourceNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SourceNumber



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% ---- On change le nombre de sources ---- %

function MAJIsource(handles)

% Mise à jour popup

NbSource = str2num(get(handles.edit1,'String'));
s = '';
for (iS=1:NbSource)
    s = sprintf('%s%d|',s,iS);
end
s = s(1:length(s)-1);
set(handles.SourceNumber,'String',s);


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


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


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%%%%
% Generation du melange
%%%%%%%

global Obs;
global Contribution;
global GMixt;
global FreqCycl;

set(handles.text30,'Visible','On');
pause(1);

if (get(handles.TypeSource,'Value')==1)
    load foetal_ecg.dat;
    load FreqCycl.dat;
    Obs = foetal_ecg(:,2:9).';
    Contribution = [];
elseif (get(handles.TypeSource,'Value')==2)
    addpath(sprintf('%s/Demo/',pwd));
    addpath(sprintf('%s/Demo/MixtureGeneration/',pwd));
    
    ParamStruct = struct(...
    'NbSrc'                 ,3,...      % Number of source signals
    'NbCpt'                 ,5,...      % Number of sensors
    'NbTrajet'              ,3);        % Number of propagation channel path (1 for instantaneous mixture).

    Parameters = struct(ParamStruct);

    Parameters.NbSrc = str2num(get(handles.edit1,'String'));
    Parameters.NbCpt = str2num(get(handles.edit2,'String'));;
    
    if (Parameters.NbSrc>Parameters.NbCpt) 
        Parameters.NbSrc = str2num(get(handles.edit2,'String'));
        Parameters.NbCpt = str2num(get(handles.edit1,'String'));;
    end
    
    if (get(handles.popupmenu5,'Value')==1)
        Parameters.NbTrajet = 1;
    else 
        Parameters.NbTrajet = 3;        
    end

    [Obs,Contribution] = DoMixture(Parameters);

    rmpath(sprintf('%s/Demo/MixtureGeneration/',pwd));
    rmpath(sprintf('%s/Demo/',pwd));
else

    Obs = GMixt;
    if (size(Obs,1)>size(Obs,2))
        Obs = Obs.';    
    end
    Contribution = [];
    if (get(handles.checkbox1,'Value')==1)
        [ Obs ]  = KillMean(Obs);   
    end
    
end

% Source signals have to be centered !
for (iy=1:size(Obs,1))
    Obs(iy,:) = Obs(iy,:) - mean(Obs(iy,:));
end



ShowStep(handles,2);

function ShowStep(handles,Step)

global Obs;
global YAxis;
global Zoom;
global Contribution;
global ContributionEst;
global GMixt;

switch Step
    case 1
        axes(handles.axes2);
        cla;
        axes(handles.axes3);
        cla;

        set(handles.text3,'Visible','On');
        set(handles.text30,'Visible','Off');
        set(handles.text28,'Visible','On');
        set(handles.text29,'Visible','Off');
        set(handles.TypeSource,'Visible','On');
        set(handles.text6,'String','Step 1 : Getting a mixture....');
        if (get(handles.TypeSource,'Value')==1)
            set(handles.text4,'Visible','Off');
            set(handles.text5,'Visible','Off');
            set(handles.edit1,'Visible','Off');
            set(handles.edit2,'Visible','Off');
            set(handles.text19,'Visible','Off');
            set(handles.text20,'Visible','Off');
            set(handles.popupmenu5,'Visible','Off');
            set(handles.text31,'Visible','Off');
            set(handles.popupmenu8,'Visible','Off');
            set(handles.pushbutton1,'Visible','On');

            set(handles.text32,'Visible','Off');
            set(handles.text33,'Visible','Off');
            set(handles.text34,'Visible','Off');
            set(handles.text35,'Visible','Off');
            set(handles.text36,'Visible','Off');
            set(handles.text37,'Visible','Off');
            set(handles.text38,'Visible','Off');
            set(handles.checkbox1,'Visible','Off');
            set(handles.checkbox2,'Visible','Off');
       
        elseif (get(handles.TypeSource,'Value')==2)
            set(handles.text4,'Visible','On');
            set(handles.text5,'Visible','On');
            set(handles.edit1,'Visible','On');
            set(handles.edit2,'Visible','On');
            set(handles.text19,'Visible','On');
            set(handles.text20,'Visible','On');
            set(handles.popupmenu5,'Visible','On');
            set(handles.text31,'Visible','Off');
            set(handles.popupmenu8,'Visible','Off');
            set(handles.pushbutton1,'Visible','On');
            set(handles.text32,'Visible','Off');
            set(handles.text33,'Visible','Off');
            set(handles.text34,'Visible','Off');
            set(handles.text35,'Visible','Off');
            set(handles.text36,'Visible','Off');
            set(handles.text37,'Visible','Off');
            set(handles.text38,'Visible','Off');
            set(handles.checkbox1,'Visible','Off');
            set(handles.checkbox2,'Visible','Off');
       
        else
            set(handles.text4,'Visible','Off');
            set(handles.text5,'Visible','Off');
            set(handles.edit1,'Visible','Off');
            set(handles.edit2,'Visible','Off');
            set(handles.text19,'Visible','Off');
            set(handles.text20,'Visible','Off');
            set(handles.popupmenu5,'Visible','Off');
            set(handles.text31,'Visible','On');
            set(handles.popupmenu8,'Visible','On');
            % Mise à jour du popumpenu8:
            Vars =  whos('GMixt');
            
            if (max(Vars.size)==0)
                set(handles.popupmenu8,'String','To use your own mixture, use command: global GMixt;GMixt=MyMixture;Demog;');
                set(handles.pushbutton1,'Visible','Off');
                set(handles.text32,'Visible','Off');
                set(handles.text33,'Visible','Off');
                set(handles.text34,'Visible','Off');
                set(handles.text35,'Visible','Off');
                set(handles.text36,'Visible','Off');
                set(handles.text37,'Visible','Off');
                set(handles.text38,'Visible','Off');
                set(handles.checkbox1,'Visible','Off');
                set(handles.checkbox2,'Visible','Off');
                
            else
                set(handles.popupmenu8,'String','Your Mixture');
                set(handles.pushbutton1,'Visible','On');
                
                set(handles.text32,'Visible','On');
                set(handles.text33,'Visible','On');
                set(handles.text34,'Visible','On');
                set(handles.text38,'Visible','On');
                set(handles.checkbox1,'Visible','On');
                set(handles.checkbox2,'Visible','On');
            
                % Warning message
                if (max(size(GMixt))>5001)
                    set(handles.text35,'Visible','On');
                else
                    set(handles.text35,'Visible','Off');
                end
                    
                set(handles.text36,'String',min(size(GMixt)));
                set(handles.text36,'Visible','On');
                set(handles.text37,'String',max(size(GMixt)));
                set(handles.text37,'Visible','On');
                
            end
            
                            
        end
        set(handles.axes1,'Visible','Off');
        set(handles.slider1,'Visible','Off');
        set(handles.text23,'Visible','Off');
        set(handles.slider2,'Visible','Off');
        
        set(handles.text24,'Visible','Off');
        set(handles.edit7,'Visible','Off');
        set(handles.pushbutton2,'Visible','Off');

        set(handles.axes2,'Visible','Off');
        set(handles.axes3,'Visible','Off');
        set(handles.text25,'Visible','Off');
        set(handles.text26,'Visible','Off');
        set(handles.text27,'Visible','Off');
        set(handles.slider3,'Visible','Off');
        set(handles.slider4,'Visible','Off');
        set(handles.popupmenu6,'Visible','Off');
        set(handles.popupmenu7,'Visible','Off');
        set(handles.pushbutton3,'Visible','Off');

        
    case 2
        set(handles.text29,'Visible','On');
        set(handles.text28,'Visible','Off');
        set(handles.text6,'String','Step 2 : Estimation of the cyclic frequencies....');
        set(handles.text3,'Visible','Off');
        set(handles.TypeSource,'Visible','Off');
        set(handles.text4,'Visible','Off');
        set(handles.text5,'Visible','Off');
        set(handles.edit1,'Visible','Off');
        set(handles.edit2,'Visible','Off');
        set(handles.text19,'Visible','Off');
        set(handles.text20,'Visible','Off');
        set(handles.popupmenu5,'Visible','Off');
        set(handles.pushbutton1,'Visible','Off');
        set(handles.text31,'Visible','Off');
        set(handles.popupmenu8,'Visible','Off');
        
        set(handles.slider1,'Visible','On');
        set(handles.text23,'Visible','On');
        set(handles.slider2,'Visible','On');
        
        set(handles.text24,'Visible','On');
        set(handles.edit7,'Visible','On');
        set(handles.pushbutton2,'Visible','On');

        set(handles.axes1,'Visible','On');
        set(handles.text25,'Visible','Off');
        set(handles.text26,'Visible','Off');
        set(handles.text27,'Visible','Off');
        set(handles.slider3,'Visible','Off');
        set(handles.slider4,'Visible','Off');
        set(handles.popupmenu6,'Visible','Off');
        set(handles.popupmenu7,'Visible','Off');
        set(handles.pushbutton3,'Visible','Off');
        
        set(handles.text32,'Visible','Off');
        set(handles.text33,'Visible','Off');
        set(handles.text34,'Visible','Off');
        set(handles.text35,'Visible','Off');
        set(handles.text36,'Visible','Off');
        set(handles.text37,'Visible','Off');
        set(handles.text38,'Visible','Off');
        set(handles.checkbox1,'Visible','Off');
        set(handles.checkbox2,'Visible','Off');
               
        set(handles.axes2,'Visible','Off');
        set(handles.axes3,'Visible','Off');
        
        axes(handles.axes1);
        [ Freq,R ] = EstimateCyclicFrequencies(Obs);   
        Zoom = 0.1;
        set(handles.axes1,'XLim',[0.0 Zoom]);
        YAxis = get(handles.axes1,'YLim');    
        
        if (get(handles.TypeSource,'Value')==1)
            set(handles.edit7,'String','FreqCycl % The cyclic frequencies are stored in the FreqCycl.dat file');
        elseif (get(handles.TypeSource,'Value')==2)
            set(handles.edit7,'String','[]');       
        else
            if (get(handles.checkbox2,'Value')==1);
                iCycl=1;
                FreqCycl = [];
                for (iF=0.005:0.005:0.49);
                    I1 = find(abs(Freq-iF)==min(abs(Freq-iF)));
                    I2 = find(abs(Freq-iF-0.005)==min(abs(Freq-iF-0.005)));
                    D1 = R(I1+1:I2);    
                    NoiseLevel = mean(D1);
                    if (max(D1)>3.5*NoiseLevel)
                        I = find(D1==max(D1));
                        FreqCycl(iCycl) = Freq(I1+I-1);
                        iCycl = iCycl+1;
                    end
                end
                set(handles.edit7,'String',mat2str(FreqCycl));       
            else
                set(handles.edit7,'String','[]');       
            end    
         end
       
        set(handles.slider2,'Value',1-(Zoom-0.01)/0.49);
        set(handles.text30,'Visible','Off');
        
    case 3
        set(handles.text31,'Visible','Off');
        set(handles.popupmenu8,'Visible','Off');
        set(handles.text28,'Visible','Off');
        set(handles.text29,'Visible','Off');
        set(handles.text6,'String','Step 3 : Separation results....');
        set(handles.text3,'Visible','Off');
        set(handles.TypeSource,'Visible','Off');
        set(handles.text4,'Visible','Off');
        set(handles.text5,'Visible','Off');
        set(handles.edit1,'Visible','Off');
        set(handles.edit2,'Visible','Off');
        set(handles.text19,'Visible','Off');
        set(handles.text20,'Visible','Off');
        set(handles.popupmenu5,'Visible','Off');
        set(handles.pushbutton1,'Visible','Off');
        set(handles.text32,'Visible','Off');
        set(handles.text33,'Visible','Off');
        set(handles.text34,'Visible','Off');
        set(handles.text35,'Visible','Off');
        set(handles.text36,'Visible','Off');
        set(handles.text37,'Visible','Off');
        set(handles.text38,'Visible','Off');
        set(handles.checkbox1,'Visible','Off');
        set(handles.checkbox2,'Visible','Off');
        
        cla;
        set(handles.axes1,'Visible','Off');
        set(handles.slider1,'Visible','Off');
        set(handles.text23,'Visible','Off');
        set(handles.slider2,'Visible','Off');
        set(handles.text24,'Visible','Off');
        set(handles.edit7,'Visible','Off');
        set(handles.pushbutton2,'Visible','Off');

        set(handles.axes2,'Visible','On');
        set(handles.axes3,'Visible','On');
        set(handles.text25,'Visible','On');
        set(handles.text26,'Visible','On');
        set(handles.text27,'Visible','On');
        set(handles.slider3,'Visible','On');
        set(handles.slider4,'Value',1-100/max(size(Obs)));
        set(handles.slider4,'Visible','On');
        set(handles.popupmenu6,'Visible','On');
        set(handles.popupmenu7,'Visible','On');
        set(handles.pushbutton3,'Visible','On');


        set(handles.text30,'Visible','Off');
        
        s = '';
        if (size(Contribution,3)>0)
            for (iS = 1:size(Contribution,1))
                for (iC = 1:size(Contribution,2))
                    s = sprintf('%sContribution of source %d on sensor %d|',s,iS,iC);    
                end
            end
        end
        for (iC = 1:size(Obs,1))
            s = sprintf('%sObservation on sensor %d|',s,iC);    
        end
        
        s = s(1:length(s)-1);
        set(handles.popupmenu6,'String',s);
        
        
        s = '';
        if (size(ContributionEst,3)>0)
            for (iS = 1:size(ContributionEst,1))
                for (iC = 1:size(ContributionEst,2))
                    s = sprintf('%sEstimated contribution of source %d on sensor %d|',s,iS,iC);    
                end
            end
        end
        for (iC = 1:size(Obs,1))
            s = sprintf('%sSum of the estimated contribution on sensor %d|',s,iC);    
        end
        
        s = s(1:length(s)-1);
        set(handles.popupmenu7,'String',s);

        PlotCurves(handles);        
        
        
    otherwise
        
end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global YAxis;
global Zoom;

x = get(hObject,'Value')*(0.5-Zoom);
set(handles.axes1,'XLim',[x x+Zoom]);
set(handles.axes1,'YLim',YAxis);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


global YAxis;
global Zoom;

Zoom = (1-get(hObject,'Value'))*0.49+0.01;
x = get(handles.slider1,'Value')*(0.5-Zoom);
set(handles.axes1,'XLim',[x x+Zoom]);
set(handles.axes1,'YLim',YAxis);


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global Obs;
global ContributionEst;

set(handles.text30,'Visible','On');
pause(1);

[ContributionEst] = DoSepate(handles,Obs);

ShowStep(handles,3);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

PlotCurves(handles);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

PlotCurves(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6

% On changle le popupmenu7

global Contribution;
global ContributionEst;

Curve1 = get(handles.popupmenu6,'Value');
if (size(Contribution,3)>0)
    if (Curve1<=(size(Contribution,1)*size(Contribution,2)))
        % On trace une contribution    
        Curve1 = Curve1-1;
        Nc = mod(Curve1,size(Contribution,2))+1; 
        Ns = floor((Curve1-Nc+1)/size(Contribution,2))+1; 
    
        Curve2 = (Ns-1)*size(ContributionEst,2)+Nc;
        
    else
        Curve2 = get(handles.popupmenu7,'Value')-1;
        Nc = mod(Curve2,size(ContributionEst,2))+1; 
        Ns = floor((Curve2-Nc+1)/size(ContributionEst,2))+1; 

        NObs = Curve1-size(Contribution,1)*size(Contribution,2);
        Curve2 = (Ns-1)*size(ContributionEst,2)+NObs;
            
    end
    
else
    Curve2 = get(handles.popupmenu7,'Value')-1;
    Nc = mod(Curve2,size(ContributionEst,2))+1; 
    Ns = floor((Curve2-Nc+1)/size(ContributionEst,2))+1; 

    NObs = Curve1;
    Curve2 = (Ns-1)*size(ContributionEst,2)+NObs;
end
set(handles.popupmenu7,'Value',Curve2);

PlotCurves(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
PlotCurves(handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ShowStep(handles,1);

function PlotCurves(handles)

global Obs;
global Contribution;
global ContributionEst;

axes(handles.axes2);
Curve1 = get(handles.popupmenu6,'Value');

if (size(Contribution,3)>0)
    if (Curve1<=(size(Contribution,1)*size(Contribution,2)))
        % On trace une contribution    
        Curve1 = Curve1-1;
        Nc = mod(Curve1,size(Contribution,2))+1; 
        Ns = floor((Curve1-Nc+1)/size(Contribution,2))+1; 
        CurrentSignal = real(permute(Contribution(Ns,Nc,:),[2 3 1]));
    else
        NObs = Curve1-size(Contribution,1)*size(Contribution,2);
        CurrentSignal = real(Obs(NObs,:));    
    end
    
else
    NObs = Curve1;
    CurrentSignal = real(Obs(NObs,:));    
end

plot(CurrentSignal);    
Zoom = 0.99-get(handles.slider4,'Value')+0.01;
Abs = get(handles.slider3,'Value')*(length(CurrentSignal)*Zoom);
set(handles.axes2,'XLim',[Abs Abs+length(CurrentSignal)*Zoom]);



axes(handles.axes3);
Curve2 = get(handles.popupmenu7,'Value');
if (Curve2<=(size(ContributionEst,1)*size(ContributionEst,2)))
    % On trace une contribution    
    Curve2 = Curve2-1;
    Nc = mod(Curve2,size(ContributionEst,2))+1; 
    Ns = floor((Curve2-Nc+1)/size(ContributionEst,2))+1; 
    CurrentSignal = real(permute(ContributionEst(Ns,Nc,:),[2 3 1]));    
else
    % On trace une observation
    NObs = Curve2-size(ContributionEst,1)*size(ContributionEst,2);
    ObsEst = permute(sum(ContributionEst,1),[2 3 1]);
    CurrentSignal = real(ObsEst(NObs,:));    
    
end

plot(CurrentSignal);    
set(handles.axes3,'XLim',[Abs Abs+length(CurrentSignal)*Zoom]);
set(handles.axes3,'YLim',get(handles.axes2,'YLim'));



function [ContributionEst] = DoSepate(handles,Obs)

global Contribution;
global FreqCycl;

if (isempty(get(handles.edit7,'String')))
    FreqCycl = [];
elseif (isspace(get(handles.edit7,'String')))
    FreqCycl = [];
else    
    FreqCycl = eval(get(handles.edit7,'String'));
end

if (get(handles.TypeSource,'Value')==1)
    [SEst,ContributionEst] = Deflation(Obs,ConvolutiveMixtureParameters,FreqCycl);
elseif (get(handles.TypeSource,'Value')==2)
    if (get(handles.popupmenu5,'Value')==1)
        [SEst,ContributionEst] = Deflation(Obs,InstantaneousMixtureParameters,FreqCycl);
    else 
        [SEst,ContributionEst] = Deflation(Obs,ConvolutiveMixtureParameters,FreqCycl);
    end
else
    [SEst,ContributionEst] = Deflation(Obs,ConvolutiveMixtureParameters,FreqCycl);
end

% The estimated contribution have to be reorganized :

if (size(Contribution,3)>0)
    addpath(sprintf('%s/Demo/EstimeSeparationPerfs/',pwd));
    CEst = ContributionEst;
    for (iContribution = 1:size(Contribution,1))
        [iSourceExtraite,MSE(iContribution)] = CalculCritere(Contribution,permute(ContributionEst(iContribution,:,:),[2 3 1]));
        CEst(iSourceExtraite,:,:) = ContributionEst(iContribution,:,:);
    end
    ContributionEst = CEst;
    rmpath(sprintf('%s/Demo/EstimeSeparationPerfs/',pwd));
end


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


