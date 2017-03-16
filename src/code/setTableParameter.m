function setTableParameter(ID,Time,Value,RestartSolver,simulationIndex,varargin)
%SETTABLEPARAMETER Sets the value of a specific parameter.
%
%   SETTABLEPARAMETER(ID,Time,Value,RestartSolver,simulationIndex)
%   	ID (double): ID of table parameter
%       Time (double): Time point of value
%       Value (double): Value at time point
%       RestartSolver (0 or 1): If it is different to 0, the solver gets
%       restarted.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%
%   Options:
%   
%   SETTABLEPARAMETER(ID,Time,Value,RestartSolver,simulationIndex,'parameterType',value_parameterType)
%       value_parameterType (string) specifiy the type of parameter
%           'variable'(default): Sets the current value of a variable parameter 
%           'reference': Sets the current value of a reference parameter 
%           To get more information about parameter types: call MoBi
%
% Example Call:
% [ID, Time, Value, RestartSolver] = getTableParameter(path_id="*", 1)
% ...
% setTableParameter(ID, Time, Value, RestartSolver,1);
%
% see also INITSIMULATION, GETTABLEPARAMETER

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 15-Nov-2012

global DCI_INFO;

%% check Inputs --------------------------------------------------------------
% check mandatory inputs
if ~exist('ID','var')
    error('Input "ID" is missing.');
end

if ~exist('Time','var')
    error('Input "Time" is missing.');
end

if ~exist('Value','var')
    error('Input "Value" is missing.');
end

if ~exist('RestartSolver','var')
    error('Input "RestartSolver" is missing.');
end

if length(ID) ~= length(Time) || length(ID) ~= length(Value) || length(ID) ~= length(RestartSolver)
    error('Inputs "ID", "Time", "Value", "RestartSolver" do not have the same length.');
end

% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end

% Check input options
[parameterType] = ...
    checkInputOptions(varargin,{...
    'parameterType',{'reference','variable'},'variable'
    });
    
%% Evaluation

% get Table identifier
switch parameterType
    case 'variable'
        TableName='InputTab';
    case 'reference'
        TableName='ReferenceTab';
end

% get the table Array
iTab=9;
TableArray=DCI_INFO{simulationIndex}.(TableName)(iTab);

jCol = strcmp('ID', {TableArray.Variables.Name});
rowIndex=[];
IDs=unique(ID);
for iPar=1:length(IDs)
    indx_tmp=find(TableArray.Variables(jCol).Values==IDs(iPar));
    rowIndex=[rowIndex(:)' indx_tmp(:)']; 
end
    
% delete current entries
indx = setdiff([1:length(TableArray.Variables(1).Values)], rowIndex);
TableArray.Variables(1).Values = TableArray.Variables(1).Values(indx);
TableArray.Variables(2).Values = TableArray.Variables(2).Values(indx);
TableArray.Variables(3).Values = TableArray.Variables(3).Values(indx);
TableArray.Variables(4).Values = TableArray.Variables(4).Values(indx);
% append new entries
TableArray.Variables(1).Values = [TableArray.Variables(1).Values(:)', ID(:)']';
TableArray.Variables(2).Values = [TableArray.Variables(2).Values(:)', Time(:)']';
TableArray.Variables(3).Values = [TableArray.Variables(3).Values(:)', Value(:)']';
TableArray.Variables(4).Values = [TableArray.Variables(4).Values(:)', RestartSolver(:)']';
% set table
DCI_INFO{simulationIndex}.(TableName)(iTab)=TableArray;

return

