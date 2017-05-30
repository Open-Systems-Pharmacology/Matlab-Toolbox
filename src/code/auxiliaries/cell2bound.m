function [bounds, numintervals] = cell2bound(C)
% CELL2BOUND Support function: Transformation of a discretization-Cell-Array into a vector.
%
%   [bounds, numintervals] = cell2bound(C)
%       - C (cellarray): discretization bounds
%       - bounds : vector of the length (sum(numintervals)+numVar) with the discretization bounds
%                  of the input variables incl. min und max value
%       - numintervals : vector of the length numVar with the number of the intervals of the variables

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 2000-01-19

nvars = length(C);
bounds = cat(2,C{:});
numintervals = zeros(1,nvars);
for i=1:nvars
   numintervals(i) = length(C{i})-1;
end
