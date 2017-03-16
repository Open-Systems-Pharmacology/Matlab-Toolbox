function modelTree_searchParameter(hmenu, ~, node)
%MODELTREE_SEARCHPARAMETER Context menu action for tree generated with createTree
%   search parameter defined by searchstring
%
%   modelTree_searchParameter(hmenu,evdata, node)
%       hmenu: javax.swing.JMenuItem
%       evdata: java.awt.event.ActionEvent
%       node: com.mathworks.hg.peer.UITreeNode
%       

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 21-Jun-2011

modelInfo=modelTree_getModelInfo(node,hmenu);
[ID,~,~,displaypath]=modelInfo.getNodeProperties(node);

% Get searchstring
prompt={['Enter the model path of the object to search:' char(10) 'Use * as wildcard']};
name='Searchstring';
numlines=1;
if strcmp(displaypath,'*') || ID>0
    defaultanswer={displaypath};
else
    defaultanswer={[displaypath '*']};
end
options.Resize='on';

answer=inputdlg(prompt,name,numlines,defaultanswer,options);

if isempty(answer)
    return
end

% get answer
path_id=answer{1};

% check for wildcards
ij_wildcards=strfind(path_id,'*');


selectednodes = javaArray('com.mathworks.hg.peer.UITreeNode', 1);

%search paths
for iBr=1:length(modelInfo.branches)
    
    % no wild card used:
    if isempty(ij_wildcards)
        jj=strcmpi(path_id,modelInfo.branches(iBr).displayPaths);
        if ~any(jj)
            selectedPaths=modelInfo.branches(iBr).displayPaths(jj);
        else
            selectedPaths='';
        end
    % all (path id = wildcard)
    elseif strcmp(path_id,'*')
         selectedPaths=modelInfo.branches(iBr).displayPaths;
    else
       if ij_wildcards(1)>1
           jj=strBegins(upper(modelInfo.branches(iBr).displayPaths),upper(path_id(1:ij_wildcards(1)-1)));
           selectedPaths=modelInfo.branches(iBr).displayPaths(jj);
       else
           selectedPaths=modelInfo.branches(iBr).displayPaths;
       end
       
       paths=selectedPaths;
       for iWildcard=1:length(ij_wildcards)-1
           key=path_id(ij_wildcards(iWildcard)+1:ij_wildcards(iWildcard+1)-1);
           tmp=regexpi(paths,key,'once');
           jj=cellfun(@isempty, tmp);
           selectedPaths=selectedPaths(~jj);
           paths=paths(~jj);
           ix=cell2mat(tmp(~jj));
           for i=1:length(paths)
               paths{i}= paths{i}(ix(i)+length(key):end);
           end
       end
       
       if ij_wildcards(end)<length(path_id)
           key=path_id(ij_wildcards(end)+1:end); 
           jj=strEnds(modelInfo.branches(iBr).displayPaths,key);
           selectedPaths=modelInfo.branches(iBr).displayPaths(jj);
       end
       
    end
    
    selectednodes_iBr=modelInfo.getNodesByDisplayPaths(iBr,selectedPaths);
    
    if ~isempty(selectednodes_iBr(1))
        if isempty(selectednodes(1))
            selectednodes=selectednodes_iBr;
        else
            selectednodes=[selectednodes selectednodes_iBr]; %#ok<AGROW>
        end
    end
    
end    

if ~isempty(selectednodes(1))
    
    tree=modelInfo.tree();

    if size(selectednodes,1)>1
        if tree.isMultipleSelectionEnabled;
            selectionMode='multiple';
        else
            selectionMode='single';
        end
        list=cell(size(selectednodes,1),1);
        for iN=1:size(selectednodes,1)
            nd=selectednodes(iN);
            tmp=nd.getUserObject;
            list{iN}=char(tmp(2));
        end
        [ix,isOK] = listdlg('Name','Search result',...
            'PromptString','More than one finding. Specify selection:',...
            'SelectionMode',selectionMode,'ListSize',[300 300],...
            'ListString',list);
        if ~isOK || isempty(ix)
            return
        else
            selectednodesx = javaArray('com.mathworks.hg.peer.UITreeNode', 1);
            for iN=1:length(ix)
                selectednodesx(iN)=selectednodes(ix(iN));
            end
            selectednodes=selectednodesx;
        end
    end
    
    % set Nodes to selected
    for i=1:2 %this has to be done twice, if children were added. Why, i don't know
        tree.repaint();
        pause(0.5);
        
        
        tree.setSelectedNodes(selectednodes);
        pause(0.5);
        
        jtree=tree.getTree();
        pt=jtree.getSelectionPath;
        jtree.scrollPathToVisible(pt(end));
    end
else
    msgbox('Nothing found, Please check search string!');
end

return


function [selectednodes,selectedPaths]=searchSelected(selectedPaths,pNode,modelInfo)

selectednodes = javaArray('com.mathworks.hg.peer.UITreeNode', 1);


try
for iC=1:pNode.getChildCount()
    node=pNode.getChildAt(iC-1);
    tmp=node.getUserObject();
    path_id=char(tmp(2));
    if node.getValue()>0
        jj=strcmp(path_id,selectedPaths);
        if any(jj)
            if isempty(selectednodes(1))
                selectednodes(1)=node;
            else
                selectednodes(end+1)=node; %#ok<AGROW>
            end
            selectedPaths=selectedPaths(~jj);
        end
    else
        jj= strncmp(path_id,selectedPaths,length(path_id));
        if any(jj)
            if node.getChildCount()==0
                node=modelTree_addChildren(node,modelInfo);
            end
            [selectednodes_tmp,selectedPaths_tmp]=searchSelected(selectedPaths(jj),node,modelInfo);
            selectedPaths= [selectedPaths(~jj); selectedPaths_tmp];
            if isempty(selectednodes(1))
                selectednodes=selectednodes_tmp;
            else
                selectednodes=[selectednodes selectednodes_tmp]; %#ok<AGROW>
            end
        end
    end
    if isempty(selectedPaths)
        break;
    end
end

catch exception
    disp(exception.message)
end
    
return


