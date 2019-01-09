function [NumberOfSuccessfullTests, SuccessfullTestsInfo, NumberOfFailedTests, FailedTestsInfo] = loop_BasisToolBox
%LOOP_BASISTOOLBOX automatical test basis Toolbox
% 
% LOOP_BASISTOOLBOX
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

NumberOfSuccessfullTests = 0;
SuccessfullTestsInfo = [];
NumberOfFailedTests = 0;
FailedTestsInfo = [];

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
    testInfo.TestName = X(iTest).name;
    try
        [ErrorFlag{iTest},ErrorMessage{iTest},TestDescription{iTest}] = test_function(X(iTest).name); %#ok<*AGROW>
        
        testInfo.ErrorFlag = ErrorFlag{iTest};
        testInfo.ErrorMessage = ErrorMessage{iTest};
        testInfo.TestDescription = TestDescription{iTest};
        
        if ErrorFlag{iTest}== 0
            NumberOfSuccessfullTests = NumberOfSuccessfullTests+1;
            if isempty(SuccessfullTestsInfo)
                SuccessfullTestsInfo = testInfo;
            else
                SuccessfullTestsInfo(end+1) = testInfo;
            end
        else
            NumberOfFailedTests = NumberOfFailedTests+1;
            if isempty(FailedTestsInfo)
                FailedTestsInfo = testInfo;
            else
                FailedTestsInfo(end+1) = testInfo;
            end
        end
    catch ME
        testInfo.ErrorFlag = -1;
        testInfo.ErrorMessage = [ME.identifier ':' ME.message];
        testInfo.TestDescription = '';
        
        NumberOfFailedTests = NumberOfFailedTests+1;
        if isempty(FailedTestsInfo)
            FailedTestsInfo = testInfo;
        else
            FailedTestsInfo(end+1) = testInfo;
        end
    end
end

logFileName = ['log/Testlog_' datestr(now,'yyyy_mm_dd')];

try
    save([logFileName '.mat'], 'NumberOfSuccessfullTests', 'SuccessfullTestsInfo', 'NumberOfFailedTests', 'FailedTestsInfo');
    xlswrite([logFileName '.xls'],{'function Name','Error Flag','Error Message','Test Descriptiopn'},'test functions','A1');
    xlswrite([logFileName '.xls'],[{X.name}',ErrorFlag',ErrorMessage',TestDescription'],'test functions','A2');
catch
end

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


