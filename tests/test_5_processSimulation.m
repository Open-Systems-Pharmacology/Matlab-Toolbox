function [ErrorFlag, ErrorMessage,TestDescription] = test_5_processSimulation
%TEST_5_PROCESSSIMULATION Test of Function checkInputOptions
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_5_PROCESSSIMULATION
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 24-Sep-2010

global DCI_INFO;

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

xml1=['models' filesep 'SimModel4_ExampleInput06.xml'];
initSimulation(xml1,'all','report','none');

xml2=['models' filesep 'SimModel4_ExampleInput05.xml'];
initSimulation(xml2,'all','report','none','addFile',true);

% 1) Processsimulation for simulationindex=1
TestDescription{end+1}='1.1) Processsimulation for simulationindex=1;';
success=processSimulation(1);

success= success && ~isempty(DCI_INFO{1}.OutputTab);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.1) Processsimulation for simulationindex=2
TestDescription{end+1}='1.2) Processsimulation for simulationindex=2;';
success=processSimulation(2);

success= success && ~isempty(DCI_INFO{2}.OutputTab);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

%2) Processsimulation for simulationindex=[1 2]
TestDescription{end+1}='2) Processsimulation for simulationindex=[1 2];';

initSimulation(xml1,'all','report','none');
initSimulation(xml2,'all','report','none','addFile',true);

success=processSimulation([1 2]);

success= success && ~isempty(DCI_INFO{1}.OutputTab) && ~isempty(DCI_INFO{2}.OutputTab);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

%3) Processsimulation for simulationindex='*'
TestDescription{end+1}='3) Processsimulation for simulationindex=*;';

initSimulation(xml1,'all','report','none');
initSimulation(xml2,'all','report','none','addFile',true);

success=processSimulation('*');

success= success && ~isempty(DCI_INFO{1}.OutputTab) && ~isempty(DCI_INFO{2}.OutputTab);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Errors

logfile='processSimulation';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;

ErrorFlag_tmp(end+1)=1;
ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];

%4) ExecutionTimeLimit
TestDescription{end+1}='4) ExecutionTimeLimit;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
xml=['models' filesep 'SimModel4_ExampleInput06.xml'];
initSimulation(xml,'all','report','none','ExecutionTimeLimit',0.00000525);
success=processSimulation;
if success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

disp(' ');


%5) Solver warning
TestDescription{end+1}='5) Solver warning;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>

xml=['models' filesep 'PKModelCoreCaseStudy_01.xml'];
initSimulation(xml,'all','report','none','stopOnWarnings',true);
setParameter(0,1,1);
success=processSimulation;
if success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

disp(' ');

diary off;

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return