function varargout = generateMatlabCodeForXML(varargin)
% GENERATEMATLABCODEFORXML A GUI suited for non-experts to start generating executable Matlab scripts.
%
%   M-file for generateMatlabCodeForXML.fig
%      GENERATEMATLABCODEFORXML, by itself, creates a new GENERATEMATLABCODEFORXML or raises the existing
%      singleton*.
%
%      H = GENERATEMATLABCODEFORXML returns the handle to a new GENERATEMATLABCODEFORXML or the handle to
%      the existing singleton*.
%
%      GENERATEMATLABCODEFORXML('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERATEMATLABCODEFORXML.M with the given input arguments.
%
%      GENERATEMATLABCODEFORXML('Property','Value',...) creates a new GENERATEMATLABCODEFORXML or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before generateMatlabCodeForXML_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to generateMatlabCodeForXML_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES


% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 16-Nov-2010


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @generateMatlabCodeForXML_OpeningFcn, ...
                   'gui_OutputFcn',  @generateMatlabCodeForXML_OutputFcn, ...
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


% --- Executes just before generateMatlabCodeForXML is made visible.
function generateMatlabCodeForXML_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to generateMatlabCodeForXML (see VARARGIN)

% Choose default command line output for generateMatlabCodeForXML
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% reset Warning message
set(handles.warning_text,'String','')


% % set help text
% filename = mfilename('fullpath');
% helpFile=getHelpFile('Base',filename);
% if ~exist(helpFile,'file')
%     set(handles.help_uipushtool,'visible','off');
% else
%     setappdata(handles.figure1,'helpFile',helpFile);
% end
% UIWAIT makes generateMatlabCodeForXML wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = generateMatlabCodeForXML_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

writeToFile(handles);

return

% --- Executes on button press in Cancel_pushbutton.
function Cancel_pushbutton_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to Cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closereq;

return


function XML_edit_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to XML_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XML_edit as text
%        str2double(get(hObject,'String')) returns contents of XML_edit as a double

readXml(handles,get(hObject,'String'));

return

% --- Executes during object creation, after setting all properties.
function XML_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to XML_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in XML_select_pushbutton.
function XML_select_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to XML_select_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[xml,xmlpath] = uigetfile('*.xml','Select simulation file');

if isnumeric(xml) && xml==0
    return
end

xml=[xmlpath  xml];

set(handles.XML_edit,'String',xml);

readXml(handles,xml);

return


% --- Executes on button press in deleteOutput_pushbutton.
function deleteOutput_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to deleteOutput_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

deleteListEntry(handles.outputSelection_listbox);

return


% --- Executes on button press in deleteInput_pushbutton.
function deleteInput_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to deleteInput_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

deleteListEntry(handles.inputSelection_listbox);

return

% --- Executes on button press in addInput_pushbutton.
function addInput_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to addInput_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.warning_text,'String','');

inputTree=getappdata(handles.uipanelInput,'inputTree');
nodes=inputTree.tree.getSelectedNodes();
node=nodes(1);

addToInput(handles,node)

return


% --- Executes on button press in addOutput_pushbutton.
function addOutput_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to addOutput_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.warning_text,'String','');

outputTree=getappdata(handles.uipanelOutput,'outputTree');
nodes=outputTree.tree.getSelectedNodes();
node=nodes(1);


addToOutput(handles,node);

return


% --- Executes on button press in showInput_pushbutton.
function showInput_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to showInput_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.warning_text,'String','');


inputTree=getappdata(handles.uipanelInput,'inputTree');
nodes=inputTree.tree.getSelectedNodes();
node=nodes(1);

inputTree_info=getappdata(handles.uipanelInput,'inputTree');

% get selected node path
[ID,type]=inputTree_info.getNodeProperties(node);


if ID==0
    set(handles.warning_text,'String','Please select parameter');
    return
else
    set(handles.warning_text,'String','');
end

switch type
    case 'P'
         if getParameter(ID,1,'property','isFormula');
             formula=getParameter(ID,1,'property','Formula');
         else
            formula=num2str(getParameter(ID,1));
         end
    case 'S'
         if getSpeciesInitialValue(ID,1,'property','isFormula');
            formula=getSpeciesInitialValue(ID,1,'property','Formula');
        else
            formula=num2str(getSpeciesInitialValue(ID,1));
        end
end
 msgbox(formula,'Formula:');
return


% --- Executes on button press in showOutput_pushbutton.
function showOutput_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to showOutput_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.warning_text,'String','');


outputTree=getappdata(handles.uipanelOutput,'outputTree');
nodes=outputTree.tree.getSelectedNodes();
node=nodes(1);

outputTree_info=getappdata(handles.uipanelOutput,'outputTree');

% get selected node path
[ID,type]=outputTree_info.getNodeProperties(node);

if ID==0
    set(handles.warning_text,'String','Please select output');
    return
else
    set(handles.warning_text,'String','');
end

switch type
    case 'O'
        formula=getObserverFormula(ID,1,'property','Formula'); 
    case 'S'
        if getSpeciesInitialValue(ID,1,'property','isFormula');
            formula=getSpeciesInitialValue(ID,1,'property','Formula');
        else
            formula=num2str(getSpeciesInitialValue(ID,1));
        end
end

 msgbox(formula,'Formula:');
return



% --- Executes on button press in searchOutput_pushbutton.
function searchOutput_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to searchOutput_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  set(handles.warning_text,'String','');
  
 searchForString(handles.uipanelOutput,'outputTree');

 return


% --- Executes on button press in searchInput_pushbutton.
function searchInput_pushbutton_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to searchInput_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  set(handles.warning_text,'String','');
  
 searchForString(handles.uipanelInput,'inputTree');

 return
% --- Executes on selection change in outputSelection_listbox.
function outputSelection_listbox_Callback(~, ~, ~)%#ok<DEFNU>
% hObject    handle to outputSelection_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns outputSelection_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outputSelection_listbox


% --- Executes during object creation, after setting all properties.
function outputSelection_listbox_CreateFcn(hObject, ~, ~)%#ok<DEFNU>
% hObject    handle to outputSelection_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in inputSelection_listbox.
function inputSelection_listbox_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to inputSelection_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inputSelection_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputSelection_listbox


% --- Executes during object creation, after setting all properties.
function inputSelection_listbox_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to inputSelection_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% Menu items

% --------------------------------------------------------------------
function help_uipushtool_ClickedCallback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to help_uipushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helpFile=getappdata(handles.figure1,'helpFile');
open(helpFile);

return

%% user specific functions

function deleteListEntry(hObject)

selection=get(hObject,'String');
if length(selection)==1
    selection={' '};
    indx_new=1;
else
    indx=get(hObject,'Value');
    selection=selection(setdiff(1:length(selection),indx));
    indx_new=max(1,indx-1);
end
% add new List:
set(hObject,'String',selection);
set(hObject,'Value',indx_new);

return

function readXml(handles,xml)

import javax.swing.*

% check if the xml is valid
if isempty(xml)
    set(handles.OK_pushbutton,'Enable','off');
    set(handles.warning_text,'String','');
elseif ~exist(xml,'file')
    set(handles.OK_pushbutton,'Enable','off');
    set(handles.warning_text,'String','Simulation file does not exist!');
else
    set(handles.warning_text,'String','Please wait, model is initialized!');
    set(handles.OK_pushbutton,'Enable','off');
    pause(0.1);
    try
        initSimulation(xml,'all','report','none');
    catch exception 
        set(handles.OK_pushbutton,'Enable','off');
        set(handles.warning_text,'String',sprintf('Simulation file is not valid! "%s"',exception.message));
    end
    try
        
        %create new input tree ----------------------
        simulationIndex=1;
        % add branches
        [descParameter,descSpeciesInitialValues]=getDescriptionArrays(simulationIndex);
        displayPathes_P=descParameter(2:end,2);
        IDs_P=descParameter(2:end,1);
        
        displayPathes_S=descSpeciesInitialValues(2:end,2);
        IDs_S=descSpeciesInitialValues(2:end,1);
    
        if ~isappdata(handles.uipanelInput,'inputTree')
            inputTree_info=ModelTree(handles.uipanelInput,'Inputs','inputTree',[0.05 0.41 0.9 0.5],false);
            
            % add branches
            inputTree_info=inputTree_info.addBranch('P','Parameter',displayPathes_P,IDs_P,simulationIndex);
            inputTree_info=inputTree_info.addBranch('S','Initial Values',displayPathes_S,IDs_S,simulationIndex);
            
            % no more menus, does not work with all matlab versions
            % % add menus 
            % inputTree_info=inputTree_info.addMenu('Add to selection',@addToInputSelection);
            inputTree_info.showFormulaMenu=false;
            inputTree_info.showDescriptionMenu=false;
            inputTree_info.withSearchMenu=false;
            
            % generateTree
            inputTree_info.generateTreeByBranches();
        else
            inputTree_info=getappdata(handles.uipanelInput,'inputTree');
            
            inputTree_info=inputTree_info.resetBranch();
            
            % add branches
            inputTree_info=inputTree_info.addBranch('P','Parameter',displayPathes_P,IDs_P,simulationIndex);
            inputTree_info=inputTree_info.addBranch('S','Initial Values',displayPathes_S,IDs_S,simulationIndex);
            
            inputTree_info.resetTreeByBranches();
        end
        
        
        % Reset Lists
        set(handles.inputSelection_listbox,'String',{' '});
        set(handles.inputSelection_listbox,'Value',1);

        
        %create new output tree --------------------------------------
        % get branches
        [descSpeciesInitialValues,descObserver]=getOutputDescriptionArrays(simulationIndex);
        displayPathes_O=descObserver(2:end,2);
        IDs_O=descObserver(2:end,1);
        
        displayPathes_S=descSpeciesInitialValues(2:end,2);
        IDs_S=descSpeciesInitialValues(2:end,1);
        
        
        if ~isappdata(handles.uipanelOutput,'outputTree')
            outputTree_info=ModelTree(handles.uipanelOutput,'Outputs','outputTree',[0.05 0.41 0.9 0.57],false);
            
            % add branches
            outputTree_info=outputTree_info.addBranch('O','Observer',displayPathes_O,IDs_O,simulationIndex);
            outputTree_info=outputTree_info.addBranch('S','Species',displayPathes_S,IDs_S,simulationIndex);
            
            % no more menus, does not work with all matlab versions
            % add menus
            % outputTree_info=outputTree_info.addMenu('Add to selection',@addToOutputSelection);
            outputTree_info.showFormulaMenu=false;
            outputTree_info.showDescriptionMenu=false;
            outputTree_info.withSearchMenu=false;
            
            % generateTree
            outputTree_info.generateTreeByBranches();
        else
            outputTree_info=getappdata(handles.uipanelOutput,'outputTree');
    
            outputTree_info=outputTree_info.resetBranch();
    
            % add branches
            outputTree_info=outputTree_info.addBranch('O','Observer',displayPathes_O,IDs_O,simulationIndex);
            outputTree_info=outputTree_info.addBranch('S','Initial Values',displayPathes_S,IDs_S,simulationIndex);
            
            outputTree_info.resetTreeByBranches();
        end
        
        
        % Reset Lists
        set(handles.outputSelection_listbox,'String',{' '});
        set(handles.outputSelection_listbox,'Value',1);


        set(handles.warning_text,'String','');
        set(handles.OK_pushbutton,'Enable','on');

    catch exception 
        set(handles.OK_pushbutton,'Enable','off');
        set(handles.warning_text,'String',['Error while setting the Trees!' char(10) exception.message]);
    end

end

return


%-- writes the selected values to a file
function writeToFile(handles)

% get InputList
inputs=get(handles.inputSelection_listbox,'String');
parameters={};
speciesInitialValues={};
if length(inputs)>=1 && ~isempty(deblank(inputs{1}))
    jj_Par=strncmp(inputs,'P: ',3);
    if any(jj_Par)
        parameters=strrep(inputs(jj_Par),'P: ','');
    end
    if any(~jj_Par)
        speciesInitialValues=strrep(inputs(~jj_Par),'S: ','');
    end
end
% get OutputList
outputs=get(handles.outputSelection_listbox,'String');
species={};
observer={};
if length(outputs)>1 || ~isempty(deblank(outputs{1}))
    jj_Obs=strncmp(outputs,'O: ',3);
    if any(jj_Obs)
        observer=strrep(outputs(jj_Obs),'O: ','');
    end
    if any(~jj_Obs)
        species=strrep(outputs(~jj_Obs),'S: ','');
    end
    
end

outputs=[species;observer];

% get path of file
appPath=[fileparts(get(handles.XML_edit,'String')) filesep];
% find filename
if ~exist([appPath 'Untitled.m'],'file')
    filename=[appPath 'Untitled.m'];
else
    i=1;
    filename=[appPath 'Untitled' num2str(i) '.m'];
    while exist(filename,'file')
        i=i+1;
        filename=[appPath 'Untitled' num2str(i) '.m'];
    end
end

fid = fopen(filename,'w');

set(handles.warning_text,'String','');

try
    % Name of xml
    fprintf(fid,'%s','% name of xml file');
    fprintf(fid,'\r\n');
    xml=get(handles.XML_edit,'String');
    fprintf(fid,'%s',['xml=' char(39) xml  char(39) ';']);
    fprintf(fid,'\r\n\r\n');

    % Switch option variable parameters
    if get(handles.all_radiobutton,'Value')
        variableParameters=[char(39)  'all' char(39)];
    elseif get(handles.none_radiobutton,'Value')
        variableParameters=[char(39) 'none' char(39)];
    elseif get(handles.allNoneFormular_radiobutton,'Value')
        variableParameters=[char(39) 'allNonFormula' char(39)];
    else
        variableParameters='initStruct';
        
        fprintf(fid,'%s','% Create the structure for the variable parameters');
        fprintf(fid,'\r\n');
        fprintf(fid,'%s','initStruct=[];');
        fprintf(fid,'\r\n');

        
        % write 
        for iP=1:length(parameters)
            path_id=parameters{iP};
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['initStruct=initParameter(initStruct,' char(39) path_id char(39)...
                ','  char(39) 'withWarning' char(39) ');']);
        end
        for iS=1:length(speciesInitialValues)
            path_id=speciesInitialValues{iS};
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['initStruct=initSpeciesInitialValue(initStruct,' char(39) path_id char(39)...
                ','  char(39) 'withWarning' char(39) ');']);
        end
        

    end    
    
    % Initialize the simulation
    fprintf(fid,'\r\n');
    fprintf(fid,'%s','% Initialize the simulation');
    fprintf(fid,'\r\n');
    fprintf(fid,'%s',['initSimulation(xml,' variableParameters ',' ...
        char(39) 'report' char(39) ','  char(39) 'none' char(39) ');']);

    % Parameter Manipulation
    if ~get(handles.none_radiobutton,'Value') && (~isempty(parameters) || ~isempty(speciesInitialValues))
        fprintf(fid,'\r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'%s',['% Here you can manipulate the Parameters with the functions getParameter, '...
            'setParameter, setRelativeParameter,...']);
        fprintf(fid,'\r\n');
        for iP=1:length(parameters)
            path_id=parameters{iP};
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['% value=getParameter(' char(39) path_id  char(39) ',1);']);
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['% setParameter(value,' char(39) path_id  char(39) ',1);']);
            fprintf(fid,'\r\n');
            fprintf(fid,'%s','% relative_value=1;');
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['% setRelativeParameter(relative_value,' char(39) path_id  char(39) ',1);']);
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['% [isExisting,description]=existsParameter(' char(39) path_id  char(39) ',1);']);
        end
        for iS=1:length(speciesInitialValues)
            path_id=speciesInitialValues{iS};
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['% value=getSpeciesInitialValue(' char(39) path_id  char(39) ',1);']);
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['% setSpeciesInitialValue(value,' char(39) path_id  char(39) ',1);']);
            fprintf(fid,'\r\n');
            fprintf(fid,'%s','% relative_value=1;');
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['% setRelativeSpeciesInitialValue(relative_value,' char(39) path_id  char(39) ',1);']);
            fprintf(fid,'\r\n');
            fprintf(fid,'%s',['% [isExisting,description]=existsSpeciesInitialValue(' char(39) path_id  char(39) ',1);']);
        end
    end
    
    % Time Pattern
    fprintf(fid,'\r\n');
    fprintf(fid,'\r\n');
    fprintf(fid,'%s','% Get and set Simulation Time');
    fprintf(fid,'\r\n');
    fprintf(fid,'%s','% timepoints=getSimulationTime(1); % vector of raster points in min');
    fprintf(fid,'\r\n');
    fprintf(fid,'%s','% setSimulationTime(timepoints,1);');
    fprintf(fid,'\r\n');
    fprintf(fid,'\r\n');
        
    % Processing    
    fprintf(fid,'\r\n');
    fprintf(fid,'\r\n');
    fprintf(fid,'%s','% Run the simulation');
    fprintf(fid,'\r\n');
    fprintf(fid,'%s','success=processSimulation(1);');
    fprintf(fid,'\r\n');
    fprintf(fid,'\r\n');

    
    % Output
    fprintf(fid,'%s','if success');
    fprintf(fid,'\r\n');
    
    % Time Unit 
    [~,timeUnit]=getSimulationTime(1);
    
    for iO=1:length(outputs)
        fprintf(fid,'%s','% Output:');
        fprintf(fid,'\r\n');
        path_id=outputs{iO};
        fprintf(fid,'%s',['    [sim_time,sim_values]=getSimulationResult('  char(39) path_id   char(39) ',1);']);
        fprintf(fid,'\r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'%s','% Figure:');
        fprintf(fid,'\r\n');
        fprintf(fid,'%s','   ax_handle=getNormFigure(1,1);');
        fprintf(fid,'\r\n');
        fprintf(fid,'%s','   plot(ax_handle,sim_time,sim_values);');
        fprintf(fid,'\r\n');
        if any(strcmp(timeUnit,{'sec','min','h','days','weeks','months'}))
            fprintf(fid,'%s',['   setAxesScaling(ax_handle,' char(39) 'timeUnit' char(39) ',' char(39) timeUnit char(39) ')']);
        else
            fprintf(fid,'%s','   setAxesScaling(ax_handle)');
        end
        fprintf(fid,'\r\n');        
        fprintf(fid,'%s',['   xlabel(ax_handle,' char(39) 'Time [min]' char(39) ');']);
        fprintf(fid,'\r\n');
        if iO<=length(species)
            fprintf(fid,'%s',['   unit=getSpeciesInitialValue(' char(39) path_id   char(39)  ',1,' ...
                char(39) 'property' char(39) ',' char(39) 'unit' char(39) ');']);
        else
            fprintf(fid,'%s',['   unit=getObserverFormula(' char(39) path_id   char(39)  ',1,' ...
                char(39) 'property' char(39) ',' char(39) 'unit' char(39) ');']);
        end
        fprintf(fid,'\r\n');
        fprintf(fid,'%s','   ylabel(ax_handle,unit);');
        fprintf(fid,'\r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'%s','% PK Parameter:');
        fprintf(fid,'\r\n');
        fprintf(fid,'%s',['    PK=getPKParameters(' char(39) path_id   char(39) ',1);']);
        fprintf(fid,'\r\n');
        fprintf(fid,'%s',['    % display Cmax as example, type "help getPKParameters" for more.']);
        fprintf(fid,'\r\n');
        fprintf(fid,'%s',['    disp(sprintf(' char(39) 'Cmax: %g %s' char(39) ',PK.cMax,unit))']);
        fprintf(fid,'\r\n');
        fprintf(fid,'\r\n');
        fprintf(fid,'\r\n');

    end
    
    fprintf(fid,'%s','else');
    fprintf(fid,'\r\n');
    fprintf(fid,'%s',['   disp(' char(39) 'Simulation was not successful' char(39) ')']);
    fprintf(fid,'\r\n');
    fprintf(fid,'%s','end');
    fprintf(fid,'\r\n');

    
    % Save and open file
    fclose(fid);
    
    try
        open(filename)
    catch %#ok<CTCH>
        try
            winopen(filename);
        catch %#ok<CTCH>
             msgbox(filename,'File was saved:')
        end
    end
    pause(0.1);
%     delete(filename);
   
catch exception
    set(handles.warning_text,'String',exception.message);
    fclose(fid);
end



return



% -- add to selection list
function addToInput(handles,node)


inputTree_info=getappdata(handles.uipanelInput,'inputTree');

% get selected node path
[ID,type]=inputTree_info.getNodeProperties(node);


if ID==0
    set(handles.warning_text,'String','Please select parameter');
    return
else
    set(handles.warning_text,'String','');
end

selection=get(handles.inputSelection_listbox,'String');
switch type
    case 'P'
        selection{end+1,1}=['P: ' getParameter(ID,1,'property','Path')]; 
    case 'S'
        selection{end+1,1}=['S: ' getSpeciesInitialValue(ID,1,'property','Path')];
end
selection=setdiff(selection,{' '});
selection=unique(selection);
set(handles.inputSelection_listbox,'String',selection);

return

function addToOutput(handles,node)

outputTree_info=getappdata(handles.uipanelOutput,'outputTree');

% get selected node path
[ID,type]=outputTree_info.getNodeProperties(node);

if ID==0
    set(handles.warning_text,'String','Please add only leaflets');
    return
else
    set(handles.warning_text,'String','');
end

selection=get(handles.outputSelection_listbox,'String');
switch type
    case 'O'
        selection{end+1,1}=['O: ' getObserverFormula(ID,1,'property','Path')]; 
    case 'S'
        selection{end+1,1}=['S: ' getSpeciesInitialValue(ID,1,'property','Path')];
end
selection=setdiff(selection,{' '});
selection=unique(selection);
set(handles.outputSelection_listbox,'String',selection);


return


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles)
    if isappdata(handles.figure1,'inputTree');
        pause(0.1);
        inputTree=getappdata(handles.figure1,'inputTree');
        set(inputTree, 'Units', 'normalized', 'position', [0.05 0.43 0.44 0.38]);
        
        outputTree=getappdata(handles.figure1,'outputTree');
        set(outputTree, 'Units', 'normalized', 'position', [0.525 0.43 0.44 0.44]);
    end
end

function searchForString(handles_uipanel,treeSpecifier)

% get tree info for specifier
thisTree=getappdata(handles_uipanel,treeSpecifier);
nodes=thisTree.tree.getSelectedNodes();
node=nodes(1);

thisTreeInfo=getappdata(handles_uipanel,treeSpecifier);

% get selected node path
[ID,~,~,displaypath]=thisTreeInfo.getNodeProperties(node);


% Get searchstring
prompt={['Enter the model path of the object to search:' char(10) 'Use * as wildcard']};
name='Searchstring';
numlines=1;
if strcmp(displaypath,'*') || ID>0
    defaultanswer={displaypath};
else
    defaultanswer={[displaypath '*']};
end
options.Resize='on';

answer=inputdlg(prompt,name,numlines,defaultanswer,options);

if isempty(answer)
    return
end

% get answer
path_id=answer{1};

% check for wildcards
ij_wildcards=strfind(path_id,'*');


selectednodes = javaArray('com.mathworks.hg.peer.UITreeNode', 1);

%search paths
for iBr=1:length(thisTreeInfo.branches)
    
    % no wild card used:
    if isempty(ij_wildcards)
        jj=strcmpi(path_id,thisTreeInfo.branches(iBr).displayPaths);
        if any(jj)
            selectedPaths=thisTreeInfo.branches(iBr).displayPaths(jj);
        else
            selectedPaths='';
        end
    % all (path id = wildcard)
    elseif strcmp(path_id,'*')
         selectedPaths=thisTreeInfo.branches(iBr).displayPaths;
    else
       if ij_wildcards(1)>1
           jj=strBegins(upper(thisTreeInfo.branches(iBr).displayPaths),upper(path_id(1:ij_wildcards(1)-1)));
           selectedPaths=thisTreeInfo.branches(iBr).displayPaths(jj);
       else
           selectedPaths=thisTreeInfo.branches(iBr).displayPaths;
       end
       
       paths=selectedPaths;
       for iWildcard=1:length(ij_wildcards)-1
           key=path_id(ij_wildcards(iWildcard)+1:ij_wildcards(iWildcard+1)-1);
           tmp=regexpi(paths,key,'once');
           jj=cellfun(@isempty, tmp);
           selectedPaths=selectedPaths(~jj);
           paths=paths(~jj);
           ix=cell2mat(tmp(~jj));
           for i=1:length(paths)
               paths{i}= paths{i}(ix(i)+length(key):end);
           end
       end
       
       if ij_wildcards(end)<length(path_id)
           key=path_id(ij_wildcards(end)+1:end); 
           jj=strEnds(thisTreeInfo.branches(iBr).displayPaths,key);
           selectedPaths=thisTreeInfo.branches(iBr).displayPaths(jj);
       end
       
    end
    
    selectednodes_iBr=thisTreeInfo.getNodesByDisplayPaths(iBr,selectedPaths);
    
    if ~isempty(selectednodes_iBr(1))
        if isempty(selectednodes(1))
            selectednodes=selectednodes_iBr;
        else
            selectednodes=[selectednodes selectednodes_iBr]; %#ok<AGROW>
        end
    end
    
end    

if ~isempty(selectednodes(1))
    
    tree=thisTreeInfo.tree();

    if size(selectednodes,1)>1
        if tree.isMultipleSelectionEnabled;
            selectionMode='multiple';
        else
            selectionMode='single';
        end
        list=cell(size(selectednodes,1),1);
        for iN=1:size(selectednodes,1)
            nd=selectednodes(iN);
            tmp=nd.getUserObject;
            list{iN}=char(tmp(2));
        end
        [ix,isOK] = listdlg('Name','Search result',...
            'PromptString','More than one finding. Specify selection:',...
            'SelectionMode',selectionMode,'ListSize',[300 300],...
            'ListString',list);
        if ~isOK || isempty(ix)
            return
        else
            selectednodesx = javaArray('com.mathworks.hg.peer.UITreeNode', 1);
            for iN=1:length(ix)
                selectednodesx(iN)=selectednodes(ix(iN));
            end
            selectednodes=selectednodesx;
        end
    end
    
    % set Nodes to selected
    for i=1:2 %this has to be done twice, if children were added. Why, i don't know
        tree.repaint();
        pause(0.5);
        
        
        tree.setSelectedNodes(selectednodes);
        pause(0.5);
        
        jtree=tree.getTree();
        pt=jtree.getSelectionPath;
        jtree.scrollPathToVisible(pt(end));
    end
else
    msgbox('Nothing found, Please check search string!');
end
