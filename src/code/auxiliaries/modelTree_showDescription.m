function modelTree_showDescription(hmenu, evdata, node)
%MODELTREE_SHOWDESCRIPTION Context menu action for tree generated with createTree
%   shows the description of a node
%
%   showDescriptionInTree(hmenu, evdata, node)
%       hmenu: javax.swing.JMenuItem
%       evdata: java.awt.event.ActionEvent
%       node: com.mathworks.hg.peer.UITreeNode
%       

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 21-Jun-2011

[modelInfo,handles]=modelTree_getModelInfo(node,hmenu);
[ID,type,simulationIndex]=modelInfo.getNodeProperties(node);

if ID > 0
    description='Description is not implemented yet in the interface';

    msgbox(description,'Description:');
else
    set(handles.warning_text,'String','Select a parameter or a initial value.');
end
return
