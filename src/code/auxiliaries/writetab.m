function  writetab(fname, data, delim, numformat, writetypes, writenames,display)
%WRITETAB Support function: Write data to ascii files.
%
% Call:
%    writetab(fname, data, delim, numformat, writetypes, writenames,display)
%
% INPUT:
%    fname      : name of the output file. STDOUT will be used if empty.
%    data       : (3 x numVars)-Cell-Array with the imported data. 
%                 1st row contains attribute names, 2nd row data types 
%                 3rd row contains the data
%    delim      : (optional) column delimiter. If not given, a tabulator
%                 '\t' (char(9)) will be used
%    numformat  : (optional) regional settings for the number format
%                  0 - decimal separator = "." (default)
%                  1 - decimal separator =,"."
%    writetypes : (optional) output of data types
%                   0 - no output of data types (default).
%                   1 - output of data types
%    writenames : (optional) output of variable names
%                   0 - no output of variable names
%                   1 - output of variable names (default)
%    display    : show progress.
%                  0 - no progress.
%                  2 - progress bar (default).

% Open Systems Pharmacology Suite;  support@systems-biology.com 
% Datum: 2001-05-30

if nargin < 2
   error('Filename and data have to be specified.')
end

if (nargin < 3), delim = [];      end    
if (nargin < 4), numformat = [];  end
if (nargin < 5), writetypes = []; end
if (nargin < 6), writenames = []; end
if (nargin < 7), display = []; end
if (isempty(delim) | strcmp(delim,'\t'))
   delim = char(9);
end
if (isempty(numformat))
   numformat = 0;
end
if (isempty(writetypes))
   writetypes = 0;
end
if (isempty(writenames))
   writenames = 1;
end
if (isempty(display))
   display = 1;
end

try
    ml_writetab(fname,data,delim,numformat,writetypes,writenames,display);
catch   exception  %#ok<CTCH>
    % try work around for non-latin systems (non-latin path names can not be evaluated by ml_writetab
    % it is problematic to use always this workaround, the path of the .dll may be unknown,
    % so the ml_freadtab should be called once, even failing, then it is
    % loaded
    old_dir = cd;
    [new_dir,name,ext] = fileparts(fname);
    cd(new_dir);
    ml_writetab([name ext],data,delim,numformat,writetypes,writenames,display);
    cd(old_dir);
end

