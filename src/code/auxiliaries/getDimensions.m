function [dimensionList,unitTranslationList]=getDimensions
%GETDIMENSIONS Returns all stored dimensions
% 
%    dimensionList= = GETDIMENSIONS(
%       dimensionList (cell array of strings): list of all defined dimensions 
%    (see also UNITCONVERTER)
%
% Example Call:
% dimensionList=getDimensions

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 15-May-2011

[unitList,unitList_dimensionList,unitTranslationList]=iniUnitList(0);
    
if isempty(unitList)
    load unitList;
end

dimensionList=unitList_dimensionList;

return
