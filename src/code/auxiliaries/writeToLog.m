function writeToLog(logText,logFile,doDisplayText,isNewFile)
%WRITETOLOG Support function: Writes text to logfile. Each entry starts with a time stamp
%
%   WRITETOLOG(logText,logFile,displayText,isNewFile)
%       logText (string): text which is added to logFile
%       doDisplayText (boolean): 
%           false: (default)  text is only written to the logFile 
%           true:   text is also displayed 
%       isNewFile (Boolean): 
%           false: (default)  text is appended to the existing logfile
%           true:   a new file is created 
%
% Example Calls:
% writeToLog('Start Code:','log.txt',false,true)
% writeToLog('End Code:','log.txt')

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 26-Nov-2010%%
%%


% Display
if ~exist('doDisplayText','var')
    doDisplayText=false;
end
if doDisplayText
    disp(logText);
end

% Write to Log
if isempty(logFile)
    return
end


% check inputs
if ~exist('isNewFile','var')
    isNewFile=false;
end

% check if File exists
if ~exist(logFile,'file')
    isNewFile=true;
end


if isNewFile
    fid = fopen(logFile,'w');
else
     fid = fopen(logFile,'a');
end
fprintf(fid,'%s',[datestr(now)  ' ' logText]);
fprintf(fid,'\r\n');
fclose(fid);

return
