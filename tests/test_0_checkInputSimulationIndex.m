function [ErrorFlag, ErrorMessage,TestDescription] = test_0_checkInputSimulationIndex
%TEST_0_CHECKINPUTSIMULATIONINDEX Test of Function checkInputOptions
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_0_CHECKINPUTSIMULATIONINDEX
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

% preparation  for test initialize model
xml=['models' filesep 'PopSim.xml'];
initSimulation(xml,'none','report','none');
initSimulation(xml,'none','report','none','addFile',true);



% Collect error messages
logfile='checkInputSimulationIndex';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;




% Check simulationIndex non numeric
TestDescription{end+1}='1) non numeric simulationIndex:;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
disp(' expected is an errormessage');

try
    checkInputSimulationIndex('simulationIndex');
catch exception
    disp(exception.message);
    if strcmp(exception.message,'SimulationIndex simulationIndex is not valid. Please add a simulationIndex between 1 and 2')
        ErrorFlag_tmp(end+1) = 0;
        ErrorMessage_tmp{end+1} = {};
    else
        ErrorFlag_tmp(end+1)=1;
        ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];

    end
end

disp(' ');

% Check simulationIndex not existin
TestDescription{end+1}='2) simulationIndex not existing (=0);';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
disp('expected is an errormessage');

try
    checkInputSimulationIndex(0);
catch exception
    disp(exception.message);
    if strcmp(exception.message,'Please add a simulationIndex, if more than one simulation is initialized')
            ErrorFlag_tmp(end+1) = 0;
        ErrorMessage_tmp{end+1} = {};
    else
        ErrorFlag_tmp(end+1)=1;
        ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];

    end
end

disp(' ');
% check simulationIndex to larg
TestDescription{end+1}='3)  simulationIndex to large (=5, 2 allowed);';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
disp('expected is an errormessage');

try
    checkInputSimulationIndex(5);
catch exception
    disp(exception.message);
    
    if strcmp(exception.message,['SimulationIndex 5 is not valid. Only 2 simulations are initialized.'...
            char(10) 'Please add a simulationIndex between 1 and 2'])
        ErrorFlag_tmp(end+1) = 0;
        ErrorMessage_tmp{end+1} = {};
    else
        ErrorFlag_tmp(end+1)=1;
        ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];
    end

end

diary off;

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return

