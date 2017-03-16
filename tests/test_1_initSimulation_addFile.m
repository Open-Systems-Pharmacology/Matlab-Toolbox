function [ErrorFlag, ErrorMessage,TestDescription] = test_1_initSimulation_addFile
%TEST_1_INITSIMULATION_ADDFILE Test call of initSimulation (check option addFile)
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_1_INITSIMULATION_ADDFILE
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 21-Sep-2010

global DCI_INFO;

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


xml=['models' filesep 'PopSim.xml'];

initSimulation(xml,'all','report','none');

% test addFile=true;
TestDescription{end+1}='1) test addFile=true;';
initSimulation(xml,'all','report','none','addFile',true);

if length(DCI_INFO)~=2
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% test addFile=false;
TestDescription{end+1}='2) test addFile=false;';
initSimulation(xml,'all','report','none','addFile',false);

if length(DCI_INFO)~=1
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return