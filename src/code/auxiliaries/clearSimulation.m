function clearSimulation(simulationIndex)
%CLEARSIMULATION Support function: Deletes the Initialization of an XML file.
%
%   clearSimulation(simulationIndex)
%           simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile');
%           the input of a vector of simulation indices is possible
%           '*' means all simulations are processed% 
%
% Example Calls:
% clearSimulation(1);
% clearSimulation([1:3]);
% clearSimulation('*');
%
% see also INITSIMULATION
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 24-Sep-2010

global DCI_INFO;
global MOBI_SETTINGS;

% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
elseif strcmp(simulationIndex,'*')
    simulationIndex=1:length(DCI_INFO);
else
    simcleared=[];
    for simulationIndex_i=simulationIndex
        if length(DCI_INFO)>=simulationIndex_i            
            checkInputSimulationIndex(simulationIndex_i);
        else
            simcleared(end+1)=simulationIndex_i;
        end
    end
    simulationIndex=setdiff(simulationIndex,simcleared);
end

if isempty(simulationIndex)
    return;
end

if length(simulationIndex)==length(DCI_INFO) && ...
        all(simulationIndex==[1:length(DCI_INFO)]) %#ok<NBRAK>
    % clear memory
    feval(MOBI_SETTINGS.MatlabInterface,'DestroyAllComponents');
    DCI_INFO=[];
else
    DCI_INFO=DCI_INFO(setdiff([1:length(DCI_INFO)],simulationIndex));
end

return