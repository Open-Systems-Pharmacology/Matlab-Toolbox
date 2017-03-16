function varargout = UnitSpecification(varargin)
% UNITSPECIFICATION MATLAB code for UnitSpecification.fig
%      UNITSPECIFICATION, by itself, creates a new UNITSPECIFICATION or raises the existing
%      singleton*.
%
%      H = UNITSPECIFICATION returns the handle to a new UNITSPECIFICATION or the handle to
%      the existing singleton*.
%
%      UNITSPECIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNITSPECIFICATION.M with the given input arguments.
%
%      UNITSPECIFICATION('Property','Value',...) creates a new UNITSPECIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UnitSpecification_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UnitSpecification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UnitSpecification

% Last Modified by GUIDE v2.5 22-Nov-2012 13:34:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UnitSpecification_OpeningFcn, ...
                   'gui_OutputFcn',  @UnitSpecification_OutputFcn, ...
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


% --- Executes just before UnitSpecification is made visible.
function UnitSpecification_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UnitSpecification (see VARARGIN)

% Choose default command line output for UnitSpecification
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

unit=varargin{1};
objectName=varargin{2};

description_text={sprintf('The Unit "%s" for "%s" is not known by the matlab toolbox.',unit,objectName) ,...
'Please specify dimension and unit.' ,...
'If you do not find a corresponding unit, generate the corresponding unit and dimension with the Tool Unit Converter.'};


set(handles.description_text,'String',description_text);
iniUnits(handles);

% UIWAIT makes UnitSpecification wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UnitSpecification_OutputFcn(~, ~, ~) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;

% get outputs
global TRANSPORT_VARARGOUT;

if isempty(TRANSPORT_VARARGOUT)
    % Dimension:
    TRANSPORT_VARARGOUT{1}='Dimensionless';
    % Unit
    TRANSPORT_VARARGOUT{2}='';
    
end
varargout=TRANSPORT_VARARGOUT;

clear global TRANSPORT_VARARGOUT;

return



% --- Executes on selection change in dimension_popupmenu.
function dimension_popupmenu_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to dimension_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dimension_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dimension_popupmenu

setUnitListPopup(handles,get(hObject,'Value'));

return


% --- Executes during object creation, after setting all properties.
function dimension_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to dimension_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in unit_popupmenu.
function unit_popupmenu_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns unit_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unit_popupmenu


% --- Executes during object creation, after setting all properties.
function unit_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TRANSPORT_VARARGOUT;

tmp=get(handles.dimension_popupmenu,'String');
TRANSPORT_VARARGOUT{1}=tmp{get(handles.dimension_popupmenu,'Value')};
tmp=get(handles.unit_popupmenu,'String');
TRANSPORT_VARARGOUT{2}=tmp{get(handles.unit_popupmenu,'Value')};

closereq
return

% --- Executes on button press in UnitConverter_pushbutton.
function UnitConverter_pushbutton_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to UnitConverter_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

waitfor(UnitConverter);
iniUnits(handles);

return


function iniUnits(handles)

[unitList,unitList_dimensionList]=iniUnitList(0);
setappdata(handles.figure1,'unitList',unitList);

set(handles.dimension_popupmenu,'String',unitList_dimensionList);
ij=find(strcmp('Dimensionless',unitList_dimensionList));
if isempty(ij)
    ij=1;
end
set(handles.dimension_popupmenu,'Value',ij);
setUnitListPopup(handles,ij);

return

function setUnitListPopup(handles,ij)

unitList=getappdata(handles.figure1,'unitList');

set(handles.unit_popupmenu,'Value',1);
set(handles.unit_popupmenu,'String',unitList(ij).unit_txt);

return
