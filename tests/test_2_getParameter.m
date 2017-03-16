function [ErrorFlag, ErrorMessage,TestDescription] = test_2_getParameter
%TEST_2_GETPARAMETER Test of Function getParameters and getSpeciesInitialValues
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_2_GETPARAMETER
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 22-Sep-2010

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


xml=['models' filesep 'SimModel4_ExampleInput06.xml'];
initSimulation(xml,'allNonFormula','report','none');

xml=['models' filesep 'SimModel4_ExampleInput05.xml'];
initSimulation(xml,'all','report','none','addFile',true);

% get Parameter Value
TestDescription{end+1}='1.1) get Parameter Value;';
[value,indx] = getParameter('TopContainer/P3',1,'parameterType','readonly');
success= value==0 && indx==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter Reference Value
TestDescription{end+1}='1.2) get Parameter Reference Value;';
[value,indx] = getParameter(83,1,'parameterType','reference');
success= value==0 && indx==4;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter Reference Value specified by indx
TestDescription{end+1}='1.3) get Parameter Reference Value by indx;';
[value,indx] = getParameter('',1,'parameterType','reference','indx',4);
success= value==0 && indx==4;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter ID
TestDescription{end+1}='1.4) get Parameter ID;';
[value,indx] = getParameter('TopContainer/P3',1,'parameterType','readonly','property','ID');
success= value==113 && indx==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter Unit
TestDescription{end+1}='1.5) get Parameter Unit;';
[value,indx] = getParameter('TopContainer/P3',1,'parameterType','readonly','property','Unit');
success= strcmp(value,'L') && indx==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter Formula
TestDescription{end+1}='1.6) get Parameter Formula;';
[value,indx] = getParameter('TopContainer/P3',1,'parameterType','readonly','property','Formula');
success= strcmp(value,'Time') && indx==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter isFormula
TestDescription{end+1}='1.7) get Parameter isFormula;';
[value,indx] = getParameter('TopContainer/P3',1,'parameterType','readonly','property','isFormula');
success= value==1 && indx==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter isFormula
TestDescription{end+1}='1.8) get Parameter Path;';
[value,indx] = getParameter('TopContainer/P3',1,'parameterType','readonly','property','Path');
success= strcmp(value,'TopContainer/P3') && indx==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

%% get Species Inital Value
TestDescription{end+1}='2.1) get Species Inital Value;';
[value,indx] = getSpeciesInitialValue('TopContainer/Educt',2,'parameterType','readonly','property','InitialValue');
success= value==0 && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter ID
TestDescription{end+1}='2.2) get Species Inital Value ID;';
[value,indx] = getSpeciesInitialValue('TopContainer/Educt',2,'parameterType','readonly','property','ID');
success= value==7 && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter Unit
TestDescription{end+1}='2.3) get Species Inital Value Unit;';
[value,indx] = getSpeciesInitialValue('TopContainer/Educt',2,'parameterType','readonly','property','Unit');
success= strcmp(value,'L') && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter Formula
TestDescription{end+1}='2.4) get Species Inital Value Formula;';
[value,indx] = getSpeciesInitialValue('TopContainer/Educt',2,'parameterType','readonly','property','Formula');
success= strcmp(value,'') && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter isFormula
TestDescription{end+1}='2.5) get Species Inital Value isFormula;';
[value,indx] = getSpeciesInitialValue('TopContainer/Educt',2,'parameterType','readonly','property','isFormula');
success= value==0 && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter Scalefactor
TestDescription{end+1}='2.6) get Species Inital Value Scalefactor;';
[value,indx] = getSpeciesInitialValue('TopContainer/Educt',2,'parameterType','readonly','property','ScaleFactor');
success= value==1 && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% get Parameter Scalefactor
TestDescription{end+1}='2.7) get Species Inital Value Path;';
[value,indx] = getSpeciesInitialValue('TopContainer/Educt',2,'parameterType','readonly','property','Path');
success= strcmp(value,'TopContainer/Educt')  && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end
%% Errors

logfile='getParameter';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;

ErrorFlag_tmp(end+1)=1;
ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];

TestDescription{end+1}='3.1) get the value for a parameter which does not exist for the specified parameter type;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    getParameter('TopContainer/P3',1,'parameterType','variable');
catch exception
    disp(exception.message);
end

diary off;

%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return