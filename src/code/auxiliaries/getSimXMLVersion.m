function XMLVersion=getSimXMLVersion(simulationIndex)
%GETXMLVERSION Returns the version of the simulation xmlfile
%
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%
% see also INITSIMULATION


% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 20-Sep-2010

global DCI_INFO;

% simulation Index
if isempty(DCI_INFO) 
    XMLVersion=3;
    return;
elseif ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end
if ~isdeployed && ~isfield(DCI_INFO{simulationIndex},'XMLVersion')
    msg=['XML Version is unknown,',...
        'if you are within the Parameter Toolbox or the Population toolbox, ',...
        'please delete all files in the subdirectory SimulationFiles with the suffix tmpDCI',...
        'than call "clear all" and try again'];
    error(msg);
end
XMLVersion=DCI_INFO{simulationIndex}.XMLVersion;


return
