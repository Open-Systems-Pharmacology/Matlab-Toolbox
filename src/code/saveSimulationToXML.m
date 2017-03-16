function saveSimulationToXML(filename,simulationIndex)
%SAVESIMULATIONTOXML saves the simulation file as XML.
%
%   SAVESIMULATIONTOXML(filename,simulationIndex)
%       filename: total or relative file of the xml file
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile');
%           
%
% Example Calls:
% success=saveSimulationToXML('models\SimModel4_ExampleInput06.xml',1);
% success=saveSimulationToXML('C:\models\SimModel4_ExampleInput06.xml',1);
%
% see also INITSIMULATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 10-Jan-2011

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

%% Evaluation

% get the correct separators
filename=strrep(filename,'/',filesep);
filename=strrep(filename,'\',filesep);

% create directory if necessary
filepath = fileparts(filename);
if ~exist(filepath,'dir') && ~isempty(filepath)
    mkdir(filepath);
end

%write all values from Matlab back into DCI component
updateSimulationInputs(simulationIndex);

Handle = DCI_INFO{simulationIndex}.Handle;
simulationXMLString = feval(MOBI_SETTINGS.MatlabInterface,'Invoke', Handle, 'GetSimulationString', '');

RetVal='';
notSupportedError = 'Unknown function invoked';

if strncmpi(simulationXMLString,notSupportedError,length(notSupportedError))
    RetVal = feval(MOBI_SETTINGS.MatlabInterface,'Invoke', Handle, 'SaveSimulationToXml', filename);
else
    [fid, errmsg] = fopen(filename,'w','native','UTF-8');
    
    if fid ~= -1
        try
            fprintf(fid, '%s', simulationXMLString);
            fclose(fid);
            fid = -1;
        catch
            if fid ~= -1
                fclose(fid);
            end
        end
    else
        RetVal = errmsg;
    end
end

if ~strcmp(RetVal, '')
    error(RetVal);
end

return
