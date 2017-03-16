function factor=getUnitFactor(unit_source,unit_target,dimension,varargin)
%GETUNITFACTOR Factor needed for transferring values from unit_source to unit_target
% 
%    factor= = GETUNITFACTOR(unit_source,unit_target,dimension)
%       unit_source (string): unit of the source data  
%       unit_target (string): unit of the target data 
%       dimension (string): dimension of the units 
%       factor  (double): factor for scaling the values: 
%               x [unit_source]= x*factor [unit_target]
%
% if for this dimension additional parameters are used, these parameters have
% to be specified as additional input parameters in pairs of parameter name
% and value:
%    (see also UNITCONVERTER)
%
% Example Call:
% factor=getUnitFactor('µmol/l','mg/l','Concentration','MW',400);

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 20-Dec-2010

[unitList,unitList_dimensionList]=iniUnitList(0);

iDim=find(strcmpi(unitList_dimensionList,dimension), 1);
    
if isempty(iDim)   
    error('unknown dimension %s',dimension)
end

% set baseUnit if no unit is given
if isempty(unit_source)
    unit_source=unitList(iDim).baseUnit;
end
if isempty(unit_target)
    unit_target=unitList(iDim).baseUnit;
end


iU_source=find(strcmpi(unit_source,unitList(iDim).unit_txt));
if isempty(iU_source)
    error('unknown unit %s for this dimension %s',unit_source,dimension)
end

iU_target=find(strcmpi(unit_target,unitList(iDim).unit_txt));
if isempty(iU_target)
    error('unknown unit %s for this dimension %s',unit_target,dimension)
end

% get the values for Formula Parameters
for iP=1:length(unitList(iDim).par_names)
    ix=find(strcmp(unitList(iDim).par_names{iP},varargin));
    if ~isempty(ix)
        eval([unitList(iDim).par_names{iP} '= ' num2str(varargin{ix+1}) ';']);
    end
end

try
    f_source=eval([unitList(iDim).formula{iU_source} ';']);
catch %#ok<CTCH>
    error('The formula %s for unit %s could not be evaluated! ',unitList(iDim).formula{iU_source},unit_source)
end

try
    f_target=eval(unitList(iDim).formula{iU_target});
catch %#ok<CTCH>
    error('The formula %s for unit %s could not be evaluated! ',unitList(iDim).formula{iU_target},unit_target)
end

factor=f_source/f_target;

return



