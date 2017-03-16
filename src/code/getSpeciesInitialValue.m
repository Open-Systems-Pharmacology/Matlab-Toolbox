function [value,rowIndex] = getSpeciesInitialValue(path_id,simulationIndex,varargin)
%GETSPECIESINITIALVALUE Returns the value and other properties of a species initial value.
%
%   value = GETSPECIESINITIALVALUE(path_id,simulationIndex)
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%   	value (double): species initial value
%
%   [value,rowIndex] = GETSPECIESINITIALVALUE(path_id,simulationIndex)
%       rowIndex: Identifying a species initial value by path_id can be time consuming, 
%           especially if it is a string with wildcards. To avoid a repeated time 
%           consuming search for the path_id, this index can be used to identify 
%           the species initial value instead of the path_id. It makes only sense in
%           complex and demanding code.
%
%   Options:
%   
%   value = GETSPECIESINITIALVALUE(path_id,simulationIndex,'parameterType',value_parameterType)
%       value_parameterType (string) specifiy the type of species initial value
%           'current' (default): Returns the current value of a variable or
%               read-only species initial value.
%           'reference': Returns the current value of a reference species initial value 
%           'variable': Returns the current value of a variable species initial value 
%           'readOnly': Returns the current value of a read-only species initial value
%           To get more information about parameter types: call MoBi
%
%   value = GETSPECIESINITIALVALUE(path_id,simulationIndex,'property',value_property )
%       value_property (string): specifies which property the function returns
%           'InitialValue' (default): Output is species initial value (double)
%           'ID': Output is the species initial value ID (double)
%           'Path': Path of parameter (string/cellarray)
%           'Unit': Output is the species initial value unit (string/cellarray)
%           'Formula' : Output is the species initial value formula (string/cellarray)
%           'isFormula' : Output (boolean):
%                   true: the species initial value is a formula
%                   false: the species initial value is no formula
%           'ScaleFactor': scale factor of the species
%
%   value = GETSPECIESINITIALVALUE(path_id,simulationIndex,'rowIndex',value_rowIndex,'parameterType',value_parameterType )
%       value_rowIndex (double): specifies the line number
%           nan (default): species initial value is identified by path_id
%           (double vector): vector with line numbers. The time consuming search 
%               for the line numbers is already done. 
%               Path_id is ignored (see description to Output rowIndex).
%               The option rowIndex can only be used in combination with the
%               option parameterType. The default parameter type 'current'
%               is not allowed together with option rowIndex.

%
%
% Example Calls:
% [value,rowIndex] = getSpeciesInitialValue('TopContainer/Educt',1);
% [value,rowIndex] = getSpeciesInitialValue('*',1,'parameterType','readonly','property','ID');
%
% see also INITSIMULATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 22-Sep-2010

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
[parameterType,property,rowIndex] = ...
    checkInputOptions(varargin,{...
    'parameterType',{'current','reference','readOnly','variable'},'current',...
    'property',{'InitialValue','ID','Unit','Formula','IsFormula','ScaleFactor','Path'},'InitialValue',...
    'rowIndex',nan,nan
    });

% option which disagree
if strcmp(parameterType,'current') && ~isnan(rowIndex)
    error(['If you want to use option rowIndex, you have to specify the parameter type further.'...
        char(10) 'Please take "reference", "readOnly" or "variable"']);
end

%% Evaluation

% get Table identifier
isReference=false;
TableName='InputTab';
iTab=4;
switch parameterType
    case 'readOnly'
        iTab=3;
    case 'reference'
        TableName='ReferenceTab';
        isReference=true;
end

% get the rowIndex, if not set by option
if isnan(rowIndex)
    rowIndex=findTableIndex(path_id, iTab, simulationIndex, isReference);
end

% for parameter type current search also read only if not found in variable
if isempty(rowIndex) && strcmp(parameterType,'current')
    iTab=3;
    rowIndex=findTableIndex(path_id,3, simulationIndex);
end

if isempty(rowIndex)
    if isnumeric(path_id)
        path_id=num2str(path_id);
    elseif strcmp(path_id','*')
        value=[];
        return
    end
    error('Species initial value with path_id "%s" does not exist for specified parameter type "%s"!',...
        path_id,parameterType);
end

% column indices
jCol=strcmp(property,{DCI_INFO{simulationIndex}.(TableName)(iTab).Variables.Name;});

% get the return value:
value=DCI_INFO{simulationIndex}.(TableName)(iTab).Variables(jCol).Values(rowIndex);

if iscell(value) && length(value)==1
    value=value{1};
end


return

