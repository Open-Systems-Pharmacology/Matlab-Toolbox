function S=readXMLStructure(xmlfile)
% READXMLSTRUCTURE reads an xml file to the structure S
%
% S=readXMLStructure(xmlfile)
%
%  xmlfile (string) - name of file
%  S  (structure)   - structure which corresponds to the structure defined by
%                           the xml file
%

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 10-Mai-2016

fid = fopen(xmlfile);
C = cell2bound(textscan(fid, '%s','delimiter', '>'));
fclose(fid);

% delete header
C=C(2:end);

% initialize Structure
S=[];

% loop on lines
[S,C]=AddChild(S,C);

return


function [S,C]=AddChild(S,C)


while ~isempty(C)
    
    
    iLine=1;
    T=cell2bound(textscan(C{iLine},'%s'));

    % get next Tag
    endOfRow=false;
    while iLine<length(C) && ~endOfRow;
        Tnext=cell2bound(textscan(C{iLine+1},'%s'));
        x=cell2bound(Tnext(1));
        if ~strcmp(x(1),'<')
            T=[T ; cell2bound(textscan(C{iLine+1},'%s'))];
            iLine=iLine+1;
        else
            endOfRow=true;
        end
    end
    
    
    % deleted used lines from C
    C=C(iLine+1:end);

    % create XMLtag out of text
    [S_tmp,tagName,TagisEndTag]=evaluateTag(T);

    if ~TagisEndTag
        [S_tmp,C]=AddChild(S_tmp,C);
    elseif isempty(S_tmp)
        return
    end


    % add Tag to structure
    if isfield(S,tagName)
        S.(tagName)(end+1)=S_tmp;
    else
        S.(tagName)=S_tmp;
    end
    
    
end


return    
   
function [S,tagName,TagisEndTag]=evaluateTag(T)

% initialization
TagisEndTag=false;
S=[];
Tag_isStartAndEndTag=false;

% check if Tag has children
Tend=T{end};
if strcmp(Tend(end),'/') % it is an endtag
   TagisEndTag=true;
    T{end}=Tend(1:end-1);
elseif ~isempty(strfind(Tend,'</')) % % it is an start and endtag
   TagisEndTag=true;
    for iLine=2:length(T)-1
        % Value is constant
        k=strfind(T{iLine},'="');
        if isempty(k)
            error('not implemented yet')
        else            
            S.(T{iLine}(1:k-1)) = T{iLine}(k+2:end-1);
        end
    end
end


% get Name of tag
tagName=T{1};
if strncmp('</',tagName,2)
    Tag_isStartAndEndTag=true;
    tagName=tagName(3:end);
else
    tagName=tagName(2:end);
end

% % properties
if ~Tag_isStartAndEndTag
    
    % reset lines
    Tnew={};
    for iPr=2:length(T)
        Tend=replaceXMLEscape(T{iPr});
        if ~isempty(Tend)
            k=strfind(Tend,'="');
            if isempty(k)
                if isempty(Tnew)
                    Tnew{end+1}=Tend;
                else
                    Tnew{end}=[Tnew{end} ' ' Tend];
                end
            else
                Tnew{end+1}=Tend;
            end
        end
    end

    for iPr=1:length(Tnew)
        Tend=Tnew{iPr};
        k=strfind(Tend,'="');
        if isempty(k)
            Tend=1;
        end
        S.(Tend(1:k-1)) = Tend(k+2:end-1);
    end
end

return

function t =  replaceXMLEscape(t)

% Replace XML escape characters
xmlE ={'&quot;','" ';...
    '&apos;',  char(39);... 
    '&lt;',  '<';...
    '&gt;',  '>';...
    '&amp;',  '&'};

for iX=1:size(xmlE,1)
    
    t = strrep(t,xmlE{iX,1},xmlE{iX,2});
end





