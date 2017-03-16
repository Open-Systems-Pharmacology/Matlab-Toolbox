function success=processSimulation(simulationIndex)
%PROCESSSIMULATION Processes the simulation.
%
%   success=PROCESSSIMULATION(simulationIndex)
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile');
%           the input of a vector of simulation indices is possible
%           '*' means all simulations are processed
%       success (boolean) is
%           false, if the solver produces an error.
%           false, if the solver produces a warning for one of the specified
%               simulations and initSimulation was called with the option
%               'stopOnWarnings'=true (default).
%           false, if the execution time limit is reached. The execution time limit is
%               set with the option 'ExcecutionTimeLimit' initSimulation.
%           true, otherwise
%
% Example Calls:
% success=processSimulation(1);
% success=processSimulation([1:3]);
% success=processSimulation('*');
%
% see also INITSIMULATION
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 24-Sep-2010

global DCI_INFO;
global MOBI_SETTINGS;

%% check Inputs --------------------------------------------------------------
% check mandatory inputs
% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
elseif strcmp(simulationIndex,'*')
    simulationIndex=1:length(DCI_INFO);
else
    for simulationIndex_i=simulationIndex
        checkInputSimulationIndex(simulationIndex_i);
    end
end

%% Evaluation

success=true;

for simulationIndex_i=simulationIndex
    if success
		% set Input Tables
        updateSimulationInputs(simulationIndex);
        try
            r = feval(MOBI_SETTINGS.MatlabInterface,'ProcessData', DCI_INFO{simulationIndex_i}.Handle);
            if r == 0
                success = false;
				errmsg = feval(MOBI_SETTINGS.MatlabInterface, 'GetLastError');
                warning('ProcessData was not successful! %s', errmsg);
            end
			
			%save solver warnings
            if ~isdeployed
    			DCI_INFO{simulationIndex_i}.SolverWarnings = getSolverWarnings(simulationIndex_i);
            end
			
        catch exception
            success=false;
            warning(exception.message)
        end
        
        if success
            try
                % get updatet Input
                for iTab=1:length(DCI_INFO{simulationIndex_i}.InputTab)
                    DCI_INFO{simulationIndex_i}.InputTab(iTab)= ...
                        feval(MOBI_SETTINGS.MatlabInterface,'GetInputTable',DCI_INFO{simulationIndex_i}.Handle,iTab);
                end
                
                % Buf fix IMLOO 2012-05-15:
                % Wenn  DCI_INFO{simulationIndex_i}.OutputTab = [] also
                % empty ist, muss man das Feld entfernen,
                % sonst gibt es einen Fehler bei %get Output
                if isfield(DCI_INFO{simulationIndex_i},'OutputTab')
                    if isempty(DCI_INFO{simulationIndex_i}.OutputTab)
                        DCI_INFO{simulationIndex_i} = rmfield(DCI_INFO{simulationIndex_i},'OutputTab');
                    end
                end
                
                % get Output
                DCI_INFO{simulationIndex_i}.OutputTab(1) = feval(MOBI_SETTINGS.MatlabInterface,...
                    'GetOutputTable',DCI_INFO{simulationIndex_i}.Handle,1);
                DCI_INFO{simulationIndex_i}.OutputTab(2) = feval(MOBI_SETTINGS.MatlabInterface,...
                    'GetOutputTable',DCI_INFO{simulationIndex_i}.Handle,2);
                
                % add rowindex ID Array for fast processing
               if ~isfield(DCI_INFO{simulationIndex_i},'OutputTabID')
                   for iCol=1:length(DCI_INFO{simulationIndex}.OutputTab(2).Variables)
                       DCI_INFO{simulationIndex_i}.OutputTabID(iCol)=...
                           str2double(DCI_INFO{simulationIndex}.OutputTab(2).Variables(iCol).Attributes(1).Value);
                   end
               end
                   
            catch exception
                success=false;
                warning('Problem while getting In-/OutputTables!');
                warning(exception.message)
            end
        end
    end
    
    if ~success
        DCI_INFO{simulationIndex_i}.OutputTab = [];
    end
end


return
