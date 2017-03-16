function varargout = createFilterCondition(varargin)
% CREATEFILTERCONDITION MATLAB code for createFilterCondition.fig
%      CREATEFILTERCONDITION, by itself, creates a new CREATEFILTERCONDITION or raises the existing
%      singleton*.
%
%      H = CREATEFILTERCONDITION returns the handle to a new CREATEFILTERCONDITION or the handle to
%      the existing singleton*.
%
%      CREATEFILTERCONDITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATEFILTERCONDITION.M with the given input arguments.
%
%      CREATEFILTERCONDITION('Property','Value',...) creates a new CREATEFILTERCONDITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before createFilterCondition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to createFilterCondition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help createFilterCondition

% Last Modified by GUIDE v2.5 06-Jun-2011 17:52:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @createFilterCondition_OpeningFcn, ...
                   'gui_OutputFcn',  @createFilterCondition_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin>1 && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before createFilterCondition is made visible.
function createFilterCondition_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to createFilterCondition (see VARARGIN)

% Choose default command line output for createFilterCondition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes createFilterCondition wait for user response (see UIRESUME)

% get input
isNumeric=varargin{1};
setappdata(handles.figure1,'isNumeric',isNumeric);

if isNumeric
    popupmenuSelection={'equals','does not equal','is greater than',...
        'is greater than or equal to','is less than','is less than or equal to'};
else
    popupmenuSelection={'equals','does not equal','begins with','does not begin with',...
       'ends with','does not end with','contains'};
end        
set(handles.condition1_popupmenu,'String',popupmenuSelection);
set(handles.condition1_popupmenu,'Value',1);

set(handles.condition2_popupmenu,'String',[{' '},popupmenuSelection]);
set(handles.condition2_popupmenu,'Value',1);

uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = createFilterCondition_OutputFcn(~, ~, ~) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% get outputs
global TRANSPORT_VARARGOUT;

if isempty(TRANSPORT_VARARGOUT)
    % isCanceled:
    TRANSPORT_VARARGOUT{1}=true;
    % condition
    TRANSPORT_VARARGOUT{2}='';
    
end
varargout=TRANSPORT_VARARGOUT;

clear global TRANSPORT_VARARGOUT;

return

% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TRANSPORT_VARARGOUT;

% isCanceled:
TRANSPORT_VARARGOUT{1}=false;

% condition
i_cond=get(handles.condition1_popupmenu,'Value');
value_cond=get(handles.condition1_edit,'String');
condition=getCondition(handles,i_cond,value_cond);

i_cond=get(handles.condition2_popupmenu,'Value');
value_cond=get(handles.condition2_edit,'String');
if i_cond>1
    if get(handles.and_radiobutton,'Value')
        condition=[condition,' & ', getCondition(handles,i_cond-1,value_cond)];
    else
        condition=[condition,' | ', getCondition(handles,i_cond-1,value_cond)];
    end        
end
TRANSPORT_VARARGOUT{2}=condition;


closereq;

return

% --- Executes on button press in Cancel_pushbutton.
function Cancel_pushbutton_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to Cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closereq;

return


% --- Executes on selection change in condition1_popupmenu.
function condition1_popupmenu_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to condition1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns condition1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from condition1_popupmenu


% --- Executes during object creation, after setting all properties.
function condition1_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to condition1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function condition1_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to condition1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of condition1_edit as text
%        str2double(get(hObject,'String')) returns contents of condition1_edit as a double

isNumeric=getappdata(handles.figure1,'isNumeric');

if isNumeric
    guiCheckNumerical(hObject,'true');
end

return


% --- Executes during object creation, after setting all properties.
function condition1_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to condition1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in condition2_popupmenu.
function condition2_popupmenu_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to condition2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns condition2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from condition2_popupmenu



% --- Executes during object creation, after setting all properties.
function condition2_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to condition2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function condition2_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to condition2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of condition2_edit as text
%        str2double(get(hObject,'String')) returns contents of condition2_edit as a double

isNumeric=getappdata(handles.figure1,'isNumeric');

if isNumeric
    guiCheckNumerical(hObject,'true');
end

return

% --- Executes during object creation, after setting all properties.
function condition2_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to condition2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% user defined functions
function condition=getCondition(handles,i_cond,value_cond)
    
isNumeric=getappdata(handles.figure1,'isNumeric');

if isNumeric
    %popupmenuSelection={'equals','does not equal','is greater than',...
    %    'is greater than or equal to','is less than','is less than or equal to'};
    
    switch i_cond
        case 1
            condition=sprintf('value==%s',value_cond);
        case 2
            condition=sprintf('value~=%s',value_cond);
        case 3
            condition=sprintf('value>%s',value_cond);
        case 4
            condition=sprintf('value>=%s',value_cond);
        case 5
            condition=sprintf('value<%s',value_cond);
        case 6
            condition=sprintf('value<=%s',value_cond);
    end
else
    %popupmenuSelection={'equals','does not equal','begins with','does not begin with',...
    %    'ends with','does not end with','contains'};
    switch i_cond
        case 1
            condition=sprintf('strcmp(value,%s)',value_cond);
        case 2
            condition=sprintf('~strcmp(value,%s)',value_cond);
        case 3
            condition=sprintf('strBegins(value,%s)',value_cond);
        case 4
            condition=sprintf('~strBegins(value,%s)',value_cond);
        case 5
            condition=sprintf('strEnds(value,%s)',value_cond);
        case 6
            condition=sprintf('~strEnds(value,%s)',value_cond);
        case 7
            condition=sprintf('strContains(value,%s)',value_cond);
    end

end 
