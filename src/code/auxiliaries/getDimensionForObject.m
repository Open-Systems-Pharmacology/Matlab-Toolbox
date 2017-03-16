function [dimension,unit,listsHasChanged]=getDimensionForObject(unit,objectname)
global MOBI_SETTINGS;

listsHasChanged=false;

% empty unit
if isempty(unit)
    dimension='Dimensionless';
    unit='';
%     return
end

% 
[dimensionList,unitTranslationList]=getDimensions;

% check if unit is predefined
for iD=2:length(dimensionList)
    unitList=getUnitsForDimension(dimensionList{iD});
    ij=find(strcmpi(unitList,strtrim(unit)));
    if ~isempty(ij)
        dimension=dimensionList{iD};        
        break;
    end
end

if getSimXMLVersion(1) <3
    default_mat='unitList_0.mat';
else
    default_mat='unitList_3.mat';
end

% unit is not predefined
if isempty(ij)
    % check if it is possible to translate unit
    jj_trs=strcmp(unitTranslationList(:,1),unit);
    
    if any(jj_trs)
        dimension=unitTranslationList{jj_trs,2};
        unit=unitTranslationList{jj_trs,3};
    else
        % user dialog for unit specification
        unitold=unit;
        if ~exist('objectname','var')
            objectname='the current object';
        end
        [dimension,unit]=UnitSpecification(unit,objectname);
        if ~isempty(unit)
            unitTranslationList{end+1,1}=unitold;
            unitTranslationList{end,2}=dimension;
            unitTranslationList{end,3}=unit;
            
            % Are the MoBi paths already set?
            if isempty(MOBI_SETTINGS)
                MoBiSettings;
            end
            
            save([MOBI_SETTINGS.application_path default_mat], '-append','unitTranslationList');
            MOBI_SETTINGS.unitTranslationList=unitTranslationList;
            
            listsHasChanged=true;            
        end
    end
    
end


 return