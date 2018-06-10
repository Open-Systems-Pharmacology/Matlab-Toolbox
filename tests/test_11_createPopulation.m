function [ErrorFlag, ErrorMessage,TestDescription] = test_11_createPopulation
%TEST_10_CREATEINDIVIDUAL Test of Function setAxesScaling
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_11_CREATEPOPULATION
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  http://open-systems-pharmacology.org

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

% get default settings for population
popSet = DefaultPopulationSettings;

% set same settings as the poulation pediatric_1-3years-Population.csv
% created by PK-SIM
popSet.MinAge = 1;
popSet.MaxAge = 3;
popSet.MinWeight = 10;
popSet.MaxWeight = 15;
popSet.MinHeight = 7;
popSet.MaxHeight= 10;
popSet.NumberOfIndividuals = 1000;
popSet.ProportionOfFemales = 50;

% set xml to define ontgenies
xml = 'models\preterm.xml';

% create the population
[isCanceled, pop_individuals] =PKSimCreatePopulation(popSet);

if isCanceled
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}='Crash during PKSimCreatePopulation';
end

% reformat structure
parameterInfos = [pop_individuals.ParameterInfos];

% read for comparison PK-SIm created population
tPKSIM = readtable('models\pediatric_1-3years-Population.csv','HeaderLines' ,2);

% check constraints on demographics
% Gender
[~,~,ix] = unique({pop_individuals.Gender});
proportionOfFemales = sum(ix==2)/length(ix)*100;
if proportionOfFemales ~= popSet.ProportionOfFemales
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('ProportionOfFemales should be : %d but it is %d',popSet.ProportionOfFemales,proportionOfFemales);
end

% Age
jj = strcmp({parameterInfos.Path},'Organism|Age');
minValue = min([parameterInfos(jj).Value]);
if minValue < popSet.MinAge
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('Minimal age should be : %d but it is %d',popSet.MinAge,minValue);
end

maxValue = max([parameterInfos(jj).Value]);
if maxValue > popSet.MaxAge
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('Maximal age should be : %d but it is %d',popSet.MaxAge,maxValue);
end

% Weight
jj = strcmp({parameterInfos.Path},'Organism|Weight');
minValue = min([parameterInfos(jj).Value]);
if minValue < popSet.MinWeight
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('Minimal weight should be : %d but it is %d',popSet.MinWeight,minValue);
end

maxValue = max([parameterInfos(jj).Value]);
if maxValue > popSet.MaxWeight
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('Maximal weight should be : %d but it is %d',popSet.MaxWeight,maxValue);
end

% Height
jj = strcmp({parameterInfos.Path},'Organism|Height');
minValue = min([parameterInfos(jj).Value]);
if minValue < popSet.MinHeight
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('Minimal weight should be : %d but it is %d',popSet.MinHeight,minValue);
end

maxValue = max([parameterInfos(jj).Value]);
if maxValue > popSet.MaxHeight
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('Maximal height should be : %d but it is %d',popSet.MaxHeight,maxValue);
end


% compare distributions of ontogeny parameters
jj = strcmp({parameterInfos.Path},'Organism|Ontogeny factor (albumin)');
[h,p] = vartest2(log(tPKSIM.Organism_OntogenyFactor_albumin_),log([parameterInfos(jj).Value]));
if h==1
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('variance of Ontogeny factor (albumin) is no like PKSimcreated pValue : %g ',p);    
end
[h,p] = ttest2(log(tPKSIM.Organism_OntogenyFactor_albumin_),log([parameterInfos(jj).Value]));
if h==1
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('mean of Ontogeny factor (albumin) is no like PKSimcreated pValue : %g ',p);    
end

% compare distributions of ontogeny parameters
jj = strcmp({parameterInfos.Path},'CYP3A4|Ontogeny factor');
if ~any(jj)
    ErrorFlag_tmp(end+1)=2;
    ErrorMessage_tmp{end+1}=sprintf('Ontogeny factor (CYP3A4) was not created');        
else
    [h,p] = vartest2(log(tPKSIM.CYP3A4_OntogenyFactor),log([parameterInfos(jj).Value]));
    if h==1
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=sprintf('variance of Ontogeny factor (CYP3A4) is no like PKSimcreated pValue : %g ',p);
    end
    [h,p] = ttest2(log(tPKSIM.CYP3A4_OntogenyFactor),log([parameterInfos(jj).Value]));
    if h==1
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=sprintf('mean of Ontogeny factor (CYP3A4) is no like PKSimcreated pValue : %g ',p);
    end
end


% merge error
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);
return