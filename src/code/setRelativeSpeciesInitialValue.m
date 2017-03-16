function rowIndex = setRelativeSpeciesInitialValue(value,path_id,simulationIndex,varargin)
%SETRELATIVESPECIESINITIALVALUE Sets the value or scale factor of a specific species relative to reference.
%
%   SETRELATIVESPECIESINITIALVALUE(value,path_id,simulationIndex)
%   	value (double): species initial value relative to reference value
%           If the variable 'value' has only one entry, value is set to all 
%               initial values to which path_id or rowIndex corresponds.
%           If the variable ‘value’ has more than one entry, the number of entries 
%               must correspond to the number of entries of the variable path_id or rowIndex. 
%               path_id must be in this case numerical (vector of IDs).
%               The first entry of the vector value is set to the initial
%               value corresponding to first entry of path_id or rowIndex, and so on.
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%
%   rowIndex = SETRELATIVESPECIESINITIALVALUE(value,path_id,simulationIndex)
%       rowIndex: To identify a species initial value by path_id can be time consuming, 
%           especially if it is a string with wildcards. To avoid this time 
%           consuming search for the path_id, this index can be used to identify 
%           the species initial value instead of the path_id. It makes only sense in
%           complex and demanding code
%
%   Options:
%
%   SETRELATIVESPECIESINITIALVALUE(value,path_id,simulationIndex,'property',value_property )
%       value_property (string): specifies which property the function sets
%           'InitialValue' (default): Output is species initial value (double)
%           'ScaleFactor': scale factor of the species
%
%   SETRELATIVESPECIESINITIALVALUE(value,path_id,simulationIndex,'rowIndex',value_rowIndex )
%       value_rowIndex (double): specifies the line number
%           nan (default): species initial value is identified by path_id
%           (double vector): vector with line numbers. The time consuming search 
%               for the line numbers is already done. 
%               Path_id is ignored (see description to Output rowIndex).
%
%
% Example Calls:
% setRelativeSpeciesInitialValue(10,'TopContainer/Educt',1);
% setRelativeSpeciesInitialValue(0.1,'*',1,'property','ScaleFactor');
%
% see also INITSIMULATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 22-Sep-2010

global DCI_INFO;

%% check Inputs --------------------------------------------------------------
% check mandatory inputs
if ~exist('value','var')
    error('input "value" is missing');
else
    if size(value,2)>1
        value=value';
    end
end

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
[property,rowIndex] = ...
    checkInputOptions(varargin,{...
    'property',{'InitialValue','ScaleFactor'},'InitialValue',...
    'rowIndex',nan,nan
    });

% check if number of entries of value correpond to rowIndex/path_id
if length(value)>1 
    if all(isnan(rowIndex)) && ~isnumeric(path_id)
        error(['The variable "value" has more than one entry, '...
            'in this case "path_id" must be numeric (vector of IDs) '...
            'or use the option rowIndex!']);
    elseif all(isnan(rowIndex)) && length(value)~=length(path_id)
        error(['The variable "value" has more than one entry, '...
            'but the number of entries does not correspond to the '...
            'number of entries of the variable "path_id".']);
    elseif all(~isnan(rowIndex)) && length(value)~=length(rowIndex)
        error(['The variable "value" has more than one entry, '...
            'but the number of entries does not correspond to the '...
            'number of entries of the option variable "rowIndex".']);
    end
end
%% Evaluation

% get Table identifier
iTab=4;

% get the rowIndex, if not set by option
if isnan(rowIndex)
    rowIndex=findTableIndex(path_id, iTab, simulationIndex);
end

if isempty(rowIndex)
    if isnumeric(path_id)
        path_id=num2str(path_id);
    end
    error('Species initial value with path_id "%s" does not exist!',path_id);
end

% column indices
jCol=strcmp(property,{DCI_INFO{simulationIndex}.InputTab(iTab).Variables.Name});

% get the return value:
DCI_INFO{simulationIndex}.InputTab(iTab).Variables(jCol).Values(rowIndex)=...
    value.*DCI_INFO{simulationIndex}.ReferenceTab(iTab).Variables(jCol).Values(rowIndex);


return

