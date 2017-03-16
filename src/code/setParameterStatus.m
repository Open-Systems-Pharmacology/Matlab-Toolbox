function setParameterStatus(parameterStatus,simulationIndex,setOptions)
%SETPARAMETERSTATUS Sets the previously stored values of the given parameter type. 
%
%   SETPARAMETERSTATUS(parameterStatus,simulationIndex)
%       parameterStatus: structure with the previously retrieved values of
%           all parameters and species initial values, 
%           previously retrieved scale factors of all species initial values 
%           and all previously retrieved time patterns
%           and all previously retrieved table parameters, of the stored type of the parameters
%           see getParameterStatus
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%       setOptions (structure) options which stears, which type of parameters are set
%           setOptions.par (boolean) default true: parameters are resetted
%           setOptions.specIn (boolean) default true: species initial values are resetted
%           setOptions.time (boolean) default true: time patterns are resetted
%           setOptions.table (boolean) default true:  table parameters are resetted
%
% Example Call:
% setParameterStatus(parameterStatus,1);
%
% see also GETPARAMETERSTATUS, INITSIMULATION
%
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 23-Sep-2010

%% check Inputs --------------------------------------------------------------
% check inputs
if ~exist('parameterStatus','var')
    error('Input "parameterStatus" is missing')
end

% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end

% set default setOption
if ~exist('setOptions','var')
    setOptions.par=true;
    setOptions.specIn=true;
    setOptions.time=true;
    setOptions.table=true;
end
%% Evaluation

% get parameter type
parameterType=parameterStatus.parameterType;

% Parameter
% set the parameter values 
if setOptions.par && ~isempty(parameterStatus.par_rowIndex)
    warning('OFF');
    setParameter(parameterStatus.par_values,[],simulationIndex,'parameterType',parameterType,'rowIndex',parameterStatus.par_rowIndex);
    warning('ON');
end

% Species Initial Value
% set the values of the species initial values
if setOptions.specIn && ~isempty(parameterStatus.spec_rowIndex)
    setSpeciesInitialValue(parameterStatus.spec_values,[],simulationIndex,...
        'parameterType',parameterType,'rowIndex',parameterStatus.spec_rowIndex);
    setSpeciesInitialValue(parameterStatus.scalefactors,[],simulationIndex,...
        'parameterType',parameterType,'property','ScaleFactor','rowIndex',parameterStatus.spec_rowIndex);
end

% Time
if setOptions.time
    setSimulationTime(parameterStatus.timePattern,simulationIndex);
end

% Table Parameters
if setOptions.table && ~isempty(parameterStatus.tableParameters.ID)
    setTableParameter(parameterStatus.tableParameters.ID, ...
                      parameterStatus.tableParameters.Time, ...
                      parameterStatus.tableParameters.Value, ...
                      parameterStatus.tableParameters.RestartSolver, ...
                      simulationIndex, ...
                      'parameterType',parameterType);
end 

return
