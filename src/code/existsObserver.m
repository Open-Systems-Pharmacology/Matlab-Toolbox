function [isExisting,description,rowIndex] = existsObserver(path_id,simulationIndex,varargin)
%EXISTSOBSERVER Checks the existence of an observer and returns its description array.
%
%   isExisting = EXISTSOBSERVER(path_id,simulationIndex)
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%   	isExisting (boolean): 
%           true: At least one observer of the given path_id exists.
%       	false: No observer of the given path_id exists.
%
%   [isExisting,description] = EXISTSOBSERVER(path_id,simulationIndex)
%       description (cell array): returns a list of all observers corresponding to path_id
%
%   [isExisting,description,rowIndex] = EXISTSOBSERVER(path_id,simulationIndex)
%       rowIndex: Identifying an observer by path_id can be time consuming, 
%           especially if it is a string with wildcards. To avoid a repeated time 
%           consuming search for the path_id, this index can be used to identify 
%           the observer instead of the path_id. It makes only sense in
%           complex and demanding code.
%
% Example Calls:
% [isexisting,description,rowIndex] = existsObserver('*',1);
%
% see also INITSIMULATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 27-Dec-2010

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

%% evaluation

%get Tab number
iTab=5;

%get rowIndex
rowIndex=findTableIndex(path_id,iTab,simulationIndex);

% get description for rowIndex
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
  
