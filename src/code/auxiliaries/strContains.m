function success_index=strContains(c,expr)
%STRCONTAINS Support function: Checks if a string in a cell array contains expr
%
%   success_index=strContains(c,expr)
%       c (cellarray of strings)
%       expr (string): 
%       success_index (Boolean vector): true if the cell array entry ends with the string 
%
% Example Calls:
% success_index=strContains({'Hallo world'},'or')

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 6-Jun-2011%%
%%

tmp=regexp(c,expr);

success_index=~cellfun(@isempty,tmp);

return