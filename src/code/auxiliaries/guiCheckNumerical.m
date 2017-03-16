function valid=guiCheckNumerical(hObject,isMandatory,minValue,maxValue,isInteger)
%GUICHECKNUMERICAL GUI support function: Checks if the input of a GUI field is numerical
%
%   valid=GUICHECKNUMERICAL(hObject)
%       - hObject (handle) : handle of corresponding field
%       - valid (boolean): 
%               - true if the field is valid (field is empty or value is numerical)
%               - false else
%
%   valid=GUICHECKNUMERICAL(hObject,isMandatory)
%       - isMandatory (boolean) (default false) if true file must not be empty
%
%   valid=GUICHECKNUMERICAL(hObject,isMandatory,minValue)
%       - minValue (double) (default []) if valid and not empty, values smaller than min are set to minValue 
%
%   valid=GUICHECKNUMERICAL(hObject,isMandatory,minValue,maxValue)
%       - maxValue (double) (default []) if valid and not empty, values greater than max are set to maxValue 
%
% Example Call: valid=guiCheckNumerical(hObject)

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 4-Nov-2010

if ~exist('isMandatory','var')
    isMandatory=false;
end

value=get(hObject,'String');

valid=true;
set(hObject,'BackgroundColor',[1 1 1]);

% check mandatory
if  isempty(value)
    if isMandatory 
        valid=false;
        set(hObject,'BackgroundColor',[1 1 0.6]);
    end
else
    % check numerical value
    value=strrep(value,',','.');
    
    numValue=str2double(value);
    valid=~isnan(numValue);
    
    if valid
        if exist('minValue','var') && ~isempty(minValue)
            numValue=max(numValue,minValue);
        end
        if exist('maxValue','var') && ~isempty(maxValue)
            numValue=min(numValue,maxValue);
        end
        if exist('isInteger','var') && isInteger
            numValue=round(numValue);
        end
        set(hObject,'String',num2str(numValue));
        set(hObject,'BackgroundColor',[1 1 1]);
    else
        set(hObject,'BackgroundColor',[1 0 0]);
    end
end

return