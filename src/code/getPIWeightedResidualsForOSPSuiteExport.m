function [resid,PI]=getPIWeightedResidualsForOSPSuiteExport(p,PI)
%GETPIWEIGHTEDRESIDUALSFOROSPSUITEEXPORT calculates residuals for the problem defined in the structure PI
% 
% in this function parameters listed in PI are updated with values of p,
% the corresponding simulations are processed and the residuals for the
% observed data listed in PI are calculated.
%
% [resid,PI]=getPIWeightedResidualsForOSPSuiteExport(p,PI)
%
%       p (double vector)     - current values of parameter, order corresponds
%                               to the order of PI.par
%       PI (structure)        - this structure contains all information needed
%                               to run the parameter identification, see
%                               also INITPARAMETERIDENTIFICATIONFOROSPSUITEEXPORT
%       resid (double vector) - vector of all weighted residuals
%       

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 10-Mai-2016

% set current values
for iP=1:length(PI.par)
    
    for iPt=1:length(PI.par(iP).simIndex)
        
        if PI.par(iP).useAsFactor            
            PI.par(iP).rowIndex(iPt)=...
                setRelativeParameter(p(iP),PI.par(iP).path_id{iPt},PI.par(iP).simIndex(iPt),'speedy','variable',PI.par(iP).rowIndex(iPt));    
        else
            PI.par(iP).rowIndex(iPt)=...
                setParameter(p(iP),PI.par(iP).path_id{iPt},PI.par(iP).simIndex(iPt),'speedy','variable',PI.par(iP).rowIndex(iPt));    
        end    
    end
end

% process Simulations
for simIndex=unique([PI.output.simIndex]);
    success=processSimulation(simIndex);
    % if processing failed in one of the simulations: return
    if ~success
        resid=nan;
        return
    end
end

% get residual for all outputs
resid=[];
for iO=1:length(PI.output)

    [sim_time,simValues,PI.output(iO).rowIndex]=...
        getSimulationResult(PI.output(iO).path_id, PI.output(iO).simIndex,'rowIndex',PI.output(iO).rowIndex);

    simValues_atExpTime=interp1(sim_time,simValues,PI.output(iO).data_time);

    valid=~isnan(PI.output(iO).data_value);
    if strcmp(PI.output(iO).scaling,'Log') 
        valid=PI.output(iO).data_value > 0 & valid;
        resid_tmp=log(simValues_atExpTime)-log(PI.output(iO).data_value);
    else
        resid_tmp=simValues_atExpTime-PI.output(iO).data_value;        
    end

    % set weights
    resid_tmp=resid_tmp.*PI.output(iO).data_weight.*PI.output(iO).weight;
    
    % add valid residuals to vector
    resid(length(resid)+[1:sum(valid)])=resid_tmp(valid); %#ok<AGROW>
end


return
