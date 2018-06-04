function [ErrorFlag, ErrorMessage,TestDescription] = test_9_compareSimulations
%TEST_9_COMPARESIMULATIONS Test of Function compareSimulation
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_9_COMPARESIMULATIONS
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

% ToDo test with simulation which contains observer and specific
% timepatterns

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

% 1 Check default options
TestDescription{end+1}='1) compare different simulations;';
xml1=['models' filesep 'PopSim.xml'];
xml2=['models' filesep 'AdultPopulation.xml'];

logfile=['log' filesep 'compareSimulation_' datestr(now,'yyyy_mm_dd') '.log'];
compareSimulations(xml1,xml2,'logfile',logfile);

fid = fopen(logfile);
tmp=textscan(fid,'%s','delimiter','\n');
C=tmp{1};
fclose(fid);

if ~length(C) == 4339
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];
end

logfile=['log/compareSimulation_2_' datestr(now,'yyyy_mm_dd') '.log'];
compareSimulations(xml1,xml2,'logfile',logfile,'resolution',10000);


fid = fopen(logfile);
tmp=textscan(fid,'%s','delimiter','\n');
C=tmp{1};
fclose(fid);

if ~length(C) ==  2269
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=['check logfile:' logfile '!'];
end


[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
