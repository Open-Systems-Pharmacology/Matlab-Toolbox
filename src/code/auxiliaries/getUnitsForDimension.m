function units=getUnitsForDimension(dimension)
%GETUNITSFORDIMENSION Returns all stored units for this dimension
% 
%    units= = GETUNITSFORDIMENSION(dimension)
%       dimension (string): dimension 
%       units  (cell array): all units which are stored for this dimension 
%    (see also UNITCONVERTER)
%
% Example Call:
% units=getUnitsForDimension('time')

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 20-Dec-2010

[unitList,unitList_dimensionList]=iniUnitList(0);

iDim=find(strcmpi(unitList_dimensionList,dimension));

if isempty(iDim)
    error('unknown dimension %s',dimension)
end

units=unitList(iDim).unit_txt;

return
