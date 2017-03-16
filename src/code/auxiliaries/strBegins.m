function success_index=strBegins(c,s)
%STRBEGINS Support function: Checks if string in a cell array begins with a string
%
%   success_index=strBegins(c,s)
%       c (cellarray of strings)
%       s (string): 
%       success_index (Boolean vector): true if the cell array entry begins with the string 
%
% Example Calls:
% success_index=strBegins({'Hallo world'},'H')

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 6-Jun-2011%%
%%

success_index=strncmp(c,s,length(s));

return