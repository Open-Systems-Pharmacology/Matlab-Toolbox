function populationSettings = DefaultPopulationSettings
%DEFAULTPOPULATIONSETTINGS Creates set default description for a population generation
%
%   populationSettings = DefaultPopulationSettings
%
%       is used in function PKSimCreatePopulation   

% Open Systems Pharmacology Suite;  support@systems-biology.com 
% Date: 12-jan-2017

    populationSettings=[];
    
try
    
    isCanceled = loadPKSimMatlabDLL;
    if isCanceled
        return
    end
    
    populationSettings = PKSim.Core.Batch.PopulationSettings;
    gestationalAgeRange = PKSim.Core.CoreConstants.PretermRange;

    populationSettings.Species             ='Human';
    populationSettings.Population          ='European_ICRP_2002';
    populationSettings.MinAge              = NaN;
    populationSettings.MaxAge              = NaN;
    populationSettings.MinGestationalAge   = System.Linq.Enumerable.Min(gestationalAgeRange);
    populationSettings.MaxGestationalAge   = System.Linq.Enumerable.Max(gestationalAgeRange);
    populationSettings.MinWeight           = NaN;
    populationSettings.MaxWeight           = NaN;
    populationSettings.MinHeight           = NaN;
    populationSettings.MaxHeight           = NaN;
    populationSettings.MinBMI              = NaN;
    populationSettings.MaxBMI              = NaN;
    populationSettings.NumberOfIndividuals = 10;
    populationSettings.ProportionOfFemales = 50;
    
    populationSettings.AddCalculationMethod('SurfaceAreaPlsInt','SurfaceAreaPlsInt_VAR1');
    
catch e
    if(isa(e, 'NET.NetException'))
        eObj = e.ExceptionObject;
        %    disp(eObj.ToString);
        error(char(eObj.ToString));
    else
        rethrow(e);
    end
end
        
