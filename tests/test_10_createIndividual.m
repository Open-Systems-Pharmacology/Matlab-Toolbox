function [ErrorFlag, ErrorMessage,TestDescription] = test_10_createIndividual
%TEST_10_CREATEINDIVIDUAL Test of Function setAxesScaling
% 
%   [ErrorFlag, ErrorMessage,TestDescription] = TEST_10_CREATEINDIVIDUAL
%       ErrorFlag (boolean):
%               0 = 'Ok'
%               1 = 'User has to check something by hand or a warning exists
%               2 = 'Serious Error'
%       ErrorMessage (string): Description of the error
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 12-Dez-2012

ErrorFlag_tmp=0;
ErrorMessage_tmp{1}='';
TestDescription={};

% default man
xmlFile='models/default man.xml';
initSimulation(xmlFile,'allnonFormula')
species='Human';
population=0;
gender=1;
age=getParameter('default man|Organism|Age',1,'parametertype','readonly');
weight=getParameter('default man|Organism|Weight',1,'parametertype','readonly');
height=getParameter('default man|Organism|Height',1,'parametertype','readonly');
BMI=nan;
[isCanceled,individualParameters] = PKSimCreateIndividual(species, population, ...
    gender, age, weight, height, BMI,'',1);
for iPar=1:length(individualParameters)
    tmp=getParameter(['default man|' individualParameters(iPar).path_id],1);
    if abs((tmp-individualParameters(iPar).Value)/tmp)>1e-3
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=sprintf('values ar not equal: %s',individualParameters(iPar).path_id);
    end
end

% asian woman
xmlFile2='models/asian woman.xml';
initSimulation(xmlFile2,'allnonFormula','addFile',true)
species='Human';
population=4;
gender=2;
age=getParameter('asian woman|Organism|Age',2,'parametertype','readonly');
weight=getParameter('asian woman|Organism|Weight',2,'parametertype','readonly');
height=getParameter('asian woman|Organism|Height',2,'parametertype','readonly');
BMI=nan;
[isCanceled,individualParameters] = PKSimCreateIndividual(species, population, ...
    gender, age, weight, height, BMI,'',1);
for iPar=1:length(individualParameters)
    tmp=getParameter(['asian woman|' individualParameters(iPar).path_id],2);
    if abs((tmp-individualParameters(iPar).Value)/tmp)>1e-3
        ErrorFlag_tmp(end+1)=2;
        ErrorMessage_tmp{end+1}=sprintf('values ar not equal: %s',individualParameters(iPar).path_id);
    end
end


% compare all parameters
[ise,desc_1]=existsParameter('*',1);
[ise,desc_2]=existsParameter('*',2);
for i=2:size(desc_1,1)
    if ~ismember(desc_2{i,2},strcat('asian woman|', {individualParameters(:).path_id})) && ...
            ~strEnds(desc_2(i,2),'|Mean') && ...
            ~strEnds(desc_2(i,2),'|Deviation') && ...
            ~strEnds(desc_2(i,2),'|Percentile')
        if abs((desc_2{i,3}-desc_1{i,3})/desc_1{i,3})>1e-3
            ErrorFlag_tmp(end+1)=2;
            ErrorMessage_tmp{end+1}=sprintf('This should be an individual parameter: %s',desc_2{i,2});
        end
    end
end

                                                  
[ErrorFlag,ErrorMessage,TestDescription]=mergeErrorFlag(ErrorFlag_tmp,ErrorMessage_tmp,TestDescription);
return