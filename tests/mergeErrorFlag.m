function [ErrorFlag, ErrorMessage,TestDescription] = mergeErrorFlag(ErrorFlag_tmp, ErrorMessage_tmp,TestDescription_tmp)
%MERGEERRORFLAG merges Array of ErrorMessages and error Flags to one resulting Flag and message
%
% [ErrorFlag, ErrorMessage] = MERGEERRORFLAG(ErrorFlag_tmp, ErrorMessage_tmp)
%   ErrorFlag_tmp (double):array of all ErrorFlags
%   ErrorMessage_tmp (cellarray) : array of all error messages
%   ErrorFlag double: Maximum of ErrorFlag_tmp
%   ErrorMessage (string): concatination of all
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

if isempty(ErrorFlag_tmp)
    ErrorFlag=0;
    ErrorMessage='';
    return
end


ErrorFlag=max(ErrorFlag_tmp);

ErrorMessage='';
for i=1:length(ErrorMessage_tmp)
    if length(strtrim(ErrorMessage_tmp{i}))>1
        ErrorMessage=[ErrorMessage ErrorMessage_tmp{i} '; ']; %#ok<*AGROW>
    end
end

TestDescription='';
if exist('TestDescription_tmp','var')
    for i=1:length(TestDescription_tmp)
        if length(strtrim(TestDescription_tmp{i}))>1
            TestDescription=[TestDescription TestDescription_tmp{i} ' '];
        end
    end
end

return