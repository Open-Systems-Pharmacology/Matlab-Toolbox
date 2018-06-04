function loop_BasisToolBox
%LOOP_BASISTOOLBOX automatical test basis Toolbox
% 
% LOOP_BASISTOOLBOX
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

% prepare logDir
if ~exist('log','dir')
    mkdir('log')
end

% check helptext of all functions
% checkHelptextForDirectory('..\Code')

% get the test-functions:
X=dir('test_*.m');

clc;
% loop over the testcases
for iTest=1:length(X)
    [ErrorFlag{iTest},ErrorMessage{iTest},TestDescription{iTest}] = test_function(X(iTest).name); %#ok<*AGROW>
end

xlswrite(['log/Testlog_' datestr(now,'yyyy_mm_dd') '.xls'],{'function Name','Error Flag','Error Message','Test Descriptiopn'},'test functions','A1');
xlswrite(['log/Testlog_' datestr(now,'yyyy_mm_dd') '.xls'],[{X.name}',ErrorFlag',ErrorMessage',TestDescription'],'test functions','A2');

return


function [ErrorFlag,ErrorMessage,TestDescription] = test_function(functionName)

try
    clear global;
    clear persistent;
    disp('----------------------------------------------')
    disp('----------------------------------------------')
    disp(functionName);
    [ErrorFlag,ErrorMessage,TestDescription]= feval(functionName(1:end-2));
    
catch exception
    ErrorFlag=2;
    ErrorMessage=exception.message;
    TestDescription='';
    disp(exception.message);
end

return


