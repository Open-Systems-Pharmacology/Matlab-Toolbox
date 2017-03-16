function MoBi(mode)
%MOBI For help on the MoBi Basis Toolbox for Matlab just type: MoBi.
% alternatively, type:
% help 'ToolboxInstallationDirectory'
% or, use the Matlab Help browser
%
% This m-file is responsible for locating your installation
% directory and, specifically, calling the appropriate help.
% MoBi(mode), where mode is empty or 1 to call command line help or 2 for
% calling the window help with the function list.

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 24-Nov-2010

if nargin==0
    mode=1;
end

% determine parent directory of current file
bb = mfilename('fullpath');
pathstr = fileparts(bb);

% add example path
appPath=[fileparts(which('MoBiSettings.m')) filesep];
addpath([appPath '../Examples']);

% command line help after typing 'MoBi' (1)
% and window help, e.g. called from the menu behind the Matlab Start button
% (2) and (3)
switch mode
    case 1
        feval('help',pathstr)
    case 2
        feval('helpwin',pathstr)
    case 3
        docsearch MoBi
    otherwise
        error('MoBiToolbox:Basis:Help', ...
            ['MoBi only allows for one input argument with value 1, 2, or 3.\n' ...
            'Alternatively, check if MoBi.m is correctly located within the installation directory of the\n' ...
            'MoBi Toolbox for Matlab.'])
end

return
