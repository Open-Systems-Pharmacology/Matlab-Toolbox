function [ErrorFlag, ErrorMessage,TestDescription] = test_4_getSimulationTime
%TEST_4_GETSIMULATIONTIME Test of Function checkInputOptions
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_4_GETSIMULATIONTIME
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


%% get
% 1.1) get general TimePattern
TestDescription{end+1}='1.1) get general TimePattern ID;';

[time,unit,pattern] = getSimulationTime(1);

success= all(time==[0:10]) && all(size(pattern)==[3 5]); %#ok<NBRAK>

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% % 1.2) get specific TimePattern
% TestDescription{end+1}='1.1) get general TimePattern *;';
% 
% [time,unit,pattern] = getSpecificSimulationTime('*');
% 
% success= false; % ToDo not implemented yet in DCI Interface
% 
% if ~success
%     ErrorFlag_tmp(end+1)=2;
%     ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
% end



%%set
% 2.1) set general TimePattern Equidistant
TestDescription{end+1}='2.1) set general TimePattern Equidistant;';

setSimulationTime(0:100,1);
[time,unit,pattern] = getSimulationTime(1);

% check if its transfereed to input table
success= all(time==[0:100]) && all(size(pattern)==[2 5]); %#ok<NBRAK>

if success
    % check if its transfereed to kernel
    processSimulation(1);
    [time]=getSimulationResult('*',1);
end

success= success && all(time==[0:100]); %#ok<NBRAK>

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 2.2) set general Time randomvector
TestDescription{end+1}='2.2) set random Timevector;';

randomVector=rand(10,1)*100;
setSimulationTime(randomVector,1);
[time,unit,pattern] = getSimulationTime(1);

success= all(time==unique(randomVector)') && all(size(pattern)==[6 5]);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 2.3) set general Time mixed equidistant vectors
TestDescription{end+1}='2.3) set general Time mixed equidistant vectors;';

timepoints=[0 10 4:2:8 3:3:9];
setSimulationTime(timepoints,1);
[time,unit,pattern] = getSimulationTime(1);

success= all(time==unique(timepoints)) && all(size(pattern)==[4 5]);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


% %todo test if the simulation pattern is transferred by the 
% % 3.1) set specific Simulation Time
% TestDescription{end+1}='3.1) set specific Simulation Time;';
% 
% timepoints=[0 10 4:2:8 3:3:9];
% setSpecificSimulationTime(timepoints,'TopContainer/y1',1);
% [time,unit,pattern] = getSpecificSimulationTime('TopContainer/y1',1);
% 
% success= all(time==unique(timepoints)) && all(size(pattern)==[4 7]);
% 
% if ~success
%     ErrorFlag_tmp(end+1)=2;
%     ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
% end
% 
% % 3.2) set specific Simulation Time
% TestDescription{end+1}='3.1) set specific Simulation Time; *';
% 
% timepoints=[0 10 4:2:8 3:3:9];
% setspecificSimulationTime(timepoints,'*',1);
% [time,unit,pattern] = getSpecificSimulationTime('TopContainer/y2',1);
% 
% success= all(time==unique(timepoints)) && all(size(pattern)==[4 7]);
% 
% if ~success
%     ErrorFlag_tmp(end+1)=2;
%     ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
% end

%todo test get and set Obeserver

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);
return