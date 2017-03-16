function PI=initParameterIdentificationForOSPSuiteExport(PI_xml,simulationList)
% INITPARAMETERIDENTIFICATIONFOROSPSUITEEXPORT initialize the exported parameter identification
% 
% this function uses as input the xmls exported from the OSPSuite. It
% generates a structure PI which is used to solve the problem and
% initializes all simulations.
%
% PI=initParameterIdentificationForOSPSuiteExport(PI_xml,simulationList)
%
%  PI (structure) 
%    .par (sturcture) settings for parameter
%    .output (structure) settings for simulation outputs and corresponding observed data
%    .configuration (structure) settings for configuration settings

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 10-Mai-2016

% read xml file
PI_struct=readXMLStructure(PI_xml);

% get parameter structure
tmp=PI_struct.ParameterIdentification.IdentificationParameterList.IdentificationParameter;
for iPar=1:length(tmp)
    PI.par(iPar)=addParameterStructure(tmp(iPar),simulationList);
end

% initialize models
for iSim=1:length(simulationList)
    
    % set structure with corresponding parameters
    initStruct=[];
    for iPar=1:length(PI.par)
        jj=iSim==PI.par(iPar).simIndex;
        for iPs=find(jj)
            initStruct=initParameter(initStruct,PI.par(iPar).path_id{iPs},'withWarning');
        end
    end
    
    initSimulation(simulationList{iSim},initStruct,'addFileAtIndex',iSim);
    
end
% set Unit
for iPar=1:length(PI.par)
    if ~PI.par(iPar).useAsFactor
        for iPs=1:length(PI.par(iPar).path_id)
            units{iPs}=getParameter(PI.par(iPar).path_id{iPs},PI.par(iPar).simIndex(iPs),'parametertype','readonly','property','Unit'); %#ok<AGROW>
        end
        units=unique(units);
        PI.par(iPar).unit=strjoin(units,'/');
    end
end

% get Output structure
tmp=PI_struct.ParameterIdentification.OutputMappingList.OutputMapping;
for iO=1:length(tmp)
    PI.output(iO)=addOutputStructure(tmp(iO),simulationList);
end

% get Configuration
PI.configuration=PI_struct.ParameterIdentification.Configuration;

% do a first evaluation set rowindices
[resid,PI]=getPIWeightedResidualsForOSPSuiteExport([PI.par.startValue],PI);
if isnan(resid)
    error('it is not possible to run parameter identification with start values');
end

return

function output=addOutputStructure(output,simulationList)

% convert to numeric if possible
fn=fieldnames(output);
for iFn=1:length(fn)
    tmp=str2double(output.(fn{iFn}));
    if ~isnan(tmp)
        output.(fn{iFn})=tmp;
    end
end


% get corresponding simulation
output.path_id=output.Output.path;
tmp=regexp(output.path_id,'\|','split');
output.simIndex=find(ismember(strrep(simulationList,'.xml',''),tmp{1}));

% initialize rowindices for fast processing
output.rowIndex=nan;

%get Data properties
output.data_name=output.ObservedData.name;
output.lloq=str2double(output.ObservedData.lloq);
output.data_time=str2double({output.ObservedData.PointList.Point(:).time});
output.data_value=str2double({output.ObservedData.PointList.Point(:).value});
output.data_weight=str2double({output.ObservedData.PointList.Point(:).weight});

% transfer Units
if ~strcmp(output.ObservedData.dimension,output.Output.dimension) 
    if strcmp(output.ObservedData.dimension,'Concentration (mass)') && ...
        strcmp(output.Output.dimension,'Concentration (molar)')
        output.data_value=output.data_value./str2double(output.ObservedData.molWeight);
    else
        error('output %s and data %s have different dimensions!',output.path_id,output.data_name);
    end
end
% set Unit
if existsObserver(output.path_id,output.simIndex)
    output.unit=getObserverFormula(output.path_id,output.simIndex,'property','Unit');
elseif existsSpeciesInitialValue(output.path_id,output.simIndex,'paramtertype','readonly');
    output.unit=existsSpeciesInitialValue(output.path_id,output.simIndex,'paramtertype','readonly','property','Unit');
end
        
        
% shorten structur
output=rmfield(output,'Output');
output=rmfield(output,'ObservedData');

return

function par=addParameterStructure(par,simulationList)

% convert to numeric if possible
fn=fieldnames(par);
for iFn=1:length(fn)
    tmp=str2double(par.(fn{iFn}));
    if ~isnan(tmp)
        par.(fn{iFn})=tmp;
    end
end


% shorten simulation parameter list
par.path_id={par.SimulationParameterList.SimulationParameter.path};
par=rmfield(par,'SimulationParameterList');

% translate names
par.path_id=strrep(par.path_id,'&lt;-&gt;','<->');

% prepare new fields
for iPt=1:length(par.path_id)
    % get corresponding simulation
    tmp=regexp(par.path_id{iPt},'\|','split');
    par.simIndex(iPt)=find(ismember(strrep(simulationList,'.xml',''),tmp{1}));
        
    % initialize rowindices for fast processing
    par.rowIndex(iPt)=nan;
    
end

% initialize Unit
par.unit='';

% initialize best value
par.finalValues=nan;


return