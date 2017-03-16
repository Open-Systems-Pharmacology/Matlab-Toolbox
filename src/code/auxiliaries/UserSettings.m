function varargout = UserSettings(varargin)
% USERSETTINGS MATLAB code for UserSettings.fig
%      USERSETTINGS, by itself, creates a new USERSETTINGS or raises the existing
%      singleton*.
%
%      H = USERSETTINGS returns the handle to a new USERSETTINGS or the handle to
%      the existing singleton*.
%
%      USERSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USERSETTINGS.M with the given input arguments.
%
%      USERSETTINGS('Property','Value',...) creates a new USERSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UserSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UserSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UserSettings

% Last Modified by GUIDE v2.5 18-Sep-2012 13:33:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UserSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @UserSettings_OutputFcn, ...
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


% --- Executes just before UserSettings is made visible.
function UserSettings_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UserSettings (see VARARGIN)

% Choose default command line output for UserSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


global MOBI_SETTINGS

if isempty(MOBI_SETTINGS)
    MoBiSettings;
end

application_path=MOBI_SETTINGS.application_path;

if ~exist(application_path,'dir')
    mkdir(application_path);
end

% remember rest values
if isfield(MOBI_SETTINGS,'pathToPKSimInstallDir')
    setappdata(handles.figure1,'pathToPKSimInstallDir', MOBI_SETTINGS.pathToPKSimInstallDir);
end
if isfield(MOBI_SETTINGS,'gsSettings')
    setappdata(handles.figure1,'gsSettings', MOBI_SETTINGS.gsSettings);
end


% PK-Sim installation directory
[isCanceled,pathToPKSimInstallDir]=getPathToPKSimInstallDir(OSPSuiteVersion);
if isCanceled
    set(handles.PKSIM_installlationpath_edit,'String','');
else
    set(handles.PKSIM_installlationpath_edit,'String',pathToPKSimInstallDir);
end    


% ghostview installation directory
loadSettings;
if isfield(MOBI_SETTINGS,'gsSettings') && ~isempty(MOBI_SETTINGS.gsSettings) && isfield(MOBI_SETTINGS.gsSettings,'gscommand')
    set(handles.ghostview_installation_path_edit,'String',MOBI_SETTINGS.gsSettings.gscommand);
else
    set(handles.ghostview_installation_path_edit,'String','');
end    

%disable selection buttons in deployed mode
if isdeployed
    set(handles.PKSim_installationpath_pushbutton, 'Enable', 'off');
    set(handles.ghostview_installtion_path_pushbutton, 'Enable', 'off');    
end

% UIWAIT makes UserSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UserSettings_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global MOBI_SETTINGS;

% save ghostview settings
gsSettings=MOBI_SETTINGS.gsSettings; %#ok<NASGU>
save([MOBI_SETTINGS.application_path 'gsSettings.mat'],'gsSettings');

% save installation path
pathToPKSimInstallDir=MOBI_SETTINGS.pathToPKSimInstallDir; %#ok<NASGU>
save([MOBI_SETTINGS.application_path 'pathToPKSimInstallDir.mat'],'pathToPKSimInstallDir');

% Close
closereq;

return

% --- Executes on button press in Cancel_pushbutton.
function Cancel_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to Cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global MOBI_SETTINGS;

% remember rest values
if isappdata(handles.figure1,'pathToPKSimInstallDir')
    MOBI_SETTINGS.pathToPKSimInstallDir=getappdata(handles.figure1,'pathToPKSimInstallDir');
end
if isfield(handles.figure1,'gsSettings')
     MOBI_SETTINGS.gsSettings=getappdata(handles.figure1,'gsSettings');
end


closereq;
return

function ghostview_installation_path_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to ghostview_installation_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ghostview_installation_path_edit as text
%        str2double(get(hObject,'String')) returns contents of ghostview_installation_path_edit as a double


% --- Executes during object creation, after setting all properties.
function ghostview_installation_path_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to ghostview_installation_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ghostview_installtion_path_pushbutton.
function ghostview_installtion_path_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to ghostview_installtion_path_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global MOBI_SETTINGS;

gsSettings=MOBI_SETTINGS.gsSettings;
if ~isempty(gsSettings) && isfield(gsSettings,'gscommand') && ~isempty(gsSettings.gscommand)
    default_file=gsSettings.gscommand;
else
   default_file= '*.exe';
end

% get user input   
[gs_exe,gs_path] = uigetfile(default_file,'please select the executable for ghostscripts (e.g. gswin32c.exe)');
if isequal(gs_exe,0) || isequal(gs_path,0)
    return
else
    gsSettings.gscommand=fullfile(gs_path,gs_exe);
    % fontpath
    gs_fontpath=strrep(gs_path,'bin','fonts');
    if exist(gs_fontpath,'dir')
        gsSettings.gsfontpath=gs_fontpath;
    end
    % libpath
    gs_libpath=strrep(gs_path,'bin','fonts');
    if exist(gs_libpath,'dir')
        gsSettings.gslibpath=gs_libpath;
    end
end
  
set(handles.ghostview_installation_path_edit,'String',gsSettings.gscommand);
MOBI_SETTINGS.gsSettings=gsSettings;

return

% --- Executes on button press in Unit_converter_pushbutton.
function Unit_converter_pushbutton_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to Unit_converter_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UnitConverter;

return

% --- Executes on button press in Unit_Reset_pushbutton.
function Unit_Reset_pushbutton_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to Unit_Reset_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

iniUnitList(2);
msgbox('Unit list is resetd to default','Reset Units')
return

function PKSIM_installlationpath_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to PKSIM_installlationpath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PKSIM_installlationpath_edit as text
%        str2double(get(hObject,'String')) returns contents of PKSIM_installlationpath_edit as a double


% --- Executes during object creation, after setting all properties.
function PKSIM_installlationpath_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to PKSIM_installlationpath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PKSim_installationpath_pushbutton.
function PKSim_installationpath_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to PKSim_installationpath_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global MOBI_SETTINGS;

application_path=MOBI_SETTINGS.application_path;

pathToPKSimInstallDir_file=[application_path 'pathToPKSimInstallDir.mat'];

if ~exist(pathToPKSimInstallDir_file,'file')
    % get environment
    ProgramFiles=getenv('ProgramFiles');
    
    PKSimDirs=dir([ProgramFiles filesep SuiteInstallationSubfolder filesep 'PK-Sim*']);
    if isempty(PKSimDirs)
        default_pathToPKSimInstallDir=ProgramFiles;
    elseif length( PKSimDirs) >1
        default_pathToPKSimInstallDir=[ProgramFiles filesep SuiteInstallationSubfolder];
    else
        default_pathToPKSimInstallDir=([ProgramFiles filesep SuiteInstallationSubfolder filesep PKSimDirs(1).name]);
    end
    
else
    load(pathToPKSimInstallDir_file);
    default_pathToPKSimInstallDir=pathToPKSimInstallDir; %#ok<NODEF>
end
    


pathToPKSimInstallDir = uigetdir(default_pathToPKSimInstallDir, 'Select the PK Sim Install directory:');
if ~isnumeric(pathToPKSimInstallDir)
    MOBI_SETTINGS.pathToPKSimInstallDir=pathToPKSimInstallDir;
    set(handles.PKSIM_installlationpath_edit,'String',pathToPKSimInstallDir);
end

return

function gsSettings=loadSettings

global MOBI_SETTINGS;



if isfield(MOBI_SETTINGS,'gsSettings')
    gsSettings=MOBI_SETTINGS.gsSettings;
else
    application_path=MOBI_SETTINGS.application_path;
    
    if ~exist(application_path,'dir')
        mkdir(application_path);
    end
    gsSettings_file=[application_path 'gsSettings.mat'];
    if ~exist(gsSettings_file,'file')
        % get environment
        ProgramFiles=getenv('ProgramFiles');
        
        % ghostview path
        gsSettings.gscommand='';
        gsSettings.gsfontpath='';
        gsSettings.gslibpath='';
        if exist(fullfile(ProgramFiles, 'GhostScript', 'bin', 'gswin32c.exe'),'file')
            gsSettings.gscommand=fullfile(ProgramFiles, 'GhostScript', 'bin', 'gswin32c.exe');
            if exist(fullfile(ProgramFiles, 'GhostScript','fonts'),'dir')
                gsSettings.gsfontpath=fullfile(ProgramFiles, 'GhostScript','fonts');
            end
            if exist(fullfile(ProgramFiles, 'GhostScript','lib'),'dir')
                gsSettings.gslibpath=fullfile(ProgramFiles, 'GhostScript','lib');
            end
        elseif exist(fullfile(ProgramFiles, 'gs','gs9.00','bin', 'gswin32c.exe'),'file')
            gsSettings.gscommand=fullfile(ProgramFiles, 'gs','gs9.00','bin', 'gswin32c.exe');
            if exist(fullfile(ProgramFiles, 'gs','gs9.00','fonts'),'dir')
                gsSettings.gsfontpath=fullfile(ProgramFiles, 'gs','gs9.00','fonts');
            end
            if exist(fullfile(ProgramFiles, 'gs','gs9.00','lib'),'dir')
                gsSettings.gslibpath=fullfile(ProgramFiles, 'gs','gs9.00','lib');
            end
        end
        
        save(gsSettings_file,'gsSettings');
        
    else
        load(gsSettings_file);
    end

    MOBI_SETTINGS.gsSettings=gsSettings;
end
    
return
