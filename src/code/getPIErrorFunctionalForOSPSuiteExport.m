function err=getPIErrorFunctionalForOSPSuiteExport(p,PI)
% GETPIERRORFUNCTIONALFOROSPSUITEEXPORT: calculates error functional for the problem defined in the structure PI
% 
% in this function parameters listed in PI are updated with values of p,
% the corresponding simulations are processed and the residuals for the
% observed data listed in PI are calculated.
%
% err=getPIErrorFunctionalForOSPSuiteExport(p,PI)
%
%       p (double vector) - current values of parameter, order corresponds
%                               to the order of PI.par
%       PI (structure)    - this structure contains all information needed
%                               to run the parameter identification, see
%                               also INITPARAMETERIDENTIFICATIONFOROSPSUITEEXPORT
%       err (double)      - error functional, norm of residuals (see also
%                               GETPIWEIGHTEDRESIDUALSFOROSPSUITEEXPORT)
%       

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 10-Mai-2016


% update parameter process simulations and get weighted residuals
 resid=getPIWeightedResidualsForOSPSuiteExport(p,PI);
 
 % calculate error as norm of residuals
 if isnan(resid)
     err=10000;
 end
 err=norm(resid);
 
 return
