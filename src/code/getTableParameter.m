function [ID, Time, Value, RestartSolver] = getTableParameter(path_id,simulationIndex,varargin)

%GETTABLEPARAMETER Returns the table (id, time, value, restartSolver) of a table parameter.
%
%   [ID, Time, Value, RestartSolver] = GETTABLEPARAMETER(path_id,simulationIndex)
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%   	ID (double): ID of table parameter
%       Time (double): Time point of value
%       Value (double): Value at time point
%       RestartSolver (0 or 1): If it is different to 0, the solver gets
%       restarted.
%
%   Options:
%   
%   [ID, Time, Value, RestartSolver] = GETTABLEPARAMETER(path_id,simulationIndex,'parameterType',value_parameterType)
%       value_parameterType (string) specifiy the type of parameter
%           'current' (default): Returns the current value of a variable or
%               read-only parameter
%           'reference': Returns the current value of a reference parameter 
%           'variable': Returns the current value of a variable parameter 
%           'readOnly': Returns the current value of a read-only parameter
%           To get more information about parameter types: call MoBi
%
%   [ID, Time, Value, RestartSolver] = GETTABLEPARAMETER(path_id,simulationIndex,'rowIndex',value_rowIndex)
%       value_rowIndex (double): specifies the line number
%           nan (default): parameter is identified by path_id
%           (double vector): vector with line numbers. The time consuming search 
%               for the line numbers is already done. 
%               Path_id is ignored (see description to Output rowIndex).
%               The option rowIndex can only be used in combination with the
%               option parameterType. The default parameter type 'current'
%               is not allowed together with option rowIndex.
%
%
% Example Calls:
% [ID, Time, Value, RestartSolver] = getTableParameter('No/AbsTol',1);
% [ID, Time, Value, RestartSolver] = getTableParameter('*',1,'parameterType','readonly');
% [ID, Time, Value, RestartSolver] = getTableParameter('*',1,'parameterType','variable', 'rowIndex', 1923);
%
% see also INITSIMULATION, SETTABLEPARAMETER

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 15-Nov-2012

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
[parameterType,rowIndex] = ...
    checkInputOptions(varargin,{...
    'parameterType',{'current','reference','readOnly','variable'},'current',...
    'rowIndex',nan,nan
    });

% option which disagree
if strcmp(parameterType,'current') && ~isnan(rowIndex)
    error(['If you want to use option rowIndex, you have to specify the parameter type further.'...
        char(10) 'Please take "reference", "readOnly" or "variable"']);
end

% get Table identifier
TableName='InputTab';
iTab=9;
switch parameterType
    case 'readOnly'
        iTab=8;
    case 'reference'
        TableName='ReferenceTab';
end

% get the table Array
TableArray=DCI_INFO{simulationIndex}.(TableName)(iTab);

% get the rowIndex, if not set by option
if isnan(rowIndex)
    % path id is numerical: ID
    if ~isnumeric(path_id)
        path_id=getParameter(path_id,simulationIndex,'parameterType',parameterType,'property','ID');
    end
else
    %find path ids if index set by option
    path_id = getParameter(path_id,simulationIndex,'parameterType',parameterType,'property','ID','rowIndex',rowIndex);   
end

% find correct indexes in table array
rowIndex=[];
jCol= strcmp('ID',{TableArray.Variables.Name});
for iPar=1:length(path_id)
    indx_tmp=find(TableArray.Variables(jCol).Values==path_id(iPar));
    rowIndex=[rowIndex(:)' indx_tmp(:)'];
end

% for parameter type current search also read only if not found in variable
if isempty(rowIndex) && strcmp(parameterType,'current')
    iTab=8;
    TableArray=DCI_INFO{simulationIndex}.(TableName)(iTab);
    
    % path id is numerical: ID
    if ~isnumeric(path_id)
        path_id=getParameter(path_id,simulationIndex,'parameterType',parameterType,'property','ID');
    end

    % find correct indexes in table array
    rowIndex=[];
    jCol= strcmp('ID',{TableArray.Variables.Name});
    for iPar=1:length(path_id)
        indx_tmp=find(TableArray.Variables(jCol).Values==path_id(iPar));
        rowIndex=[rowIndex(:)' indx_tmp(:)']; 
    end
end

ID=TableArray.Variables(1).Values(rowIndex);
Time=TableArray.Variables(2).Values(rowIndex);
Value=TableArray.Variables(3).Values(rowIndex);
RestartSolver=TableArray.Variables(4).Values(rowIndex);

return





