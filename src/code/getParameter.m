function [value,rowIndex] = getParameter(path_id,simulationIndex,varargin)
%GETPARAMETER Returns the value and other properties of a parameter.
%
%   value = GETPARAMETER(path_id,simulationIndex)
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%   	value (double): parameter value
%
%   [value,rowIndex] = GETPARAMETER(path_id,simulationIndex)
%       rowIndex: Identifying a parameter by path_id can be time consuming, 
%           especially if it is a string with wildcards. To avoid a repeated time 
%           consuming search for the path_id, this index can be used to identify 
%           the parameter instead of the path_id. It makes only sense in
%           complex and demanding code.
%
%   Options:
%   
%   value = GETPARAMETER(path_id,simulationIndex,'parameterType',value_parameterType)
%       value_parameterType (string) specify the type of parameter
%           'current' (default): Returns the current value of a variable or
%               read-only parameter
%           'reference': Returns the current value of a reference parameter 
%           'variable': Returns the current value of a variable parameter 
%           'readOnly': Returns the current value of a read-only parameter
%           To get more information about parameter types: call MoBi
%
%   value = GETPARAMETER(path_id,simulationIndex,'property',value_property )
%       value_property (string): specifies which property the function returns
%           'Value' (default): Output is parameter value (double/cellarray)
%           'ID': Output is the parameter ID (double)
%           'Path': Path of parameter (string/cellarray)
%           'Unit': Output is the parameter unit (string/cellarray)
%           'Formula' : Output is the parameter formula (string/cellarray)
%           'isFormula' : Output (boolean):
%                   true: the parameter is a formula
%                   false: the parameter is not a formula
%           'IsTable' : Output (boolean):
%                   true: the parameter is a time-dependent table
%                   false: the parameter is not a time-dependent table
%           'IsValue' : Output (boolean):
%                   true: the parameter is a value
%                   false: the parameter is not a value
%           'ParameterType' : Output (string/cellarray):
%                   Formula: the parameter is a formula
%                   Table: the parameter is a time-dependent table
%                   Value: the parameter is a value
%
%   value = GETPARAMETER(path_id,simulationIndex,'rowIndex',value_rowIndex,'parameterType',value_parameterType)
%       value_rowIndex (double): specifies the line number
%           nan (default): parameter is identified by path_id
%           (double vector): vector with line numbers. The time consuming search 
%               for the line numbers is already done. 
%               Path_id is ignored (see description to Output rowIndex).
%               The option rowIndex can only be used in combination with the
%               option parameterType. The default parameter type 'current'
%               is not allowed together with option rowIndex.
%
%   value = GETPARAMETER(path_id,simulationIndex,'timeProfile',value_timeProfile)
%       value_timeProfile (double vector): time points where parameter
%       values are evaluated (only important for table parameters)
%           0 (default): parameter is identified by path_id
%       value is then a matrix, rows corresponds to the path_id, columns to the time profile.    
%
% Example Calls:
% [value,rowIndex] = getParameter('No/AbsTol',1);
% [value,rowIndex] = getParameter('*',1,'parameterType','readonly','property','ID');
% [value,rowIndex] = getParameter('*',1,'timeprofile',[0 10 20]);
%
% see also INITSIMULATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 20-Sep-2010

global DCI_INFO;

%% check Inputs --------------------------------------------------------------
% check mandatory inputs
if ~exist('path_id','var')
    error('input "path_id" is missing');
end

% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end

% Check input options
[parameterType,property,rowIndex,timeProfile] = ...
    checkInputOptions(varargin,{...
    'parameterType',{'current','reference','readOnly','variable'},'current',...
    'property',{'Value','ID','Unit','Formula','IsFormula','IsTable','IsValue','ParameterType','Path','Description'},'Value',...
    'rowIndex',nan,nan,...
    'timeProfile',nan,nan
    });

% option which disagree
if strcmp(parameterType,'current') && ~isnan(rowIndex)
    error(['If you want to use option rowIndex, you have to specify the parameter type further.'...
        char(10) 'Please take "reference", "readOnly" or "variable"']);
end

% get DCIVersion
if length(DCI_INFO{simulationIndex}.InputTab)==9
    DCI_version=2;
else
    DCI_version=1;
end    

%% Evaluation

% get Table identifier
isReference=false;
TableName='InputTab';
iTab=2;
switch parameterType
    case 'readOnly'
        iTab=1;
    case 'reference'
        TableName='ReferenceTab';
        isReference=true;
end

% get the rowIndex, if not set by option
if isnan(rowIndex)
    rowIndex=findTableIndex(path_id, iTab, simulationIndex, isReference);
end

% for parameter type current search also read only if not found in variable
rowIndexList={[],[]};
rowIndexList{iTab}=rowIndex;
tabList=iTab;
if strcmp(parameterType,'current')
    iTab=1;
    rowIndexList{1}=findTableIndex(path_id,1, simulationIndex);
    
    % merge tables, take only parameters which are not variable form
    % readonly
    if length(rowIndexList{1}) == length(rowIndexList{2})
        % there is no additional parameter in the read only table
        rowIndexList{1}=[];
    else
        
        % get additional IDs
        jCol=strcmp('ID',{DCI_INFO{simulationIndex}.(TableName)(iTab).Variables.Name});
        ID_tab2=DCI_INFO{simulationIndex}.(TableName)(2).Variables(jCol).Values(rowIndexList{2});
        ID_tab1=DCI_INFO{simulationIndex}.(TableName)(1).Variables(jCol).Values(rowIndexList{1});
                
        ID_new = setdiff(ID_tab1,ID_tab2);
        rowIndexList{1}=findTableIndex(ID_new,1, simulationIndex);
end

    % for parameter type current merge variable and reference table
    if ~isempty(rowIndexList{1})
        tabList = [1 2];
    end

    % set row index to nan,
    % cannot be used as new import because of table merge
    rowIndex = nan;
end

if isempty(rowIndexList{1}) && isempty(rowIndexList{2})
    if isnumeric(path_id)
        path_id=num2str(path_id);
    elseif strcmp(path_id,'*')
        value=[];
        return
    end
    error('Parameter with path_id "%s" does not exist for specified parameter type "%s"!',...
        path_id,parameterType);
end

% column indices
if ismember(property,{'IsFormula','IsTable','IsValue'}) && DCI_version==2
    jCol=strcmp('ParameterType',{DCI_INFO{simulationIndex}.(TableName)(iTab).Variables.Name});
elseif ismember(property,{'IsTable', 'IsValue','ParameterType'}) && DCI_version==1
    value=false;
    return;
else
    jCol=strcmp(property,{DCI_INFO{simulationIndex}.(TableName)(iTab).Variables.Name});
end

value = [];
for iTab = tabList
% get the return value:
    value_tab=DCI_INFO{simulationIndex}.(TableName)(iTab).Variables(jCol).Values(rowIndexList{iTab});


if DCI_version==2
    switch property
        case 'IsFormula'
                value_tab=strcmp('Formula',value_tab);
        case 'IsTable'
                value_tab=strcmp('Table',value_tab);
        case 'IsValue'
                value_tab=strcmp('Value',value_tab);
        case 'Value'
                jj_nan=isnan(value_tab); % table parameter
            if any(jj_nan)
                
                %get the table parameter
                jColP=strcmp('ParameterType',{DCI_INFO{simulationIndex}.(TableName)(iTab).Variables.Name});
                    valueType=DCI_INFO{simulationIndex}.(TableName)(iTab).Variables(jColP).Values(rowIndexList{iTab});
                jColID=strcmp('ID',{DCI_INFO{simulationIndex}.(TableName)(iTab).Variables.Name});
                    IDs=DCI_INFO{simulationIndex}.(TableName)(iTab).Variables(jColID).Values(rowIndexList{iTab});
                jj_Table=strcmp(valueType,'Table');
                
				if any(jj_Table)
                    if isnan(timeProfile)
                    % warning missing time profile
                        warning('MoBiToolbox:Basis:TableParameterGet',...
                            'At least one parameter is a table parameter but no time profile has been specified.');
                        timeProfile=0;
                    end
                        values_new = num2cell(value_tab);
					for iT=find(jj_Table(:)')
                            [~, Time, Value]=getTableParameter(IDs(iT),simulationIndex);
						vals = interp1(Time,Value,timeProfile,'linear');
						vals(timeProfile<Time(1))=Value(1); 
						vals(timeProfile>Time(end))=Value(end); 
						values_new{iT} = vals;
					end
                        value_tab=values_new;
					if length(timeProfile) == 1
                            value_tab = cell2mat(value_tab);
					end 
				end
            end
    end
end

    value = [value; value_tab]; %#ok<AGROW>

end


% convert 1 entry cell arrays to string
if iscell(value) && length(value)==1
    value=value{1};
end


return

