function [ErrorFlag, ErrorMessage,TestDescription] = test_6_getSimulationResult
%TEST_6_GETSIMULATIONRESULT Test of Function checkInputOptions
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_6_GETSIMULATIONRESULT
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 24-Sep-2010

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

xml1=['models' filesep 'SimModel4_ExampleInput06.xml'];
initSimulation(xml1,'all','report','none');

processSimulation(1);

% 1) get Simulation result by ID
TestDescription{end+1}='1) get Simulation result by ID;';

[sim_time,sim_values,indx]=getSimulationResult(1,1);

success= all(sim_time==[0:10]) && all(sim_values==2*ones(1,11)) && indx==1; %#ok<*NBRAK>

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 2) get Simulation result by path
TestDescription{end+1}='2) get Simulation result by path;';

[sim_time,sim_values,indx]=getSimulationResult('TopContainer/y1',1);

success= all(sim_time==[0:10]) && all(sim_values==2*ones(1,11)) && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


% 3) get Simulation result for all
TestDescription{end+1}='3) get Simulation result for all;';

[sim_time,~,indx]=getSimulationResult('*',1);

success= all(sim_time==[0:10])  && all(indx==1:3);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 3) get Simulation result for more than one ID
TestDescription{end+1}='3) get Simulation result for all;';

[sim_time,~,indx]=getSimulationResult([1:3],1);

success= all(sim_time==[0:10]) && all(indx==1:3);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 4) get Simulation result for by indx
TestDescription{end+1}='4) get Simulation result for all;';

[~,~,indx]=getSimulationResult('*',1,'rowIndex',indx);
[sim_time,~,indx]=getSimulationResult(1,1,'rowIndex',indx);

success= all(sim_time==[0:10]) && all(indx==1:3);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Errors

logfile='getSimulationResult';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;

ErrorFlag_tmp(end+1)=1;
ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];

%5) not existing simulation result
TestDescription{end+1}='5) try to get not existing simulation result;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
try
    getSimulationResult(895,1);
catch exception
    disp(exception.message);
end
disp(' ');

%6) get result before processing
TestDescription{end+1}='6) try to get result before processing;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>

initSimulation(xml1,'all','report','none');

try
    getSimulationResult(1,1);
catch exception
    disp(exception.message);
end
disp(' ');

diary off

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return