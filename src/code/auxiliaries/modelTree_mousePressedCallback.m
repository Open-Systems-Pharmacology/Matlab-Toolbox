function modelTree_mousePressedCallback(~, eventData, jmenu,functionList,isVisible)
%MODELTREE_MOUSEPRESSEDCALLBACK Set the mouse-press callback
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

if eventData.isMetaDown % right-click is like a Meta-button
    % Get the clicked node
    clickX = eventData.getX;
    clickY = eventData.getY;
    jtree = eventData.getSource;
    treePath = jtree.getPathForLocation(clickX, clickY);
    
    if(~isempty(treePath))
        menuItem=jmenu.getSubElements;
        warning('off','MATLAB:hg:PossibleDeprecatedJavaSetHGProperty');
        for iMenu=1:length(menuItem)
            if isVisible(iMenu)
                set(menuItem(iMenu),'Visible','on');
            else
                set(menuItem(iMenu),'Visible','off');
            end
        end
        jmenu.show(jtree, clickX, clickY);
        jmenu.repaint;
        node = treePath.getLastPathComponent;
        % Set the menu item's callbacks
        menuItem=jmenu.getSubElements;
        warning('off','MATLAB:hg:PossibleDeprecatedJavaSetHGProperty');
        for iMenu=1:length(menuItem)
            set(menuItem(iMenu),'ActionPerformedCallback',{functionList{iMenu}, node});
        end
    end
end

return