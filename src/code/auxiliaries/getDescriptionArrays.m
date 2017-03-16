function [descParameter,descSpeciesInitialValues]=getDescriptionArrays(simulationIndex,withSolverParameter,withFormula)
%GETDESCRIPTIONARRAYS Returns the description Arrays without model name
% 
% [descParameter,descSpeciesInitialValues]=getDescriptionArrays(simulationIndex)
%           simulationIndex (double)    = index of simulation
%           descParameter (cell array)  =parameter description
%           descSpeciesInitialValues (cell array) = initial value description
%
% [descParameter,descSpeciesInitialValues]=getDescriptionArrays(simulationIndex,withSolverParameter)
%           withSolverParameter (boolean) = if true solver Parameter are included
%                           (default=false)
%
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 3-Nov-2011

if ~exist('withSolverParameter','var')
    withSolverParameter=false;
end
if ~exist('withFormula','var')
    withFormula=true;
end


[isExisting_par,descParameter_tmp]=existsParameter('*',simulationIndex,'parameterType','variable');
[isExisting_spec,descSpeciesInitialValues_tmp]=existsSpeciesInitialValue('*',simulationIndex,'parameterType','variable');

% delete Formulas
if ~withFormula
    if ~isempty(descParameter_tmp)
        jcolPath= strcmpi(descParameter_tmp(1,:),'IsFormula');
        ix=[1; find(~cell2mat(descParameter_tmp(2:end,jcolPath)))+1];
        descParameter_tmp=descParameter_tmp(ix,:);
    end
    if ~isempty(descSpeciesInitialValues_tmp)
        jcolPath= strcmpi(descSpeciesInitialValues_tmp(1,:),'IsFormula');
        ix=[1; find(~cell2mat(descSpeciesInitialValues_tmp(2:end,jcolPath)))+1];
        descSpeciesInitialValues_tmp=descSpeciesInitialValues_tmp(ix,:);
    end
end

% return only ID and path
if isExisting_par
    icolPath=find(strcmpi(descParameter_tmp(1,:),'Path'));
    icolID=find(strcmpi(descParameter_tmp(1,:),'ID'));
    descParameter=descParameter_tmp(:,[icolID icolPath]);
else
    descParameter={'ID','Path'};
end

if isExisting_spec
    icolPath=find(strcmpi(descSpeciesInitialValues_tmp(1,:),'Path'));
    icolID=find(strcmpi(descSpeciesInitialValues_tmp(1,:),'ID'));
    descSpeciesInitialValues=descSpeciesInitialValues_tmp(:,[icolID icolPath]);
else
    descSpeciesInitialValues={'ID','Path'};
end

% is it possible to delete the model name? ( All Parameter are in
% the branch model name or No, all initial values are in the branch
% model name)
if size(descParameter,1)>1
    tmp=regexp(descParameter(2,2),['\' object_path_delimiter],'split');
    startString=[tmp{1}{1} object_path_delimiter];
    startString_once=regexptranslate('escape', [tmp{1}{1} object_path_delimiter]);
    jj_startString=strncmp(descParameter(2:end,2),startString,length(startString)-1);
    solverParameters={'AbsTol','RelTol','H0','HMin','HMax','MxStep','UseJacobian'};
    jj_No=ismember(descParameter(2:end,2),solverParameters);
    
    if size(descSpeciesInitialValues,1)>1
        jj_initialValues=strncmp(descSpeciesInitialValues(2:end,2),startString,length(startString));
    else
        jj_initialValues=[];
    end
    if ~any(~jj_startString & ~jj_No) && ~any(~jj_initialValues)
        descParameter(2:end,2)=...
            regexprep(descParameter(2:end,2),startString_once,'','once');
        descSpeciesInitialValues(2:end,2)=...
            regexprep(descSpeciesInitialValues(2:end,2),startString_once,'','once');
    end

    % delete Solver parameter
    if ~withSolverParameter
        keep=setdiff(1:size(descParameter,1),find(jj_No)+1);
        descParameter=descParameter(keep,:);
        jj_No=[];
    end

end

return