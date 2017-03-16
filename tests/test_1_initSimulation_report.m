function [ErrorFlag, ErrorMessage,TestDescription] = test_1_initSimulation_report
%TEST_1_INITSIMULATION_ADDFILE Test call of initSimulation (check option addFile)
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_1_INITSIMULATION_REPORT
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 21-Sep-2010


ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


xml=['models' filesep 'PopSim.xml'];

logfile='initSimulation_report';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;

ErrorFlag_tmp(end+1)=1;
ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];

% test report=none
TestDescription{end+1}='1) test report=none;';
disp('1) test report=none;')
initSimulation(xml,'all','report','none');

% test report=short
TestDescription{end+1}='2) test report=short;';
disp('2) test report=short;')
initSimulation(xml,'all','report','short');

% test report=long
TestDescription{end+1}='2) test report=long;';
disp('3) test report=long;')
initSimulation(xml,'all','report','long');


diary off;

%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);


return