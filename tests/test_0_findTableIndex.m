function [ErrorFlag, ErrorMessage,TestDescription] = test_0_findTableIndex
%TEST_0_FINDTABLEINDEX Test call of findTableIndex 
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_FINDTABLEINDEX
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

% model initialisation
xml=['models' filesep 'TableParameters.xml'];
initSimulation(xml,'all','report','none');

% find numeric
TestDescription{end+1}='1) find indx per ID;';
[indx] = findTableIndex(5738, 2, 1);
if indx~= 1923
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find in refernce table
TestDescription{end+1}='2) find in reference table;';
[indx] = findTableIndex(5738, 2, 1,true);
if indx~=1923
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find numeric for nonexistent number
TestDescription{end+1}='3) find numeric for nonexistent number;';
[indx] = findTableIndex(9999, 2, 1,true);
if ~isempty(indx)
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path without wildcards
TestDescription{end+1}='4) find path without wildcards;';
[indx] = findTableIndex('S1|Applications|T1|Fraction (dose)', 2, 1,true);
if indx~=1923
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path all
TestDescription{end+1}='5) find path all;';
[indx] = findTableIndex('*', 2, 1,true);
if length(indx) ~= 1947
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
[indx] = findTableIndex('S1|Organism|FcRn receptor conc.*', 2, 1,true);
if ~all(indx==9) 
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path wildcard in bewtween 
TestDescription{end+1}='8)find path wildcard in bewtween ;';
[indx] = findTableIndex('S1|O*sm|Weight', 2, 1,true);
if ~all(indx==5)
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path start wildcard 
TestDescription{end+1}='9) find path start wildcard ;';
[indx] = findTableIndex('*Tol', 2, 1,true);
if ~all(indx==[1941,1942])
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% find path more than one wild card
TestDescription{end+1}='10) find path more than one wild card;';
[indx] = findTableIndex('S1|*|Rate constant for *dosomal uptake (*)', 2, 1,true);
if ~all(indx==[20])
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
