function [ErrorFlag, ErrorMessage,TestDescription] = test_0_checkInputOptions
%TEST_0_CHECKINPUTOPTIONS Test of Function checkInputOptions
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_0_CHECKINPUTOPTIONS
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

% 1 Check default options
TestDescription{end+1}='1) With no options default options ar taken;';
varargin={};
[emptyString,report,addFile,numericvalue,ExecutionTimeLimit] = ...
    checkInputOptions(varargin,{...
    'emptyString','','short',...
    'report',{'none','short','long'},'short',...
    'addFile',[true false],true,...
    'numericvalue',nan,1,...
    'ExecutionTimeLimit','<$ %g>0 $>',0,...
    });

if ~strcmp(emptyString,'short')
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('1.1 The default value is not transfered for possible option empty string');
end
if ~strcmp(report,'short')
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('1.2 The default value is not transfered for possible option cellarray');
end
if ~addFile
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('1.3 The default value is not transfered for possible option vector of predefined numbers ');
end
if numericvalue~=1
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('1.4 The default value is not transfered for possible option numeric number');
end
if ExecutionTimeLimit~=0
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('1.5 The default value is not transfered for possible option condition');
end


% 2 Check input option possible option values empty string
TestDescription{end+1}='2) input option possible option values empty string;';
varargin={'optionname',1};
[testoutput] = ...
    checkInputOptions(varargin,{...
    'optionname','',0,...
    });


if testoutput~=varargin{2}
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% Check input option possible option values cell array
TestDescription{end+1}='3) input option possible option values cell array;';
varargin={'optionname','Key1'};
[testoutput] = ...
    checkInputOptions(varargin,{...
    'optionname',{'Key1','Key2','Key3'},'Key3',...
    });

if testoutput~=varargin{2}
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% Check input option possible option values predefined numbers 
TestDescription{end+1}='4) input option possible option values cell array;';
varargin={'optionname',1};
[testoutput] = ...
    checkInputOptions(varargin,{...
    'optionname',[1 2 3],2,...
    });

if testoutput~=varargin{2}
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% Check input option possible option values numeric value
TestDescription{end+1}='5) input option possible option values numeric value;';
varargin={'optionname',1};
[testoutput] = ...
    checkInputOptions(varargin,{...
    'optionname',nan,2,...
    });

if testoutput~=varargin{2}
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% Check input option possible option condition
TestDescription{end+1}='6) input option possible option values numeric value;';
varargin={'optionname',1};
[testoutput] = ...
    checkInputOptions(varargin,{...
    'optionname','<$ %g>0 & %g <= 7 $>',2,...
    });

if testoutput~=varargin{2}
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% Check input option possible option condition
TestDescription{end+1}='6.1) input option possible option values cellarray;';
varargin={'optionname',{'none'}};
[testoutput] = ...
    checkInputOptions(varargin,{...
    'optionname','{}',{2},...
    });

if ~strcmp(testoutput{1},varargin{2}{1})
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Errors

logfile='checkInputOptions';
if ~exist('log','dir')
    mkdir('log');
end
diary( ['log/' logfile '_' datestr(now,'yyyy_mm_dd') '.log']);
diary on;


% Check input option possible option values cell array wrong keyword
TestDescription{end+1}='7) input option possible option values cell array wrong keyword;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>
disp('expected: Key4 is wrong keyword for option optionname:');
disp(' ');

try 
    varargin={'optionname','Key4'};
    checkInputOptions(varargin,{...
        'optionname',{'Key1','Key2','Key3'},'Key3',...
        });
catch exception
    disp(exception.message);
    if strcmp(exception.message,'For option "optionname" the keyword "Key4" is unknown!')
        ErrorFlag_tmp(end+1)=0;
        ErrorMessage_tmp{end+1}={};
    else
        ErrorFlag_tmp(end+1)=1;
        ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];
    end
end
disp(' ');


% Check input option possible option values predefined numbers wrong number
TestDescription{end+1}='8) input option possible option values predefined numbers wrong number;';
disp(sprintf('Test: %s',TestDescription{end}));
disp('expected: 4 is wrong number for option optionname:');
disp(' ');

try 
    varargin={'optionname',4};
    checkInputOptions(varargin,{...
        'optionname',[1 2 3],2,...
        });
catch exception
    disp(exception.message);
    if strcmp(exception.message,'For option "optionname" the value "4" is unknown!')
        ErrorFlag_tmp(end+1)=0;
        ErrorMessage_tmp{end+1}={};
    else
        ErrorFlag_tmp(end+1)=1;
        ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];
    end

end
disp(' ');


% Check input option possible option values numeric value
TestDescription{end+1}='9) input option possible option values numeric value;';
disp(sprintf('Test: %s',TestDescription{end}));
disp('expected: value must be numeric for option optionname:');
disp(' ');

try
    varargin={'optionname','1'};
    checkInputOptions(varargin,{...
        'optionname',nan,2,...
        });
catch exception
    disp(exception.message);
    if strcmp(exception.message,'For option "optionname" the value "1" must be numeric!')
        ErrorFlag_tmp(end+1)=0;
        ErrorMessage_tmp{end+1}={};
    else
        ErrorFlag_tmp(end+1)=1;
        ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];
    end
end
disp(' ');

% Check input option possible option condition condition fails
TestDescription{end+1}='10) input option possible option values condition fails;';
disp('expected: value must fullfill condition:');
disp(' ');

try
    varargin={'optionname',8};
    checkInputOptions(varargin,{...
        'optionname','<$ %g>0 & %g <= 7 $>','anything',...
        });
catch exception
    disp(exception.message);
    if strcmp(exception.message,'For option "optionname" value "8" is not valid. The following condition has to be fulfilled: optionname>0 & optionname <= 7 !')
        ErrorFlag_tmp(end+1)=0;
        ErrorMessage_tmp{end+1}={};
    else
        ErrorFlag_tmp(end+1)=1;
        ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];
    end

end
disp(' ');

% Check input option possible option condition condition fails
TestDescription{end+1}='11) input option possible option values condition fails;';
disp('expected: value must be a cell:');
disp(' ');

try
    varargin={'optionname','none'};
    checkInputOptions(varargin,{...
        'optionname','{}',{2},...
        });
catch exception
    disp(exception.message);
    if strcmp(exception.message,'For option "optionname" the value "none" must be a cell!')
        ErrorFlag_tmp(end+1)=0;
        ErrorMessage_tmp{end+1}={};
    else
        ErrorFlag_tmp(end+1)=1;
        ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];
    end


end
disp(' ');
diary off;

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
