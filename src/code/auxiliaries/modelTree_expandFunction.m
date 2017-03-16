function nodes=modelTree_expandFunction(tree, evd)
%MODELTREE_EXPANDFUNCTION Set the mouse-press callback
%
%   nodes=modelTree_expandFunction(tree, evd)
%       tree: uitree
%       evd: event
%       nodes (uiNode): corresponding node
%

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 28-Sept-2011

try
    
    nodes=[];
    % get current Node
    selectedNode=evd.getCurrentNode;
    tree.setSelectedNode(selectedNode);
    
    % get modelTree inf
    rootNode=tree.getRoot();
    h_figure = get(tree.UIContainer,'Parent');
    handle_text=rootNode.getUserObject();
    modelInfo=getappdata(h_figure,handle_text);
    
    if selectedNode.getChildCount()>0;
        nodes = javaArray('com.mathworks.hg.peer.UITreeNode', 1);
        for iNode=1:selectedNode.getChildCount();
            child=selectedNode.getChildAt(iNode-1);
            
            childID=child.getValue();
            if childID==0 && child.getChildCount()==0
                child=modelInfo.addChildrenToNode(child);
            end
            nodes(iNode)=child;
        end
    end
    

    nodes=[];
catch exception
    disp(exception.message)
end



return