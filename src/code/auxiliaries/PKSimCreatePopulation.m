function [isCanceled, individuals] = PKSimCreatePopulation(populationSettings)
%PKSIMCREATEPOPULATION Creates physiology parameters of a population
%
%   [isCanceled, individuals] = PKSimCreatePopulation(populationSettings)
%
%       populationSettings (structure) : description of population
%        demographics
%        create default settings by the function  DefaultPopulationSettings   

% Open Systems Pharmacology Suite;  support@systems-biology.com 
% Date: 12-jan-2017

individuals=[];

try
    
    isCanceled = loadPKSimMatlabDLL;
    if isCanceled
        return
    end
    
    PopulationFactory=PKSim.Matlab.MatlabPopulationFactory;
        
    %Ontogenies
    ontogenies = NET.createArray('System.String', 0);
    
    %---- create new population
    result=PopulationFactory.CreatePopulation(populationSettings, ontogenies);
    
    %check no of individuals
    if result.Count ~= populationSettings.NumberOfIndividuals
        error('Could not create required number of individuals');
    end
    
    %---- convert returned values (NET array) into matlab struct array
    covariates=NET.invokeGenericMethod('System.Linq.Enumerable', 'ToArray', {'PKSim.Core.Model.IndividualCovariates'}, result.AllCovariates);
    parameterPaths=NET.invokeGenericMethod('System.Linq.Enumerable', 'ToArray', {'System.String'}, result.AllParameterPaths);
    
    allParameterInfos=NET.invokeGenericMethod('System.Linq.Enumerable', 'ToArray', {'PKSim.Core.Model.ParameterValues'},  result.AllParameterValues);
        
    numberOfParams = parameterPaths.Length;
    
    for individualIdx=1:result.Count
        individuals(individualIdx).Gender = char(covariates(individualIdx).Gender.Name);
        individuals(individualIdx).Race = char(covariates(individualIdx).Race.Name);
        
        individuals(individualIdx).ParameterInfos = [];
        
        for paramIdx=1:numberOfParams
            
            parameterInfo = allParameterInfos(paramIdx);
            
            individuals(individualIdx).ParameterInfos(paramIdx).Path  = char(parameterPaths(paramIdx));
            individuals(individualIdx).ParameterInfos(paramIdx).Value = double(parameterInfo.Values.Item(individualIdx-1));
            individuals(individualIdx).ParameterInfos(paramIdx).Percentile = double(parameterInfo.Percentiles.Item(individualIdx-1));
        end
    end
    
catch e
    if(isa(e, 'NET.NetException'))
        eObj = e.ExceptionObject;
        %    disp(eObj.ToString);
        error(char(eObj.ToString));
    else
        rethrow(e);
    end
end
