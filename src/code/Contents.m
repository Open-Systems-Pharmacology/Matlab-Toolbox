% #######################################################################
% MoBi® Basis Toolbox for Matlab®
% #######################################################################
%
% The MoBi® Basis Toolbox for Matlab® is a collection of Matlab® functions, which
% allow the processing of models developed in MoBi® from within Matlab®.
% For example, the Matlab® environment can be used to change parameters in
% a model developed in MoBi®, simulate the model, and analyze the results.
% This allows an efficient operation in the model analysis stage, using the
% programming options as well as the function library available within
% Matlab® in combination with the powerful modeling interface and solver
% kernel included in MoBi®. In addition, the Toolbox offers efficient analysis
% methods tailored towards the needs of systems biology and PBPK modeling
% including parameter identification and optimization.
%
% ----------------------------------------------------------------
%  Help for MoBi Toolbox:
%   MoBi                           - For help on the MoBi Basis Toolbox for Matlab just type: MoBi.
%
% ----------------------------------------------------------------
%  Script Generation:
%   generateMatlabCodeForXML       - A GUI suited for non-experts to start generating executable Matlab scripts.
%
% ----------------------------------------------------------------
% Initialization of a MoBi Simulation:
%   MoBiSettings                   - Sets the version of the MoBi®-Matlab port and necessary paths.
%   initSimulation                 - Initializes an XML file.
%   initParameter                  - Generates or updates a structure of variable parameters as input for the function initSimulation.
%   initSpeciesInitialValue        - Generates or updates a structure of variable species initial values as input for the function initSimulation.
%
% ----------------------------------------------------------------
% Manipulate Parameters:
%   In the following, different functions are listed, which allow checking
%   the existence of a parameter as well as getting and changing its
%   value. Most functions come in two versions to distinguish the
%   different types of parameters, i.e., ‘parameter’ and ‘species initial value’. 
%   There are three kinds of parameters:
%   o	Readonly: All parameters exist as read-only parameter, the values can be read but cannot be varied.
%   o	Variable: Parameters, which are set to variables during the initialization. 
%       The values can be read and varied.
%   o	Reference: For every variable parameter a reference parameter exists. 
%       Variable parameters can be set relative to this reference
%       parameter. The values of reference parameter can be varied. 
%   existsParameter                - Checks the existence of a parameter and returns its description.
%   existsSpeciesInitialValue      - Checks the existence of a species initial values and returns its description.
%   getParameter                   - Returns the value and other properties of a parameter.
%   getParameterStatus             - Saves values of the given parameter type in the variable parameterStatus. 
%   getSpeciesInitialValue         - Returns the value and other properties of a species initial value.
%   setParameter                   - Sets the value of a specific parameter.
%   setSpeciesInitialValue         - Sets the value or scale factor of a specific species initial value.
%   setRelativeParameter           - Sets the value of a variable parameter relative to reference.
%   setRelativeSpeciesInitialValue - Sets the value or scale factor of a specific species relative to reference.
%   setAllParameters               - Sets all parameter values of one type (source) to the values of another type (target). 
%   setParameterStatus             - Sets the previously stored values of the given parameter type. 
%   getTableParameter              - Returns the table (id, time, value, restartSolver) of a table parameter.
%   setTableParameter              - Sets the value of a specific parameter.
%
% ----------------------------------------------------------------
% Observer
% The formulas of observers are only available as read-only.
%   getObserverFormula             - Returns the formula and other properties of an observer.
%   existsObserver                 - Checks the existence of an observer and returns its description array.
%
% ----------------------------------------------------------------
% Time pattern
%   For a simulation a time pattern is defined. These are the points where
%   the simulated results of species time profiles and observer time
%   profiles are stored and made available for the user.
%   A time pattern can be defined for a specific species or observer or
%   general (valid for all species and observers for which no specific time
%   pattern is defined).    
%
%   getSimulationTime              - Returns the time vector, unit of time and a cell array with the description of the time pattern. 
%   setSimulationTime              - Sets the simulation time.
%
% ----------------------------------------------------------------
% Process Simulation
%   processSimulation              - Processes the simulation.
%
% ----------------------------------------------------------------
% Analysis Result
%   getSimulationResult            - Gets the time profile of the species or observer specified by path_id.
%   getPKParameters                - Gets PK parameters of the time profile of a species or observer specified by path_id.
%   getPKParametersForConcentration - Gets PK parameters of a time profile.
%   
% ----------------------------------------------------------------
% Functions you might find useful:
%
%   compareSimulations             - Compares two simulations for differences.
%   getNormFigure                  - Creates figure with norm format.
%   setAxesScaling                 - Sets scaling and limit of x and y axes. Checks if sufficient ticks exist.
%   saveSimulationToXML            - saves the simulation file as XML.
% ----------------------------------------------------------------
% Functions to use the OSPSuite parameter identification export:
%
%   getPIErrorFunctionalForOSPSuiteExport        - calculates error functional for the problem defined in the structure PI
%   getPIWeightedResidualsForOSPSuiteExport      - calculates residuals for the problem defined in the structure PI
%   initParameterIdentificationForOSPSuiteExport - initialize the exported parameter identification
%   plotPIDefaultOutputForOSPSuiteExport         - generates default plots for the parameter identification called for the SB Suite export
