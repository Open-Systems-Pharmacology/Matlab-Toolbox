function initStruct=initSpeciesInitialValue(initStruct, path_id, initializeIfFormula,varargin)
%INITSPECIESINITIALVALUE Generates or updates a structure of variable species initial values as input for the function initSimulation.
% which defines which species initial values shall be available for manipulation
%
%   initStruct=INITSPECIESINITIALVALUE(initStruct, path_id)
%       initStruct (struct): structure of variable species initial values, may be empty
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       initStruct(struct): structure of variable parameters and species
%           initial values.
%
%   initStruct=INITSPECIESINITIALVALUE(initStruct, path_id,initializeIfFormula)
%       initializeIfFormula (string): 
%           'always': The  species initial values are initialized without warning, even if they are consist of a formula.
%           'withWarning' (default): If a species initial value is a formula, it is initialized but with a warning.
%           'never': If a species initial value is a formula, it is not initialized, and an error is produced.
%
%   Options:
%
%   initStruct=INITSPECIESINITIALVALUE(initStruct, path_id,initializeIfFormula,...
%           'throwWarningIfNotExisting',value_throwWarningIfNotExisting)
%       value_throwWarningIfNotExisting (boolean): 
%           true: (default) If a species initial value should be  initialized, which does not
%                   exist in the simulation, a warning is thrown.
%           false:  If a species initial value should be  initialized, which does not
%                   exist in the simulation, no warning is thrown, the parameter will be skipped quietly.
%
%   see also INITSIMULATION, INITPARAMETER

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
% check optional inputs
if ~exist('initializeIfFormula','var')
    initializeIfFormula='withWarning';
end
jj=strcmpi(initializeIfFormula,{'always','withWarning','never'});
if isempty(jj)
    error('wrong input for initializeIfFormula %s; please use always withWarning or never',initializeIfFormula);
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

initStruct.InitialValues(end+1).path_id=path_id;
initStruct.InitialValues(end).initializeIfFormula=initializeIfFormula;
initStruct.InitialValues(end).throwWarningIfNotExisting=throwWarningIfNotExisting;
return
