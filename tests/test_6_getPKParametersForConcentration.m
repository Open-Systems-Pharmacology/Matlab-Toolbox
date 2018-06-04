function [ErrorFlag, ErrorMessage,TestDescription] = test_6_getPKParametersForConcentration
%TEST_6_GETPKPARAMETERSFORCONCENTRATION Test of Function checkInputOptions
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_6_GETPKPARAMETERSFORCONCENTRATION
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};


% 1.1) get Cmax and Cmin 
TestDescription{end+1}='1.1) get Cmax and Cmin;';

time=[1:10]; %#ok<*NBRAK>
concentration=[2 1:3 1:3 1:3];
PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'none'});

success= PK.cMax==3 && PK.tMax==4 && PK.cMin==1 && PK.tMin==2 ;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.2) AUC
TestDescription{end+1}='1.2) get AUC lin; method lin';

time=[0:0.2:2];
concentration=[0:5 4:-1:0];
PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'none'},'method','lin');

success= PK.AUC_last==5 && PK.AUC_0last==5 && PK.AUMC_last==5 && PK.AUMC_0last==5;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.3) AUC
TestDescription{end+1}='1.3) add AUC_0; options TimeRange';

time=[0.2:0.2:2];
concentration=[1:5 4:-1:0];
PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'none'},'method','lin',...
    'timeRange',[0 2],'extrapolationTo0','zero');

success= PK.AUC_last==4.9 && PK.AUC_0last==5 && PK.AUMC_last==4.98 && PK.AUMC_0last==5;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.4) AUC log
TestDescription{end+1}=' 1.4) AUC log;';

time=[0:50];
lambda=0.05;
C0=100;
concentration=C0.*exp(-lambda.*time);
PK=getPKParametersForConcentration(time,concentration);

success= abs(PK.AUC_inf-C0/lambda)<1e-3*PK.AUC_inf ...
    && ((PK.AUC_inf-PK.AUC_last)-C0./lambda*exp(-lambda.*time(end)))<1e-3*PK.AUC_inf...
    && abs(log(2)/lambda-PK.tHalf)<1e-3*PK.tHalf ...
    && abs(PK.perc_AUC_lastToInf- 100*exp(-lambda.*time(end)))<1e-3*PK.perc_AUC_lastToInf;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.5) AUMC
TestDescription{end+1}=' 1.5) compare AUMC(t,c) with AUC(t,t*C)  lin and log;';

time=[0:100];
lambda=0.05;
C0=100;
C50=C0.*exp(-lambda.*50);
concentration=[0:C50/50:C50 C0.*exp(-lambda.*[51:100])]; %#ok<BDSCI>
PK=getPKParametersForConcentration(time,concentration);
PK2=getPKParametersForConcentration(time,time.*concentration);

success= abs(PK2.AUC_inf-PK.AUMC_inf)<1e-2*PK2.AUC_inf &&...
    abs(PK2.AUC_last-PK.AUMC_last)<1e-2*PK2.AUC_last && ...
    abs(PK.AUC_inf-(0.5*C50*50+C50/lambda))<1e-3*PK.AUC_inf;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.6) Dose
TestDescription{end+1}=' 1.6) Test CL, Vss Vz;';

time=[0:100];
lambda=0.05;
C0=100;
concentration=C0.*exp(-lambda.*time);
Dose=100;
PK=getPKParametersForConcentration(time,concentration,'Dose',Dose);

success= abs(PK.VSS-PK.Vd)<1e-2*PK.VSS &&...
    abs(PK.CL-Dose./C0*lambda)<1e-2*PK.CL;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.7) LLOQ
TestDescription{end+1}=' 1.7) Calculation tLLOQ';

time=[0:100];
lambda=0.05;
C0=100;
C50=C0.*exp(-lambda.*50);
concentration=C0.*exp(-lambda.*time);
PK=getPKParametersForConcentration(time,concentration,'LLOQ',C50);

success= PK.tLLOQ==50;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


% 1.8) AUC
TestDescription{end+1}='1.8) add AUC_0; extrapolationTo0 =lin';

time=[0.2:0.2:2];
concentration=[1:5 4:-1:0];
PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'none'},...
    'timeRange',[0 2],'extrapolationTo0','lin');

success= PK.AUC_last==4.9 && PK.AUC_0last==5 && PK.AUMC_last==4.98 && PK.AUMC_0last==5;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.9) AUC
TestDescription{end+1}='1.9) add AUC_0; extrapolationTo0 =log, method log';

time=[10:100];
lambda=0.05;
C0=100;
concentration=C0.*exp(-lambda.*time);

PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'none'},...
    'timeRange',[0 100],'extrapolationTo0','log','method','log');

time=[0:100];
concentration=C0.*exp(-lambda.*time);
PK2=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'none'},...
    'timeRange',[0 100],'extrapolationTo0','log','method','log');

success= abs(PK.AUC_0last-PK2.AUC_last)<1e-3*PK.AUC_0last ;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.10) AUC
TestDescription{end+1}='1.10) add AUC_0; extrapolationTo0 =log';

time=[0:100];
lambda=0.05;
C0=100;
concentration=C0.*exp(-lambda.*time);

PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'pointsPercent',0.5},...
    'method','log');
PK2=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'rangePercent',0.1},...
    'method','log');
PK3=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'Rsquare'},...
    'method','log');
PK4=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'range',50,100},...
    'method','log');

success= abs(PK.tHalf-PK2.tHalf)<1e-3*PK.tHalf && ...
    abs(PK.tHalf-PK3.tHalf)<1e-3*PK.tHalf && ...
    abs(PK.tHalf-PK4.tHalf)<1e-3*PK.tHalf;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.11) Infusion Time
TestDescription{end+1}='1.11) infusion time';

time=[0:100];
lambda=0.05;
C0=100;
concentration=C0.*exp(-lambda.*time);

PK=getPKParametersForConcentration(time,concentration,'infusionTime',0,'method','log');
PK2=getPKParametersForConcentration(time,concentration,'infusionTime',10,'method','log');

success=PK.MRT-PK2.MRT==5;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

% 1.12) get PK Parameter for species
TestDescription{end+1}='1.12) get PK Parameter';

xml1=['models' filesep 'SimModel4_ExampleInput06.xml'];
initSimulation(xml1,'all','report','none');

processSimulation(1);

PK=getPKParameters('TopContainer/y1',1);

success=PK.cMax==2 && PK.cMin==2;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end


% 1.13) concentration = Array
TestDescription{end+1}='1.13) concentration = Array';


PK=getPKParameters('*',1);

success=length(PK.cMax)==3;

if ~success
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('failed: %s',TestDescription{end});
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Errors


%2.1) try to short extrapolation range
TestDescription{end+1}='2.1) try to short extrapolation range;';
disp(sprintf('Test: %s',TestDescription{end})); %#ok<*DSPS>

time=[1:10];
concentration=[2 1:3 1:3 1:3];
getPKParametersForConcentration(time,concentration);
warnMsg = lastwarn;
if ~strcmp(warnMsg,'The extrapolation range is to small, only 2 points')
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=['faiöed in 2.1!'];
end

disp(' ');


diary off

[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);

return
