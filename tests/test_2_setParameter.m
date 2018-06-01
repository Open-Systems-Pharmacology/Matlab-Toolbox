function [ErrorFlag, ErrorMessage,TestDescription] = test_2_setParameter
%TEST_2_SETPARAMETER Test of Function setParameters and setSpeciesInitialValues
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_2_SETPARAMETER
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
initSimulation(xml,'all','report','none');

xml=['models' filesep 'SimModel4_ExampleInput05.xml'];
initSimulation(xml,'all','report','none','addFile',true);

% set Parameter Value
TestDescription{end+1}='1) With no options default options ar taken;';
[indx] = setParameter(1,'TopContainer/P3',1,'parameterType','variable');
value=DCI_INFO{1}.InputTab(2).Variables(3).Values(indx);
success= value==1 && indx==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% set Parameter Reference Value
TestDescription{end+1}='2)set Parameter Reference Value;';
[indx] = setParameter(2,83,1,'parameterType','reference');
value=DCI_INFO{1}.ReferenceTab(2).Variables(3).Values(indx);
success= value==2 && indx==8;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% set Parameter Reference Value specified by indx
TestDescription{end+1}='3) set Parameter Reference Value specified by indx;';
[indx] = setParameter(3,'',1,'parameterType','reference','indx',4);
value=DCI_INFO{1}.ReferenceTab(2).Variables(3).Values(indx);
success= value==3 && indx==4;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% set Parameter Reference Value for more than one value
TestDescription{end+1}='4) set Parameter Reference Value for more than one value;';
[indx] = setParameter([80:86],[80:86],1,'parameterType','reference'); %#ok<*NBRAK>
value=DCI_INFO{1}.ReferenceTab(2).Variables(3).Values(indx);
success= all(value==[80:86]') && all(indx==[5:11]);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% set Parameter Reference Value for more than one value by Index
TestDescription{end+1}='5) set Parameter Reference Value for more than one value by Index;';
[indx] = setParameter([80:86],'',1,'parameterType','reference','indx',[1:7]); %#ok<*NBRAK>
value=DCI_INFO{1}.ReferenceTab(2).Variables(3).Values(indx);
success= all(value==[80:86]') && all(indx==[1:7]);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

%% set Species Inital Value
TestDescription{end+1}='6) set Species Inital Value;';
[indx] = setSpeciesInitialValue(2,'TopContainer/Educt',2,'property','InitialValue');
value=DCI_INFO{2}.InputTab(4).Variables(3).Values(indx);
success= value==2 && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% set Scale Factor
TestDescription{end+1}='7) set Scale Factor;';
[indx] = setSpeciesInitialValue(4,'TopContainer/Educt',2,'property','ScaleFactor');
value=DCI_INFO{2}.InputTab(4).Variables(4).Values(indx);
success= value==4 && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


%% Errors

logfile='setParameter';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;

ErrorFlag_tmp(end+1)=1;
ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];

TestDescription{end+1}='8) get the value for a non existing a parameter;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setParameter(1,'TopContainer/P13',1,'parameterType','variable');
catch exception
    disp(exception.message);
end
disp(' ');

TestDescription{end+1}='9) set multiple value for a string path_id;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setParameter([1:4],'TopContainer/P3',1,'parameterType','variable');
catch exception
    disp(exception.message);
end
disp(' ');

TestDescription{end+1}='10) set multiple value for not corresponding indx;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setParameter([1:4],'TopContainer/P3',1,'indx',[1:5]);
catch exception
    disp(exception.message);
end
disp(' ');

TestDescription{end+1}='11) set multiple value for not corresponding path_id;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setParameter([1:4],[80:86],1);
catch exception
    disp(exception.message);
end
diary off;


%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return