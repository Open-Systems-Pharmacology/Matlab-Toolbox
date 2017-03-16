function PK=getPKParameters(path_id,simulationIndex,varargin)
%GETPKPARAMETERS Gets PK parameters of the time profile of a species or observer specified by path_id.
%
%   PK=getPKParameters(path_id,simulationIndex)
%       path_id (string/double):
%           if it is numerical, it is interpreted as ID. Input of a vector of IDs is possible.
%           if path_id is a string it is interpreted as path. The wildcard ‘*’ can be used.
%               It substitutes for any zero or more characters.
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%       PK (structure)     each field contains a parameter 
%           PK.cMax: (double) maximum concentration directly taken, in case
%               of two cMax the first tMax will be used
%           PK.tMax: (double) time of maximum concentration
%           PK.cMin: (double) minimum concentration directly taken, in case
%               of two cMin the first tMin will be used
%           PK.tMin: (double) time of minimum concentration
%           PK.AUC_last  Area under the concentration vs. time curve from
%               first to last data point 
%           PK.AUC_inf  Area under the concentration vs. time curve from
%               first data point to infinity 
%           PK.AUC_0last  Area under the concentration vs. time curve from
%               zero to last data point 
%           PK.AUC_0inf  Area under the concentration vs. time curve from
%               zero to infinity 
%           PK.perc_AUC_lastToInf Percentage of AUC from the last data
%              point to infinity
%           PK.AUMC_last  Area under the first moment curve, i.e., the curve of 
%               the product of concentration and time vs time, from 
%               first data point to last data point  
%           PK.AUMC_0last  Area under the first moment curve, i.e., the curve of 
%               the product of concentration and time vs time, from 
%               zero to last data point 
%           PK.AUMC_inf  Area under the first moment curve, i.e., the curve of 
%               the product of concentration and time vs time, from 
%               first data point to infinity 
%           PK.AUMC_0inf  Area under the first moment curve, i.e., the curve of 
%               the product of concentration and time vs time, from 
%               zero to infinity 
%           PK.MRT Mean residence time (Note MRT_iv=MRT-infusiontime*0.5
%               see option infusion time)
%           PK.tHalf Half life associated with terminal slope
%
%        If dose is given as option:   
%           PK.CL = D/AUC Total body clearance of drug or apparent
%                clearance CL/F (for extravascular application) 
%           PK.VSS = CL*MRT apparent volume of distribution at steady state
%               (use only with IV applications!)
%           PK.Vd =D/AUC/lambda Apparent volume of distribution during terminal phase
%               or =Vd/F for extravascular administration
%
%       If LLOQ is given as option:
%           PK.tLLOQ Time to reach LLOQ
%
%   Options:
%
%   PK=getPKParameters(path_id,simulationIndex,'rowIndex',value_rowIndex)
%       value_rowIndex (double): specifies the line number
%           nan (default): parameter is identified by path_id
%           (double vector): vector with line numbers. The time consuming search 
%               for the line numbers is already done. 
%               Path_id is ignored (see description to Output rowIndex).
%
%   PK=getPKParameters(path_id,simulationIndex,'timeRange',value_timeRange)
%       value_timeRange (2x1 double vector): specifies the time range, where
%           the calculation is done:
%               first data point: first point >=value_timeRange(1)
%               last data point: last point <=value_timeRange(2)
%           default (range of the given time vector).
%           Affects all PK parameters
%   Example Call:
%   [cMax]=getPKParametersForConcentration('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',1,'timeRange',[60 120]);
%
%
%   PK=getPKParameters(path_id,simulationIndex,'extrapolationRange',value_extrapolationRange)
%       value_extrapolationRange (cell array): specifies the time range, where
%           the regression is done. default {'pointsPercent',0.1}.
%           possible options are:
%               {'none'}: no extrapolation is done, all depending PK parameters are nan
%               {'pointsPercent',x} :  x=(double between 0 and 1) 
%                   x is the fraction of the points of the time range which are taken for
%                   the regression. 
%                   example: (time = 0:60, x=0.1 => extrapolation is done from 54:60) 
%               {'rangePercent',x}: x=(double between 0 and 1) the last x
%                   x is the fraction of the time range which are taken for
%                   the regression. For equally distributed points it is
%                   the same as 'pointsPercent'.
%                   example: (time = 0:60, x=0.1 => extrapolation is done from 54:60) 
%               {'Rsquare'}: During the calculation the regressions is
%                   repeated using the last three points, then the last four
%                   points, last five, etc. Points prior to Cmax are not
%                   used. Points with a value of zero are excluded. 
%                   For each regression, an adjusted R^2 is computed.
%                   The regression with the largest adjusted R^2 is selected
%                   to estimate lambda.
%               {'range',t1, t2}: (t1,t2, double) Time points for extrapolation 
%                   are between t1 and t2.
%           Affects PK parameters: PK.AUC_inf, PK.AUC_0inf, PK.perc_AUC_lastToInf,
%               PK.tHalf, PK.MRT, PK.tLLOQ, PK.AUMC_0inf, PK.AUMC_0inf
%   Example Call:
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',...
%       1,'extrapolationRange',{'pointsPercent',0.5});
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',...
%       1,'extrapolationRange',{'rangePercent',0.1});
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',...
%       1,'extrapolationRange',{'none'});
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',...
%       1,'extrapolationRange',{'Rsquare'});
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',...
%       1,'extrapolationRange',{'range',1000,1440});
%
%
%   PK=getPKParameters(path_id,simulationIndex,'extrapolationTo0',value_extrapolationTo0)
%       value_extrapolationTo0d (string): specifies the extrapolation method to zero. 
%           'lin': the concentration at t=0 will be calculated by linear
%               extrapolation of the first two points.
%           'log': the concentration at t=0 will be calculated by
%               logarithmic extrapolation of the first two points.
%           'zero': (default) the concentration at t=0 will be assumed as zero
%       Affects PK parameters: PK.AUC_0inf, PK.AUC_0last, PK.AUMC_0inf, PK.MRT, 
%   Example Call:
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',1,'extrapolationTo0','log');
%
%
%   PK=getPKParameters(path_id,simulationIndex,'method',value_method)
%       value_method (string): specifies the method how to calculate AUC. 
%           'lin': linear trapezoidal rule 
%           'log':  logarithmic trapezoidal rule
%       	'linLog' (default): linear before the maximum, log behind
%       Affects PK parameters PK.AUC_last, PK.AUC_0last, PK.AUC_inf, PK.AUC_0inf, 
%           PK.MRT, PK.perc_AUC_lastToInf
%   Example Call:
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',1,'method','lin');
%
%
%   PK=getPKParameters(path_id,simulationIndex,'infusionTime',value_infusionTime)
%       value_infusionTime (double): (default 0) infusion time. 
%       Affects PK parameter: PK.MRT,PK.CL, PK.Vss, PK.Vd
%   Example Call:
%   [cMax,tMax,AUCtend,AUCinf]=getPKParametersForConcentration(...
%           'TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',1,'infusionTime',30);
%
%
%   PK=getPKParameters(path_id,simulationIndex,'LLOQ',value_LLOQ)
%       value_LLOQ (double): (default nan) lower limit of quantification. 
%       Affects PK parameter: PK.tLLOQ
%   Example Call:
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',1,'LLOQ',0.01);
%
%
%   PK=getPKParameters(path_id,simulationIndex,'Dose',value_dose)
%       value_dose (double): (default nan) dose of application. 
%       Affects PK parameter: PK.CL, PK.Vss, PK.Vd
%   Example Call:
%   PK=getPKParameters('TestSim|Organism|PeripheralVenousBlood|MoleculeProperties|Acyclovir|OBSPlasma',1,'Dose',10);
%
% see also INITSIMULATION, GETPKPARAMETERSFORCONCENTRATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 24-Sep-2010

%%
% Check input options
% [rowIndex,timeRange,extrapolationRange,extrapolationTo0,method,infusionTime,LLOQ,Dose] = ...
[rowIndex] = ...
    checkInputOptions(varargin,{...
    'rowIndex',nan,nan,...
    'timeRange',nan,[0 1],...
    'extrapolationRange','{}',{'pointsPercent',0.1},...
    'extrapolationTo0',{'lin','log','zero'},'log',...
    'method',{'lin','log','linLog'},'linLog',...
    'infusionTime','<$ %g>=0 $>',0,...
    'LLOQ','<$ %g>0 $>',nan ...
    'Dose','<$ %g>0 $>',nan ...
    });

% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end

% get Result
[time,concentration]=getSimulationResult(path_id,simulationIndex,'rowIndex',rowIndex);

% calculate PK Parameter
if isempty(varargin)
    PK=getPKParametersForConcentration(time,concentration);
else
    PK=getPKParametersForConcentration(time,concentration,varargin);
end

return


