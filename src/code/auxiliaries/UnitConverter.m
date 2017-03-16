function varargout = UnitConverter(varargin)
% UNITCONVERTER a GUI suited to add new units to the MoBi Toolboxes

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 20-Dec-2010

% UNITCONVERTER MATLAB code for UnitConverter.fig
%      UNITCONVERTER, by itself, creates a new UNITCONVERTER or raises the existing
%      singleton*.
%
%      H = UNITCONVERTER returns the handle to a new UNITCONVERTER or the handle to
%      the existing singleton*.
%
%      UNITCONVERTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNITCONVERTER.M with the given input arguments.
%
%      UNITCONVERTER('Property','Value',...) creates a new UNITCONVERTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UnitConverter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UnitConverter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES


% Last Modified by GUIDE v2.5 02-Oct-2012 13:42:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UnitConverter_OpeningFcn, ...
                   'gui_OutputFcn',  @UnitConverter_OutputFcn, ...
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


% --- Executes just before UnitConverter is made visible.
function UnitConverter_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UnitConverter (see VARARGIN)

% Choose default command line output for UnitConverter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% getHel file name
filename = mfilename('fullpath');
helpFile=getHelpFile('Base',filename);

if ~exist(helpFile,'file')
    set(hObject,'visible','off');
else
    setappdata(hObject,'helpFile',helpFile);
end

% Define tabs
tabGroup = uitabgroup('Parent',handles.figure1);
set(tabGroup,'SelectionChangeCallback',...
    @(obj,evt) selectionChangeTabGroup(obj,evt));

tab_definition = uitab('parent',tabGroup,'title','Unit Definition');
set(handles.unitDefinition_uipanel,'Parent',tab_definition);
set(tab_definition,'Tag','definition');

tab_translation = uitab('parent',tabGroup,'title','String Translation');
set(handles.unitTranslation_uipanel,'Parent',tab_translation);
set(tab_translation,'Tag','translation');


setappdata(handles.figure1,'tabGroup',tabGroup);



% Initialize Unit List
[unitList,unitList_dimensionList,unitTranslationList]=iniUnitList(0);
setappdata(handles.figure1,'unitList',unitList);
setappdata(handles.figure1,'unitList_dimensionList',unitList_dimensionList);
setappdata(handles.figure1,'unitTranslationList',unitTranslationList);

[defaultList,defaultList_dimensionList]=iniUnitList(1);
setappdata(handles.figure1,'defaultList',defaultList);
setappdata(handles.figure1,'defaultList_dimensionList',defaultList_dimensionList);

%Initialize handles
set(handles.dimension_popupmenu,'String',unitList_dimensionList);
selectDimension(handles,1);

% set translationList
if ~isempty(unitTranslationList)
    data=unitTranslationList;
   data(:,4)=repmat({'<html><b><u>edit</u></b></html>'},size(data,1),1);
   data(:,5)=repmat({'<html><b><u>delete</u></b></html>'},size(data,1),1);
else
    data=cell(0,4);
end
set(handles.translationList_uitable,'data',data);

resetWarning(handles);
% UIWAIT makes UnitConverter wait for user response (see UIRESUME)
% uiwait(handles.figure1);

return

% --- Outputs from this function are returned to the command line.
function varargout = UnitConverter_OutputFcn(hObject, ~, ~)  
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;

varargout{1}=hObject;

% --------------------------------------------------------------------
function help_uipushtool_ClickedCallback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to help_uipushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helpFile=getappdata(handles.figure1,'helpFile');
open(helpFile);

return

% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



global MOBI_SETTINGS;

% reset warning
resetWarning(handles);

application_path=MOBI_SETTINGS.application_path;

unitList=getappdata(handles.figure1,'unitList'); 
unitList_dimensionList=getappdata(handles.figure1,'unitList_dimensionList'); 

MOBI_SETTINGS.unitList=unitList; 
MOBI_SETTINGS.unitList_dimensionList=unitList_dimensionList; 

unitTranslationList=getappdata(handles.figure1,'unitTranslationList'); %#ok<NASGU>
save([application_path  'unitList'],'unitList','unitList_dimensionList','unitTranslationList');

closereq;

return

% --- Executes on button press in cancel_pushbutton.
function cancel_pushbutton_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closereq;

return

% --- Executes on selection change in dimension_popupmenu.
function dimension_popupmenu_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to dimension_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dimension_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dimension_popupmenu

% reset warning
resetWarning(handles);

selectDimension(handles,get(hObject,'Value'));
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


% --- Executes on button press in add_dimension_pushbutton.
function add_dimension_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to add_dimension_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset warning
resetWarning(handles);

% load necessary variables
unitList=getappdata(handles.figure1,'unitList');
unitList_dimensionList=getappdata(handles.figure1,'unitList_dimensionList');

%new dimension
dimension=get(handles.dimension_edit,'String');
baseUnit=get(handles.baseUnit_edit,'String');

% check if dimension already exists
if any(strcmp(unitList_dimensionList,dimension))
    set(handles.warning_text,'String','There is already a dimension with this name!');
    return
end

% add the new dimension to unitList_dimensionList
unitList_dimensionList{end+1}=dimension;
iDim=length(unitList_dimensionList);
unitList(iDim).formula{1}='1';
unitList(iDim).unit_txt{1}=baseUnit;
unitList(iDim).baseUnit=baseUnit;
unitList(iDim).par_descriptions={};
unitList(iDim).par_names={};

% sort dimensions alphabetically
[unitList_dimensionList,ix]=sort(unitList_dimensionList);
unitList=unitList(ix);

% save updated unitList
setappdata(handles.figure1,'unitList',unitList);
setappdata(handles.figure1,'unitList_dimensionList',unitList_dimensionList);

% set handles according the unitList
set(handles.dimension_popupmenu,'String',unitList_dimensionList);

iDim=find(strcmp(unitList_dimensionList,dimension));
selectDimension(handles,iDim);

return



function dimension_edit_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to dimension_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimension_edit as text
%        str2double(get(hObject,'String')) returns contents of dimension_edit as a double

% reset warning
resetWarning(handles);

return

% --- Executes during object creation, after setting all properties.
function dimension_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to dimension_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deleteUnit_pushbutton.
function deleteUnit_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to deleteUnit_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset warning
resetWarning(handles);

% load necessary variables
iDim=get(handles.dimension_popupmenu,'Value');
unitList=getappdata(handles.figure1,'unitList');
nUnits=length(unitList(iDim).unit_txt);
iU=get(handles.unit_popupmenu,'Value');


% delete the new unit to unitList
keep=setdiff(1:nUnits,iU);
unitList(iDim).unit_txt=unitList(iDim).unit_txt(keep);
unitList(iDim).formula=unitList(iDim).formula(keep);

% save updated unitList
setappdata(handles.figure1,'unitList',unitList);

% set handles according the unitList
iU=max(iU-1,1);
setUnits(handles,iU);
selectUnit(handles,iU);

% update table
setTable(handles);

return

% --- Executes on button press in addUnit_pushbutton.
% generates new unit in the unitList structure
function addUnit_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to addUnit_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset warning
resetWarning(handles);

% load necessary variables
iDim=get(handles.dimension_popupmenu,'Value');
unitList=getappdata(handles.figure1,'unitList');

% new unit
unit=get(handles.unit_edit,'string');

% check if unit already exists
if any(strcmp(unitList(iDim).unit_txt,unit))
    set(handles.warning_text,'String','There is already a unit with this name!');
    return
end

% add the new unit to unitList
unitList(iDim).unit_txt{end+1}=unit;
unitList(iDim).formula{end+1}=get(handles.factor_edit,'string');
checkValidity_factor_edit(handles);

% sort units by factor
[~,ix]=evalFactor(unitList(iDim));
unitList(iDim).unit_txt=unitList(iDim).unit_txt(ix);
unitList(iDim).formula=unitList(iDim).formula(ix);

% save updated unitList
setappdata(handles.figure1,'unitList',unitList);

% set handles according the unitList
iU=find(strcmp(unit,unitList(iDim).unit_txt));
setUnits(handles,iU);
selectUnit(handles,iU);

% update table
setTable(handles);

return

function unit_edit_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to unit_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of unit_edit as text
%        str2double(get(hObject,'String')) returns contents of unit_edit as a double

% reset warning
resetWarning(handles);

return

% --- Executes during object creation, after setting all properties.
function unit_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to unit_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function factor_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to factor_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of factor_edit as text
%        str2double(get(hObject,'String')) returns contents of factor_edit as a double

% reset warning
resetWarning(handles);

% replace , decimal separator with .
tmp=get(hObject,'String');
tmp =strrep(tmp,',','.');
set(hObject,'String',tmp);

% check field input
checkValidity_factor_edit(handles);

return

% --- Executes during object creation, after setting all properties.
function factor_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to factor_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in unit_popupmenu.
function unit_popupmenu_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns unit_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unit_popupmenu

% reset warning
resetWarning(handles);

iU=get(handles.unit_popupmenu,'Value');
selectUnit(handles,iU);

return

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


% --- Executes on button press in updateUnit_pushbutton.
function updateUnit_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to updateUnit_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset warning
resetWarning(handles);

% load necessary variables
iDim=get(handles.dimension_popupmenu,'Value');
unitList=getappdata(handles.figure1,'unitList');
iU=get(handles.unit_popupmenu,'Value');
nUnits=length(unitList(iDim).unit_txt);

% new unit name
unit=get(handles.unit_edit,'string');


% check if unit already exists
if any(strcmp(unitList(iDim).unit_txt(setdiff(1:nUnits,iU)),unit))
    set(handles.warning_text,'String','There is already a unit with this name!');
    return
end

% update the unit to unitList
unitList(iDim).unit_txt{iU}=unit;
unitList(iDim).formula{iU}=get(handles.factor_edit,'string');


% sort units by factor
[~,ix]=evalFactor(unitList(iDim));
unitList(iDim).unit_txt=unitList(iDim).unit_txt(ix);
unitList(iDim).formula=unitList(iDim).formula(ix);

% save updated unitList
setappdata(handles.figure1,'unitList',unitList);

% set handles according the unitList
iU=find(strcmp(unit,unitList(iDim).unit_txt));
setUnits(handles,iU);
selectUnit(handles,iU);

% update table
setTable(handles);

return


function baseUnit_edit_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to baseUnit_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baseUnit_edit as text
%        str2double(get(hObject,'String')) returns contents of baseUnit_edit as a double

% reset warning
resetWarning(handles);

return

% --- Executes during object creation, after setting all properties.
function baseUnit_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to baseUnit_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deleteDimension_pushbutton.
function deleteDimension_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to deleteDimension_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset warning
resetWarning(handles);

% load necessary variables
unitList=getappdata(handles.figure1,'unitList');
unitList_dimensionList=getappdata(handles.figure1,'unitList_dimensionList');
iDim=get(handles.dimension_popupmenu,'Value');

% remove the new dimension to unitList_dimensionList
keep=setdiff(1:length(unitList_dimensionList),iDim);
unitList_dimensionList=unitList_dimensionList(keep);
unitList=unitList(keep);


% save updated unitList
setappdata(handles.figure1,'unitList',unitList);
setappdata(handles.figure1,'unitList_dimensionList',unitList_dimensionList);

% set handles according the unitList
set(handles.dimension_popupmenu,'String',unitList_dimensionList);

iDim=max(1,iDim-1);
selectDimension(handles,iDim);

return


% --- Executes on selection change in parameter_popupmenu.
function parameter_popupmenu_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to parameter_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns parameter_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from parameter_popupmenu

% reset warning
resetWarning(handles);

selectParameter(handles,get(hObject,'Value'));
return

% --- Executes during object creation, after setting all properties.
function parameter_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to parameter_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function description_edit_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to description_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of description_edit as text
%        str2double(get(hObject,'String')) returns contents of description_edit as a double

% reset warning
resetWarning(handles);

return

% --- Executes during object creation, after setting all properties.
function description_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to description_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function name_edit_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name_edit as text
%        str2double(get(hObject,'String')) returns contents of name_edit as a double

% reset warning
resetWarning(handles);

return

% --- Executes during object creation, after setting all properties.
function name_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_edit as text
%        str2double(get(hObject,'String')) returns contents of value_edit as a double

% reset warning
resetWarning(handles);

valid=guiCheckNumerical(hObject);

if valid
    set(handles.addParameter_pushbutton,'enable','on');
else
    set(handles.addParameter_pushbutton,'enable','off');
end

return

% --- Executes during object creation, after setting all properties.
function value_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addParameter_pushbutton.
function addParameter_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to addParameter_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset warning
resetWarning(handles);

% load necessary variables
unitList=getappdata(handles.figure1,'unitList');
iDim=get(handles.dimension_popupmenu,'Value');

%new parameter
description=get(handles.description_edit,'String');
name=get(handles.name_edit,'String');
value=str2double(get(handles.value_edit,'String'));

% set a description
if isempty(description)
    description=name;
end

% check if parameter already exists
if any(strcmp(unitList(iDim).par_names,name))
    set(handles.warning_text,'String','There is already a parameter with this name!');
    return
end

% add the new parameter to unitList
unitList(iDim).par_descriptions{end+1}=description;
unitList(iDim).par_names{end+1}=name;
unitList(iDim).par_values(end+1)=value;

% sort parameters alphabetically
[unitList(iDim).par_descriptions,ix]=sort(unitList(iDim).par_descriptions);
unitList(iDim).par_names=unitList(iDim).par_names(ix);
unitList(iDim).par_values=unitList(iDim).par_values(ix);

% save updated unitList
setappdata(handles.figure1,'unitList',unitList);

% set handles according the unitList
set(handles.parameter_popupmenu,'String',unitList(iDim).par_descriptions);

iP=find(strcmp(unitList(iDim).par_names,name));
selectParameter(handles,iP);

return

% --- Executes on button press in deleteParameter_pushbutton.
function deleteParameter_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to deleteParameter_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset warning
resetWarning(handles);

% load necessary variables
unitList=getappdata(handles.figure1,'unitList');
iDim=get(handles.dimension_popupmenu,'Value');
iP=get(handles.parameter_popupmenu,'Value');


% get the units where the parameter might be used
jj_used=~cellfun(@isempty,regexp(unitList(iDim).formula, unitList(iDim).par_names{iP}));
    
if any(jj_used)
    % check if formulas still valid
    for iPList=setdiff(1:length(unitList(iDim).par_names),iP)
        eval([unitList(iDim).par_names{iPList} '= ' num2str(unitList(iDim).par_values(iPList))]);
    end

    % eval formulas    
    for iFormula=find(jj_used)
        try
            eval(unitList(iDim).formula{iFormula});
        catch     %#ok<CTCH>
            set(handles.warning_text,'String','Parameter is used in formula. Deletion is not possible!');
            return
        end
    end

end

% remove the parameter from unitList
keep=setdiff(1:length(unitList(iDim).par_descriptions),iP);
unitList(iDim).par_descriptions=unitList(iDim).par_descriptions(keep);
unitList(iDim).par_names=unitList(iDim).par_names(keep);
unitList(iDim).par_values=unitList(iDim).par_values(keep);


% save updated unitList
setappdata(handles.figure1,'unitList',unitList);

% set handles according the unitList
if isempty(unitList(iDim).par_descriptions)
    set(handles.parameter_popupmenu,'String',{''});
else
    set(handles.parameter_popupmenu,'String',unitList(iDim).par_descriptions);
end

iP=max(1,iP-1);
selectParameter(handles,iP);

return


% --- Executes on button press in updateParameter_pushbutton.
function updateParameter_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to updateParameter_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset warning
resetWarning(handles);

% load necessary variables
unitList=getappdata(handles.figure1,'unitList');
iDim=get(handles.dimension_popupmenu,'Value');
iP=get(handles.parameter_popupmenu,'Value');

%new parameter
description=get(handles.description_edit,'String');
name=get(handles.name_edit,'String');
value=str2double(get(handles.value_edit,'String'));

% check if parameter already exists
if ~strcmp(name,unitList(iDim).par_names{iP})  && any(strcmp(unitList(iDim).par_names,name))
    set(handles.warning_text,'String','There is already a parameter with this name!');
    return
end

% get the units where the parameter might be used
jj_used=~cellfun(@isempty,regexp(unitList(iDim).formula, unitList(iDim).par_names{iP}));

% add the new parameter to unitList
unitList(iDim).par_descriptions{iP}=description;
unitList(iDim).par_names{iP}=name;
unitList(iDim).par_values(iP)=value;

if any(jj_used)
    % check if formulas still valid
    for iPList=1:length(unitList(iDim).par_names)
        eval([unitList(iDim).par_names{iPList} '= ' num2str(unitList(iDim).par_values(iPList))]);
    end

    % eval formulas    
    for iFormula=find(jj_used)
        try
            eval(unitList(iDim).formula{iFormula});
        catch     %#ok<CTCH>
            set(handles.warning_text,'String','Parameter is used in formula. By updating this formulas became invalid!');
            return
        end
    end

end


% sort dimensions alphabetically
[unitList(iDim).par_descriptions,ix]=sort(unitList(iDim).par_descriptions);
unitList(iDim).par_names=unitList(iDim).par_names(ix);
unitList(iDim).par_values=unitList(iDim).par_values(ix);

% save updated unitList
setappdata(handles.figure1,'unitList',unitList);

% set handles according the unitList
set(handles.parameter_popupmenu,'String',unitList(iDim).par_descriptions);

iP=find(strcmp(unitList(iDim).par_names,name));
selectParameter(handles,iP);

% refresh Table
setTable(handles);
 
return

% --- Executes on button press in reset_pushbutton.
function reset_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to reset_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initialize Unit List
[unitList,unitList_dimensionList]=iniUnitList(2);
setappdata(handles.figure1,'unitList',unitList);
setappdata(handles.figure1,'unitList_dimensionList',unitList_dimensionList);

%Initialize handles
set(handles.dimension_popupmenu,'String',unitList_dimensionList);
selectDimension(handles,1);

resetWarning(handles);

return

%% user specific functions


% --- checks if the dimension belongs to default dimension
function [isDefaultDimension,iDimDef]=checkIfDimensionIsDefault(handles,dimension)
% Intrinsic units can't be updated or deleted

defaultList_dimensionList=getappdata(handles.figure1,'defaultList_dimensionList');
iDimDef=find(strcmp(defaultList_dimensionList,dimension));
isDefaultDimension=~isempty(iDimDef);


return

% --- checks if the unit belongs to default units
function isDefaultUnit=checkIfUnitIsDefault(handles,dimension,unit)


% if dimension is not default unit is also not default
[isDefaultDimension,iDimDef]=checkIfDimensionIsDefault(handles,dimension);
if ~isDefaultDimension
    isDefaultUnit=false;
    return
end

defaultList=getappdata(handles.figure1,'defaultList');

isDefaultUnit=any(strcmp(unit,defaultList(iDimDef).unit_txt));

return

% --- check if Units is Base unit
function isBaseUnit=checkIfUnitIsBase(handles,unit)

baseUnit=get(handles.baseUnit_text,'String');
isBaseUnit=strcmp(unit,baseUnit);

return

% --- checks if the parameter belongs to default parameters
function isDefaultPar=checkIfParameterIsDefault(handles,dimension,par_name)


% if dimension is not default unit is also not default
[isDefaultDimension,iDimDef]=checkIfDimensionIsDefault(handles,dimension);
if ~isDefaultDimension
    isDefaultPar=false;
    return
end

defaultList=getappdata(handles.figure1,'defaultList');

isDefaultPar=any(strcmp(par_name,defaultList(iDimDef).par_names));

return
% --- Executes on selection change in dimension_popupmenu.
function selectDimension(handles,iDim)

% Set dimension popup
set(handles.dimension_popupmenu,'Value',iDim);
dimensions=get(handles.dimension_popupmenu,'String');

% enable delete and update button if dimension is not intrinsic
if checkIfDimensionIsDefault(handles,dimensions{iDim});
    set(handles.deleteDimension_pushbutton,'enable','off');
else
    set(handles.deleteDimension_pushbutton,'enable','on');
end

% Set Panel unit
setUnits(handles,1);

% Set Panel Parameter
setParameters(handles,1);

% set Factor Table
setTable(handles);

return

% --- Sets the handles and setting in the Panel unit.
function setUnits(handles,iU)

iDim=get(handles.dimension_popupmenu,'Value');

unitList=getappdata(handles.figure1,'unitList');

% Load units and save the dimension specific application data
baseUnit=unitList(iDim).baseUnit;
set(handles.baseUnit_text,'String',baseUnit);
set(handles.unit_popupmenu,'String',unitList(iDim).unit_txt);
selectUnit(handles,iU);

return

% --- action if a unit selection changes
function selectUnit(handles,iU)

set(handles.unit_popupmenu,'Value',iU);

% load necessary variables
iDim=get(handles.dimension_popupmenu,'Value');
dimensions=get(handles.dimension_popupmenu,'String');
unitList=getappdata(handles.figure1,'unitList');
formulas=unitList(iDim).formula;
units=unitList(iDim).unit_txt;

% set the edit fields of the formula to selected unit
set(handles.unit_edit,'String',units{iU})
set(handles.factor_edit,'String',formulas{iU})
checkValidity_factor_edit(handles);

% is unit default
isDefaultUnit=checkIfUnitIsDefault(handles,dimensions{iDim},units{iU});
isBaseUnit=checkIfUnitIsBase(handles,units{iU});

if isDefaultUnit || isBaseUnit
    set(handles.updateUnit_pushbutton,'enable','off');
    set(handles.deleteUnit_pushbutton,'enable','off');
    set(handles.factor_edit,'enable','off');
else
    set(handles.updateUnit_pushbutton,'enable','on');
    set(handles.deleteUnit_pushbutton,'enable','on');
     set(handles.factor_edit,'enable','on');
end

return

% --- Sets the handles and setting in the Panel parameter.
function setParameters(handles,iP)

% load necessary variables
iDim=get(handles.dimension_popupmenu,'Value');
unitList=getappdata(handles.figure1,'unitList');
descriptions=unitList(iDim).par_descriptions;


% set handles
if isempty(descriptions)
    set(handles.parameter_popupmenu,'String',{' '});
    set(handles.parameter_popupmenu,'Value',1);
else
    set(handles.parameter_popupmenu,'String',descriptions);
    set(handles.parameter_popupmenu,'Value',iP);
end

selectParameter(handles,iP);

return

% --- action if a parameter selection changes
function selectParameter(handles,iP)

set(handles.parameter_popupmenu,'Value',iP);

% load necessary variables
iDim=get(handles.dimension_popupmenu,'Value');
dimensions=get(handles.dimension_popupmenu,'String');
unitList=getappdata(handles.figure1,'unitList');
descriptions=unitList(iDim).par_descriptions;
names=unitList(iDim).par_names;
currentValues=unitList(iDim).par_values;


% set the edit fields of the formula to selected unit
if isempty(descriptions)
    set(handles.description_edit,'String','');
    set(handles.name_edit,'String','');
    set(handles.value_edit,'String','');
    
    isDefaultParameter=true;
else
    set(handles.description_edit,'String',descriptions{iP});
    set(handles.name_edit,'String',names{iP});
    set(handles.value_edit,'String',num2str(currentValues(iP)));

    % is parameter default
    isDefaultParameter=checkIfParameterIsDefault(handles,dimensions{iDim},names{iP});

end
if isDefaultParameter
    set(handles.deleteParameter_pushbutton,'enable','off');
else
    set(handles.deleteParameter_pushbutton,'enable','on');
end

return

% --- refresh Table data
function setTable(handles)

% load necessary variables
iDim=get(handles.dimension_popupmenu,'Value');
unitList=getappdata(handles.figure1,'unitList');
nUnits=length(unitList(iDim).unit_txt);

[factor,ix]=evalFactor(unitList(iDim));


% set table data
ColumnNames=unitList(iDim).unit_txt(ix);
RowNames=unitList(iDim).unit_txt(ix);
table_data=cell(nUnits,nUnits);
for iCol=1:nUnits
    for iRow=1:nUnits
        f=factor(ix(iRow))/factor(ix(iCol));
        table_data{iRow,iCol}=sprintf('%.3g',f);
    end
end

set(handles.uitable,'ColumnName',ColumnNames);
set(handles.uitable,'RowName',RowNames);
set(handles.uitable,'Data',table_data);

return

% --- eval Formula to numeric factor
function [factor,ix]=evalFactor(unitList)
% 
% get the values for Formula Parameters
for iP=1:length(unitList.par_names)
    eval([unitList.par_names{iP} '= ' num2str(unitList.par_values(iP))]);
end

% evaluate and sort factors
nUnits=length(unitList.unit_txt);
factor=nan(nUnits,1);
for iUnit=1:nUnits
    factor(iUnit)=eval(unitList.formula{iUnit});
end




% sort first units without parameters than units with parameters
formulasWith=zeros(nUnits,1);
for iP=1:length(unitList.par_names)
    for iUnit=1:nUnits
        if ~isempty(strfind(unitList.formula{iUnit},unitList.par_names{iP}))
            formulasWith(iUnit)=1;
        end
    end
end


[~,ix]=sortrows([formulasWith,factor]);


return

function checkValidity_factor_edit(handles)

% load necessary variables
unitList=getappdata(handles.figure1,'unitList');
iDim=get(handles.dimension_popupmenu,'Value');


for iP=1:length(unitList(iDim).par_names)
    eval([unitList(iDim).par_names{iP} '= ' num2str(unitList(iDim).par_values(iP))]);
end


try
    valid=isnumeric(eval(get(handles.factor_edit,'String')));
catch  %#ok<CTCH>
    set(handles.warning_text,'String','invalid Formula');
    valid=false;
end

if valid
    set(handles.factor_edit,'BackgroundColor',[1 1 1]);
    set(handles.addUnit_pushbutton,'enable','on')
    set(handles.updateUnit_pushbutton,'enable','on')
else
    set(handles.factor_edit,'BackgroundColor',[1 0 0]);
    set(handles.addUnit_pushbutton,'enable','off')
    set(handles.updateUnit_pushbutton,'enable','off')
end


return


% --- reset warning
function resetWarning(handles)

set(handles.warning_text,'String','');

return


%%
%%
% Selection ChangeFunction tab group
function selectionChangeTabGroup(~,~,~,~,~)
% src uitabgroup
% evt: event
% newTag
% oldTag
% handles

return

% --- Executes when entered data in editable cell(s) in translationList_uitable.
function translationList_uitable_CellEditCallback(~, eventdata, handles) %#ok<DEFNU>
% hObject    handle to translationList_uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% return if no real selection
if isempty(eventdata.Indices) || eventdata.Indices(2)~=1
    return
end

try
    set(handles.warning_text,'String','');
    
    data=get(handles.translationList_uitable,'data');
    unitTranslationList=data(:,1:3);
    setappdata(handles.figure1,'unitTranslationList',unitTranslationList);
    
catch exception
    constructErrorMessageForExceptions(exception,'');
    
    return
end

return




% --- Executes when selected cell(s) is changed in translationList_uitable.
function translationList_uitable_CellSelectionCallback(~, eventdata, handles) %#ok<DEFNU>
% hObject    handle to translationList_uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selected
% handles    structure with handles and user data (see GUIDATA)


% return if no real selection
if isempty(eventdata.Indices) || eventdata.Indices(2)<4
    return
end

try
    set(handles.warning_text,'String','');
    
    
    % get selected entries
    iRow=eventdata.Indices(1);
    iCol=eventdata.Indices(2);
     data=get(handles.translationList_uitable,'data');
    switch iCol
        case 4
            data=editTranslationEntry(data,iRow,data{iRow,1});
            
        case 5
            keep=setdiff(1:size(data,1),iRow);
            data=data(keep,:);
    end
    
    set(handles.translationList_uitable,'data',data);

    unitTranslationList=data(:,1:3);
    setappdata(handles.figure1,'unitTranslationList',unitTranslationList);
    
catch exception
    constructErrorMessageForExceptions(exception,'');
    
    return
end

return


% --- Executes on button press in new_Translation_pushbutton.
function new_Translation_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to new_Translation_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=get(handles.translationList_uitable,'data');

[data]=editTranslationEntry(data,size(data,1)+1,'');

set(handles.translationList_uitable,'data',data);

unitTranslationList=data(:,1:3);
setappdata(handles.figure1,'unitTranslationList',unitTranslationList);

return
 
function [data]=editTranslationEntry(data,iRow,sourceString)
  
answer=inputdlg({'Enter the source string:'},'Source string',1,{sourceString});
if ~isempty(answer)
    unitold=answer{1};
    [dimension,unit]=UnitSpecification(unitold,'selected unit');
    if ~isempty(unit)
       
        
        data{iRow,1}=unitold;
        data{iRow,2}=dimension;
        data{iRow,3}=unit;
        data{iRow,4}='edit';
        data{iRow,5}='delete';
    end
end
