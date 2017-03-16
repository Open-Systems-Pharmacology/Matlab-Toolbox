function msg=ps2pdf_MoBi(psfile,pdffile,varargin)
%PS2PDF_MOBI Calls the matlab function ps2pdf with the ghostview paths, save as user settings.
%   The user settings are initialized with MoBi Settings
%
%   msg=ps2pdf_MoBi(psfile,pdffile);
%       psfile         full or relative path to the postscript file to convert
%       pdffile        full or relative path to the pdf file to create
%       msg            errormessage, it is empty if conversion was successful
%
%   further options as set of parameter-value pairs
%       gscommand      path to Ghostscript executable to use; this will try
%                     to default to the version of Ghostscript shipped with 
%                     MATLAB, if any. If this value is specified you should 
%                     also specify the gsfontpath and gslibpath values.
%               NOTE: ps2pdf cannot use MATLAB's version of Ghostscript
%                     in a deployed application; you MUST provide a 
%                     the path to a separate instance of Ghostscript. 
%
%      gsfontpath     full path to the Ghostscript font files
%                     If a gscommand is specified then this path should
%                     also be specified and reference the same Ghostscript
%                     version
%
%      gslibpath      full path to the Ghostscript library (.ps) files. 
%                     If a gscommand is specified then this path should
%                     also be specified and reference the same Ghostscript
%                     version
%
%                     If gscommand is NOT specified and we can determine
%                     the version of Ghostscript, if any, shipped with
%                     MATLAB, then this value will be overridden to use the
%                     path that references MATLAB's version of Ghostscript
%
%      gspapersize    paper size to use in the created .pdf file. If not 
%                     specified or the specified value is not recognized 
%                     it will use whatever default paper size is 
%                     built into the version of Ghostscript being run
%
%                         NOTE: no scaling of the input occurs - it's simply
%                         placed on a page with the specified paper size. 
%
%                         Valid values for gspapersize are: 
%                              'letter', 'ledger', 'legal', '11x17', 
%                              'archA', 'archB', 'archC', 'archD', 'archE', 
%                              'a0', 'a1', 'a2', 'a3','a4', 'a5',
%                              'a6', 'a7', 'a8', 'a9', 'a10'
%                         
%      deletepsfile   0 to keep the input ps file after creating pdf
%                     non-zero to delete the input ps file after creating pdf
%                     Default is 0: keep the input ps file (do NOT delete it)
%                        NOTE: if the pdf creation process fails, the input
%                        PS file will be kept regardless of this setting
%
%      verbose        0 to suppress display of status/progress info; 
%                     non-zero to allow display of status/progress info
%                     Default is 0 (no display)
%
%Example Calls: 
%    use MATLAB's version of Ghostscript to generate an A4 pdf file
%      msg=ps2pdf_MoBi(('input.ps','output.pdf', 'gspapersize', 'a4')
%
%    use a local copy of Ghostcript to generate a file, and display some 
%    status/progress info while doing so.
%      msg=ps2pdf_MoBi(('../reports/input.ps', 'c:\temp\output3.pdf', ...
%            'gspapersize', 'a4', 'verbose', 1, ...
%            'gscommand', 'C:\Program Files\GhostScript\bin\gswin32c.exe', ...
%            'gsfontpath', 'C:\Program Files\GhostScript\fonts', ...
%            'gslibpath', 'C:\Program Files\GhostScript\lib')

% Open Systems Pharmacology Suite;  support@systems-biology.com 
% Date: 24-Jun-2011

% set warning off

warning('off','ps2pdf:ghostscriptCommandSuggestion')

% initialize return values
msg='';

% add varagins
varargin_ps2pdf(1).value='psfile';
varargin_ps2pdf(2).value=psfile;
varargin_ps2pdf(3).value='pdffile';
varargin_ps2pdf(4).value=pdffile;
if exist('varargin','var')
    for iArg=1:length(varargin)
        varargin_ps2pdf(end+1).value=varargin{iArg}; %#ok<AGROW>
    end
end

% Load user defined settings
gsSettings=loadSettings;

% if no ghowstview instance is specified try Matlab Builtin function (not
% possible for deployed applications)
if isempty(gsSettings.gscommand) && ~isdeployed
    try 
        ps2pdf(varargin_ps2pdf(:).value);
    catch exception
        msg=[sprintf('The conversion of %s to pdf has failed:',pdffile), exception.message];
    end
elseif isempty(gsSettings.gscommand) && isdeployed
    [msg,varargin_ps2pdf]=updateGhostviewPath(varargin_ps2pdf,['The conversion to pdf needs ghostscript'....
    'Please insert the path to a ghostscript executable (e.g. gswin32c.exe):'],application_path);
    if ~isempty(msg)
        try
            ps2pdf(varargin_ps2pdf(:).value);
        catch exception
            msg=[sprintf('The conversion of %s to pdf has failed:',pdffile), exception.message];
        end
    end
elseif ~exist(gsSettings.gscommand,'file')
    [msg,varargin_ps2pdf]=updateGhostviewPath(varargin_ps2pdf,['The conversion to pdf needs ghostscript'....
    'Please insert the path to a ghostscript executable (e.g. gswin32c.exe):'],application_path);
    if ~isempty(msg)
        try
            ps2pdf(varargin_ps2pdf(:).value);
        catch exception
            msg=[sprintf('The conversion of %s to pdf has failed:',pdffile), exception.message];
        end
    end
else
    varargin_ps2pdf(end+1).value='gscommand';
    varargin_ps2pdf(end+1).value=gsSettings.gscommand;
    if ~isempty(gsSettings.gsfontpath)
        varargin_ps2pdf(end+1).value='gsfontpath';
        varargin_ps2pdf(end+1).value=gsSettings.gsfontpath;
    end
    if ~isempty(gsSettings.gslibpath)
        varargin_ps2pdf(end+1).value='gslibpath';
        varargin_ps2pdf(end+1).value=gsSettings.gslibpath;
    end
    try
        ps2pdf(varargin_ps2pdf(:).value);
    catch exception
        msg=[sprintf('The conversion of %s to pdf has failed:',pdffile), exception.message];
    end
end    


return



function [msg,varargin_ps2pdf]=updateGhostviewPath(varargin_ps2pdf,title_txt,application_path)


% get user input   
[gs_exe,gspath] = uigetfile('*.exe',title_txt);
if isequal(gs_exe,0) || isequal(gspath,0)
    msg=sprintf('%s file was not generated. Use %s',pdffile,psfile);
    return
else
    varargin_ps2pdf(end+1).value='gscommand';
    varargin_ps2pdf(end+1).value=fullfile(gspath,gs_exe);
    gsSettings.gscommand=fullfile(gspath,gs_exe);
    % fontpath
    gsfontpath=strrep(gspath,'bin','fonts');
    if exist(gsfontpath,'dir')
        varargin_ps2pdf(end+1).value='gsfontpath';
        varargin_ps2pdf(end+1).value=fullfile(gspath,gs_exe);
        gsSettings.gsfontpath=gsfontpath;
    end
    % libpath
    gslibpath=strrep(gspath,'bin','fonts');
    if exist(gslibpath,'dir')
        varargin_ps2pdf(end+1).value='gslibpath';
        varargin_ps2pdf(end+1).value=fullfile(gslibpath,gs_exe);
        gsSettings.gslibpath=gslibpath;
    end
end
  
 save([application_path 'gsSettings.mat'],'gsSettings');

return

function gsSettings=loadSettings

global MOBI_SETTINGS;

if isempty(MOBI_SETTINGS)
    MoBiSettings;
end

if isfield(MOBI_SETTINGS,'gsSettings')
    gsSettings=MOBI_SETTINGS.gsSettings;
else
    application_path=MOBI_SETTINGS.application_path;
    
    if ~exist(application_path,'dir')
        mkdir(application_path);
    end
    gsSettings_file=[application_path 'gsSettings.mat'];
    if ~exist(gsSettings_file,'file')
        % get environment
        ProgramFiles=getenv('ProgramFiles');
        
        % ghostview path
        gsSettings.gscommand='';
        gsSettings.gsfontpath='';
        gsSettings.gslibpath='';
        if exist(fullfile(ProgramFiles, 'GhostScript', 'bin', 'gswin32c.exe'),'file')
            gsSettings.gscommand=fullfile(ProgramFiles, 'GhostScript', 'bin', 'gswin32c.exe');
            if exist(fullfile(ProgramFiles, 'GhostScript','fonts'),'dir')
                gsSettings.gsfontpath=fullfile(ProgramFiles, 'GhostScript','fonts');
            end
            if exist(fullfile(ProgramFiles, 'GhostScript','lib'),'dir')
                gsSettings.gslibpath=fullfile(ProgramFiles, 'GhostScript','lib');
            end
        elseif exist(fullfile(ProgramFiles, 'gs','gs9.00','bin', 'gswin32c.exe'),'file')
            gsSettings.gscommand=fullfile(ProgramFiles, 'gs','gs9.00','bin', 'gswin32c.exe');
            if exist(fullfile(ProgramFiles, 'gs','gs9.00','fonts'),'dir')
                gsSettings.gsfontpath=fullfile(ProgramFiles, 'gs','gs9.00','fonts');
            end
            if exist(fullfile(ProgramFiles, 'gs','gs9.00','lib'),'dir')
                gsSettings.gslibpath=fullfile(ProgramFiles, 'gs','gs9.00','lib');
            end
        end
        
        save(gsSettings_file,'gsSettings');
        
    else
        load(gsSettings_file);
    end

    MOBI_SETTINGS.gsSettings=gsSettings;
end
    
return

