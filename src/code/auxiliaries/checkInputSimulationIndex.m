function checkInputSimulationIndex(simulationIndex)
%CHECKINPUTSIMULATIONINDEX Support function: Checks if the simulation index is valid
%       throws error if it is invalid
%
%   simulationIndex=CHECKINPUTSIMULATIONINDEX(simulationIndex)
%       simulationIndex index of the simulation (see also INITSIMULATION option 'addFile')  

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 20-Sep-2010

global DCI_INFO;

if ~isnumeric(simulationIndex) 
        error('MoBiToolbox:Basis:SimulationIndex',...
            'SimulationIndex %s is not valid. Please add a simulationIndex between 1 and %d',...
            simulationIndex,length(DCI_INFO));
elseif simulationIndex==0
    if length(DCI_INFO)>1
        error('MoBiToolbox:Basis:SimulationIndex',...
            'Please add a simulationIndex, if more than one simulation is initialized');
    end
elseif isempty(DCI_INFO)
        error('MoBiToolbox:Basis:SimulationIndex',...
            'SimulationIndex %d is not valid. There is none simulation initialized.',...
            simulationIndex);
elseif length(DCI_INFO)<simulationIndex    
        error('MoBiToolbox:Basis:SimulationIndex',...
            ['SimulationIndex %d is not valid. Only %d simulations are initialized.'...
            char(10) 'Please add a simulationIndex between 1 and %d'],...
            simulationIndex,length(DCI_INFO),length(DCI_INFO));
end

return

