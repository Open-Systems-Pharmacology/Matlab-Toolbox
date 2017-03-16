function updateSimulationInputs(simulationIndex)
% UPDATESIMULATIONINPUTS Sets the current parametervalues to the DCI Interface.

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: March-2016

    global MOBI_SETTINGS;
    global DCI_INFO;

    for iTab=[2 4 6 9] 
        feval(MOBI_SETTINGS.MatlabInterface,'SetInputTable', DCI_INFO{simulationIndex}.Handle,iTab,DCI_INFO{simulationIndex}.InputTab(iTab));
    end