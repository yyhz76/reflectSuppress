% SLIDER_DEMO MATLAB code for single image reflection suppression

function varargout = slider_demo(varargin)
% SLIDER_DEMO MATLAB code for slider_demo.fig
%      SLIDER_DEMO, by itself, creates a new SLIDER_DEMO or raises the existing
%      singleton*.
%
%      H = SLIDER_DEMO returns the handle to a new SLIDER_DEMO or the handle to
%      the existing singleton*.
%
%      SLIDER_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLIDER_DEMO.M with the given input arguments.
%
%      SLIDER_DEMO('Property','Value',...) creates a new SLIDER_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before slider_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to slider_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help slider_demo

% Last Modified by GUIDE v2.5 11-Mar-2018 21:49:05

% Begin initialization code - DO NOT EDIT

addpath(genpath(pwd))

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @slider_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @slider_demo_OutputFcn, ...
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


% --- Executes just before slider_demo is made visible.
function slider_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to slider_demo (see VARARGIN)

% Choose default command line output for slider_demo
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes slider_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = slider_demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = handles.a;

h = get(hObject,'Value');

c = reflectSuppress(a, h, 1e-8);

str = ['Threshold h:', ' ', sprintf('%.3f',h)];

set(handles.edit1, 'String', str);

axes(handles.axes2);

imshow(c);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.jpg', 'Pick an image', '.\figures');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       a = imread(filename);
       
       axes(handles.axes1);
       imshow(a);
       handles.a = a;
    end
    % Update handles structure
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
