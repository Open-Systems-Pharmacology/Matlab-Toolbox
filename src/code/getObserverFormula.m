function [value,rowIndex] = getObserverFormula(path_id,simulationIndex,varargin)
%GETOBSERVERFORMULA Returns the formula and other properties of an observer.
%
%   value = GETOBSERVERFORMULA(path_id,simulationIndex)
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%   	value (string): observer formula
%
%   [value,rowIndex] = GETOBSERVERFORMULA(path_id,simulationIndex)
%       rowIndex: Identifying an observer by path_id can be time consuming, 
%           especially if it is a string with wildcards. To avoid a repeated time 
%           consuming search for the path_id, this index can be used to identify 
%           the observer instead of the path_id. It makes only sense in
%           complex and demanding code.
%
%   Options:
%   
%   value = GETOBSERVERFORMULA(path_id,simulationIndex,'property',value_property )
%       value_property (string): specifies which property the function returns
%           'Formula' (default): Output is the parameter formula (string/cellarray)
%           'ID': Output is the parameter ID (double)
%           'Path': Path of parameter (string/cellarray)
%           'Unit': Output is the parameter unit (string/cellarray)
%
%   value = GETOBSERVERFORMULA(path_id,simulationIndex,'rowIndex',value_rowIndex )
%       value_rowIndex (double): specifies the line number
%           nan (default): parameter is identified by path_id
%           (double vector): vector with line numbers. The time consuming search 
%               for the line numbers is already done. 
%               Path_id is ignored (see description to Output rowIndex).
%
%
% Example Calls:
% [formula,rowIndex]=getObserverFormula('SpecModel|Organism|Lung|Cell|C|AmountObs_2',1);;
% [ID,rowIndex]=getObserverFormula('SpecModel|Organism|Lung|Cell|C|AmountObs_2',1,'property','ID');
%
% see also INITSIMULATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 28-Sep-2010

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
[property,rowIndex] = ...
    checkInputOptions(varargin,{...
    'property',{'ID','Formula','Path','Unit'},'Formula',...
    'rowIndex',nan,nan
    });



%% Evaluation

% get Table identifier
iTab=5;

% get the rowIndex, if not set by option
if isnan(rowIndex)
    rowIndex=findTableIndex(path_id, iTab, simulationIndex);
end


if isempty(rowIndex)
    if isnumeric(path_id)
        path_id=num2str(path_id);
    elseif strcmp(path_id','*')
        value=[];
        return
    end
    error('Observer with path_id "%s" does not exist!',path_id);
end

% column indices
jCol=strcmp(property,{DCI_INFO{simulationIndex}.InputTab(iTab).Variables.Name;});

% get the return value:
value=DCI_INFO{simulationIndex}.InputTab(iTab).Variables(jCol).Values(rowIndex);

if iscell(value) && length(value)==1
    value=value{1};
end

return

