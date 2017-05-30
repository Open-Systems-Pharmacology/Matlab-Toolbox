function [sim_time,sim_values,rowIndex,path_id_list]=getSimulationResult(path_id,simulationIndex,varargin)
%GETSIMULATIONRESULT Gets the time profile of the species or observer specified by path_id.
%
%   [sim_time,sim_values]=GETSIMULATIONRESULT(path_id,simulationIndex)
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%       sim_time: time vector corresponding to specified path_id
%       sim_values: concentration profile [n x m double] ( m = number of matching Species)
%
%   [sim_time,sim_values,rowIndex]=GETSIMULATIONRESULT(path_id,simulationIndex)
%       rowIndex: Identifying a species by path_id can be time consuming, 
%           especially if it is a string with wildcards. To avoid a repeated time 
%           consuming search for the path_id, this index can be used to identify 
%           the species instead of the path_id. It makes only sense in
%           complex and demanding code.
%
%   [sim_time,sim_values,~,path_id]=GETSIMULATIONRESULT(path_id,simulationIndex)
%       path_id (cell array): List of path_ids in the same order as the
%           results, so that you an discrimnate the results if you use wild
%           cards.
%
%   Options:
%
%   [sim_time,sim_values,rowIndex]=GETSIMULATIONRESULT(path_id,simulationIndex,'rowIndex',value_rowIndex)
%       value_rowIndex (double): specifies the line number
%           nan (default): parameter is identified by path_id
%           (double vector): vector with line numbers. The time consuming search 
%               for the line numbers is already done. 
%               Path_id is ignored (see description to Output rowIndex).
%
%                                   
%
%
% Example Calls:
% [sim_time,sim_values,rowIndex]=getSimulationResult('TopContainer|Educt',1);
% [sim_time,sim_values,rowIndex]=getSimulationResult('TopContainer|Educt',1,'rowIndex',rowIndex);
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
[rowIndex] = ...
    checkInputOptions(varargin,{...
    'rowIndex',nan,nan,...
    });

%% Evaluation
% check if process is done
if ~isfield(DCI_INFO{simulationIndex},'OutputTab')
    error('Outputs not yet generated for simulationIndex %d. Please use processSimulation',simulationIndex);
elseif isempty(DCI_INFO{simulationIndex}.OutputTab)
    error('Outputs are empty for simulationIndex %d. Probably the last processSimulation was interrupted by an error.',simulationIndex);    
end

% Initialize outputs
path_id_list={};

% get the rowIndex, if not set by option
if isnan(rowIndex)
    if ~isnumeric(path_id)
        ID=[];
        [isexisting,description]=existsSpeciesInitialValue(path_id,simulationIndex,'parameterType','readOnly');
        if isexisting
            jj=strcmp(description(1,:),'ID');
            ID=cell2mat(description(2:end,jj));
        end
            [isexisting,description]=existsObserver(path_id,simulationIndex);
            if isexisting
                jj=strcmp(description(1,:),'ID');
                ID=[ID;cell2mat(description(2:end,jj))];
            end
        if isempty(ID)
            error('output not found: %s,',path_id);
        end
    else
        ID=path_id;
    end
    
    % get rowindices    
    rowIndex=find(ismember(DCI_INFO{simulationIndex}.OutputTabID,ID));
    %     rowIndex=[];
    %     for iCol=1:length(DCI_INFO{simulationIndex}.OutputTab(2).Variables)
    %         if any(ID==str2double(DCI_INFO{simulationIndex}.OutputTab(2).Variables(iCol).Attributes(1).Value))
    %             rowIndex(end+1)=iCol; %#ok<AGROW>
    %         end
    %     end
end

if isempty(rowIndex)
    if isnumeric(path_id)
        path_id=num2str(path_id);
    end
    error('Result with path_id "%s" does not exist!',path_id);
end

% get Ouput
% time
rowIndex_time=1;%str2double(DCI_INFO{simulationIndex}.OutputTab(2).Variables(rowIndex(1)).Attributes(4).Value);
sim_time=DCI_INFO{simulationIndex}.OutputTab(1).Variables(rowIndex_time).Values';
% check if timeIndex is unique
timeIndexIsUnique=true;
%This has only to be done if tdifferent time scales for different output would be poissble. That is not impülemented
% for i=2:length(rowIndex)
%     rowIndex_time_tmp=str2double(DCI_INFO{simulationIndex}.OutputTab(2).Variables(rowIndex(i)).Attributes(4).Value);
%     if rowIndex_time_tmp ~=rowIndex_time
%         sim_time=unique([sim_time,DCI_INFO{simulationIndex}.OutputTab(1).Variables(rowIndex_time_tmp).Values]);
%         timeIndexIsUnique=false;
%     end
% end

% values
sim_values=nan(length(rowIndex),length(sim_time));
for iIndx=1:length(rowIndex)
    rowIndex_i=rowIndex(iIndx);
    values_tmp=DCI_INFO{simulationIndex}.OutputTab(2).Variables(rowIndex_i).Values;
    
    % set nan for missing timepoints
    if ~timeIndexIsUnique
        rowIndex_time_tmp=str2double(DCI_INFO{simulationIndex}.OutputTab(2).Variables(rowIndex(iIndx)).Attributes(4).Value2);
        ji=interp1(DCI_INFO{simulationIndex}.OutputTab(1).Variables(rowIndex_time_tmp).Values,[1:length(sim_time)],sim_time); %#ok<NBRAK>
        sim_values(iIndx,ji)  = values_tmp;
    else
        sim_values(iIndx,:) = values_tmp;        
    end
    
    path_id_list{iIndx,1}=DCI_INFO{simulationIndex}.OutputTab(2).Variables(rowIndex_i).Attributes(2).Value; %#ok<AGROW>
end

return
