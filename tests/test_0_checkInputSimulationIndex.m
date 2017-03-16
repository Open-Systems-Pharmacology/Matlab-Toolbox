function [ErrorFlag, ErrorMessage,TestDescription] = test_0_checkInputSimulationIndex
%TEST_0_CHECKINPUTSIMULATIONINDEX Test of Function checkInputOptions
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_0_CHECKINPUTSIMULATIONINDEX
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 20-Sep-2010


ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


xml=['models' filesep 'PopSim.xml'];
initSimulation(xml,'none','report','none');
initSimulation(xml,'none','report','none','addFile',true);



% Collect error messages
logfile='checkInputSimulationIndex';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;



ErrorFlag_tmp(end+1)=1;
ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];

% Check simulationIndex non numeric
TestDescription{end+1}='1) non numeric simulationIndex:;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
disp(' expected is an errormessage');

try
    checkInputSimulationIndex('simulationIndex');
catch exception
    disp(exception.message);
end

disp(' ');

TestDescription{end+1}='2) simulationIndex not existing (=0);';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
disp('expected is an errormessage');

try
    checkInputSimulationIndex(0);
catch exception
    disp(exception.message);
end

disp(' ');

TestDescription{end+1}='3)  simulationIndex to large (=5, 2 allowed);';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
disp('expected is an errormessage');

try
    checkInputSimulationIndex(5);
catch exception
    disp(exception.message);
end

diary off;

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return

