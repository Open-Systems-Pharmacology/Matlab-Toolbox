function data = readtab(fname, delim, numformat, readtypes, readnames, display)
%READTAB Support function: Read data from ascii files.
%
% Call:
%    data = readtab(fname, delim, numformat, readtypes, readnames, display)
%
% INPUT:
%    fname     : Name of the input file
%    delim     : (optional) column delimiter. If not given, a tabulator
%                '\t' (char(9)) will be used
%    numformat : (optional) regional settings for the number format
%                  0 - decimal separator = "." (default)
%                  1 - decimal separator =,"."
%    readtypes : (optional) data type recognition
%                  0 - automatic data type recognition
%                  1 - data types are explicitly given in the table
%                  (default)
%    readnames : (optional) variable names recognition
%                  0 - data table does not contain variable names
%                  1 - variable names are stored in the 1st row of the data
%                  table (default).
%    display   : show progress.
%                  0 - no progress.
%                  1 - progress as text.
%                  2 - progress bar.
%                  3 - both (default).
%      
% OUTPUT:
%    data      : (3 x numVars)-Cell-Array with the imported data. 
%                1st row contains attribute names, 2nd row data types 
%                3rd row contains the data
%
% Example:
%
%    TEST.TXT
%       Temperature;Pressure;Name;Outcome;Remark
%       NaN;12;Captain Kirk;1,3;abcdefg
%       2,0e-1;22;Mr. Spock;hij
%       3,0e-1;32;;3,3;1.2345
%       4,0e-1;NaN;Scotty;4,3;klmno
%
%    Import via data=freadtab('test.txt',';',1,0,1) gives:
%
%       data = 
%       { 'Temperature', 'Pressure',  'Name',     'Outcome',    'Remark';
%         'double',     'long',       'string',   'double',     'string';
%         [4x1 double], [4x1 double], {4x1 cell}, [4x1 double], {4x1 cell} }
%
%    with 
%
%       data{3,1} = [NaN; 0.2000; 0.3000; 0.4000]
%       data{3,2} = [12; 22; 32; NaN]
%       data{3,3} = {'Captain Kirk'; 'Mr. Spock'; ''; 'Scotty'}
%       data{3,4} = [1.3; NaN; 3.3; 4.3]
%       data{3,5} = {'abcdefg'; 'hij'; '1.2345'; 'klmno'}
%
% Open Systems Pharmacology Suite;  support@systems-biology.com 
%   Datum: 2000-05-23

%#function wbinterface

% Check for correct arguments
if (nargin < 2), delim = [];     end    
if (nargin < 3), numformat = []; end
if (nargin < 4), readtypes = []; end
if (nargin < 5), readnames = []; end
if (nargin < 6), display = [];   end

if (isempty(delim) | strcmp(delim,'\t'))
   delim = char(9);
end
if (isempty(numformat))
   numformat = 0;
end
if (isempty(readtypes))
   readtypes = 1;
end
if (isempty(readnames))
   readnames = 1;
end
if (isempty(display))
   display = 3;
end

% Call C-DLL 
try
    [varnames,vartypes,numdata,strdata] = ml_freadtab(fname,delim,numformat,readtypes,readnames,display);
catch     %#ok<CTCH>
    % try work around for non-latin systems (non-latin pathnames cannot be evaluated by ml_freadtab
    % it is problematic to use always this workaround, the path of the .dll may be unknown,
    % so the ml_freadtab should be called once, even failing, then it is
    % loaded
    old_dir = cd;
    [new_dir,name,ext] = fileparts(fname);
    if ~isempty(new_dir)
        cd(new_dir);
    end
    [varnames,vartypes,numdata,strdata] = ml_freadtab([name ext],delim,numformat,readtypes,readnames,display);
    cd(old_dir);
end

% Put results into cell-array
if isempty(varnames)
   data = {};
else
   nvars = length(varnames);
   data = cell(3,nvars);
   data(1,:) = varnames;
   data(2,:) = vartypes;
   strind = find(strcmp('string',vartypes));
   numind = setdiff(1:nvars,strind);
   if (~isempty(strind))
      data(3,strind)=num2cell(strdata,1);
   end
   if (~isempty(numind))
      data(3,numind)=num2cell(numdata,1);
   end   
end
