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

% Last Modified by GUIDE v2.5 28-May-2018 09:20:55

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qualitymetrics_gui (see VARARGIN)

img1 = imread('img_evaltests/dataset2/segment_cropped (1).png');
img2 = imread('img_evaltests/dataset2/segment_cropped (3).png');

axes(handles.axes1);
imshow(img1);
axes(handles.axes2);
imshow(img2);
axes(handles.axes3);
imhist(img1);
axes(handles.axes4);
imhist(img2);

data(:,1) = qualitymetrics(img1);
data(:,2) = qualitymetrics(img2);
set(handles.comparisontable, 'Data', data);


% Choose default command line output for qualitymetrics_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes qualitymetrics_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = qualitymetrics_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;
