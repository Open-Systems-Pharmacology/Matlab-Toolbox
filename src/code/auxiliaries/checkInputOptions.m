function varargout = checkInputOptions(givenOption,possibleOption)
%CHECKINPUTOPTIONS Support function: Checks options and returns option values
%
%   varargout = CHECKINPUTOPTIONS(givenOption,possibleOption)
%       - givenOption (cellarray) : pairs of given options,{'option name',possible option values'
%       - possibleOption (cellarray) : triples of possible options,
%               {'optionname',possible option values, defaultvalue}
%               possible option values can be:
%                   - empty string ('')  function accepts the given value for this
%                       option without further checks
%                   - cell array with keywords (strings), function checks if the given
%                       value for this option is one of the keywords
%                   - vector of predefined numbers (doubles,integers, booleans) function checks if the given
%                       value for this option is one of the predefined numbers
%                   - nan, function accepts any numeric value
%                   - string with condition. Function accepts only value which fulfils condition.
%                       The condition has to be written between these characters: <$ condition &>.
%                       For the validation, the place holders (%g) are
%                       replaced with the given option
%                       Examples: '<$ %g>0 %>'
%                                 '<$ %g>0 & %g <= 7 $>'
%                   - string '{}'. Function accepts only cellarrays
%       - varargout (cellarray): optionvalues
%
% Example Call:
% [report,addFile,stopOnWarnings,ExecutionTimeLimit] = ...
%     checkInputOptions(varargin,{...
%     'report',{'none','short','long'},'short',...
%     'addFile',[true false],false,...
%     'stopOnWarnings',[true false],false,...
%     'ExecutionTimeLimit','<$ %g>0 $>',0,...
%     });

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 16-Sep-2010


% set default values
varargout=possibleOption(3:3:end);

if isempty(givenOption)
    return
end

if mod(length(givenOption),2)~=0
    error('Invalid parameter/value pair arguments.!');
end

% split the arrays
givenOption_keywords=givenOption(1:2:end);
givenOption_values=givenOption(2:2:end);
possibleOption_keywords=possibleOption(1:3:end);
possibleOption_values=possibleOption(2:3:end);

% Check if the options are valid
for iGiven=1:length(givenOption_keywords)
    
    iPossible=find(strcmpi(givenOption_keywords{iGiven},possibleOption_keywords));
    if isempty(iPossible)
        error('Option "%s" is unknown!', givenOption{iGiven});
        break;
    end
    
    possible_values=possibleOption_values{iPossible};
    % no possible values provided
    if strcmp(possible_values,'')
        
        % cell array with keywords
    elseif iscell(possible_values)
        if ~ischar(givenOption_values{iGiven})
            if isnumeric(givenOption_values{iGiven})
                error('For option "%s" the value "%g" must be a string!',...
                    givenOption_keywords{iGiven},givenOption_values{iGiven});
            else
                error('For option "%s" the value must be a string!',...
                    givenOption_keywords{iGiven});
            end
            break;
        end
        jj=strcmpi(givenOption_values{iGiven},possible_values);
        
        if ~any(jj)
            error('For option "%s" the keyword "%s" is unknown!',...
                givenOption_keywords{iGiven},givenOption_values{iGiven});
            break;
        else
            givenOption_values{iGiven}=possible_values{jj};
        end
        % any numeric value
    elseif isnan(possible_values)
        if ~isnumeric(givenOption_values{iGiven})
            error('For option "%s" the value "%s" must be numeric!',...
                givenOption_keywords{iGiven},givenOption_values{iGiven});
            break;
        end
        
        %vector with doubles or booleans
    elseif isnumeric(possible_values) || islogical(possible_values)
        
        if ~isnumeric(givenOption_values{iGiven}) && ~islogical(givenOption_values{iGiven})
            if isnumeric(possible_values)
                error('For option "%s" the value "%s" must be numeric!',...
                    givenOption_keywords{iGiven},givenOption_values{iGiven});
            else
                error('For option "%s" the value "%s" must be logical!',...
                    givenOption_keywords{iGiven},givenOption_values{iGiven});
            end
            break;
        elseif ~ismember(givenOption_values{iGiven},possible_values);
            error('For option "%s" the value "%g" is unknown!',...
                givenOption_keywords{iGiven},givenOption_values{iGiven});
            break;
        end
        % condition
    elseif ischar(possible_values) && strcmp(possible_values([1:2 end-1:end]),'<$$>')
        condition=strtrim(possible_values(3:end-3));
        ij=strfind(condition,'%g');
        if ~eval(sprintf(condition,repmat(givenOption_values{iGiven},1,length(ij))))
            condition_str=strrep(condition,'%g',givenOption_keywords{iGiven});
            error('For option "%s" value "%g" is not valid. The following condition has to be fulfilled: %s !',...
                givenOption_keywords{iGiven},givenOption_values{iGiven},condition_str);
            break;
        end
    elseif ischar(possible_values) && strcmp(possible_values,'{}')
        if ~iscell(givenOption_values{iGiven})
            error('For option "%s" the value "%s" must be a cell!',...
                givenOption_keywords{iGiven},givenOption_values{iGiven});
        end
    else
        error('unknown format of possible value!')
    end
    varargout{iPossible}=givenOption_values{iGiven};
    
end

return;
