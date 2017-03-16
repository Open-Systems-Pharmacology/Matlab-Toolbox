function constructErrorMessageForExceptions(exception,errorDir)
%CONSTRUCTERRORMESSAGEFOREXCEPTIONS Support function: creates Error message for software crashes
% 
%   constructErrorMessageForExceptions(exception)
%       exception (exception) thrown by matlab
%       errorDir (string) directory where the exception is saved. If not
%       given or empty exception is not saved.
 
% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 19-Aug-2011

% getError Message
[~,fname]=fileparts(exception.stack(1).file);
errordlg(sprintf('Programm execution error. Please contact support. (%s line %d: %s)',fname,exception.stack(1).line,exception.message),'Error');

% save Exception if directory is given
if exist('errorDir','var') && ~isempty(errorDir)
    if ~exist(errorDir,'dir')
        mkdir(errorDir)
    end
    save([errorDir 'error_' datestr(now,'yy-mm-dd-HH-MM')],'exception')
end

%if an error occurred during invisible plot generation reset matlab settings
if ~strcmp(get(0, 'defaultFigureVisible'),'on')
    set(0, 'defaultFigureVisible', 'on');
end
if ~strcmp(get(0, 'defaultAxesVisible'),'on')
    set(0, 'defaultAxesVisible', 'on');
end
set(0, 'ShowHiddenHandles', 'on');
handles = get(0,'Children');
for i = 1:length(handles)
    h = handles(i);
    if isempty(get(h, 'CloseRequestFcn'))
        delete(h);
    end
end
set(0, 'ShowHiddenHandles', 'off');

% in undeployed mode rethrow
if ~isdeployed
    exception.rethrow;
end

return