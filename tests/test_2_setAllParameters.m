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
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

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



TestDescription{end+1}='3) Set read-only tables as target;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setAllParameters('readOnly','variable',1);
catch exception
    disp(exception.message);
    if ~strcmp(exception.message,'The parameter type for target is unknown: readOnly')
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=['Failed in 3) check logfile:' logfile '!'];
    end
end
disp(' ');

TestDescription{end+1}='4) Set unknown tables as source;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setAllParameters('unknown','readOnly',1);
catch exception
    disp(exception.message);
    if ~strcmp(exception.message,'The parameter type for target is unknown: unknown')
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=['Failed in 4) check logfile:' logfile '!'];
    end
    
end
disp(' ');

diary off;

%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
