function [isCanceled,individualParameters] = PKSimCreateIndividual(species, population, gender, age, weight, height, BMI,...
    xmlFile,simulationIndex,useDistribution, gestational_age)
%PKSIMCREATEINDIVIDUAL Creates physiology parameters of an mean individual
%
%   individualParameters = PKSimCreateIndividual(species, population, gender, age, weight, height, ...
%                                                      xmlFile,simulationIndex)
%       species (string) : Beagle,Dog,Human,Minipig,Monkey,Mouse,Rat
%       population (string or double): only for species Human,
%               European_ICRP_2002=0,WhiteAmerican_NHANES_1997=1,BlackAmerican_NHANES_1997=2
%               MexicanAmericanWhite_NHANES_1997=3,Asian_Tanaka_1996=4,
%               Preterm=5, Japanese_Population=6
%       gender (string or double) MALE=1,FEMALE=2; for animals the gender is ignored
%       age (double , unit years)
%       weight (double, unit kg)
%       height (double, unit dm)
%       BMI (double, unit kg/dm^2)
%       xmlFile (string) path of the simulation file, -> generate surface area calculation method and ontogeny information
%           file will be new initialized, if xml is empty, and
%           simulationIndex = nan, default surface area calculation is
%           taken, and no ontogenies are generated
%       simulationIndex (double), default 1, if xmlFile is empty, an already initialized simulation file
%               with the corresponding simulationIndex will be taken for
%               the ontogeny and surface Area calculation method evaluation
%       useDistribution (boolean) default false: Set to true, the physiological parameter will be
%       randomly distributed otherwise, a mean individual will be created
%
%       isCanceled (boolean) if true function was aborted
%       individualParameters: (structure) fields:
%               path_id (string) path of the parameter
%               Value (double) value of the parameter
%       gestational_age (double) gestational age in weeks at birth, only
%                relevant for preterm, default 40)


% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 16-jan-2012

%% check inputs
if ~exist('useDistribution','var')
    useDistribution=false;
end

% species
speciesList={'Beagle','Dog','Human','Minipig','Monkey','Mouse','Rat'};
jj=strcmpi(speciesList,species);
if ~any(jj)
    error('unknown species %s',species);
else
    species=speciesList{jj};
end

% Population
population_list={'European_ICRP_2002','WhiteAmerican_NHANES_1997','BlackAmerican_NHANES_1997',...
    'MexicanAmericanWhite_NHANES_1997','Asian_Tanaka_1996','Preterm','Japanese_Population'};
if strcmp(species,'Human');
    if isempty(population)
        population=population_list{1};
    elseif isnumeric(population)        
        population=population_list{population+1};
    else
        jj=strcmpi(population_list,population);
        if ~any(jj)
            error('unknown population %s',population);
        else
            population=population_list{jj};
        end
    end
else
    population=species;
    gender='UNKNOWN';
end
% Gender
genderText={'MALE','FEMALE','UNKNOWN'};
if isnumeric(gender)
    gender=genderText{gender};
else
    jj=strcmpi(genderText,gender);
    if ~any(jj)
        error('unknown Gender %s',gender);
    else
        gender=genderText{jj};
    end
end

% height, weight, BMI
if sum(isnan([height, weight,BMI]))>1
    error('There must be at least 2 out of the parameters height weight and BMI not nan!')
elseif  sum(isnan([height, weight,BMI]))==0
    BMI_calc=weight/(height)^2;
    if BMI_calc-BMI>0.005
        warning('MoBiToolbox:BasisToolbox:CreateIndvidualInconsitentData',...
            'The data are inconsitent (BMI,Weight and Height)!');
    end
elseif isnan(height)
    height=sqrt(weight/BMI);
elseif isnan(weight)
    weight=BMI*(height)^2;
end


%Simulation file
if isempty(xmlFile) && isnan(simulationIndex)
    % take default method and no ontogenies
    endothelialSurfaceAreaCalculationMethod='SurfaceAreaPlsInt_VAR1';
    onto_path={};
else
    if ~isempty(xmlFile)
        initSimulation(xmlFile,'none','report','none','addFileAtIndex',simulationIndex);
        %     simulationIndex=1;
    else
        checkInputSimulationIndex(simulationIndex);
    end
    % endothelialSurfaceAreaCalculationMethod
    path_id='*|Neighborhoods|*_pls_*_int|Surface area (plasma/interstitial)';
    if existsParameter(path_id,simulationIndex,'parametertype','readOnly');
        tmp=getParameter(path_id,1,'Property','Formula','parametertype','readOnly');
        switch tmp{1}
            case 'k * f_vas_org * V_org'
                endothelialSurfaceAreaCalculationMethod='SurfaceAreaPlsInt_VAR1';
            case 'k * Q_org ^ beta'
                endothelialSurfaceAreaCalculationMethod='SurfaceAreaPlsInt_VAR3';
            otherwise
                endothelialSurfaceAreaCalculationMethod='SurfaceAreaPlsInt_VAR1';
        end
    else
        warning('MoBiToolbox:BasisToolbox:UnkownEndothelialSurfaceAreaMethode',...
            'The endothelial surface area calculation method is not known, take default!');
        endothelialSurfaceAreaCalculationMethod='SurfaceAreaPlsInt_VAR1';
    end
    
    % ontogeniesInfo
    [ise,descr]=existsParameter('*Ontogeny factor GI',simulationIndex,'parameterType','readOnly');
    if ise
        jCol=strcmpi(descr(1,:),'Path');
        onto_path=descr(2:end,jCol);
    else
        onto_path={};
    end
end

%%
try
    individualParameters=[];
    
    isCanceled = loadPKSimMatlabDLL;
    if isCanceled
        return
    end
    
    IndividualFactory=PKSim.Matlab.MatlabIndividualFactory;
    
    %set gestational age to default if not passed as parameter
    if ~exist('gestational_age', 'var')
        gestational_age = PKSim.Core.CoreConstants.NOT_PRETERM_GESTATIONAL_AGE_IN_WEEKS;
    end

    %---- create origin data
    originData=PKSim.Core.Batch.OriginData;
    originData.Species=species;
    originData.Population=population;
    originData.Gender=gender;
    originData.Age=age;
    originData.GestationalAge=gestational_age;
    originData.Weight=weight;
    originData.Height=height;
    originData.AddCalculationMethod('SurfaceAreaPlsInt',endothelialSurfaceAreaCalculationMethod);
    
    %---- create NET array with required ontogenies
    if ~isempty(onto_path)
        ontogenies=NET.createArray('PKSim.Matlab.MoleculeOntogeny', length(onto_path));
        
        for iO=1:length(onto_path)
            jj_tmp=strfind(onto_path{iO},object_path_delimiter);
            
            Molecule=onto_path{iO}(jj_tmp(end-1)+1:jj_tmp(end)-1);

            % at the moment, "Ontogeny like" is set = "Molecule"
            %later, this can be changed
            ontogeny = PKSim.Matlab.MoleculeOntogeny(Molecule, Molecule);
            
            ontogenies(iO) = ontogeny;
        end
        
    else
        ontogenies=NET.createArray('PKSim.Matlab.MoleculeOntogeny', 0);
    end
    
    if useDistribution
        %---- create new individual
        result=IndividualFactory.DistributionsFor(originData, ontogenies);
        
        %---- convert returned values (NET array) into matlab struct array
        for idx=1:result.Length
            individualParameters(idx).path_id=char(result(idx).ParameterPath);  %#ok<AGROW>
            individualParameters(idx).Value=result(idx).Value; %#ok<AGROW>
            individualParameters(idx).Mean=result(idx).Mean; %#ok<AGROW>
            individualParameters(idx).Std=result(idx).Std; %#ok<AGROW>
            individualParameters(idx).DistributionType=char(result(idx).DistributionType.DisplayName); %#ok<AGROW>
        end
    else
        %---- create new individual
        result=IndividualFactory.CreateIndividual(originData, ontogenies);
        
        %---- convert returned values (NET array) into matlab struct array
        for idx=1:result.Length
            individualParameters(idx).path_id=char(result(idx).ParameterPath);  %#ok<AGROW>
            individualParameters(idx).Value=result(idx).Value; %#ok<AGROW>
        end
    end
    
    
catch e
    if(isa(e, 'NET.NetException'))
        eObj = e.ExceptionObject;
        error(char(eObj.ToString));
    else
        rethrow(e);
    end
end



