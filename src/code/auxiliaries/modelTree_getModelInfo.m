function  [modelInfo,handles,tree]=modelTree_getModelInfo(node,hmenu)
%MODELTREE_GETMODELINFO Get the corresponding ModelTree
%
%   [modelInfo,handles,tree]=modelTree_getModelInfo(node,hmenu)   
%       node (uiNode): corresponding node
%       hmenu (handle): menu handle
%       modelInfo (modelTree): 
%       handles: handles of the GUI
%       tree: javatree
%

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 28-Sept-2011

rootNode=node.getRoot();
h_figure = getappdata(hmenu,'Parent');
handle_text=rootNode.getUserObject();
modelInfo=getappdata(h_figure,handle_text);

% gethandles
tree=modelInfo.tree();
handles = guidata(get(tree.UIContainer,'Parent'));

return
