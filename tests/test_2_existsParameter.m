function [ErrorFlag, ErrorMessage,TestDescription] = test_2_existsParameter
%TEST_2_EXISTSPARAMETER Test of Function existsParameters and existsSpeciesInitialValues
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_2_EXISTSPARAMETER
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

xml=['models' filesep 'SimModel4_ExampleInput06.xml'];
initSimulation(xml,'allNonFormula','report','none');

% check for existing parameter
TestDescription{end+1}='1) check for existing parameter;';
[isExisting,description,indx] = existsParameter('TopContainer/P1',1,'parameterType','readonly');
success=isExisting &&...
    all(size(description)==[2,7]) &&...
    indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% check for non existing parameter
TestDescription{end+1}='2) check for non existing parameter;';
[isExisting,description,indx] = existsParameter('TopContainer/P1',1);
success=~isExisting &&...
    isempty(description) &&...
    isempty(indx);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% check for existing speciesInitialValue
TestDescription{end+1}='3) check for existing speciesInitialValue;';
[isExisting,description,indx] = existsSpeciesInitialValue('TopContainer/y1',1,'parameterType','readonly');
success=isExisting &&...
    all(size(description)==[2,8]) &&...
    indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% check for non existing speciesInitialValue
TestDescription{end+1}='4) check for non existing speciesInitialValue;';
[isExisting,description,indx] = existsSpeciesInitialValue('TopContainer/blabla',1,'parameterType','variable');
success=~isExisting &&...
    isempty(description) &&...
    isempty(indx);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
