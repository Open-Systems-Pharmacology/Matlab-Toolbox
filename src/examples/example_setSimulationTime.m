function example_setSimulationTime
%EXAMPLE_SETSIMULATIONTIME examples for the use of the timepattern functions 
%
%   in this example different timepattern for Urine and plasma concentration is set.
%   see also SETSIMULATIONTIME
%
% Example 1
% Initialize a simulation an set a specific time pattern for one species
% Example 2
% Initialize a simulation an set different specific time pattern for two species
% get the result using wildcards
%
% 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 27-Dez-2010

%% Example 1
% Initialize a simulation an set a specific time pattern for one species

% Initialization
% name of xml file
appPath=[fileparts(which('example_setSimulationTime.m')) filesep];
xml=[appPath 'models' filesep 'PKSim_Input_04_MultiApp.xml'];

% Create the structure for the variable parameters
initStruct=[];

% Initialize the simulation
initSimulation(xml,initStruct,'report','none');

% Set the genral simulation time for all outputs without spcicfic settings
% to one day with 1 minute intervall
setSimulationTime(0:1:1440,1);

% Run the simulation
success=processSimulation(1);

if success
    % figure initialisation
    ax_handle=getNormFigure(2,1);
    
    %retrive plasma concetration
    [time,drug]=getSimulationResult('ROOT/ORGANISM/VenousBlood/Plasma/DRUG',1);
    % plot timecourse
    set(gcf, 'CurrentAxes', ax_handle(1));
    plot(time/60,drug,'kx-');
    setAxesScaling(gca,'timeUnit','h');
    ylabel('Plasma concnetration')
    
    %retrive urine
    [time,drug]=getSimulationResult('ROOT/ORGANISM/Kidney/Urine/DRUG',1);
    % plot timecourse
    set(gcf, 'CurrentAxes', ax_handle(2));
    plot(time/60,drug,'kx-');
    setAxesScaling(gca,'timeUnit','h');
    ylabel('Plasma Urine')
    
    shg;
else
    error('solver failed')
end


%% Example 2
%  Initialize a simulation an set different specific time pattern for two species
% get the result using wildcards

% Initialization
% name of xml file
appPath=[fileparts(which('example_setSimulationTime.m')) filesep];
xml=[appPath 'models' filesep 'PKSim_Input_04_MultiApp.xml'];

% Create the structure for the variable parameters
initStruct=[];

% Initialize the simulation
initSimulation(xml,initStruct,'report','none');

% Run the simulation
success=processSimulation(1);

if success
    % figure initialisation
    ax_handle=getNormFigure;
    
    %retrive concentration array
    [time,drug]=getSimulationResult('ROOT/ORGANISM/*/Plasma/DRUG',1);
    % plot timecourse
    set(gcf, 'CurrentAxes', ax_handle(1));
    plot(time/60,drug,'x');
    setAxesScaling(gca,'timeUnit','h');
        
    shg;
else
    error('solver failed')
end

return