function PK=getPKParametersForConcentration(time,concentration,varargin)
%GETPKPARAMETERSFORCONCENTRATION Gets PK parameters of a time profile.
%
%   PK=getPKParametersForConcentration(time,concentration)
%       time (double n x 1): time vector
%       concentration (double n x m): concentration vector
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
%               see option infusion time
%           PK.tHalf Half life associated with terminal slope
%
%        If dose is given as option:   
%           PK.CL D/AUC Total body clearance of drug or apparent
%               clearance CL/F (for extravascular application) 
%           PK.VSS = CL*MRT apparent volume of distribution at steady state
%               (use only with IV applications!)
%           PK.Vd (=D/AUC/lambda) Apparent volume of distribution during terminal phase
%               or (Vd/F for extravascular administration)
%       
%       If LLOQ is given as option:
%           PK.tLLOQ Time to reach LLOQ
%
%   Options:
%
%   PK=getPKParametersForConcentration(time,concentration,'timeRange',value_timeRange)
%       value_timeRange (2x1 double vector): specifies the time range, where
%           the calculation is done:
%               first data point: first point >=value_timeRange(1)
%               last data point: last point <=value_timeRange(2)
%           default (range of the given time vector).
%           Affects all PK parameters.
%   Example Call:
%   [cMax]=getPKParametersForConcentration('No/AbsTol',1,'timeRange',[60 120]);
%
%
%   PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',value_extrapolationRange)
%       value_extrapolationRange (cell array): specifies the time range, where
%           the regression is done. default {'pointsPercent',0.1}.
%           possible options are:
%               {'none'}: no extrapolation is done, all depending PK Parameters are nan
%               {'pointsPercent',x} :  x=(double between 0 and 1) 
%                   x is the fraction of the points of the time range which are taken for
%                   the regression. 
%                   example: (time = 0:60, x=0.1 => extrapolation is done from 54:60) 
%               {'rangePercent',x}: x=(double between 0 and 1) the last x
%                   x is the fraction of the time range which are taken for
%                   the regression. For equally distributed points it is
%                   the same as 'pointsPercent'
%                   example: (time = 0:60, x=0.1 => extrapolation is done from 54:60) 
%               {'Rsquare'}: During the calculation the regressions is
%                   repeated using the last three points, then the last four
%                   points, last five, etc. Points prior to Cmax are not
%                   used. Points with a value of zero are excluded. 
%                   For each regression, an adjusted R^2 is computed.
%                   The regression with the largest adjusted R^2 is selected
%                   to estimate lambda.
%               {'range',t1, t2}: (t1,t2, double) Time points for extrapolation 
%                   are between t1 and t2
%           Affects PK parameters: PK.AUC_inf, PK.AUC_0inf, PK.perc_AUC_lastToInf,
%               PK.tHalf, PK.MRT, PK.tLLOQ, PK.AUMC_0inf, PK.AUMC_0inf
%   Example Call:
%   PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'pointsPercent',0.5});
%   PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'rangePercent',0.1});
%   PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'none'});
%   PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'Rsquare'});
%   PK=getPKParametersForConcentration(time,concentration,'extrapolationRange',{'range',1000,1440});
%
%
%   PK=getPKParametersForConcentration(time,concentration,'extrapolationTo0',value_extrapolationTo0)
%       value_extrapolationTo0 (string): specifies the extrapolation method to first point of the timeRange. 
%           see option timeRange
%           'lin': the concentration at t=timeRange(1) will be calculated by linear
%               extrapolation of the first two points.
%           'log': the concentration at t=timeRange(1) will be calculated by
%               logarithmic extrapolation of the first two points.
%           'zero': (default) the concentration at t=timeRange(1) will be assumed as zero
%       Affects PK parameters: PK.AUC_0inf, PK.AUC_0last, PK.AUMC_0inf, PK.MRT, 
%   Example Call:
%   PK=getPKParametersForConcentration(time,concentration,'extrapolationTo0','log');
%
%
%   PK=getPKParametersForConcentration(time,concentration,'method',value_method)
%       value_method (string): specifies the method how to calculate AUC. 
%           'lin': linear trapezoidal rule 
%           'log':  logarithmic trapezoidal rule
%       	'linLog' (default): linear before the maximum, log behind
%       Affects PK parameters PK.AUC_last, PK.AUC_0last, PK.AUC_inf, PK.AUC_0inf, 
%           PK.MRT, PK.perc_AUC_lastToInf
%   Example Call:
%   PK=getPKParametersForConcentration(time,concentration,'method','lin');
%
%
%   PK=getPKParametersForConcentration(time,concentration,'infusionTime',value_infusionTime)
%       value_infusionTime (double): (default 0) infusion time. 
%       Affects PK parameter: PK.MRT,PK.CL, PK.Vss, PK.Vd
%   Example Call:
%   [cMax,tMax,AUCtend,AUCinf]=getPKParametersForConcentration(time,concentration,'infusionTime',30);
%
%
%   PK=getPKParametersForConcentration(path_id,simulationIndex,'LLOQ',value_LLOQ)
%       value_LLOQ (double): (default nan) lower limit of quantification. 
%       Affects PK parameter: PK.tLLOQ
%   Example Call:
%   PK=getPKParametersForConcentration(time,concentration,'LLOQ',0.01);
%
%
%   PK=getPKParametersForConcentration(time,concentration,'Dose',value_dose)
%       value_dose (double): (default nan) dose of application. 
%       Affects PK parameter: PK.CL, PK.Vss, PK.Vd
%   Example Call:
%   PK=getPKParametersForConcentration(time,concentration,'Dose',10);
%
% see also GETPKPARAMETERS

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 25-Sep-2010

%% check Inputs --------------------------------------------------------------
% check mandatory inputs
if ~exist('time','var')
    error('input "time" is missing');
else
    if size(time,1)==1 && size(time,2)>1
        time=time';
    end
end


if ~exist('concentration','var')
    error('input "concentration" is missing');
else
    if size(concentration,1)==1 && size(concentration,2)>1
        concentration=concentration';
    end
    if  size(concentration,1)~=size(time,1)
        if size(concentration,2)==size(time,1)
            concentration=concentration';
        else
            error('Dimensions of time and concentration are inconsistent. Please insert time as n X 1 vector and concentrations as n X nIndividuals');
        end
    end
end

% Check input options
if ~isempty(varargin) && iscell(varargin{1}) %% function is called by getPKParameters
    varargin=varargin{1};
end
[timeRange,extrapolationRange,extrapolationTo0,method,infusionTime,LLOQ,Dose] = ...
    checkInputOptions(varargin,{...
    'timeRange',nan,[time(1) time(end)],...
    'extrapolationRange','{}',{'pointsPercent',0.1},...
    'extrapolationTo0',{'lin','log','zero'},'log',...
    'method',{'lin','log','linLog'},'linLog',...
    'infusionTime','<$ %g>=0 $>',0,...
    'LLOQ','<$ %g>=0 $>',nan ...
    'Dose','<$ %g>=0 $>',nan ...
    });

% check inputs for extrapolation range
if length(extrapolationRange)==1
    extrapolationRange_check=extrapolationRange;
    extrapolationRange_check{2}='';
elseif length(extrapolationRange)==3
    extrapolationRange_check{1}=extrapolationRange{1};
    extrapolationRange_check{2}=[extrapolationRange{2} extrapolationRange{3}];
else
    extrapolationRange_check=extrapolationRange;   
end
checkInputOptions(extrapolationRange_check,{...
    'rangePercent','<$ %g>0 && %g<=1 $>',nan,...
    'pointsPercent','<$ %g>0 && %g<=1 $>',nan,...
    'none','','',...
    'Rsquare','','',...
    'range',nan,nan ...
    });
%


%% Outputs:
nInd=size(concentration,2);
PK.cMax=nan(1,nInd);
PK.tMax=nan(1,nInd);
PK.cMin=nan(1,nInd);
PK.tMin=nan(1,nInd);
PK.AUC_last=nan(1,nInd);
PK.AUC_inf=nan(1,nInd);
PK.AUC_0last=nan(1,nInd);
PK.AUC_0inf=nan(1,nInd);
PK.perc_AUC_lastToInf=nan(1,nInd);
PK.AUMC_last=nan(1,nInd);
PK.AUMC_inf=nan(1,nInd);
PK.AUMC_0last=nan(1,nInd);
PK.AUMC_0inf=nan(1,nInd);
PK.MRT=nan(1,nInd);
PK.tHalf=nan(1,nInd);
PK.CL=nan(1,nInd);
PK.VSS=nan(1,nInd);
PK.Vd=nan(1,nInd);
PK.tLLOQ=nan(1,nInd);

% set warnings
warn_defaults(1)=warning('QUERY', 'MoBiToolbox:Basis:GetPKParameter:RangeTosmall');
warn_defaults(2)=warning('QUERY', 'MoBiToolbox:Basis:GetPKParameter:ZeroValuesInExtrapolationRange');

    
% Loop over all concentration profiles
for iPrf=1:size(concentration,2)

    Y=concentration(:,iPrf);
    
    % Check if there are strange prfiles with values below 0
%     jj=Y >= 0;
%     if ~any(jj)
%         return
%     end
    
    % get the time range
    jj= time>=timeRange(1) & time<=timeRange(end);
%     jj=jj & time>=timeRange(1) & time<=timeRange(end);
    Y=Y(jj);
    X=time(jj);
    if ~any(jj)
        return
    end

    % Cmax
    [PK.cMax(iPrf),tmax_ix]=max(Y);
    PK.tMax(iPrf)=X(tmax_ix);

    % Cmin
    [PK.cMin(iPrf),tmin_ix]=min(Y);
    PK.tMin(iPrf)=X(tmin_ix);

    
    % AUC 0->t1 
    if X(1)>timeRange(1);
        timeStep=X(1)-timeRange(1);
        switch extrapolationTo0
            case 'lin'
                C0=interp1(X,Y,timeRange(1),'linear','extrap');
                AUC_0=timeStep * ((C0-Y(1))/2+Y(1));
            case 'log'
                C0=exp(interp1(X,log(Y),timeRange(1),'linear','extrap'));
                meanValue=Y(1)-C0;
                logValue=log(Y(1)./C0);
                AUC_0=timeStep.*meanValue./logValue;
            case 'zero'
                AUC_0=timeStep*Y(1)/2;
        end
    else
        AUC_0=0;
    end
    
    % AUC t1 ->tmax
    jj=find(X<=PK.tMax(iPrf));
    timeSteps=X(jj(2:end))-X(jj(1:end-1));
    if strcmp(method,'lin') ||  strcmp(method,'linLog')
        meanValues=0.5*(Y(jj(2:end))+Y(jj(1:end-1)));
        AUC_1=sum(timeSteps.*meanValues);
    else
        meanValues=Y(jj(2:end))-Y(jj(1:end-1));
        logValues=log(Y(jj(2:end))./Y(jj(1:end-1)));
        AUC_1=sum(timeSteps.*meanValues./logValues);
    end

    % AUC tmax->tend
    jj=find(X>=PK.tMax(iPrf));
    timeSteps=X(jj(2:end))-X(jj(1:end-1));
    if strcmp(method,'log') ||  strcmp(method,'linlog')
        diffValues=Y(jj(2:end))-Y(jj(1:end-1));
        logValues=log(Y(jj(2:end))./Y(jj(1:end-1)));
        jj_nonzero=abs(logValues)>0;
        AUC_2=sum(timeSteps(jj_nonzero).*diffValues(jj_nonzero)./logValues(jj_nonzero));
        AUC_2=AUC_2+sum(timeSteps(~jj_nonzero).*Y(jj(~jj_nonzero)));
    else
        meanValues=0.5*(Y(jj(2:end))+Y(jj(1:end-1)));
        AUC_2=sum(timeSteps.*meanValues);
    end

    PK.AUC_last(iPrf)=AUC_1+AUC_2;
    PK.AUC_0last(iPrf)=AUC_0+AUC_1+AUC_2;
    

    % First momentum
    YM=Y.*X;
    
    % AUMC 0->t1 
    if X(1)>timeRange(1);
        timeStep=X(1)-timeRange(1);
        meanValue=0.5*(YM(1));
        AUMC_0=timeStep.*meanValue;
    else
        AUMC_0=0;
    end
    
    [~,tmax_ix]=max(YM);
    % AUMC t1 -> tmax
    jj=1:tmax_ix;
    timeSteps=X(jj(2:end))-X(jj(1:end-1));
    if strcmp(method,'lin') ||  strcmp(method,'linLog')
        momentumValues=0.5*(YM(jj(2:end))+YM(jj(1:end-1)));
        AUMC_1=sum(momentumValues.*timeSteps);
    else
        momentumValues=(YM(jj(2:end))-YM(jj(1:end-1)));
        logValues=log(YM(jj(2:end))./YM(jj(1:end-1)));
        AUMC_1=sum(momentumValues.*timeSteps./logValues);
    end
    
    % AUMC tmax->tend
    jj=tmax_ix:length(YM);
    timeSteps=X(jj(2:end))-X(jj(1:end-1));
    if strcmp(method,'log') ||  strcmp(method,'Linlog')
        momentumValues=(YM(jj(2:end))-YM(jj(1:end-1)));
        logValues=log(YM(jj(2:end))./YM(jj(1:end-1)));
        AUMC_2=sum(momentumValues.*timeSteps./logValues);
    else
        momentumValues=0.5*(YM(jj(2:end))+YM(jj(1:end-1)));
        AUMC_2=sum(momentumValues.*timeSteps);
    end
    
    PK.AUMC_last(iPrf)=AUMC_1+AUMC_2;
    PK.AUMC_0last(iPrf)=(AUMC_0+AUMC_1+AUMC_2);

    
    % Extrapolation of the PK
    switch extrapolationRange{1}
        case'none'
            % no extraploation is needed
            lambda=nan;
        case'rangePercent'
            Xmin=(X(1)+(1-extrapolationRange{2})*(X(end)-X(1)));
            win=find(X>=Xmin);
            [lambda,intercept]=extrapolateInRange(X,Y,win);
        case'pointsPercent'
            n=length(X);
            win=n-floor(n*extrapolationRange{2}):n;
            [lambda,intercept]=extrapolateInRange(X,Y,win);
        case 'Rsquare'
            ji=find(X>=PK.tMax(iPrf));
            p=nan(2,length(ji)-1);
            Rsquare=nan(1,length(ji)-2);
            for j=3:length(ji)
                jk=ji(end-j+1:end);
                n=length(jk);
                V=[X(jk) ones(n,1)];
                p(:,j-2)=V\log(Y(jk));
                c=corrcoef(time(jk),log(Y(jk)));
                % adjust R^2
                Rsquare(j-2)=1-(1-c(1,2)^2)*(n-1)/(n-2);
            end
            % take the lambda with the largest R^2
            [~,imaxR]=max(Rsquare);
            lambda=-1*p(1,imaxR);
            intercept=exp(p(2,imaxR));

        case 'range'
            win=find(X>=extrapolationRange{2} & extrapolationRange{3}>=X);
            [lambda,intercept]=extrapolateInRange(X,Y,win);

    end

    if lambda>0

        % t 1/2
        PK.tHalf(iPrf)=log(2)/lambda;
        
        
        % AUC tend->inf
        C_last=intercept*exp(-lambda*X(end));
        AUC_3=C_last/lambda;
        
        % AUC ->oo
        PK.AUC_inf(iPrf)=AUC_1+AUC_2+AUC_3;
        PK.AUC_0inf(iPrf)=AUC_0+AUC_1+AUC_2+AUC_3;
        
        PK.perc_AUC_lastToInf(iPrf)=AUC_3/(AUC_0+AUC_1+AUC_2+AUC_3)*100;

        
        % t_LLOQ
        if ~isnan(LLOQ)
            if Y(end)<LLOQ
                [~,t_LLOQ_ix]=min(abs(Y-LLOQ));
                PK.tLLOQ=time(t_LLOQ_ix);
            else
                PK.tLLOQ=log(intercept/LLOQ)/lambda;
            end
        end
        
        
        % AUMC tmax->tend
        AUMC_3=X(end)*C_last/lambda+C_last/lambda.^2;
        
        % AUMC ->oo
        PK.AUMC_inf(iPrf)=AUMC_1+AUMC_2+AUMC_3;
        PK.AUMC_0inf(iPrf)=AUMC_0+AUMC_1+AUMC_2+AUMC_3;

        % mean residence time
        PK.MRT(iPrf)=(AUMC_0 + AUMC_1 + AUMC_2 + AUMC_3)...
            /(AUC_0 + AUC_1 + AUC_2 + AUC_3) - infusionTime/2;
        
        if ~isnan(Dose)
            PK.CL(iPrf)=Dose./PK.AUC_0inf(iPrf);
            PK.VSS(iPrf)=PK.CL(iPrf).*PK.MRT(iPrf);
            PK.Vd(iPrf)=Dose./PK.AUC_0inf(iPrf)./lambda;
        end

    end
        
end

% reset warning
for iWarn=1:length(warn_defaults)
    warning(warn_defaults(iWarn).state, 'MoBiToolbox:Basis:GetPKParameter:RangeTosmall');
end

return


function [lambda,intercept]=extrapolateInRange(X,Y,win)

lambda=nan;
intercept=nan;


n=length(win);
if length(win)<3
    warning('MoBiToolbox:Basis:GetPKParameter:RangeTosmall',...
        'The extrapolation range is to small, only %d points',n);
    warning('off', 'MoBiToolbox:Basis:GetPKParameter:RangeTosmall');
end

if any(Y(win)<=0)
    warning('MoBiToolbox:Basis:GetPKParameter:ZeroValuesInExtrapolationRange',...
        'There are values below or equal 0 in the extrapolation Range!')
    warning('off', 'MoBiToolbox:Basis:GetPKParameter:ZeroValuesInExtrapolationRange');
else
    p=polyfit(X(win) ,log(Y(win)),1);
%     V=[X(win) ones(n,1)];
%     p=V\log(Y(win));
    lambda=-1*p(1);
    intercept=exp(p(2));
end
