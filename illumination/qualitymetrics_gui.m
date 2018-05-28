function varargout = qualitymetrics_gui(varargin)
% QUALITYMETRICS_GUI MATLAB code for qualitymetrics_gui.fig
%      QUALITYMETRICS_GUI, by itself, creates a new QUALITYMETRICS_GUI or raises the existing
%      singleton*.
%
%      H = QUALITYMETRICS_GUI returns the handle to a new QUALITYMETRICS_GUI or the handle to
%      the existing singleton*.
%
%      QUALITYMETRICS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUALITYMETRICS_GUI.M with the given input arguments.
%
%      QUALITYMETRICS_GUI('Property','Value',...) creates a new QUALITYMETRICS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before qualitymetrics_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to qualitymetrics_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help qualitymetrics_gui

% Last Modified by GUIDE v2.5 28-May-2018 14:40:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @qualitymetrics_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @qualitymetrics_gui_OutputFcn, ...
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


% --- Executes just before qualitymetrics_gui is made visible.
function qualitymetrics_gui_OpeningFcn(hObject, eventdata, handles, varargin)
global path1 path2
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qualitymetrics_gui (see VARARGIN)
path1 = 'img_evaltests/dataset2/segment_cropped (6).png';
path2 = 'img_evaltests/dataset2/segment_cropped (3).png';
initimages();
updategraphs(handles);
initsliders(handles);

% Choose default command line output for qualitymetrics_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes qualitymetrics_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function initimages()
    global path1 path2 img1 img2 img1_cropped img2_cropped img1_wlim img1_hlim

    img1 = imread(path1);
    img2 = imread(path2);
    img1_cropped = img1;
    img2_cropped = img2;
    [h, w] = size(img1);
    img1_wlim = [1 w];
    img1_hlim = [1 h];

function initsliders(handles)
    set(handles.slider1_htop,'Value',1);
    set(handles.slider1_hbottom,'Value',0);
    set(handles.slider1_wleft,'Value',0);
    set(handles.slider1_wright,'Value',1);

% --- Outputs from this function are returned to the command line.
function varargout = qualitymetrics_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global path2
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.png');
if isequal(file,0)
   disp('User selected Cancel');
else
   path2 = fullfile(path,file)
   disp(['User selected ', path2]);
   updategraphs(handles);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global path1 path2
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.png');
if isequal(file,0)
   disp('User selected Cancel');
else
   path1 = fullfile(path,file)
   disp(['User selected ', path1]);
   initimages();
   initsliders(handles);
   updategraphs(handles);
end

function updategraphs(handles)
global path1 path2 img1_cropped img2_cropped
%img1 = imread('img_evaltests/dataset2/segment_cropped (6).png');
%img2 = imread('img_evaltests/dataset2/segment_cropped (3).png');
%img1 = imread(path1);
%img2 = imread(path2);

axes(handles.axes1);
imshow(img1_cropped);
axes(handles.axes2);
imshow(img2_cropped);
axes(handles.axes3);
imhist(img1_cropped);
axes(handles.axes4);
imhist(img2_cropped);

data(:,1) = qualitymetrics(img1_cropped);
data(:,2) = qualitymetrics(img2_cropped);

%# convert matrix of numbers to cell array of strings (right aligned)
XX = reshape(strtrim(cellstr(num2str(data(:)))), size(data));

idx = ( data(:,1) > data(:,2) );
XX(idx,1) = strcat(...
    '<html><span style="color: #FF0000; font-weight: bold;">', ...
    XX(idx,1), ...
    '</span></html>');

idx = ( data(:,2) > data(:,1) );
XX(idx,2) = strcat(...
    '<html><span style="color: #FF0000; font-weight: bold;">', ...
    XX(idx,2), ...
    '</span></html>');

set(handles.comparisontable, 'Data', XX);

function output = imgcrop(img, hlim, wlim)
hlim 
wlim
output = img(hlim(1):hlim(2),wlim(1):wlim(2));

% --- Executes on slider movement.
function slider1_htop_Callback(hObject, eventdata, handles)
global img1 img1_cropped img1_wlim img1_hlim
% hObject    handle to slider1_htop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

[h w] = size(img1);
val = 1 - get(handles.slider1_htop,'Value');
index = round(val*h/2);
if(index<1)
    index = 1;
end
img1_hlim(1) = index;
img1_cropped = imgcrop(img1,img1_hlim,img1_wlim);
updategraphs(handles);

% --- Executes during object creation, after setting all properties.
function slider1_htop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1_htop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider1_wright_Callback(hObject, eventdata, handles)
global img1 img1_cropped img1_wlim img1_hlim
% hObject    handle to slider1_wright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
[h w] = size(img1);
val = get(handles.slider1_wright,'Value');
index = round(w/2 + val*w/2);
if(index<1)
    index = 1;
end
img1_wlim(2) = index;
img1_cropped = imgcrop(img1,img1_hlim,img1_wlim);
updategraphs(handles);

% --- Executes during object creation, after setting all properties.
function slider1_wright_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1_wright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider1_hbottom_Callback(hObject, eventdata, handles)
global img1 img1_cropped img1_wlim img1_hlim
% hObject    handle to slider1_hbottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
[h w] = size(img1);
val = 1 - get(handles.slider1_hbottom,'Value');
index = round(h/2 + val*h/2);
if(index<1)
    index = 1;
end
img1_hlim(2) = index;
img1_cropped = imgcrop(img1,img1_hlim,img1_wlim);
updategraphs(handles);

% --- Executes during object creation, after setting all properties.
function slider1_hbottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1_hbottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider1_wleft_Callback(hObject, eventdata, handles)
global img1 img1_cropped img1_wlim img1_hlim
% hObject    handle to slider1_wleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
[h w] = size(img1);
val = get(handles.slider1_wleft,'Value');
index = round(val*w/2);
if(index<1)
    index = 1;
end
img1_wlim(1) = index;
img1_cropped = imgcrop(img1,img1_hlim,img1_wlim);
updategraphs(handles);

% --- Executes during object creation, after setting all properties.
function slider1_wleft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1_wleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
