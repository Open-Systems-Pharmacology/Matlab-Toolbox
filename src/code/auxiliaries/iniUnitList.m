function [unitList,unitList_dimensionList,unitTranslationList]=iniUnitList(Flag,simXMLVersion)
%INIUNITLIST Returns all stored units and dimensions
% 
%    [unitList,unitList_dimensionList,unitTranslationList]=iniUnitList(asNew)
%       Flag (double): -1 reloads the default units 
%            empty or 0, take values of working space
%            1, take values as defaults from xml file
%            2, take values as new ones from xml file
%       simXMLVersion Version of simulation xml file
%       unitList_dimensionList (cell array): all dimension which are stored 
%       unitList  (structure): one entry for each dimension
%           - unit_txt (cell array): list of all units for corresponding dimension
%           - baseUnit (string): base Unit
%           - formula (cell array): factor or formula for unit conversion
%           - par_names (cell array): list of parameters needed for
%                       formula evaluation
%           - par_descriptions (cell array): description of parameters needed for
%                       formula evaluation
%           - par_values (cell array): default values of parameters
%       unitTranslationList (cellarray) units which shall be translated automatically
%           - first column, source unit
%           - second column, target dimension
%           - first column, target unit
%
%    (see also UNITCONVERTER)
%
% Example Call:
% [unitList,unitList_dimensionList]=iniUnitList(true)

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 30-Nov-2011
global MOBI_SETTINGS;

% Are the MoBi paths already set?
if isempty(MOBI_SETTINGS)
    MoBiSettings;
end

if ~exist('simXMLVersion','var') || isempty(simXMLVersion)
    simXMLVersion=getSimXMLVersion(1);
end


application_path=MOBI_SETTINGS.application_path;
if ~exist(application_path,'dir')
    mkdir(application_path);
end

if simXMLVersion <3
    default_mat=[application_path  'unitList_0.mat'];
else
    default_mat=[application_path  'unitList_3.mat'];
end


% generate New
if Flag>0 || ~exist(default_mat,'file') ;
    if simXMLVersion<3 
        load 'unitList_0_org.mat';        
     elseif ~isdeployed
         [unitList,unitList_dimensionList]=generateUnitsOutOfXml;
    else
        load 'unitList_org.mat';        
    end
    if Flag~=1
        unitTranslationList=getUnitTranslationList;
        save(default_mat,'unitList','unitList_dimensionList','unitTranslationList');
        MOBI_SETTINGS.unitList=unitList;
        MOBI_SETTINGS.unitList_dimensionList=unitList_dimensionList;
        MOBI_SETTINGS.unitTranslationList=unitTranslationList; 
    end
    % Load initialized
elseif isfield(MOBI_SETTINGS,'unitList') && Flag==0
    unitList=MOBI_SETTINGS.unitList;
    unitList_dimensionList=MOBI_SETTINGS.unitList_dimensionList;
    unitTranslationList=getUnitTranslationList;
else
    % Load existing
    load(default_mat);
    MOBI_SETTINGS.unitList=unitList; %#ok<NODEF>
    MOBI_SETTINGS.unitList_dimensionList=unitList_dimensionList; %#ok<NODEF>
    MOBI_SETTINGS.unitTranslationList=getUnitTranslationList; 
end



return

function unitTranslationList=getUnitTranslationList

unitTranslationList=cell(0,3);

return



function [unitList,unitList_dimensionList]=generateUnitsOutOfXml

mu = char(181);

fileNameUnits= 'OSPSuite.Dimensions.xml';

fid = fopen(fileNameUnits);
C = cell2bound(textscan(fid, '%s','delimiter', '>'));
fclose(fid);

unitList_dimensionList={};
unitList=struct('unit_txt',[],'formula',[],'par_descriptions',{},'par_names',{},'par_values',[],'baseUnit',[]);
unitList=unitList([]);

i=2;
while i<=length(C)
    T=cell2bound(textscan(C{i},'%s'));
    
    % new line
    newRow=false;
    while i<length(C) && ~newRow;
        Tnext=cell2bound(textscan(C{i+1},'%s'));
        x=cell2bound(Tnext(1));
        if ~strcmp(x(1),'<')
            T=[T ; cell2bound(textscan(C{i+1},'%s'))]; %#ok<AGROW>
            i=i+1;
        else
            newRow=true;
        end
    end
    i=i+1;
       
    
    
    Tag=evaluateTag(T);
    
    switch Tag.Name
        case 'Dimension'
            unitList_dimensionList{end+1}=getTagName(Tag,'name'); %#ok<AGROW>
            unitList(end+1).baseUnit=getTagName(Tag,'baseUnit'); %#ok<AGROW>
            unitList(end).unit_txt={};
        case 'Unit'
            unitList(end).unit_txt{end+1}=getTagName(Tag,'name');
            unitList(end).formula{end+1}=getTagName(Tag,'factor');
    end
    
    
end

% merge Time and LongTime
ij_Time=find(strcmp('Time',unitList_dimensionList));
ij_LongTime=find(strcmp('LongTime',unitList_dimensionList));
if ~isempty(ij_LongTime) && ~isempty(ij_Time)
    unitList_dimensionList{end+1}='Time';
    if strcmp(unitList(ij_Time).baseUnit,unitList(ij_LongTime).baseUnit)
        unitList(end+1)=unitList(ij_Time);
    else
        error('merge of Time difficult!');
    end

    [~,ix]=setdiff( unitList(ij_Time).unit_txt,unitList(ij_LongTime).unit_txt);
    %unitList(end).unit_txt=[unitList(ij_Time).unit_txt,unitList(ij_LongTime).unit_txt(ix)];
    %unitList(end).formula=[unitList(ij_Time).formula,unitList(ij_LongTime).formula(ix)];
    unitList(end).unit_txt=[unitList(ij_Time).unit_txt(ix),unitList(ij_LongTime).unit_txt];
    unitList(end).formula=[unitList(ij_Time).formula(ix),unitList(ij_LongTime).formula];
    
    keep=setdiff(1:length(unitList_dimensionList),[ij_Time ij_LongTime]);
    unitList_dimensionList=unitList_dimensionList(keep);
    unitList=unitList(keep);

end

% merge Concentration and MolarConcentration
ij_MC=find(strcmp('Concentration (molar)',unitList_dimensionList));
ij_C=find(strcmp('Concentration (mass)',unitList_dimensionList));
% xml Version <3:
if isempty(ij_MC) && isempty(ic_C)
    ij_MC=find(strcmp('MolarConcentration',unitList_dimensionList));
    ij_C=find(strcmp('Concentration',unitList_dimensionList));
end

unitList_dimensionList{end+1}='Concentration';  %#ok<*NASGU>
if strcmp(unitList(ij_MC).baseUnit,[mu,'mol/l'])&& strcmp(unitList(ij_C).baseUnit,'kg/l')
    unitList(end+1)=unitList(ij_MC);
    formula = cellfun(@num2str, num2cell(str2double(unitList(ij_C).formula)*1e9), 'UniformOutput', false);

elseif strcmp(unitList(ij_MC).baseUnit,[mu,'mol/l'])&& strcmp(unitList(ij_C).baseUnit,[mu,'g/l'])
    unitList(end+1)=unitList(ij_MC);
    formula =unitList(ij_C).formula;
else
   error('merge of Concentration failed!');
end
[~,ix]=setdiff( unitList(ij_MC).unit_txt,unitList(ij_C).unit_txt);
%unitList(end).unit_txt=[unitList(ij_MC).unit_txt,unitList(ij_C).unit_txt(ix)];
%unitList(end).formula=[unitList(ij_MC).formula,strcat(unitList(ij_C).formula(ix),'/MW')]; 
unitList(end).unit_txt=[unitList(ij_MC).unit_txt(ix),unitList(ij_C).unit_txt];
unitList(end).formula=[unitList(ij_MC).formula(ix),strcat(formula,'/MW')]; 
unitList(end).par_descriptions={'Molweight [g/mol]'};
unitList(end).par_names={'MW'};
unitList(end).par_values=400; 


keep=setdiff(1:length(unitList_dimensionList),[ij_MC ij_C]);
unitList_dimensionList=unitList_dimensionList(keep); 
unitList=unitList(keep); 

% sort alphabetical
[unitList_dimensionList,ix_sort]=sort(unitList_dimensionList);
unitList=unitList(ix_sort);


% add mcMol for µMol units
for iDim=1:length(unitList_dimensionList)
    jj=~cellfun(@isempty,strfind(unitList(iDim).unit_txt,mu));
    if any(jj)
        unitList(iDim).unit_txt=[unitList(iDim).unit_txt strrep((unitList(iDim).unit_txt(jj)),mu,'mc')];
        unitList(iDim).formula=[unitList(iDim).formula unitList(iDim).formula(jj)];
    end
end

return

function Tag=evaluateTag(T)

% initialization
Tag.isOnlyEndTag=false;
Tag.isEndTag=false;
Tag.isStartAndEndTag=false;
Tag.Properties={};
Tag.Name='';
Tag.Constant='';



tmp=T{end};
if strcmp(tmp(end),'/')
    Tag.isEndTag=true;
    T{end}=tmp(1:end-1);
elseif ~isempty(strfind(tmp,'</'))
    Tag.isStartAndEndTag=true;
    for i=2:length(T)-1
        k=strfind(T{i},'="');
        if isempty(k)
            Tag.Constant=[Tag.Constant ' '  T{i}];
        else            
            Tag.Properties{end+1}.name=T{i}(1:k-1);
            Tag.Properties{end}.value=T{i}(k+2:end-1);          
        end
    end
    Tag.Constant=strtrim([Tag.Constant ' ' tmp(1:strfind(tmp,'</')-1)]);
end

Tag.Name=T{1};
if strBegins('</',Tag.Name)
    Tag.isOnlyEndTag=true;
    Tag.Name=Tag.Name(3:end);
else
    Tag.Name=Tag.Name(2:end);
end

% % properties
if ~Tag.isStartAndEndTag
    
    Tnew={};
    for iPr=2:length(T)
        tmp=T{iPr};
        if ~isempty(tmp)
            k=strfind(tmp,'=');
            if isempty(k)
                if isempty(Tnew)
                    Tnew{end+1}=tmp; %#ok<AGROW>
                else
                    Tnew{end}=[Tnew{end} ' ' tmp]; %#ok<AGROW>
                end
            else
                Tnew{end+1}=tmp; %#ok<AGROW>
            end
        end
    end

    for iPr=1:length(Tnew)
        tmp=Tnew{iPr};
        k=strfind(tmp,'=');
        if isempty(k)
            tmp=1;
        end
        Tag.Properties{end+1}.name=tmp(1:k-1);
        Tag.Properties{end}.value=tmp(k+2:end-1);

    end
end

return

function value =getTagName(Tag,key)

value='';

for i=1:length(Tag.Properties)
    if ~isempty(Tag.Properties{i}.name)
        switch upper(Tag.Properties{i}.name)
            case upper(key)
                value = Tag.Properties{i}.value;
                value=strrep(value,'Â','');
        end
    end
end
return


function [bounds, numintervals] = cell2bound(C)

nvars = length(C);
bounds = cat(2,C{:});
numintervals = zeros(1,nvars);
for i=1:nvars
   numintervals(i) = length(C{i})-1;
end