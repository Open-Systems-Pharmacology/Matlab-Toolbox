function [ErrorFlag, ErrorMessage,TestDescription] = test_1_initSimulation_xml
%TEST_1_INITSIMULATION_XML Test call of initSimulation (check input variable XML)
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_1_INITSIMULATION_XML
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
  
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

thispath=cd;

TestDescription{end+1}='1) absolute path;';
xml_absolute=[thispath filesep 'models' filesep 'PopSim.xml'];
[ErrorFlag_tmp(end+1), ErrorMessage_tmp{end+1}]=call_initSimulation(xml_absolute);

TestDescription{end+1}='2) absolute path;';
xml_rel=['models' filesep 'PopSim.xml'];
[ErrorFlag_tmp(end+1), ErrorMessage_tmp{end+1}]=call_initSimulation(xml_rel);


[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return

function [ErrorFlag, ErrorMessage]=call_initSimulation(xml)

try
   initSimulation(xml,'none','report','none');
   ErrorFlag=0;
   ErrorMessage='';
catch %#ok<CTCH>
   ErrorFlag=2;
   ErrorMessage=sprintf('initsimulation fails for %s',xml);
end    
