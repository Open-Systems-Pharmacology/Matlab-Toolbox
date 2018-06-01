function [ErrorFlag, ErrorMessage,TestDescription] = test_9_saveSimulationToXML
%TEST_9_SAVESIMULATIONTOXML Test call of saveSimulationToXML
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_9_SAVESIMULATIONTOXML
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org


ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


xml=['models' filesep 'SimModel4_ExampleInput06.xml'];


% save simulation without parameter initialisation
initSimulation(xml,'none','report','none');

TestDescription{end+1}='1) save simulation;';
[~,filename] = fileparts(xml);
newxml=['log/models_' datestr(now,'yyyy_mm_dd') filesep 'without' filesep filename '.xml'];

saveSimulationToXML(newxml,1);

success= exist(newxml,'file');

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end



% save simulation with parameter initialisation
initSimulation(xml,'all','report','none');

TestDescription{end+1}='1) save simulation;';
[~,filename] = fileparts(xml);
newxml=['log/models_' datestr(now,'yyyy_mm_dd') filesep 'with' filesep filename '.xml'];

saveSimulationToXML(newxml,1);

success= exist(newxml,'file');

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return