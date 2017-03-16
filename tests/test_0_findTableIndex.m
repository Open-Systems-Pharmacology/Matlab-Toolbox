function [ErrorFlag, ErrorMessage,TestDescription] = test_0_findTableIndex
%TEST_0_FINDTABLEINDEX Test call of findTableIndex 
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_FINDTABLEINDEX
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 19-Sep-2010

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


xml=['models' filesep 'Simulation 22_11_2011 12_38_50.xml'];
initSimulation(xml,'all','report','none');

% find numeric
TestDescription{end+1}='1) find indx per ID;';
[indx] = findTableIndex(111, 2, 1);
if indx~=1
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find in refernce table
TestDescription{end+1}='2) find in refernce table;';
[indx] = findTableIndex(111, 2, 1,true);
if indx~=1
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find numeric for nonexistent number
TestDescription{end+1}='3) find numeric for nonexistent number;';
[indx] = findTableIndex(1, 2, 1,true);
if ~isempty(indx)
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path without wildcards
TestDescription{end+1}='4) find path without wildcards;';
[indx] = findTableIndex('No/H0', 2, 1,true);
if indx~=7
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path all
TestDescription{end+1}='5) find path all;';
[indx] = findTableIndex('*', 2, 1,true);
if ~all(indx==1:8)
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find nonexistent path 
TestDescription{end+1}='6) find nonexistent path ;';
[indx] = findTableIndex('nonexistent', 2, 1,true);
if ~isempty(indx)
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path end wildcard 
TestDescription{end+1}='7) find path end wildcard ;';
[indx] = findTableIndex('*Tol', 2, 1,true);
if ~all(indx==[2:3]) %#ok<NBRAK>
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path wildcard in bewtween 
TestDescription{end+1}='8)find path wildcard in bewtween ;';
[indx] = findTableIndex('|*n', 2, 1,true);
if ~all(indx==[5 8])
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path start wildcard 
TestDescription{end+1}='9) find path start wildcard ;';
[indx] = findTableIndex('*Tol', 2, 1,true);
if ~all(indx==[2 3])
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path more than one wild card
TestDescription{end+1}='10) find path more than one wild card;';
[indx] = findTableIndex('Model*rganism|Re*ion*k1', 2, 1,true);
if ~all(indx==[1])
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
