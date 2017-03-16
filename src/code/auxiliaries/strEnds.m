function success_index=strEnds(c,s)
%STRENDS Support function: Checks if string in a cell array ends with a string
%
%   success_index=strBegins(c,s)
%       c (cellarray of strings)
%       s (string): 
%       success_index (Boolean vector): true if the cell array entry ends with the string 
%
% Example Calls:
% success_index=strEnds({'Hallo world'},'ld')

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 6-Jun-2011%%
%%

success_index=false(length(c),1);

tmp=regexp(c,s,'end');

ix=find(~cellfun(@isempty,tmp));
if ~isempty(ix)
    for i=ix'
        success_index(i)=tmp{i}(end)==length(c{i});
    end
end
return