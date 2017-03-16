function parameterStatus=getParameterStatus(simulationIndex,varargin)
%GETPARAMETERSTATUS Saves values of the given parameter type in the variable parameterStatus. 
%This variable can be used later in the code to restore the saved status with the function setParameterStatus.
%
%   parameterStatus=GETPARAMETERSTATUS(simulationIndex)
%       simulationIndex (integer)
%           index of the simulation (see INITSIMULATION option 'addFile')
%
%       parameterStatus: structure with the values of
%           all parameters and species initial values, scale factors of all species initials values 
%           and all time patterns and all table parameters. The type of the parameter is also stored.
%           see SETPARAMETERSTATUS
%
%   Options:
%   
%   parameterStatus=GETPARAMETERSTATUS(simulationIndex,'parameterType',value_parameterType)
%       value_parameterType (string) specify the type of parameter
%           'variable': (default) stores the values of all variable parameters 
%           'reference': stores the values of all reference parameters 
%           To get more information about parameter types: call MoBi
%
% Example Calls:
% parameterStatus=getParameterStatus(1);
% parameterStatus=getParameterStatus(1,'parameterType','reference');
%
% see also INITSIMULATION, SETPARAMETERSTATUS

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 15-Nov-2012

%% check Inputs --------------------------------------------------------------
% check inputs

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
    'parameterType',{'variable','reference'},'variable',...
    });

%% Evaluation
% store parameter type
parameterStatus.parameterType=parameterType;

% Parameter
% get the values of the source table
warning('OFF');
[parameterStatus.par_values,parameterStatus.par_rowIndex] = ...
    getParameter('*',simulationIndex,'parameterType',parameterType);
warning('ON');

% Species Initial Value
% get the values of the species initial values
[parameterStatus.spec_values,parameterStatus.spec_rowIndex] = ...
getSpeciesInitialValue('*',simulationIndex,'parameterType',parameterType);
parameterStatus.scalefactors = ...
    getSpeciesInitialValue('*',simulationIndex,...
    'parameterType',parameterType,'property','ScaleFactor');

% time pattern 
[time,~,pattern]=getSimulationTime(simulationIndex);
parameterStatus.simulationTime=time;
parameterStatus.timePattern=pattern;

% Table Parameters
[parameterStatus.tableParameters.ID,...
parameterStatus.tableParameters.Time,...
parameterStatus.tableParameters.Value,....
parameterStatus.tableParameters.RestartSolver] = ...
	getTableParameter('*', simulationIndex,'parameterType',parameterType);

return
