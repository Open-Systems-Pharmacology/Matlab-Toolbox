function txt=getPercentilePotenzText(value)
%GETPERCENTILEPOTENZTEXT Support function: Returns potenz text for percentiles depending on value
%
%   txt=getPercentilePotenzText(value)
%       value (double) percentile
%       txt (string): percentile with potenz text
%
% Example Calls:
% txt=getPercentilePotenzText(1) -> txt = '1^{st}'
% txt=getPercentilePotenzText(2) -> txt = '2^{nd}'
% txt=getPercentilePotenzText(3) -> txt = '3^{rd}'
% txt=getPercentilePotenzText(4) -> txt = '4^{th}'

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 30-Aug-2011%%
%%

if ismember(value,11:13)
    txt=sprintf('%g^{th}',value);
elseif mod(value,10)==1
    txt=sprintf('%g^{st}',value);
elseif mod(value,10)==1
    txt=sprintf('%g^{nd}',value);
elseif mod(value,10)==1
    txt=sprintf('%g^{rd}',value);
else
    txt=sprintf('%g^{th}',value);
end
