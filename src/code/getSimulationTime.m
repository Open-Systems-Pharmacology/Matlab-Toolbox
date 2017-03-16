function [time,unit,pattern]=getSimulationTime(simulationIndex)
%GETSIMULATIONTIME Returns the time vector, unit of time and a cell array with the description of the time pattern. 
%
%   time = GETSIMULATIONTIME(simulationIndex)
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%   	time (double): time vector of the general time pattern 
%
%   [time,unit] = GETSIMULATIONTIME(simulationIndex)
%       unit: (string) unit of simulation time.
%
%   [time,unit,pattern] = GETSIMULATIONTIME(simulationIndex)
%       pattern: cellarray with description of the time pattern.
%
% Example Calls:
% [time,pattern] = getSimulationTime(1);
%
% see also INITSIMULATION

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 29-Sep-2010

%% check Inputs --------------------------------------------------------------
global DCI_INFO;

% simulation Index
if ~exist('simulationIndex','var')
    checkInputSimulationIndex(0);
    simulationIndex=1;
else
    checkInputSimulationIndex(simulationIndex);
end

%% evaluation

%get Tab number
iTab=6;

% initialize pattern time vector and unit
pattern=cell(length(DCI_INFO{simulationIndex}.InputTab(iTab).Variables(1).Values)+1,...
    length(DCI_INFO{simulationIndex}.InputTab(iTab).Variables));
unit='';
time=[];

% get pattern time vector and unit
nCol=length(DCI_INFO{simulationIndex}.InputTab(iTab).Variables);
for iPar=1:length(DCI_INFO{simulationIndex}.InputTab(iTab).Variables(1).Values);
    for iCol=1:nCol
        % Header
        if iPar==1
            pattern{1,iCol}=DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Name;
            
            if strcmp('Unit',pattern{1,iCol})
                unit=DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values{iPar};
            end
            
            Values{iCol}=DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values;
            
            colName{iCol}=DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Name;
        end
        % order entry into pattern and save it in structure par
        tmp=Values{iCol}(iPar);
        if iscell(tmp)
            pattern(iPar+1,iCol)=tmp;
            par.(colName{iCol})=tmp{1};
        else
            pattern{iPar+1,iCol}=tmp;
            par.(colName{iCol})=tmp;
        end
    end
    
    % get time values
    if par.NoOfTimePoints==1
        time(end+1)=par.StartTime; %#ok<AGROW>
    else
        switch par.Distribution
            case 'Equidistant'
                time(end+1:end+par.NoOfTimePoints) = ...
                    [par.StartTime:(par.EndTime-par.StartTime)/(par.NoOfTimePoints-1):par.EndTime]; %#ok<NBRAK>
            otherwise
                error('distribution is not implemented yet');
        end
    end
end

% make time vector unique:
time=unique(time);


return
