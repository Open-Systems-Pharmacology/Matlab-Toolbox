function [ErrorFlag, ErrorMessage,TestDescription] = test_2_setRelativeParameter
%TEST_2_SETRELATIVEPARAMETER Test of Function setRelativeParameter and setSpeciesInitialValue
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_2_SETRELATIVEPARAMETER
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

% set Relative Parameter Value
TestDescription{end+1}='1) set Relative Parameter Value;';
[indx] = setParameter(10,'TopContainer/P3',1,'parameterType','reference');
setRelativeParameter(0.1,'TopContainer/P3',1,'rowindex',indx);
value=DCI_INFO{1}.InputTab(2).Variables(3).Values(indx);
success= value==1 && indx==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


% set Relative Parameter Reference Value for more than one value
TestDescription{end+1}='2) set Relative Parameter Reference Value for more than one value;';
[indx] = setParameter(10,[80:86],1,'parameterType','reference'); %#ok<*NBRAK>
setRelativeParameter([1:7],[80:86],1); %#ok<*NBRAK>
value=DCI_INFO{1}.InputTab(2).Variables(3).Values(indx);
success= all(value==[10:10:70]') && all(indx==[5:11]);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


%% set Species Inital Value
TestDescription{end+1}='3.1) set Species Inital Value;';
[indx] = setSpeciesInitialValue(2,'TopContainer/Educt',2,'property','InitialValue','parameterType','reference');
setRelativeSpeciesInitialValue(4,'TopContainer/Educt',2,'property','InitialValue');
value=DCI_INFO{2}.InputTab(4).Variables(3).Values(indx);
success= value==8 && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

%% set Species Inital Value
TestDescription{end+1}='3.2)set Species Value with  more than one value;';
[indx] = setSpeciesInitialValue(2,'*',1,'property','InitialValue','parameterType','reference');
setRelativeSpeciesInitialValue(ones(length(indx),1),'TopContainer/Educt',1,'property','InitialValue','rowindex',indx);
value=DCI_INFO{1}.InputTab(4).Variables(3).Values(indx);
success= all(value==2);

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% set Scale Factor
TestDescription{end+1}='4) set Scale Factor;';
[indx] = setSpeciesInitialValue(4,'TopContainer/Educt',2,'property','ScaleFactor','parameterType','reference');
setRelativeSpeciesInitialValue(5,'TopContainer/Educt',2,'property','ScaleFactor');
value=DCI_INFO{2}.InputTab(4).Variables(4).Values(indx);
success= value==20 && indx==1;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


%% Errors

logfile='setRelativeParameter';
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;


TestDescription{end+1}='5) get the value for a non existing parameter;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setRelativeParameter(1,'TopContainer/P13',1);
catch exception
    disp(exception.message);
    if ~strcmp(exception.message,'Parameter with path_id "TopContainer/P13" does not exist!')
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=['Failed in 5) check logfile:' logfile '!'];
    end
    
end
disp(' ');

TestDescription{end+1}='6)  get the value for a non existing species Initial value;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
% get Parameter for nonexisten pat_id
try
    setRelativeSpeciesInitialValue(1,'TopContainer/P13',1);
catch exception
    disp(exception.message);
    if ~strcmp(exception.message,'Species initial value with path_id "TopContainer/P13" does not exist!')
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=['Failed in 6) check logfile:' logfile '!'];
    end

end
disp(' ');

TestDescription{end+1}='7)set Species Value with  more than one value;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
try
    setSpeciesInitialValue([2 4],'TopContainer/Educt',[2 1],'property','InitialValue','parameterType','reference');
catch exception
    disp(exception.message);
    if ~strcmp(exception.message,'The variable "value" has more than one entry, in this case "path_id" must be numeric (vector of IDs) or use the option rowIndex!')
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=['Failed in 7) check logfile:' logfile '!'];
    end

end
disp(' ');



%%Merge errors
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
