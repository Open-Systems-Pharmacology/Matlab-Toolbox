function varargout = dataImport(varargin)
% DATAIMPORT MATLAB code for dataImport.fig
%      DATAIMPORT, by itself, creates a new DATAIMPORT or raises the existing
%      singleton*.
%
%      H = DATAIMPORT returns the handle to a new DATAIMPORT or the handle to
%      the existing singleton*.
%
%      DATAIMPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAIMPORT.M with the given input arguments.
%
%      DATAIMPORT('Property','Value',...) creates a new DATAIMPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dataImport_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dataImport_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dataImport

% Last Modified by GUIDE v2.5 22-Nov-2012 13:30:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dataImport_OpeningFcn, ...
    'gui_OutputFcn',  @dataImport_OutputFcn, ...
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


% --- Executes just before dataImport is made visible.
function dataImport_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dataImport (see VARARGIN)

% Choose default command line output for dataImport
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dataImport wait for user response (see UIRESUME)

% ini data ---------------------------
set(handles.warning_text,'String','');

% AggregationTypes
aggregationType={'Y arith. mean','Y geo. mean' ,'Y median'};
setappdata(handles.figure1,'aggregationType',aggregationType);
aggregationType_class={'mean','geomean' ,'median'};
setappdata(handles.figure1,'aggregationType_class',aggregationType_class);
aggregationVar={'Y std','Y gsd' ,'Y var'};
setappdata(handles.figure1,'aggregationVar',aggregationVar);
aggregationVar_class={'std','gsd' ,'variance'};
setappdata(handles.figure1,'aggregationVar_class',aggregationVar_class);

% Classification Format selection
set(handles.onePerRow_radiobutton,'Value',1);
formatSelection_uipanel_SelectionChangeFcn([], [], handles);

% file Format selection
set(handles.xls_radiobutton,'Value',1);
xls_txt_uipanel_SelectionChangeFcn([], [], handles);

% enable tabs
enableClassification(handles,'off');
enableData(handles,'off');

dimensionList=getDimensions;
set(handles.X_dimension_popupmenu,'String',[{' '} dimensionList]);
ij_time=find(strcmpi(dimensionList,'time'));
set(handles.X_dimension_popupmenu,'Value',ij_time+1);
set(handles.X_unit_popupmenu,'visible','on');
set(handles.X_unit_popupmenu,'String',getUnitsForDimension('time'));
set(handles.X_unit_popupmenu,'Value',1);
set(handles.X_unit_edit,'visible','off');

set(handles.Y_dimension_popupmenu,'String',[{' '} dimensionList]);
set(handles.Y_dimension_popupmenu,'Value',1);
set(handles.Y_unit_popupmenu,'visible','off');
set(handles.Y_unit_edit,'visible','on');

% save errordumpdirectory
errorDumpDirectory='';
if ~isempty(varargin)
    jj=strcmpi(varargin,'ERRORDUMPDIRECTORY');
    if any(jj)
        ji=find(jj)+1;
        errorDumpDirectory=varargin{ji};
    end
end
setappdata(handles.figure1,'errorDumpDirectory',errorDumpDirectory);

% save data import filepath
data_importfilepath='';
if ~isempty(varargin)
    jj=strcmpi(varargin,'DATA_IMPORTFILEPATH');
    if any(jj)
        ji=find(jj)+1;
        data_importfilepath=varargin{ji};
    end
end
setappdata(handles.figure1,'data_importfilepath',data_importfilepath);

% initalize outputs
setappdata(handles.figure1,'data_struct',[]);
setappdata(handles.figure1,'individual_struct',[]);


uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dataImport_OutputFcn(~, ~, ~)
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
    % datastruct
    TRANSPORT_VARARGOUT{2}='';
    % individualstruct
    TRANSPORT_VARARGOUT{3}='';
    % Import path
    TRANSPORT_VARARGOUT{4}='';
    
end
varargout=TRANSPORT_VARARGOUT;

clear global TRANSPORT_VARARGOUT;

return


% --- Executes on button press in Cancel_pushbutton.
function Cancel_pushbutton_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to Cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closereq;

return

% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TRANSPORT_VARARGOUT;

try
    % isCanceled:
    TRANSPORT_VARARGOUT{1}=false;
    
    updateDataStructByHandles(handles)
    data_struct=getappdata(handles.figure1,'data_struct');
    TRANSPORT_VARARGOUT{2}=data_struct;
    individual_struct=getappdata(handles.figure1,'individual_struct');
    TRANSPORT_VARARGOUT{3}=individual_struct;
    TRANSPORT_VARARGOUT{4}= getappdata(handles.figure1,'data_importfilepath');
    
    closereq;
    
    %     if exist('data_D8.mat','file')
    %         load data_D8;
    %         indx=length(data)+1;
    %     else
    %         indx=1;
    %     end
    %
    %     data(indx).name=data_struct.name;
    %     data(indx).time=data_struct.X_values;
    %     data(indx).time_unit=data_struct.X_unit;
    %     data(indx).Y_values=data_struct.Y_values;
    %     data(indx).Y_unit=data_struct.Y_unit;
    %     data(indx).individuals=data_struct.individuals;
    %     data(indx).Period=cell2mat({individual_struct.Period__});
    %     data(indx).Subject_Group=cell2mat({individual_struct.Subject_Group});
    %
    %     save('data_D8','data');
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return

%% panel format objects

% --- Executes when selected object is changed in xls_txt_uipanel.
function xls_txt_uipanel_SelectionChangeFcn(~, ~, handles)
% hObject    handle to the selected object in xls_txt_uipanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

try
    if get(handles.xls_radiobutton,'Value')
        
        set(handles.xls_checkbox,'enable','on');
        set(handles.header_row_edit,'enable','on');
        
        set(handles.header_row_edit,'String','1');
        guiCheckNumerical(handles.header_row_edit);
        
        set(handles.delimiter_popupmenu,'enable','off');
        set(handles.decimal_popupmenu,'enable','off');
        
        set(handles.onePerRow_radiobutton,'Value',1);
    else
        set(handles.xls_checkbox,'enable','off');
        set(handles.header_row_edit,'enable','off');
        
        set(handles.delimiter_popupmenu,'enable','on');
        set(handles.decimal_popupmenu,'enable','on');
        
        set(handles.nonmem_radiobutton,'Value',1);
    end
    
    set(handles.import_pushbutton,'enable','on');
    
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return

% --- Executes on button press in xls_checkbox.
function xls_checkbox_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to xls_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xls_checkbox

function header_row_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to header_row_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of header_row_edit as text
%        str2double(get(hObject,'String')) returns contents of header_row_edit as a double

try
    valid=guiCheckNumerical(hObject,true,0,[]);
    
    if valid
        tmp=str2double(get(hObject,'String'));
        set(hObject,'String',num2str(round(tmp)));
        
        set(handles.import_pushbutton,'enable','on')
    else
        set(handles.import_pushbutton,'enable','off')
    end
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return


% --- Executes during object creation, after setting all properties.
function header_row_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to header_row_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in delimiter_popupmenu.
function delimiter_popupmenu_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to delimiter_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns delimiter_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from delimiter_popupmenu


% --- Executes during object creation, after setting all properties.
function delimiter_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to delimiter_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in decimal_popupmenu.
function decimal_popupmenu_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to decimal_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns decimal_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from decimal_popupmenu


% --- Executes during object creation, after setting all properties.
function decimal_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to decimal_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in import_pushbutton.
function import_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to import_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    % reset warning
    set(handles.warning_text,'String','');
    
    
    data_importfilepath=getappdata(handles.figure1,'data_importfilepath');
    % file format = excel
    dialogTitle = 'Pick a file';
    if get(handles.xls_radiobutton,'Value')
        if useStandardFileDialog
            [filename, pathname] = uigetfile( ...
                {'*.xlsx;*.xls', 'Excel (*.xlsx;*.xls)'}, ...
                dialogTitle,data_importfilepath);
        else
            [filename, pathname] = AskForFile('Excel (*.xls, *.xlsx)|*.xlsx; *.xls', dialogTitle, data_importfilepath);
        end
    else
        if useStandardFileDialog
            [filename, pathname] = uigetfile( ...
                { '*.csv', 'CSV (*.csv)';...
                '*.txt', 'TXT (*.txt)';...
                '*.NMdat', 'Nonmem (*.NMdat)';...
                '*.*', 'All files'}, ...
                dialogTitle,data_importfilepath);
        else
            [filename, pathname] = AskForFile('CSV (*.csv)|*.csv|TXT (*.txt)|*.txt|Nonmem (*.NMdat)|*.NMdat|All files|*.*', dialogTitle, data_importfilepath);
        end
    end
    % selection was cancelled
    if isnumeric(filename)
        return
    end
    
    setappdata(handles.figure1,'data_importfilepath',pathname);
    
    % read data
    if get(handles.xls_radiobutton,'Value')
        
        % Take first sheet
        if get(handles.xls_checkbox,'Value')
            [~,~,data_tmp]=xlsread([pathname,filename]);
        else % with sheet and range selection
            [~,~,data_tmp]=xlsread([pathname,filename],-1);
        end
        
        if ~iscell(data_tmp) && isnan(data_tmp)
            errordlg('Excel sheet was empty.', 'Error');
            return
        end
        % get number of header rows
        nCol=size(data_tmp,2);
        if nCol<=1
            errordlg('The selected range in Excel was to small. Please select at least two columns.', 'Error');
            return
        end
        data=cell(3,nCol);
        nHeaderRows=str2double(get(handles.header_row_edit,'String'));
        
        data_header=data_tmp(1:nHeaderRows,:);
        data_rows=data_tmp(nHeaderRows+1:end,:);
        if isempty(data_rows)
            errordlg('The selected range in Excel was to small. Please select more rows.', 'Error');
            return
        end

        maxNValid=0;
        
        for iCol=1:nCol
            % Header
            if nHeaderRows==0
                col_name=sprintf('column %d',iCol);
            else
                col_name=data_header{1,iCol};
                for iHR=2:nHeaderRows
                    col_name=[col_name,' ',data_header{iHR,iCol}]; %#ok<AGROW>
                end
            end
            data{1,iCol}=col_name;
            
            % Data type
            jj_num=cellfun(@isnumeric,data_rows(:,iCol));
            if all(jj_num)
                data{2,iCol}='double';
                data{3,iCol}=cell2mat(data_rows(:,iCol));
            else
                data{2,iCol}='string';
                data{3,iCol}=data_rows(:,iCol);
            end
            
            % get last valid  entry
            ix_num=find(jj_num);%#ok<AGROW>
            if iCol==25
                disp(iCol)
            end
            tmp(~jj_num)=nan; %#ok<AGROW>
            tmp(jj_num)=cell2mat(data_rows(jj_num,iCol));%#ok<AGROW>
            i_last=find(~isnan(tmp),1,'last');
            if ~isempty(i_last);
                maxNValid=max(maxNValid,i_last);
            end
            ix_str=find(~jj_num);
            i_last=find(~strcmp(data_rows(~jj_num,iCol),''),1,'last');
            if ~isempty(i_last);
                maxNValid=max(maxNValid,ix_str(i_last));
            end
        end
        
        % cut non valid rows
        if maxNValid>0 && maxNValid<size(data_rows,1)
            for iCol=1:nCol
                data{3,iCol}=data{3,iCol}(1:maxNValid);
            end
        end
        
    else
        % get delimiter
        i_delim=get(handles.delimiter_popupmenu,'Value');
        switch i_delim
            case 1 %Tab delimited
                delim='\t';
            case 2 %Semicolon delimited
                delim=';';
            case 3 %Comma delimited
                delim=',';
            case 4 %Blank delimited
                delim=' ';
        end
        
        % get decimal delimiter
        i_delim=get(handles.decimal_popupmenu,'Value');
        switch i_delim
            case 1 %point (English)
                numformat=0;
            case 2 %Comma (German)
                numformat=1;
        end
        
        data = readtab([pathname,filename], delim, numformat, 0,1,0);
    end
    
    % save data
    setappdata(handles.figure1,'data',data);
    
    % set data to table
    data_tab=cell(size(data,2),5);
    
    for iCol=1:size(data,2)
        % column name
        data_tab{iCol,1}=data{1,iCol};
        
        % classification
        if ~get(handles.nonmem_radiobutton,'Value')
            if iCol==1
                data_tab{iCol,2}='X';
            elseif get(handles.onePerRow_radiobutton,'Value')
                data_tab{iCol,2}='Y';
            else
                data_tab{iCol,2}='no import';
            end
        else   % Nonmen
            if iCol==1
                data_tab{iCol,2}='individual ID';
            else
                switch upper(data{1,iCol})
                    case {'TIME'}
                        data_tab{iCol,2}='X';
                    case {'CP'}
                        data_tab{iCol,2}='Y';
                    case {'AGE','WGHT','WEIGHT','BW','HEIGHT','HGHT','GENDER','SEX','BMI'}
                        data_tab{iCol,2}='individual prop.';
                    otherwise
                        data_tab{iCol,2}='no import';
                end
            end
        end
        
        % filter
        data_tab{iCol,3}='<html><b><u>add filter</u></b></html>';
        data_tab{iCol,4}='';
        
        
        % first values
        if strcmp(data{2,iCol},'double')
            tmp=num2str(data{3,iCol}(1));
        else
            tmp=data{3,iCol}{1};
        end
        for iRow=2:min(10,length(data{3,iCol}))
            if strcmp(data{2,iCol},'double')
                tmp=[tmp, ', ' num2str(data{3,iCol}(iRow))]; %#ok<AGROW>
            else
                tmp=[tmp, ', ' data{3,iCol}{iRow}]; %#ok<AGROW>
            end
        end
        tmp=[tmp, ',... ']; %#ok<AGROW>
        
        data_tab{iCol,5}=tmp;
        
    end
    
    set(handles.classification_uitable,'data',data_tab);
    
    % set panel active
    enableClassification(handles,'on');
    
    % set file name to dataset name
    [~,name] = fileparts(filename);
    set(handles.name_edit,'String',name);
    
    % set data panel inactive
    enableData(handles,'off');
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return

%% panel classification


% --- Executes when selected object is changed in formatSelection_uipanel.
function formatSelection_uipanel_SelectionChangeFcn(~, ~, handles)
% hObject    handle to the selected object in formatSelection_uipanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

try
    if get(handles.nonmem_radiobutton,'Value')
        % set description
        set(handles.format_text,'String',['one or more columns contain the individual identifier, '...
            'one the X values and one the Y values, in all columns a filter is possible. '...
            'The colums classified as "inidvidual prop." generates the individual description']);
        
        % enable buttons
        set(handles.percentile_pushbutton,'enable','off')
        set(handles.percentile_edit,'enable','off')
        
        % set column Format
        colForm=get(handles.classification_uitable,'ColumnFormat');
        colForm{2}={'individual ID'    'X'    'Y'    'no import' 'individual prop.'};
        set(handles.classification_uitable,'ColumnFormat',colForm)
        
    elseif get(handles.onePerRow_radiobutton,'Value')
        % set description
        set(handles.format_text,'String',['one column contains the X values, '...
            'for each individual exist one column with the Y values, in all columns a filter is possible']);
        
        % enable buttons
        set(handles.percentile_pushbutton,'enable','off');
        set(handles.percentile_edit,'enable','off');
        
        % set column Format
        colForm=get(handles.classification_uitable,'ColumnFormat');
        colForm{2}={'X'    'Y'    'no import'};
        set(handles.classification_uitable,'ColumnFormat',colForm)
        
    elseif get(handles.aggregated_radiobutton,'Value')
        % set description
        set(handles.format_text,'String',['one column contains the X values, '...
            'one column the aggregated Y values, supported aggregations are arith.mean, geo. mean, median,' ...
            'further columns are std, gsd variance and percentile, in all columns a filter is possible']);
        
        % enable buttons
        set(handles.percentile_pushbutton,'enable','on')
        set(handles.percentile_edit,'enable','on')
        
        % set column Format
        colForm=get(handles.classification_uitable,'ColumnFormat');
        
        aggregationType=getappdata(handles.figure1,'aggregationType');
        aggregationVar=getappdata(handles.figure1,'aggregationVar');
        
        colForm{2}=[{'X'}    aggregationType aggregationVar ...
            {'Y 5th percentile' 'Y 25th percentile' 'Y 75th percentile' 'Y 95th percentile' 'no import'}];
        set(handles.classification_uitable,'ColumnFormat',colForm)
    end
    
    % set default classifications
    data_tab=get(handles.classification_uitable,'Data');
    for iCol=1:size(data_tab,1)
        if iCol==1 && ~get(handles.nonmem_radiobutton,'Value')
            data_tab{iCol,2}='X';
        elseif get(handles.onePerRow_radiobutton,'Value')
            data_tab{iCol,2}='Y';
        else
            data_tab{iCol,2}='no import';
        end
    end
    set(handles.classification_uitable,'Data',data_tab);
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end


return

% --- Executes when selected cell(s) is changed in classification_uitable.
function classification_uitable_CellSelectionCallback(~, eventdata, handles) %#ok<DEFNU>
% hObject    handle to classification_uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selected
% handles    structure with handles and user data (see GUIDATA)

try
    % Add new filter
    if ~isempty(eventdata.Indices) && eventdata.Indices(2)==3
        
        % Load data
        data=getappdata(handles.figure1,'data');
        data_tab=get(handles.classification_uitable,'data');
        
        % get Column
        iCol=eventdata.Indices(1);
        
        % check if selected column is numeric
        if strcmp(data{2,1},'double') || any(cellfun(@isnumeric,data{3,iCol}))
            
            [isCanceled,filter]=createFilterCondition(true);
            
        else
            [isCanceled,filter]=createFilterCondition(false);
        end
        
        if ~isCanceled
            data_tab{iCol,4}=filter;
            set(handles.classification_uitable,'data',data_tab);
        end
        
    end
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end


return

% --- Executes on button press in convert_pushbutton.
function convert_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to convert_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    set(handles.warning_text,'String','');
    
    
    % load data -----------------
    data=getappdata(handles.figure1,'data');
    data_tab=get(handles.classification_uitable,'data');
    
    
    % check if all necessary Columns are classified -----------------------
    % individual ID
    if get(handles.nonmem_radiobutton,'Value')
        ix_ID=find(strcmp(data_tab(:,2),'individual ID'));
        if isempty(ix_ID)
            set(handles.warning_text,'String','Please select column for individual identification!')
            return
        end
    end
    % X
    ix_X=find(strcmp(data_tab(:,2),'X'));
    if isempty(ix_X)
        set(handles.warning_text,'String','No column for X values was defined!')
    elseif length(ix_X)>1
        set(handles.warning_text,'String','Please select only one X column!')
        return
    end
    % Y
    if get(handles.nonmem_radiobutton,'Value') || get(handles.onePerRow_radiobutton,'Value')
        ix_Y=find(strcmp(data_tab(:,2),'Y'));
        if isempty(ix_Y)
            set(handles.warning_text,'String','Please select column for Y values!')
            return
        elseif length(ix_Y)>1 && get(handles.nonmem_radiobutton,'Value')
            set(handles.warning_text,'String','Please select only one Y column!')
            return
        end
    end
    % Y aggregated
    if get(handles.aggregated_radiobutton,'Value')
        
        aggregationType=getappdata(handles.figure1,'aggregationType');
        aggregationVar=getappdata(handles.figure1,'aggregationVar');
        
        ix_Y=find(ismember(data_tab(:,2),aggregationType));
        if isempty(ix_Y)
            set(handles.warning_text,'String','Please select column for Y values!')
            return
        elseif length(ix_Y)>1
            set(handles.warning_text,'String','Please select only one Y column!')
            return
        end
        ix_Ydelta=find(ismember(data_tab(:,2),aggregationVar));
        if length(ix_Ydelta)>1
            set(handles.warning_text,'String','Please select only one column for Y error!')
            return
        end
        
        tmp=strfind(data_tab(:,2),'percentile');
        ix_Prct=find(~cellfun(@isempty,tmp));
        if ~isempty(ix_Prct)
            for iCol=ix_Prct
                ix=find(strcmp(data_tab(:,2),data_tab(iCol,2)));
                if length(ix)>1
                    set(handles.warning_text,'String','Please select only one column per percentile!')
                    return
                end
            end
        end
    end
    
    % individual columns
    individual_struct_tab={};
    
    if get(handles.nonmem_radiobutton,'Value')
        ix_ind=find(strcmp(data_tab(:,2),'individual prop.'));
        if ~isempty(ix_Y)
            individual_struct_tab{1,end+1}='ID';
            for iProp=ix_ind'
                tmp=data_tab{iProp,1};
                switch upper(tmp)
                    case 'AGE'
                        tmp='Age';
                    case {'WGHT','WEIGHT','BW'}
                        tmp='BW';
                    case {'HEIGHT','HGHT'}
                        tmp='Height';
                    case {'GENDER','SEX'}
                        tmp='Gender';
                    otherwise
                        forbiddenLetters={' ','/' '\' '?','-','+',':'};
                        for iL=1:length(forbiddenLetters)
                            tmp=strrep(tmp,forbiddenLetters{iL},'_');
                        end
                end
                individual_struct_tab{1,end+1}=tmp; %#ok<AGROW>
            end
        end
    end
    
    % get filter --------------------------------------------------
    jj_all=true(length(data{3,1}),1);
    for iCol=1:size(data,2)
        filter=data_tab{iCol,4};
        
        % check for mixed columns
        if ~isempty(filter) || ~strcmp(data_tab{iCol,2},'no import')
            if  strcmp(data{2,iCol},'string') && any(cellfun(@isnumeric,data{3,iCol}))
                jj_num=cellfun(@isnumeric,data{3,iCol});
                value=nan(length(data{3,iCol},1));
                value(jj_num)=cell2mat(data{3,iCol}(jj_num));
            else
                value=data{3,iCol};
            end
        end
        
        % check filter
        if ~isempty(filter)
            try
                jj=eval(filter);
            catch %#ok<CTCH>
                set(handles.warning_text,'String',...
                    sprintf('Filter evaluation for column %s was not possible, please check help',data_tab{iCol,1}));
                jj=jj_all;
            end
            jj_all=jj & jj_all;
        end
        
        % convert import columns to numeric
        if ~strcmp(data_tab{iCol,2},'no import') && ~strcmp(data_tab{iCol,2},'individual ID')
            if iscell(value)
                set(handles.warning_text,'String','The import columns must have numeric values');
                return
            end
            data{3,iCol}=value;
        end
        
        switch data_tab{iCol,2}
            case 'X' % X has no nans
                jj_all=~isnan(value) & jj_all;
        end
    end
    % set filter
    for iCol=1:size(data,2)
        data{3,iCol}=data{3,iCol}(jj_all);
    end
    
    
    % generate Structures -----------------------------
    data_struct=struct('name','','X_values','','X_dimension','','X_unit','',...
        'Y_values','','Y_dimension','','Y_unit','',...
        'individuals','',...
        'Y_aggregate','','aggregation','','Y_delta','','delta_type','',...
        'Y_n','','percentiles','','Y_percentiles','');
    
    data_struct_tab=[];
    data_struct_tab_col={};
    
    % Nonmem like data
    if get(handles.nonmem_radiobutton,'Value')
        
        % X
        if ~isempty(ix_X)
            data_struct.X_values=unique(data{3,ix_X});
            data_struct_tab_col{1}='X';
            data_struct_tab{1,1}=data{1,ix_X};
            data_struct_tab(2:length(data_struct.X_values)+1,1)=...
                num2cell(data_struct.X_values);
            xOffset=1;
            
        else
            data_struct.X_values=[];
            xOffset=0;
        end
        
        % sort by individuals
        for i=1:length(ix_ID)
            iCol=ix_ID(i);
            [uni_ID_col{i},~,ix_uni_ID_col(:,i)]=unique(data{3,iCol}); %#ok<AGROW>
        end
        
        uni_ix=unique(ix_uni_ID_col,'rows');
        
        % Initialize Array
        data_struct.individuals=cell(size(uni_ix,1),1);
        data_struct.Y_values=nan(max(1,length(data_struct.X_values)),size(uni_ix,1));
        data_struct_tab(2:length(data_struct.X_values)+1,xOffset+1:xOffset+size(uni_ix,1))=...
            num2cell(data_struct.Y_values);
        
        % Individual Loop
        for iInd=1:size(uni_ix,1)
            
            % name of individual
            indivdiual_name='';
            for i=1:length(ix_ID)
                tmp=uni_ID_col{i}(uni_ix(iInd,i));
                if iscell(tmp)
                    tmp=tmp{1};
                end
                if isnumeric(tmp)
                    indivdiual_name=[indivdiual_name '_' sprintf('%g',tmp)]; %#ok<AGROW>
                else
                    indivdiual_name=[indivdiual_name '_' tmp];%#ok<AGROW>
                end
            end
            data_struct.individuals{iInd}=indivdiual_name(2:end);
            data_struct_tab_col{xOffset+iInd}=sprintf('Y_%d',iInd);%#ok<AGROW>
            data_struct_tab{1,xOffset+iInd}=indivdiual_name(2:end);%#ok<AGROW>
            
            % entries for individual
            jj_ind=all((repmat(uni_ix(iInd,:),size(ix_uni_ID_col,1),1)==ix_uni_ID_col),2);
            
            
            X_ind=data{3,ix_X}(jj_ind);
            Y_ind=data{3,ix_Y}(jj_ind);
            if any(~isnan(Y_ind))
                ij=interp1(data_struct.X_values,[1:length(data_struct.X_values)],X_ind); %#ok<NBRAK>
                data_struct.Y_values(ij,iInd)=Y_ind;
                data_struct_tab(1+ij,xOffset+iInd)=num2cell(Y_ind); %#ok<AGROW>
                
                % individual properties
                if ~isempty(ix_ind)
                    individual_struct_tab{end+1,1}=data_struct.individuals{iInd}; %#ok<AGROW>
                    for iProp=1:length(ix_ind)
                        tmp=data{3,ix_ind(iProp)}(jj_ind);
                        if iscell(tmp)
                            individual_struct_tab{end,iProp+1}=tmp{1}; %#ok<AGROW>
                        elseif isnumeric(tmp)
                            individual_struct_tab{end,iProp+1}=tmp(1); %#ok<AGROW>
                        end
                    end
                end
            end
        end
        
        
        jjNan=all(isnan(data_struct.Y_values));
        data_struct.Y_values=data_struct.Y_values(:,~jjNan);
        data_struct.individuals=data_struct.individuals(~jjNan);
        data_struct_tab=data_struct_tab(:,[true ~jjNan]);
        data_struct_tab_col=data_struct_tab_col([true ~jjNan]);
        
        % one individual per column
    elseif get(handles.onePerRow_radiobutton,'Value')
        
        % X
        if ~isempty(ix_X)
            data_struct.X_values=data{3,ix_X};
            data_struct_tab_col{1}='X';
            data_struct_tab{1,1}=data{1,ix_X};
            data_struct_tab(2:length(data_struct.X_values)+1,1)=...
                num2cell(data_struct.X_values);
            xOffset=1;
            
        else
            data_struct.X_values=[];
            xOffset=0;
        end
        
        % Y
        % Initialize Array
        data_struct.individuals=cell(length(ix_Y),1);
        data_struct.Y_values=nan(max(1,length(data_struct.X_values)),length(ix_Y));
        data_struct_tab(2:length(data_struct.X_values)+1,xOffset+1:xOffset+length(ix_Y))=...
            num2cell(data_struct.Y_values);
        % Loop on Columns
        for iY=1:length(ix_Y)
            iCol=ix_Y(iY);
            
            data_struct.Y_values(:,iY)=data{3,iCol};
            data_struct_tab_col{xOffset+iY}=sprintf('Y_%d',iY);%#ok<AGROW>
            data_struct_tab{1,xOffset+iY}=data{1,iCol};%#ok<AGROW>
            data_struct_tab(2:size(data_struct.Y_values,1)+1,xOffset+iY)=...
                num2cell(data_struct.Y_values(:,iY));%#ok<AGROW>
        end
        
        % aggregated data
    elseif get(handles.aggregated_radiobutton,'Value')
        % X
        if ~isempty(ix_X)
            data_struct.X_values=data{3,ix_X};
            data_struct_tab_col{1}='X';
            data_struct_tab{1,1}=data{1,ix_X};
            data_struct_tab(2:length(data_struct.X_values)+1,1)=...
                num2cell(data_struct.X_values);
            xOffset=1;
            
        else
            data_struct.X_values=[];
            xOffset=0;
        end
        
        % Y_aggregate
        aggregationType=getappdata(handles.figure1,'aggregationType');
        aggregationVar=getappdata(handles.figure1,'aggregationVar');
        aggregationType_class=getappdata(handles.figure1,'aggregationType_class');
        aggregationVar_class=getappdata(handles.figure1,'aggregationVar_class');
        
        data_struct.Y_aggregate=data{3,ix_Y};
        jType= strcmp(data_tab(ix_Y,2),aggregationType);
        data_struct.aggregation=aggregationType_class{jType};
        
        data_struct_tab_col{xOffset+1}=data_tab{ix_Y,2};
        data_struct_tab{1,xOffset+1}=data{1,ix_Y};
        data_struct_tab(2:length(data_struct.Y_aggregate)+1,xOffset+1)=...
            num2cell(data_struct.Y_aggregate);
        
        % Y_delta
        if ~isempty(ix_Ydelta)
            data_struct.Y_delta=data{3,ix_Ydelta};
            jType= strcmp(data_tab(ix_Ydelta,2),aggregationVar);
            data_struct.delta_type=aggregationVar_class{jType};
            
            data_struct_tab_col{xOffset+2}=data_tab{ix_Ydelta,2};
            data_struct_tab{1,xOffset+2}=data{1,ix_Ydelta};
            data_struct_tab(2:length(data_struct.Y_delta)+1,xOffset+2)=...
                num2cell(data_struct.Y_delta);
        end
        
        % percentiles
        if ~isempty(ix_Prct)
            percentiles=nan(length(ix_Prct),1);
            for i=1:length(ix_Prct)
                percentiles(i)=str2double(strrep(data_tab{ix_Y,2}(3:end),'th percentile',''));
            end
            [data_struct.percentiles,ix_sort]=sort(percentiles);
            
            offset=size(data_struct_tab,2);
            for iP=1:length(ix_Prct)
                iCol=ix_Prct(ix_sort(i));
                
                data_struct.Y_percentiles(:,iP)=data{3,iCol};
                data_struct_tab_col{offset+iP}=data_tab{iCol,2};%#ok<AGROW>
                data_struct_tab{1,offset+iP}=data{1,iCol};%#ok<AGROW>
                data_struct_tab(2:length(data_struct.Y_aggregate)+1,offset+iP)=...
                    num2cell(data_struct.Y_percentiles(:,iP));%#ok<AGROW>
            end
        end
        
    end
    
    
    % check column header for unit information
    if ~isempty(ix_X)
        Xunit=checkUnit(data{1,ix_X},handles.X_dimension_popupmenu,handles.X_unit_popupmenu,handles.X_unit_edit);
        if ~isempty(Xunit)
            data_struct_tab{1,1}=strrep(data_struct_tab{1,1},['[' Xunit ']'],'');
            data_struct.X_unit=strtrim(Xunit);
        end
    end
    Yunit=checkUnit(data{1,ix_Y(1)},handles.Y_dimension_popupmenu,handles.Y_unit_popupmenu,handles.Y_unit_edit);
    if ~isempty(Yunit)
        data_struct_tab(1,xOffset+1:xOffset+length(ix_Y))=...
            strrep(data_struct_tab(1,xOffset+1:xOffset+length(ix_Y)),['[' Yunit ']'],'');
        data_struct.Y_unit=strtrim(Yunit);
    end
    
    setappdata(handles.figure1,'data_struct',data_struct);
    
    
    % set data table
    set(handles.data_uitable,'ColumnName',data_struct_tab_col);
    set(handles.data_uitable,'data',data_struct_tab);
    set(handles.data_uitable,'ColumnEditable',true(1,length(data_struct_tab_col)));
    
    % set individual table
    set(handles.individual_uitable,'data',individual_struct_tab);
    if isempty(individual_struct_tab)
        mode_radiobutton='off';
    else
        mode_radiobutton='on';
        set(handles.individual_uitable,'ColumnEditable',true(1,size(individual_struct_tab,2)));
    end
    enableData(handles,'on',mode_radiobutton);
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return



% --- Executes on button press in percentile_pushbutton.
function percentile_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to percentile_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    tmp=get(handles.percentile_edit,'String');
    
    colForm=get(handles.classification_uitable,'ColumnFormat');
    colForm{2}=[colForm{2}  {sprintf('Y %sth percentile',tmp)}];
    set(handles.classification_uitable,'ColumnFormat',colForm)
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return

function percentile_edit_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to percentile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of percentile_edit as text
%        str2double(get(hObject,'String')) returns contents of percentile_edit as a double

try
    valid=guiCheckNumerical(hObject,true,0,100);
    
    if valid
        set(handles.percentile_pushbutton,'on');
    else
        set(handles.percentile_pushbutton,'off');
    end
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return



% --- Executes during object creation, after setting all properties.
function percentile_edit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to percentile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% functions classification panel

function enableClassification(handles,mode)

set(handles.classification_uitable,'enable',mode);
set(handles.convert_pushbutton,'enable',mode);

if strcmp(mode,'on') && get(handles.aggregated_radiobutton,'Value')
    mode_percentile='on';
else
    mode_percentile='off';
end
set(handles.percentile_pushbutton,'enable',mode_percentile)
set(handles.percentile_edit,'enable',mode_percentile)

return

% check if column header contains unit
function Xunit=checkUnit(columnheader,h_X_dimension_popupmenu,h_X_unit_popupmenu,h_X_unit_edit)


Xunit='';

j1=strfind(columnheader,'[');
j2=strfind(columnheader,']');
% X units was found

if ~isempty(j1) && ~isempty(j2)
    Xunit=columnheader(j1+1:j2-1);
    
    % check if unit is predefined
    [dimension,Xunit]=getDimensionForObject(Xunit,columnheader);
    
    dimensionList=get(h_X_dimension_popupmenu,'String');
    iD=find(strcmp(dimensionList,dimension));
    
    % a new dimension was created
    if isempty(iD)    
        dimensionList=getDimensions;
        set(handles.X_dimension_popupmenu,'String',[{' '} dimensionList]);
        ij_time=find(strcmpi(dimensionList,'time'));
        set(handles.X_dimension_popupmenu,'Value',ij_time+1);
        set(handles.X_unit_popupmenu,'visible','on');
        set(handles.X_unit_popupmenu,'String',getUnitsForDimension('time'));
        set(handles.X_unit_popupmenu,'Value',1);
        set(handles.X_unit_edit,'visible','off');
        
        set(handles.Y_dimension_popupmenu,'String',[{' '} dimensionList]);
        set(handles.Y_dimension_popupmenu,'Value',1);
        set(handles.Y_unit_popupmenu,'visible','off');
        set(handles.Y_unit_edit,'visible','on');

        dimensionList=get(h_X_dimension_popupmenu,'String');
        iD=find(strcmp(dimensionList,dimension));
    end

    % set handles
    set(h_X_dimension_popupmenu,'Value',iD);
    unitList=getUnitsForDimension(dimensionList{iD});
    set(h_X_unit_popupmenu,'String',unitList);
    ij=find(strcmpi(unitList,strtrim(Xunit)));
    set(h_X_unit_popupmenu,'Value',ij);
    set(h_X_unit_edit,'visible','off');
    set(h_X_unit_popupmenu,'visible','on');
    
end


return

%% panel data


function name_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name_edit as text
%        str2double(get(hObject,'String')) returns contents of name_edit as a double


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


% --- Executes on selection change in X_dimension_popupmenu.
function X_dimension_popupmenu_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to X_dimension_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns X_dimension_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from X_dimension_popupmenu

try
    indx=get(hObject,'Value');
    if indx==1
        set(handles.X_unit_popupmenu,'visible','off');
        set(handles.X_unit_edit,'visible','on');
    else
        tmp = get(hObject,'String');
        dimension=tmp{indx};
        set(handles.X_unit_popupmenu,'String',getUnitsForDimension(dimension));
        set(handles.X_unit_popupmenu,'Value',1);
        set(handles.X_unit_popupmenu,'visible','on');
        set(handles.X_unit_edit,'visible','off');
    end
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return

% --- Executes during object creation, after setting all properties.
function X_dimension_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to X_dimension_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in X_unit_popupmenu.
function X_unit_popupmenu_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to X_unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns X_unit_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from X_unit_popupmenu


% --- Executes during object creation, after setting all properties.
function X_unit_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to X_unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Y_dimension_popupmenu.
function Y_dimension_popupmenu_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to Y_dimension_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Y_dimension_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Y_dimension_popupmenu

try
    indx=get(hObject,'Value');
    if indx==1
        set(handles.Y_unit_popupmenu,'visible','off');
        set(handles.Y_unit_edit,'visible','on');
    else
        tmp = get(hObject,'String');
        dimension=tmp{indx};
        set(handles.Y_unit_popupmenu,'String',getUnitsForDimension(dimension));
        set(handles.Y_unit_popupmenu,'Value',1);
        set(handles.Y_unit_popupmenu,'visible','on');
        set(handles.Y_unit_edit,'visible','off');
    end
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return

% --- Executes during object creation, after setting all properties.
function Y_dimension_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to Y_dimension_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Y_unit_popupmenu.
function Y_unit_popupmenu_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to Y_unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Y_unit_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Y_unit_popupmenu


% --- Executes during object creation, after setting all properties.
function Y_unit_popupmenu_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
% hObject    handle to Y_unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_pushbutton.
function show_pushbutton_Callback(~, ~, handles) %#ok<DEFNU>
% hObject    handle to show_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


try
    updateDataStructByHandles(handles)
    data_struct=getappdata(handles.figure1,'data_struct');
    
    
    % X vs Y
    if ~isempty(data_struct.X_values) && ~isempty(data_struct.Y_values)
        ax=getNormFigure;
        set(gcf, 'CurrentAxes', ax);
        plot(data_struct.X_values,data_struct.Y_values,'kx','markersize',8,'linewidth',2)
        if ~isempty(data_struct.X_unit)
            xlabel(['[' data_struct.X_unit ']']);
        end
        if ~isempty(data_struct.Y_unit)
            ylabel(['[' data_struct.Y_unit ']']);
        end
        
        if ~isempty(data_struct.individuals) && length(data_struct.individuals)<16
            lgtxt=data_struct.individuals;
            jj=cellfun(@isnumeric,lgtxt);
            if any(jj)
                lgtxt(jj)=cellfun(@num2str,lgtxt(jj),'UniformOutput',false);
            end
            legend(lgtxt,'location','eastoutside');
        end
        setAxesScaling(ax,'timeUnit',data_struct.X_unit);
        
    elseif isempty(data_struct.X_values) && ~isempty(data_struct.Y_values)
        ax=getNormFigure;
        set(gcf, 'CurrentAxes', ax);
        hist(data_struct.Y_values)
        if ~isempty(data_struct.Y_unit)
            xlabel(['[' data_struct.Y_unit ']']);
        end
        ylabel('number of individual');
        
    elseif ~isempty(data_struct.X_values) && ~isempty(data_struct.Y_aggregate) && ~isempty(data_struct.Y_delta)
        ax=getNormFigure;
        set(gcf, 'CurrentAxes', ax);
        switch data_struct.delta_type
            case 'Y gsd'
                errorbar(data_struct.X_values,data_struct.Y_aggregate,...
                    data_struct.Y_aggregate-data_struct.Y_aggregate./data_struct.Y_delta,...
                    data_struct.Y_aggregate.*data_struct.Y_delta-data_struct.Y_aggregate,'kx','markersize',8,'linewidth',2);
            otherwise
                errorbar(data_struct.X_values,data_struct.Y_aggregate,data_struct.Y_delta,'kx','markersize',8,'linewidth',2);
                
        end
        xlabel(['[' data_struct.X_unit ']']);
        ylabel(['[' data_struct.Y_unit ']']);
        setAxesScaling(ax,'timeUnit',data_struct.X_unit);
        
    elseif ~isempty(data_struct.X_values) && ~isempty(data_struct.Y_aggregate) && isempty(data_struct.Y_delta)
        ax=getNormFigure;
        set(gcf, 'CurrentAxes', ax);
        plot(data_struct.X_values,data_struct.Y_aggregate,'kx','markersize',8,'linewidth',2);
        if ~isempty(data_struct.X_unit)
            xlabel(['[' data_struct.X_unit ']']);
        end
        if ~isempty(data_struct.Y_unit)
            ylabel(['[' data_struct.Y_unit ']']);
        end
        setAxesScaling(ax,'timeUnit',data_struct.X_unit);
        
    elseif isempty(data_struct.X_values) && ~isempty(data_struct.Y_aggregate)
        ax=getNormFigure;
        set(gcf, 'CurrentAxes', ax);
        hist(data_struct.Y_aggregate)
        if ~isempty(data_struct.Y_unit)
            xlabel(['[' data_struct.Y_unit ']']);
        end
        ylabel('number of individual');
    end
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return

function X_unit_edit_Callback(~, ~, ~) %#ok<DEFNU>
% hObject    handle to X_unit_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X_unit_edit as text
%        str2double(get(hObject,'String')) returns contents of X_unit_edit as a double


% --- Executes during object creation, after setting all properties.
function X_unit_edit_CreateFcn(hObject, ~, ~)%#ok<DEFNU>
% hObject    handle to X_unit_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y_unit_edit_Callback(~, ~, ~)%#ok<DEFNU>
% hObject    handle to Y_unit_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_unit_edit as text
%        str2double(get(hObject,'String')) returns contents of Y_unit_edit as a double


% --- Executes during object creation, after setting all properties.
function Y_unit_edit_CreateFcn(hObject, ~, ~)%#ok<DEFNU>
% hObject    handle to Y_unit_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when selected object is changed in data_ind_uipanel.
function data_ind_uipanel_SelectionChangeFcn(~, ~, handles) %#ok<DEFNU>
% hObject    handle to the selected object in data_ind_uipanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

try
    setDataTypeSelection(handles);
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
end

return

%% functions for data panel
function enableData(handles,mode,mode_radiobutton)

try
    if ~exist('mode_radiobutton','var')
        mode_radiobutton=mode;
    end
    
    fieldNames={'OK_pushbutton','show_pushbutton','name_edit','data_uitable',...
        'X_unit_edit','X_unit_popupmenu','X_dimension_popupmenu',...
        'Y_unit_edit','Y_unit_popupmenu','Y_dimension_popupmenu'};
    
    for iFn=1:length(fieldNames)
        set(handles.(fieldNames{iFn}),'enable',mode);
    end
    set(handles.data_radiobutton,'enable',mode_radiobutton);
    set(handles.individual_radiobutton,'enable',mode_radiobutton);
    
    if strcmp(mode_radiobutton,'off')
        set(handles.data_radiobutton,'Value',1)
        setDataTypeSelection(handles);
    end
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
end

return

function setDataTypeSelection(handles)

if get(handles.individual_radiobutton,'Value')
    set(handles.data_uipanel,'visible','off');
    set(handles.individual_uipanel,'visible','on');
else
    set(handles.data_uipanel,'visible','on');
    set(handles.individual_uipanel,'visible','off');
end

return

% generate the structure by handles
function updateDataStructByHandles(handles)

try
    data_struct=getappdata(handles.figure1,'data_struct');
    data_struct_tab_col=get(handles.data_uitable,'ColumnName');
    data_struct_tab=get(handles.data_uitable,'data');
    
    % % name
    data_struct.name=get(handles.name_edit,'String');
    % X_values
    jx=strcmp(data_struct_tab_col,'X');
    if any(jx)
        data_struct.X_values=cell2mat(data_struct_tab(2:end,jx));
    else
        data_struct.X_values=[];
    end
    % X_unit and dimension
    if get(handles.X_dimension_popupmenu,'Value')>1
        tmp=get(handles.X_dimension_popupmenu,'String');
        data_struct.X_dimension=tmp{get(handles.X_dimension_popupmenu,'Value')};
        tmp=get(handles.X_unit_popupmenu,'String');
        data_struct.X_unit=tmp{get(handles.X_unit_popupmenu,'Value')};
    else
        data_struct.X_dimension='';
        data_struct.X_unit=get(handles.X_unit_edit,'String');
    end
    
    % Y_values and individuals
    jx=strncmp(data_struct_tab_col,'Y_',2);
    if any(jx)
        data_struct.Y_values=cell2mat(data_struct_tab(2:end,jx));
        data_struct.individuals=data_struct_tab(1,jx);
    else
        data_struct.Y_values=[];
        data_struct.individuals={};
    end
    % Y_unit and dimension
    if get(handles.Y_dimension_popupmenu,'Value')>1
        tmp=get(handles.Y_dimension_popupmenu,'String');
        data_struct.Y_dimension=tmp{get(handles.Y_dimension_popupmenu,'Value')};
        tmp=get(handles.Y_unit_popupmenu,'String');
        data_struct.Y_unit=tmp{get(handles.Y_unit_popupmenu,'Value')};
    else
        data_struct.Y_dimension='';
        data_struct.Y_unit=get(handles.Y_unit_edit,'String');
    end
    
    % Aggregation
    aggregationType=getappdata(handles.figure1,'aggregationType');
    aggregationVar=getappdata(handles.figure1,'aggregationVar');
    
    % values
    jx=ismember(data_struct_tab_col,aggregationType);
    if any(jx)
        data_struct.Y_aggregate=cell2mat(data_struct_tab(2:end,jx));
    else
        data_struct.Y_aggregate=[];
    end
    
    % delta
    jx=ismember(data_struct_tab_col,aggregationVar);
    if any(jx)
        data_struct.Y_delta=cell2mat(data_struct_tab(2:end,jx));
    else
        data_struct.Y_delta=[];
    end
    
    % percentiles
    jx=strEnds(data_struct_tab_col,'th percentiles');
    if any(jx)
        data_struct.Y_percentiles=cell2mat(data_struct_tab(2:end,jx));
    else
        data_struct.Y_percentiles=[];
    end
    
    % save data struct
    setappdata(handles.figure1,'data_struct',data_struct);
    
    
    % individual struct ------------------------------------------
    individual_struct_tab=get(handles.individual_uitable,'data');
    
    individual_struct=[];
    for iCol=1:size(individual_struct_tab,2)
        for iInd=1:size(individual_struct_tab,1)-1
            individual_struct(iInd).(individual_struct_tab{1,iCol})=individual_struct_tab{1+iInd,iCol}; %#ok<AGROW>
        end
    end
    
    % save individual struct
    setappdata(handles.figure1,'individual_struct',individual_struct);
    
catch exception
    constructErrorMessageForExceptions(exception,getappdata(handles.figure1,'errorDumpDirectory'));
    
    return
end

return
