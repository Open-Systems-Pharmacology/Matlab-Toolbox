function plotPIDefaultOutputForOSPSuiteExport(PI,finalValues)
% PLOTPIDEFAULTOUTPUTFOROSPSUITEEXPORT generates default plots for the parameter identification calle for the SB Suite export
%
% this function generates following outputs
%   excel table Parameter.xlsx  with identification parmeter,
%   Histofrmm with residuals
%   time profile plot for all outputs deifned in PI
%
%      PI (structure)    - this structure contains all information needed
%                               to run the parameter identification, see
%                               also INITPARAMETERIDENTIFICATIONFOROSPSUITEEXPORT
%      finalValues (double vector) - values identified by algorithm for the
%                               problem defiend in PI

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 10-Mai-2016


% set final Values to structure
for iP=1:length(PI.par)
    PI.par(iP).finalValue=finalValues(iP);
end


% export parameters
tmp=PI.par;
tmp=rmfield(tmp,'dimension');
tmp=rmfield(tmp,'simIndex');
tmp=rmfield(tmp,'rowIndex');
tmp=rmfield(tmp,'path_id');

xlswrite('Parameter.xlsx',[fieldnames(tmp)';squeeze(struct2cell(tmp))'],1);

% evaluate function at the final Values
[resid,PI]=getPIWeightedResidualsForOSPSuiteExport(finalValues,PI);

% histogramm residual
ax=getNormFigure;
hist(resid);
xlabel('residual');


% plot outputs
for iO=1:length(PI.output)
    
    ax=getNormFigure;

    [sim_time,simValues,PI.output(iO).rowIndex]=...
        getSimulationResult(PI.output(iO).path_id, PI.output(iO).simIndex,'rowIndex',PI.output(iO).rowIndex);

    % timeprofile
    plot(ax,sim_time,simValues,'k-','displayname',PI.output(iO).path_id,'linewidth',2);
    plot(ax,PI.output(iO).data_time,PI.output(iO).data_value,'kx','displayname',PI.output(iO).data_name,'linewidth',2);
    
    xlabel('time [min]')
    ylabel(PI.output(iO).unit);
    l=legend(ax,'show');
    set(l,'fontsize',8,'interpreter','none','location','northoutside')
    
end

