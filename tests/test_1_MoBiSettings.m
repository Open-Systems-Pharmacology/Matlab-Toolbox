function [ErrorFlag, ErrorMessage,TestDescription] = test_1_MoBiSettings
%TEST_1_MOBISETTINGS Test of Function checkInputOptions
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_1_MOBISETTINGS
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 16-Sep-2010

global MOBI_SETTINGS;

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

% Set the function
MoBiSettings;

% Check if the global MoBi Settings is set
TestDescription{end+1}='1) Check if the global MoBi Settings is set;';
if isempty(MOBI_SETTINGS)
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% Check if the DCI Interface is reachable
TestDescription{end+1}='2) Check if the DCI Interface is reachable;';
feval(MOBI_SETTINGS.MatlabInterface,'Help');
if isempty(MOBI_SETTINGS)
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
