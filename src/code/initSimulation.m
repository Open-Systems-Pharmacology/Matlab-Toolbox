function initSimulation(XML,variableParameters,varargin)
%INITSIMULATION Initializes an XML file.
%
%   INITSIMULATION(XML, variableParameters)
%       XML (string): full or relative path name of the XML file
%       variableParameters (string or structure): Defines the parameters which should be variable:
%           - 'all'
%               all parameters and species inititial values are set to variable.
%           - 'none'
%               no parameter and species inititial values is set to variable.
%           - 'allNonFormula'
%               all parameters and species inititial values which are not described by a formula 
%                      are set to variable.
%          - a strcuture
%               all parameters and species inititial values defined in this structure
%               are set to variable.
%               For how to generate the structure, see initParameter, initSpeciesInitialValue.
%
%   Options:
%
%   INITSIMULATION(XML, variableParameters,'addFile',value_addFile)
%       value_addFile (boolean): 
%           - false (default). 
%           - true  The simulation is added to the so far initialized simulations. 
%                   All initialized simulations can be reached simultaneously. 
%                   The simulations are identified by a simulationIndex which is 
%                   incremented by 1 with each initialization. 
%
%   INITSIMULATION(XML, variableParameters,'addFileAtIndex',value_addFileAtIndex)
%       value_addFileAtIndex (double): simulationIndex, Integer between 1 and maximal number of simulations previous initialized +1 
%                   All initialized simulations can be reached simultaneously. 
%                   The simulations are identified by a simulationIndex which is 
%                   incremented by 1 with each initialization. 
%
%   INITSIMULATION(XML, variableParameters,'report',value_report)
%       value_report(string):
%             - none:  no report is generated
%             - short (default): a short summary is given on the number of
%                      variable parameters and variable species
%             - long:  all variable parameters are listed with all properties
%
%   INITSIMULATION(XML, variableParameters,'stopOnWarnings',value_stopOnWarnings)
%       value_stopOnWarnings: (boolean) 
%              - true (default): simulation will stop on ODE solver warnings
%              - false : ignores ODE solver warnings
% 
%   INITSIMULATION(XML, variableParameters,'ExecutionTimeLimit',value_ExecutionTimeLimit)
%       value_ExecutionTimeLimit: (double)
%              - Execution time limit [CPU s] for single simulation run
%              - 0 = no limit (default)
%
%   INITSIMULATION(XML, variableParameters,'pathsArePoppaths',value_pathsArePoppaths)
%       value_pathsArePoppaths: (boolean)
%              - true Parameter paths are interpreted as pop paths (used by
%                       PK-SIM Population Simulation)
%              - false (default)
%
% Examples calls:
%   initSimulation('examples\SimModel4_ExampleInput06.xml', initStruct);
%   initSimulation('examples\SimModel4_ExampleInput06.xml', 'allnonformula', 'addFile', true, 'ExecutionTimeLimit',100);
%   initSimulation('examples\SimModel4_ExampleInput06.xml', 'allnonformula', 'report', 'none', 'stopOnWarnings',false);
% 
% see also INITPARAMETER, INITSPECIESINITIALVALUE

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 16-Sep-2010


global DCI_INFO;
global MOBI_SETTINGS;

% Are the MoBipaths already set?
if isempty(MOBI_SETTINGS)
    MoBiSettings;
end

%% check Inputs --------------------------------------------------------------
% check mandatory inputs
if ~exist('XML','var')
    error('input "XML" is missing');
else
    if ~exist(XML,'file')
        error('XML %s does not exist',XML);
    end
    %replace os-specific file separators
    XML=strrep(XML,'/',filesep);
    XML=strrep(XML,'\',filesep);
    
end
if ~exist('variableParameters','var')
    error('input "variableParameters" is missing');
else
    iniAllParameters=false;
    iniAllNonFormulaParameters=false;
    iniNoneParameters=false;
    iniStructure=false;
    
    if ischar(variableParameters)
        ij=find(strcmpi(variableParameters,{'none','all','allNonFormula'}));
        if isempty(ij)
            error('wrong input for variableParameters %s; please use "none", "all", "allnonFormula" or a valid structure',variableParameters);
        end
        switch ij
            case 1
                iniNoneParameters=true;
            case 2
                iniAllParameters=true;
            case 3
                iniAllNonFormulaParameters=true;
        end
    elseif isstruct(variableParameters) 
        iniStructure=true;
    elseif isempty(variableParameters)
        iniNoneParameters=true;
    else
        error('wrong input for variable_parameters  please use none, all, allnonFormula or a valid structure');
    end
end

% Check input options
[report,addFile,stopOnWarnings,executionTimeLimit,pathsArePoppaths,addFileAtIndex] = ...
    checkInputOptions(varargin,{...
    'report',{'none','short','long'},'short',...
    'addFile',[true false],false,...
    'stopOnWarnings',[true false],true,...
    'ExecutionTimeLimit','<$ %g>=0 $>',0,...
    'pathsArePoppaths',[true false],false,...
    'addFileAtIndex',nan,nan,....
    });

% 
if ~isnan(addFileAtIndex) && addFileAtIndex>length(DCI_INFO)+1
    error('The simulation Index must be within the range 1-%d',length(DCI_INFO)+1);
end
    

%% read and configure XML

if strcmp(report,'short') || strcmp(report,'long')
    disp(sprintf('Initialisation of %s', XML)); %#ok<*DSPS>
end

% clear memory
if ~addFile && isnan(addFileAtIndex)
    feval(MOBI_SETTINGS.MatlabInterface,'DestroyAllComponents');
    DCI_INFO=[];
    simulationIndex=1;
elseif addFile
    simulationIndex=length(DCI_INFO)+1;
else
    simulationIndex=addFileAtIndex;
end

%Create the component
DCI_INFO{simulationIndex}.Handle = feval(MOBI_SETTINGS.MatlabInterface,'LoadComponent', MOBI_SETTINGS.SimModelComp);

%Get parameter table
ConfigTab = feval(MOBI_SETTINGS.MatlabInterface,'GetParameterTable',DCI_INFO{simulationIndex}.Handle,1);

%Simulation Schema
jj=strcmp('SimModelSchema',{ConfigTab.Variables.Name});
ConfigTab.Variables(jj).Values={MOBI_SETTINGS.SimModelSchema};

%Simulation File
jj=strcmp('SimulationFile',{ConfigTab.Variables.Name});
ConfigTab.Variables(jj).Values={XML};

% Stop on Solver warnings
jj=strcmp('StopOnWarnings',{ConfigTab.Variables.Name});
if stopOnWarnings
    ConfigTab.Variables(jj).Values=1;
else
    ConfigTab.Variables(jj).Values=0;
end

% Execution time Limit
jj=strcmp('ExecutionTimeLimit',{ConfigTab.Variables.Name});
ConfigTab.Variables(jj).Values=executionTimeLimit;

%Set parameter table into the component and configure
ret = feval(MOBI_SETTINGS.MatlabInterface,'SetParameterTable',DCI_INFO{simulationIndex}.Handle,1,ConfigTab);
if ret==0
    errmsg=feval(MOBI_SETTINGS.MatlabInterface,'GetLastError');
    error('Error in Configure: %s',errmsg);
end

ret = feval(MOBI_SETTINGS.MatlabInterface,'Configure',DCI_INFO{simulationIndex}.Handle);
if ret==0
    errmsg=feval(MOBI_SETTINGS.MatlabInterface,'GetLastError');
    error('Error in Configure: %s',errmsg);
end



%% Initialize Parameters
% Number of Input Tabs:
TableArray=feval(MOBI_SETTINGS.MatlabInterface,'GetInputTables',DCI_INFO{simulationIndex}.Handle);

% save Table Array to correct DCIInterface Error (Formulas is not correct)
TableArray_old=TableArray;
    


% add model name to poppaths
if pathsArePoppaths
    jCol=strcmp('Path',{TableArray(2).Variables.Name});
    tmp=regexp(TableArray(2).Variables(jCol).Values(1),['\' object_path_delimiter],'split');
    for iP=1:length(variableParameters.Parameters)
        variableParameters.Parameters(iP).path_id=...
            strcat(tmp{1}{1},object_path_delimiter,variableParameters.Parameters(iP).path_id);
    end
end

for iTab=[2 4]
    
    % column indices
    iCol_isV=find(strcmp('IsVariable',{TableArray(iTab).Variables.Name}));
    iCol_isP=find(strcmp('ParameterType',{TableArray(iTab).Variables.Name}));
    if isempty(iCol_isP) % Old version of DCI Component and Species Initial values
        iCol_isF=find(strcmp('IsFormula',{TableArray(iTab).Variables.Name}));
    else
        iCol_isF=[];
    end
    
    % all Parameters are initialized:
    if iniAllParameters
        TableArray(iTab).Variables(iCol_isV).Values(:) = 1;
        % only non Formulas are initialized
    elseif iniAllNonFormulaParameters
        if isempty(iCol_isP)
            jj_noFormula=~TableArray(iTab).Variables(iCol_isF).Values(:);
        else
            jj_noFormula=~strcmp(TableArray(iTab).Variables(iCol_isP).Values(:),'Formula');
        end
        TableArray(iTab).Variables(iCol_isV).Values(jj_noFormula) = 1;
    elseif iniNoneParameters
    elseif iniStructure                     
        TableArray(iTab)=initParameterStruct(variableParameters,TableArray(iTab),iTab,iCol_isV,iCol_isF,XML,iCol_isP);
    end
    
    %report
    if strcmp(report,'short')
        nAll=sum(TableArray(iTab).Variables(iCol_isV).Values(:));
        if isempty(iCol_isP)
            nIsFormula=sum(TableArray(iTab).Variables(iCol_isF).Values(:).*TableArray(iTab).Variables(iCol_isV).Values(:));
            disp(sprintf('Number of %s: %d, with formulas: %d ',TableArray(iTab).Name,nAll,nIsFormula));
        else
            nIsFormula=sum(strcmp(TableArray(iTab).Variables(iCol_isP).Values(:),'Formula').*(TableArray(iTab).Variables(iCol_isV).Values(:)==1));
            nIsTable=sum(strcmp(TableArray(iTab).Variables(iCol_isP).Values(:),'Table').*(TableArray(iTab).Variables(iCol_isV).Values(:)==1));
            disp(sprintf('Number of %s: %d, with formulas: %d, table parameters: %d',TableArray(iTab).Name,nAll,nIsFormula,nIsTable));
        end
    elseif strcmp(report,'long')
         nAll=sum(TableArray(iTab).Variables(iCol_isV).Values(:));
        description=cell(nAll+1,...
            length(TableArray(iTab).Variables)-1);
        jj=TableArray(iTab).Variables(iCol_isV).Values==1;
        if any(jj)
            disp(sprintf('%s:',TableArray(iTab).Name));
            for iCol=1:length(TableArray(iTab).Variables)-1
                description{1,iCol}=TableArray(iTab).Variables(iCol).Name;
                tmp=TableArray(iTab).Variables(iCol).Values(jj);
                if iscell(tmp)
                    description(2:end,iCol)=tmp;
                else
                    description(2:end,iCol)=num2cell(tmp);
                end
            end
            disp(description);
        else
            disp(sprintf('%s: nothing initialized',TableArray(iTab).Name));
        end  
    end
    
    %Save input table into the component
    feval(MOBI_SETTINGS.MatlabInterface,'SetInputTable',DCI_INFO{simulationIndex}.Handle,iTab,TableArray(iTab));
    
end

%% ProcessMetaData
%leaves only parameters/species specified by user for optimization
ret = feval(MOBI_SETTINGS.MatlabInterface,'processmetadata',DCI_INFO{simulationIndex}.Handle);
if ret==0
    errmsg=feval(MOBI_SETTINGS.MatlabInterface,'GetLastError');
    error('Error in ProcessMetaData: %s',errmsg);
end

%get final input tables
for iTab=1:size(TableArray,2)
    DCI_INFO{simulationIndex}.InputTab(iTab)= feval(MOBI_SETTINGS.MatlabInterface,'GetInputTable',DCI_INFO{simulationIndex}.Handle,iTab);
end

% correct DCIInterface Error (Formulas is not correct)
cols={'ParameterType','IsFormula','Formula'};
for iTab=1:4
    InputTab= DCI_INFO{simulationIndex}.InputTab(iTab);
    [ise,loc]= ismember(TableArray_old(iTab).Variables(1).Values,InputTab.Variables(1).Values);
    
    if ~isempty(InputTab.Variables(1).Values)
        if  all(InputTab.Variables(1).Values==TableArray_old(iTab).Variables(1).Values(ise))
            for iC=1:length(cols)
                iCol=find(strcmp(cols{iC},{InputTab.Variables.Name}));
                if ~isempty(iCol)
                    InputTab.Variables(iCol).Values=TableArray_old(iTab).Variables(iCol).Values(ise);
                end
            end
            DCI_INFO{simulationIndex}.InputTab(iTab)=InputTab;
        else
            disp('there might be something strange with the Formula information');
        end
    end
end

% Save Reference Tables
for iTab=[2 4 9]
    DCI_INFO{simulationIndex}.ReferenceTab(iTab) = DCI_INFO{simulationIndex}.InputTab(iTab);
end

% set XML Version
tmp=str2double(feval(MOBI_SETTINGS.MatlabInterface,'Invoke', DCI_INFO{simulationIndex}.Handle, 'GetXMLVersion'));
if isnan(tmp)
    tmp=2;
%     error('xml version is not numeric');
end
DCI_INFO{simulationIndex}.XMLVersion = tmp;
iniUnitList(-1,DCI_INFO{simulationIndex}.XMLVersion);

return

%%
function TableArray=initParameterStruct(initStruct,TableArray,iTab,iCol_isV,iCol_isF,XML,iCol_isP)
        
global DCI_INFO;
        
% select the structure of the Table
if iTab==2
    tmpStruct=initStruct.Parameters;
    warningtxt='The parameter ID=%g, path=%s is defined as Formula: "%s" ';
    errortxt=[warningtxt  '!' char(10) 'If you want to initialize this paramater '...
        'do not use option "never" for the function initParameter!'] ;
elseif iTab==4
    tmpStruct=initStruct.InitialValues;
    warningtxt='The species initial value ID=%g, path=%s is defined as Formula: "%s" ';
    errortxt=[warningtxt '!' char(10) 'If you want to initialize this  species initial value  '...
        'do not use option "never" for the function initSpeciesInitialValue!'] ;
end

% set the table to DCI_INFO
%(the function findTableIndex works with DCI_INFO)
DCI_INFO{end}.InputTab(iTab)= TableArray;

iCol_F=find(strcmp('Formula',{TableArray.Variables.Name}));
simulationIndex=length(DCI_INFO);

for iP=1:length(tmpStruct)
    
    rowIndex=findTableIndex(tmpStruct(iP).path_id,iTab,simulationIndex);
    
    if tmpStruct(iP).throwWarningIfNotExisting && isempty(rowIndex)
        warning('MoBiToolbox:Basis:NoteExistingParameterInitialization',...
                    'The parameter path=%s does not exist in the simulation %s',...
                    tmpStruct(iP).path_id,XML);
    end
    
    switch tmpStruct(iP).initializeIfFormula
        case 'always'
            TableArray.Variables(iCol_isV).Values(rowIndex) = 1;
        case 'withWarning'
            TableArray.Variables(iCol_isV).Values(rowIndex) = 1;
            if ~isempty(iCol_isF)
                ji_Formula=find(TableArray.Variables(iCol_isF).Values(rowIndex));
            else
                ji_Formula=find(strcmp(TableArray.Variables(iCol_isP).Values(rowIndex),'Formula'));
            end                
            for iF=ji_Formula'
                warning('MoBiToolbox:Basis:FormulaParameterInitialization',...
                    [warningtxt ' however it is  initialized!'],...
                    TableArray.Variables(1).Values(rowIndex(iF)),...
                    TableArray.Variables(2).Values{rowIndex(iF)},...
                    TableArray.Variables(iCol_F).Values{rowIndex(iF)});
            end
        case 'never'
            
            if ~isempty(iCol_isF)
                jj_Formula=TableArray.Variables(iCol_isF).Values(rowIndex);
            else
                jj_Formula=strcmp(TableArray.Variables(iCol_isP).Values(rowIndex),'Formula');
            end 
            TableArray.Variables(iCol_isV).Values(rowIndex(~jj_Formula)) = 1;
            
            for iF=find(jj_Formula)'
                error('MoBiToolbox:Basis:FormulaParameterInitialization',errortxt,...
                    TableArray.Variables(1).Values(rowIndex(iF)),...
                    TableArray.Variables(2).Values{rowIndex(iF)},...
                    TableArray.Variables(iCol_F).Values{rowIndex(iF)});
            end

    end
end

return
