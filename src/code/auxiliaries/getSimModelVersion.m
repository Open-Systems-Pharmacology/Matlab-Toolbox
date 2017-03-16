function [simModelVersion, simModelCompVersion] = getSimModelVersion(simulationIndex)
%GETSIMMODELVERSION returns the version of SimModel and SimModelComp
%
%   [SimModelVersion, SimModelCompVersion] = GETSIMMODELVERSION
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile');
%           the input of a vector of simulation indices is not possible
%       simModelVersion (string) version of the sim
%       simModelCompVersion (string) version of the simmodel component.
%           
%
% Example Calls:
%
%   initSimulation(<xxx.xml>,'none');
% 	[simModelVersion, simModelCompVersion] = getSimModelVersion(1);
%

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 01-Feb-2012
	
global MOBI_SETTINGS;
global DCI_INFO;

%% check Inputs --------------------------------------------------------------
% check mandatory inputs
% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end



simModelVersion = feval(MOBI_SETTINGS.MatlabInterface,'Invoke', DCI_INFO{simulationIndex}.Handle, 'GetSimModelVersion', '');

simModelCompVersion = feval(MOBI_SETTINGS.MatlabInterface,'Invoke', DCI_INFO{simulationIndex}.Handle, 'GetSimModelCompVersion', '');


return