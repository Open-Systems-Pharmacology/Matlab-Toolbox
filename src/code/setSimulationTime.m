function setSimulationTime(timepoints_pattern,simulationIndex)
%SETSIMULATIONTIME Sets the simulation time.
%
%   SETSIMULATIONTIME(timepoints_pattern,simulationIndex)
%       timepoints_pattern (double) timevector
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%
% Example Calls:
% setSimulationTime(0:100,1);
%
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


% delete old lines
for iCol=1:length(DCI_INFO{simulationIndex}.InputTab(iTab).Variables)
    if iscell(DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values)
        DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values = {};
    else
        DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values=[];
    end
end

% if time is given as pattern
if iscell(timepoints_pattern)
    for iP=2:size(timepoints_pattern,1)
        addTimePattern(timepoints_pattern{iP,1},timepoints_pattern{iP,2},timepoints_pattern{iP,4},timepoints_pattern{iP,3},simulationIndex)
    end
else
    %     time is given as a vector
    
    % get Unit
    [~,baseUnit]=getSimulationTime(simulationIndex);

    % sort and unify time;
    timepoints=unique(timepoints_pattern);
    
    % search for equidistant points
    while length(timepoints)>1
        deltaT=timepoints(2:end)-timepoints(1:end-1);
        ij=find(abs(deltaT-deltaT(1))/deltaT(1)>0.000001,1);
        if isempty(ij)
            addTimePattern(timepoints(1),timepoints(end),length(timepoints),baseUnit,simulationIndex);
            timepoints=[];
        else
            addTimePattern(timepoints(1),timepoints(ij),ij,baseUnit,simulationIndex);
            timepoints=timepoints(ij+1:end);
        end
    end
    if  length(timepoints)==1
        addTimePattern(timepoints(1),timepoints(1),1,baseUnit,simulationIndex);
    end
end

return


function addTimePattern(startTime,endTime,noOfTimePoints,baseUnit,simulationIndex)
%ADDTIMEPATTERN Adds a new line to the general time pattern
%
%       startTime (double) first time point
%       endTime (double) last time point
%       noOfTimePoints (double) number of time points
%       Time Unit
%       simulationIndex (integer)
%           index of the simulation (see initSimulation option 'addFile')
%

%% check Inputs --------------------------------------------------------------
global DCI_INFO;

%get Tab number
iTab=6;


% set new lines
for iCol=1:length(DCI_INFO{simulationIndex}.InputTab(iTab).Variables)
    switch DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Name
        case 'StartTime'
            DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values(end+1)=startTime;
        case 'EndTime'
            DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values(end+1)=endTime;
        case 'NoOfTimePoints'
            DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values(end+1)=noOfTimePoints;
        case 'Distribution'
            DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values{end+1}='Equidistant';
        case 'Unit' 
            DCI_INFO{simulationIndex}.InputTab(iTab).Variables(iCol).Values{end+1}=baseUnit;
    end
end


return
