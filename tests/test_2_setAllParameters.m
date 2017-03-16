function [ErrorFlag, ErrorMessage,TestDescription] = test_2_setAllParameter
%TEST_2_SETALLPARAMETER Test of Function setParameters and setSpeciesInitialValues
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_2_SETALLPARAMETER
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
% % ToDo test if the DCI Interface accepts  the chagned values 
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 22-Sep-2010

global DCI_INFO;

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

xml=['models' filesep 'SimModel4_ExampleInput06.xml'];
initSimulation(xml,'allNonFormula','report','none');

values_ref=getParameter('*',1,'parameterType','variable');

%% refernce to variable
TestDescription{end+1}='1) refernce to variable;';

indx=setParameter(11,'*',1,'parameterType','reference');
setAllParameters('variable','reference',1);
value=DCI_INFO{1}.InputTab(2).Variables(3).Values(indx);
success= all(value==11);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% read-only to variable
TestDescription{end+1}='2) read-only to variable;';
setAllParameters('variable','readOnly',1);
value=DCI_INFO{1}.InputTab(2).Variables(3).Values(indx);
success= all(value==values_ref);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


%% Errors

logfile='setAllParameter';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;

ErrorFlag_tmp(end+1)=1;
ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];


TestDescription{end+1}='3) Set read-only tables as target;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setAllParameters('readOnly','variable',1);
catch exception
    disp(exception.message);
end
disp(' ');

TestDescription{end+1}='4) Set unkwon tables as source;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setAllParameters('unknown','readOnly',1);
catch exception
    disp(exception.message);
end
disp(' ');

diary off;

%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
