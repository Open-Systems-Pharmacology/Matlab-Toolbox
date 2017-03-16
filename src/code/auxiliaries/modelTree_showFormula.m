function modelTree_showFormula(hmenu, evdata, node)
%MODELTREE_SHOWFORMULA Context menu action for tree generated with createTree
%   shows the formula of a node
%
%   showFormulaInTree(hmenu, evdata, node)
%       hmenu: javax.swing.JMenuItem
%       evdata: java.awt.event.ActionEvent
%       node: com.mathworks.hg.peer.UITreeNode
%       

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 4-Jan-2011


[modelInfo,handles]=modelTree_getModelInfo(node,hmenu);
[ID,type,simulationIndex]=modelInfo.getNodeProperties(node);

if ID>0
    
    switch type
        case {'P','pop'}  % pop is called by Population simulation define populations
            isFormula=getParameter(ID,simulationIndex,'property','isFormula');
            if isFormula
                formula=getParameter(ID,simulationIndex,'property','Formula');
            else
                formula=num2str(getParameter(ID,simulationIndex));
            end
        case 'S'
            isFormula=getSpeciesInitialValue(ID,simulationIndex,'property','isFormula');
            if isFormula
                formula=getSpeciesInitialValue(ID,simulationIndex,'property','Formula');
            else
                formula=num2str(getSpeciesInitialValue(ID,simulationIndex));
            end
        case 'O'
            formula=getObserverFormula(ID,simulationIndex,'property','Formula');
    end
    msgbox(formula,'Formula:');
else
    set(handles.warning_text,'String','Select a parameter or a initial value.');
end

return
