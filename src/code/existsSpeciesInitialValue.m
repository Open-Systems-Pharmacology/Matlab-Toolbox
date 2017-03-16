function [isExisting,description,rowIndex] = existsSpeciesInitialValue(path_id,simulationIndex,varargin)
%EXISTSSPECIESINITIALVALUE Checks the existence of a species initial values and returns its description.
%
%   isExisting = EXISTSSPECIESINITIALVALUE(path_id,simulationIndex)
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%   	isexisting (boolean): 
%           true: At least one species of the given path_id exists.
%       	false: No species of the given path_id exists.
%
%   [isExisting,description] = EXISTSSPECIESINITIALVALUE(path_id,simulationIndex)
%       description (cell array): returns a list of all parameters corresponding to path_id
%
%   [isExisting,description,rowIndex] = EXISTSSPECIESINITIALVALUE(path_id,simulationIndex)
%       rowIndex: Identifying a species by path_id can be time consuming, 
%           especially if it is a string with wildcards. To avoid a repeated time 
%           consuming search for the path_id, this index can be used to identify 
%           the species instead of the path_id. It makes only sense in
%           complex and demanding code.
%
%   Options:
%
%   isExisting = EXISTSSPECIESINITIALVALUE(path_id,simulationIndex,'parameterType',parameterType_value)
%       parameterType_value (string)
%           'variable' (default). Only the variable parameters are searched. 
%           'readOnly' Read only parameters are searched. 
%           To get more information about parameter types: call MoBi
%
%
%
% Example Calls:
% [isexisting,description,rowIndex] = existsSpeciesInitialValue('TopContainer/y1',1,'parameterType','variable')
% [isexisting,description,rowIndex] = existsSpeciesInitialValue('*',1)
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

if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end

% Check input options
[parameterType] = ...
    checkInputOptions(varargin,{...
    'parameterType',{'readOnly','variable'},'variable'
    });

    
%% evaluation

%get Tab number
iTab=find(strcmpi(parameterType,{'readOnly','variable'}))+2;

%get rowIndex
rowIndex=findTableIndex(path_id,iTab,simulationIndex);

description={};
if isempty(rowIndex) 
    isExisting=false;
else
    isExisting=true;
    for iCol=1:length(DCI_INFO{simulationIndex}.InputTab(iTab).Variables)
        description{1,iCol}=DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Name; %#ok<*AGROW>
        for iPar=1:length(rowIndex)
            tmp=DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values(rowIndex(iPar));
            if iscell(tmp)
                description(iPar+1,iCol)=tmp;
            else
                description{iPar+1,iCol}=tmp;
            end
        end
    end
    
end

return
