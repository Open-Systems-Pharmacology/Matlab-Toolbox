function checkHelptextForDirectory(functionDir)
%CHECKHELPTEXTFORDIRECTORY Scan all functions of a directory and checks if a valid helptext exists
% 
%   CHECKHELPTEXTFORDIRECTORY(functionDir)
%       functionDir name of the directory

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 16-Sep-2010

files=dir([functionDir filesep '*.m']);

output{1,1}='Filename';
output{1,2}='Error';

fid = fopen([functionDir filesep 'Contents.m']);
contents=textscan(fid,'%s','delimiter','\n');


for iFile=1:length(files)
    if ~any(strcmp(files(iFile).name,{'Contents.m'}))
        ErrorMessage =checkHelptext(files(iFile).name,contents{1},functionDir);
        if ~isempty(ErrorMessage)
            output{end+1,1}=files(iFile).name;
            output{end,2}=ErrorMessage;
        end
                
    end
end

xlswrite(['log/Testlog_' datestr(now,'yyyy_mm_dd') '.xls'],output,'Helptext');

return




function [ErrorMessage] = checkHelptext(functionName,contents,functionDir)

helptext=strtrim(help(functionName));

ErrorMessage_tmp={};
% helptext exists
if length(helptext)<10
    ErrorMessage_tmp{end+1}=sprintf('Helptext for function %s is to very short',functionName);
end

% helptext starts with function Name
if ~strcmpi(functionName(1:end-2),helptext(1:length(functionName)-2));
    ErrorMessage_tmp{end+1}=sprintf('Helptext for function %s starts not with functionName',functionName);
end

% functiontext contains 'Keywords'
keywords={'% Open Systems Pharmacology Suite;  support@systems-biology.com','% Date:'};
fid = fopen([functionDir filesep functionName]);
functiontext=textscan(fid,'%s','delimiter','\n');
for iWord=1:length(keywords)
    if ~any(strncmp(keywords{iWord},functiontext{1},length(keywords{iWord})))
        ErrorMessage_tmp{end+1}=sprintf('Functiontext for function %s contains no %s',functionName,keywords{iWord}); %#ok<*AGROW>
    end
end

% check if function is listed in Content
if isempty(strfind(contents,functionName(1:end-2)))
    ErrorMessage_tmp{end+1}=sprintf('function %s is not listed in Content',functionName);
end

ErrorMessage='';
for i=1:length(ErrorMessage_tmp)
    if length(strtrim(ErrorMessage_tmp{i}))>1
        ErrorMessage=[ErrorMessage ErrorMessage_tmp{i} '; '];
    end
end


return