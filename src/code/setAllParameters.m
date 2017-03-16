function setAllParameters(target,source,simulationIndex)
%SETALLPARAMETERS Sets all parameter values of one type (source) to the values of another type (target). 
%   This affects parameters and species initial values including scale factors.
%
%   SETALLPARAMETERS(target,source,simulationIndex)
%       target: (string) Name of the target type, 
%           possible as target are the types:    
%               'variable'
%               'reference' 
%       source: (string) Name of the source type, 
%           possible as source are the types:    
%               'variable'
%               'reference' 
%               'readonly': parameters which have not been initialized as variable
%                           are ignored
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%
% Example Calls:
% setAllParameters('variable','reference',1);
%
% see also INITSIMULATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 22-Sep-2010


%% check Inputs --------------------------------------------------------------
% check mandatory inputs
if ~exist('target','var')
    error('input "target" is missing');
else
    keys={'variable','reference'};
    ij=find(strcmpi(target,keys));
    if isempty(ij)
        error('The parameter type for target is unknown: %s',target);
    else
        target=keys{ij};
    end
end

if ~exist('source','var')
    error('input "source" is missing');
else
    keys={'variable','reference','readOnly'};
    ij=find(strcmpi(source,keys));
    if isempty(ij)
        error('The parameter type for source is unknown: %s',source);
    else
        source=keys{ij};
    end
end

% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end


%% Evaluation

% Parameter

% get the iDs and rowIndex of the target table, 
[IDvector,target_rowIndex]=getParameter('*',simulationIndex,'parameterType',target,'property','ID');

if ~isempty(IDvector)
    % get the values of the source table
    values=getParameter(IDvector,simulationIndex,'parameterType',source);
    
    % set the values to the target table
    setParameter(values,'*',simulationIndex,'parameterType',target,'rowIndex',target_rowIndex);
end

% Species Initial Values

% get the iDs and rowIndex of the target table, 
[IDvector,target_rowIndex]=getSpeciesInitialValue('*',simulationIndex,'parameterType',target,'property','ID');

if ~isempty(IDvector)
    % get the values of the source table
    values=getSpeciesInitialValue(IDvector,simulationIndex,'parameterType',source);
    scalefactors=getSpeciesInitialValue(IDvector,simulationIndex,'parameterType',source,'property','ScaleFactor');
    
    % set the values to the target table
    setSpeciesInitialValue(values,nan,simulationIndex,'parameterType',target,'rowIndex',target_rowIndex);
    setSpeciesInitialValue(scalefactors,nan,simulationIndex,'parameterType',target,'rowIndex',target_rowIndex,'property','ScaleFactor');
end

return
