function [ErrorFlag, ErrorMessage,TestDescription] = test_1_initSimulation_report
%TEST_1_INITSIMULATION_ADDFILE Test call of initSimulation (check option addFile)
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_1_INITSIMULATION_REPORT
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org


ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


xml=['models' filesep 'PopSim.xml'];

logfile =  fullfile('log',['initSimulation_report_' datestr(now,'yyyy_mm_dd_hhMM') '.log']);
diary( logfile);
diary on;

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


fid = fopen(logfile);
tmp=textscan(fid,'%s','delimiter','\n');
C=tmp{1};
fclose(fid);

% check logfile
if length(C) ~= 7321
    ErrorFlag_tmp=2;
    ErrorMessage_tmp{1}='length of logfile not correct';
end
if ~strcmp(C{1},'1) test report=none;')
    ErrorFlag_tmp(end+1) = 2;
    ErrorMessage_tmp{end+1}='first of logfile not correct';
end
if ~strcmp(C{2},'2) test report=short;')
    ErrorFlag_tmp(end+1) = 2;
    ErrorMessage_tmp{end+1}='short logfile should strat in line 2';
end
if ~strcmp(C{6},'3) test report=long;')
    ErrorFlag_tmp(end+1) = 2;
    ErrorMessage_tmp{end+1}='long logfile should strat in line 6';
end

%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);


return
