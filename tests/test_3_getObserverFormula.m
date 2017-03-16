function [ErrorFlag, ErrorMessage,TestDescription] = test_3_getObserverFormula
%TEST_3_GETOBSERVERFORMULA Test of Function getObserverFormula
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_3_GETOBSERVERFORMULA
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 10-Jan-2011

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


xml=['models' filesep 'PKModelCoreCaseStudy_02.xml'];
initSimulation(xml,'none','report','none');


% get Formula
TestDescription{end+1}='1.1) get Formula;';
[formula,indx]=getObserverFormula('SpecModel/Organism/Lung/Cell/C/AmountObs_2',1);
success= strcmp(formula,'M/2') && indx==6;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get ID
TestDescription{end+1}='1.2) get Formula ID ;';
[ID,indx]=getObserverFormula('SpecModel/Organism/Lung/Cell/C/AmountObs_2',1,'property','ID');
success= ID== 62 && indx==6;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


% check existenz
TestDescription{end+1}='2) check existen;';
[~,desc]=existsObserver('*',1);
success= all(size(desc)==[18 4]);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return

