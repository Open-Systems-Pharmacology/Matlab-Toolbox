function [helpFile]=getHelpFile(toolbox,filename,tab)
%GETHELPFILE GUI support function: returns the path of the helpfile corresponding to the calling GUI
% 
% [helpFile,helpRBG]=GETHELPFILE(toolbox,filename)
%   - toolbox (string)  : name of the corresponding toolbox
%   - filename (string)  : filename (fullpath) of the calling GUI
%   - name of tab in a complicated GUI
%   - helpFile (string) : path of the helpfile corresponding to the calling gui
%   - helpRBG (array) : Image for button
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 21-Dez-2010


% get filename
[~, name] = fileparts(filename);
helpFile='';

switch toolbox
    % basis Toolbox
    case 'Base'

        appPath=[fileparts(which('MoBiSettings.m')) filesep];
        addpath([appPath '../Manual']);
        
        switch name
            case 'generateMatlabCodeForXML'
                helpFile=strcat('ch01.html');
            case 'UnitConverter'
                helpFile=strcat('index.html');
        end
    % Toolbox: population simulation
    case 'PopulationSimulation'
        appPath=[fileparts(which('startPopulationSimulation.m')) filesep];
        addpath([appPath '../Manual']);
        switch name
            % Main and Start GUI of population simulation
            case 'mainPopulationSimulation'
                helpFile=strcat('ch01s02.html');
            % definition of applications
            case 'defineSimulation'
                helpFile=strcat('ch01s03.html');
            % definition of populations
            case 'definePopulation'
                switch tab
                    % define additional parameters + covariances
                    case {'varpar','covVarPar'}
                        helpFile=strcat('ch01s04.html');
                        % define population sets
                    case 'popset'
                        helpFile=strcat('ch01s04.html');
                        % define population sets
                    case 'sim'
                        helpFile=strcat('ch01s04.html');
                end
            % definition of output
            case 'defineOutput'
                helpFile=strcat('ch01s05.html');
            case 'defineFigures'
                switch tab
                    % define population tables
                    case 'report'
                        helpFile=strcat('ch01s06.html');
                        % define additional parameters + covariances
                    case 'Pop'
                        helpFile=strcat('ch01s06.html');
                        % define population sets
                    case 'figures'
                        helpFile=strcat('ch01s06.html');
                    case 'userDefined'
                        helpFile=strcat('ch01s06.html');
                end
            case 'defineSensitivity'
                switch tab
                    % define population tables
                    case 'report'
                        helpFile=strcat('ch01s07.html');
                        % define additional parameters + covariances
                    case 'settings'
                        helpFile=strcat('ch01s07.html');
                end
            % definition of output
            case 'checkReprocessing'
                helpFile=strcat('xxx.html');
        end        
    % Toolbox: population simulation
    case 'ParameterIndentification'
        
         appPath=[fileparts(which('mainParameteridentification.m')) filesep];
        addpath([appPath '../Manual']);
        
        switch name
            case 'mainParameteridentification'
                switch tab
                    % select projects and start actions
                    case 'start'
                        helpFile=strcat('index.html');
                        % define models
                    case 'parameter'
                        helpFile=strcat('index.html');
                        % define data
                    case 'data'
                        helpFile=strcat('index.html');
                    case 'output'
                        helpFile=strcat('index.html');
                    case 'algorithm'
                        helpFile=strcat('index.html');
                    case 'individual'
                        helpFile=strcat('index.html');
                        % define figures
                    case 'figures'
                        helpFile=strcat('index.html');
                        % define extras
                    case 'extras'
                        helpFile=strcat('index.html');
                end
        end
    otherwise
end
    
return
