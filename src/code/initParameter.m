function initStruct=initParameter(initStruct, path_id, initializeIfFormula,varargin) 
%INITPARAMETER Generates or updates a structure of variable parameters as input for the function initSimulation.
% which defines which parameters shall be available for manipulation
%
%   initStruct=INITPARAMETER(initStruct, path_id)
%       initStruct (struct): structure of variable parameters and species
%           initial values, may be empty
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       initStruct(struct): structure of variable parameters and species
%           initial values
%
%   initStruct=INITPARAMETER(initStruct, path_id,initializeIfFormula)
%       initializeIfFormula (string): 
%           'always': The parameter is initialized without warning, even though it is a formula.
%           'withWarning' (default): If the parameter is a formula, it is initialized but with a warning.
%           'never': If the parameter is a formula, it is not initialized, an error is produced.
%
%   Options:
%
%   initStruct=INITPARAMETER(initStruct, path_id,initializeIfFormula,...
%           'throwWarningIfNotExisting',value_throwWarningIfNotExisting)
%       value_throwWarningIfNotExisting (boolean): 
%           true: (default) If a parameter should be  initialize, which does not
%                   exist in the simulation, a warning is thrown.
%           false:  If a parameter should be  initialized, which does not
%           exist in the simulation, no warning is thrown, the parameter will be skipped quietly.
%
%   see also INITSIMULATION, INITSPECIESINITIALVALUE
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 18-Sep-2010
% Update: 20-Jun_2012 Option throwWarningIfNotExisting

%% check Inputs --------------------------------------------------------------
% check mandatory inputs
if ~exist('initStruct','var')
    error('input "initStruct" is missing');
else
    if ~isempty(initStruct) && ~isstruct(initStruct)
        error('initStruct has the wrong format');
    end
end
if ~exist('path_id','var')
    error('input "path_id" is missing');
end
if iscell(path_id)
    error('input "path_id" is a cellarray, should be a string or a number');
end
% check optional inputs
if ~exist('initializeIfFormula','var')
    initializeIfFormula='withWarning';
end
jj=strcmpi(initializeIfFormula,{'always','withWarning','never'});
if ~any(jj)
    error('wrong input for initializeIfFormula="%s"; please use "always","withWarning" or "never"',initializeIfFormula);
end

% Check input options
[throwWarningIfNotExisting] = ...
    checkInputOptions(varargin,{...
    'throwWarningIfNotExisting',[true false],true...
    });

%% set structure
if isempty(initStruct)
    tmp=struct('path_id',[],'initializeIfFormula',[]);
    initStruct.Parameters=tmp([]);    
    initStruct.InitialValues=tmp([]);
end

initStruct.Parameters(end+1).path_id=path_id;
initStruct.Parameters(end).initializeIfFormula=initializeIfFormula;
initStruct.Parameters(end).throwWarningIfNotExisting=throwWarningIfNotExisting;

return
