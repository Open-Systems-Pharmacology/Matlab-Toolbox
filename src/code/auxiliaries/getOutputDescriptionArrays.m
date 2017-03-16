function [descSpeciesInitialValues,descObserver]=getOutputDescriptionArrays(simulationIndex)
%GETOUTPUTDESCRIPTIONARRAYS Returns the description Arrays without model name
% 
% [descParameter,descSpeciesInitialValues]=getOutputDescriptionArrays(simulationIndex)
%           simulationIndex (double)    = index of simulation
%           descSpeciesInitialValues (cell array) = initial value description
%           descObserver (cell array)  =observer description
% 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 3-Nov-2011

[~,descObserver_tmp]=existsObserver('*',simulationIndex);
[~,descSpeciesInitialValues_tmp]=existsSpeciesInitialValue('*',simulationIndex);


% return only ID and path
if ~isempty(descObserver_tmp)
    icolPath=find(strcmpi(descObserver_tmp(1,:),'Path'));
    icolID=find(strcmpi(descObserver_tmp(1,:),'ID'));
    descObserver=descObserver_tmp(:,[icolID icolPath]);
else
    descObserver={'ID','Path'};
end

if ~isempty(descSpeciesInitialValues_tmp)
    icolPath=find(strcmpi(descSpeciesInitialValues_tmp(1,:),'Path'));
    icolID=find(strcmpi(descSpeciesInitialValues_tmp(1,:),'ID'));
    descSpeciesInitialValues=descSpeciesInitialValues_tmp(:,[icolID icolPath]);
else
    descSpeciesInitialValues={'ID','Path'};
end

% is it possible to delete the model name? ( All Parameter are in
% the branch model name or No, all initial values are in the branch
% model name)
if size(descObserver,1)>1 
    tmp=regexp(descObserver(2,2),['\' object_path_delimiter],'split');    
elseif size(descSpeciesInitialValues,1)>1  
    tmp=regexp(descSpeciesInitialValues(2,2),['\' object_path_delimiter],'split');
else
    tmp='';
end
if ~isempty(tmp)
    startString=[tmp{1}{1} object_path_delimiter];
    startString_once=[tmp{1}{1} '\' object_path_delimiter];

    jj_startString=strncmp(descObserver(2:end,2),startString,length(startString));
    
    if size(descSpeciesInitialValues,1)>1
        jj_initialValues=strncmp(descSpeciesInitialValues(2:end,2),startString,length(startString));
    else
        jj_initialValues=[];
    end
    if ~any(~jj_startString) && ~any(~jj_initialValues)
        descObserver(2:end,2)=...
            regexprep(descObserver(2:end,2),startString_once,'','once');
        descSpeciesInitialValues(2:end,2)=...
            regexprep(descSpeciesInitialValues(2:end,2),startString_once,'','once');
    end
end

return