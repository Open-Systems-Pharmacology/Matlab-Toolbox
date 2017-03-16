classdef ModelTree
%MODELTREE Treeview to display the model parameters hierarchically
%

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 28-Sept-2011

   properties
       
      branches=struct('type',[],'name',[],'displayPaths',[],'IDs',[],'simulationIndices',[],'IconPath',[]); 
      
      % tree
      tree;

      % Jmenu
      jmenu = javax.swing.JPopupMenu;
      menuItem=javaArray('javax.swing.JMenuItem', 1);
      menuIsVisible=true(0,1);
      functionList={};
       
      % treeoptions
      multipleSelection=true;
      
      % options for displaying menus  
      showFormulaMenu=true;
      showDescriptionMenu=true;
      withSearchMenu=true

      % options for displaying nodes
      showFormulaIcon=true;
      displayWithValue=true;

      % parent handle
      h_parent; 
      
      name='Root';
      handle_identifier;
      tree_pos=[0 0 1 1];
   end
   
   methods
       %% constructor
       function obj = ModelTree(h_parent,name,handle_identifier,tree_pos,multipleSelection)
           import javax.swing.*
           
           warning('off','MATLAB:uitree:DeprecatedFunction')
           warning('off','MATLAB:uitreenode:DeprecatedFunction')
           warning('off','MATLAB:hg:JavaSetHGProperty')
           warning('off','MATLAB:hg:g_object:TransformFcnNotSet')
           
           
           obj.branches=obj.branches([]);
           obj.h_parent=h_parent;
           obj.name=name;
           obj.handle_identifier=handle_identifier;
           obj.tree_pos=tree_pos;
           obj.multipleSelection=multipleSelection;
           
           obj.jmenu = javax.swing.JPopupMenu();
           obj.menuItem = javaArray('javax.swing.JMenuItem', 1);
       end
      
      %% add a branch by specified arrays
      function obj=addBranch(obj,type,name,displayPaths,IDs,simulationIndices,iconPaths)
         
          obj.branches(end+1).type=type;
          obj.branches(end).name=name;
          
          % Replace object delimiter as first letter
          jj=strBegins(displayPaths,object_path_delimiter);
          if any(jj)
              for i=find(jj)'
                  displayPaths{i}=displayPaths{i}(2:end);
              end
          end
          obj.branches(end).displayPaths=displayPaths;
          
          % IDs
          if length(IDs)~=length(displayPaths)
              error('The branch Ids must have the same  number as the branch display pathes');
          end
          if iscell(IDs)
              IDs=cell2mat(IDs);
          end
          obj.branches(end).IDs=IDs;
          
          % simulation indices
          if length(simulationIndices)~=length(displayPaths) && length(simulationIndices)>1
              error('The branch simulation indices must have the same  number as the branch display pathes');
          end
          if iscell(simulationIndices)
              simulationIndices=cell2mat(simulationIndices);
          end
          
          uni_simulationIndices=unique(simulationIndices);
          if length(uni_simulationIndices)==1    
              obj.branches(end).simulationIndices=uni_simulationIndices;
          else
              obj.branches(end).simulationIndices=simulationIndices;
          end
              
          % Icon path 
          if exist('iconPaths','var')
              if length(iconPaths)~=length(displayPaths)
                  error('The branch icon paths must have the same  number as the branch display pathes');
              end
              obj.branches(end).iconPaths=iconPaths;
          else
              obj.branches(end).iconPaths={};
          end
      end
      
      %% reset branches
      function obj=resetBranch(obj)
          obj.branches=obj.branches([]);  
      end
      
      %% create tree
      function obj=generateTreeByBranches(obj)
          
          import javax.swing.*
          import javax.swing.tree.*;
                   
          rootNode = uitreenode('v0',0, obj.name, [], 0);
          
          % add nodes for branches
          for iB=1:length(obj.branches)
              node = uitreenode('v0',0, obj.branches(iB).name, '', false);
              node.setUserObject({iB,'*'});
              rootNode.add(node);
              
          end
          
          
          % set treeModel
          treeModel = DefaultTreeModel( rootNode );
 
          % create the tree
          h_tmp=obj.h_parent;
          while ~ishghandle(handle(h_tmp), 'figure')
              h_tmp=get(h_tmp,'Parent');
          end
          obj.tree = uitree('v0','Parent',h_tmp);
          obj.tree.setModel( treeModel );
          set(obj.tree.UIContainer,'Parent',obj.h_parent);

          % rootNode.setParent(tree);
          obj.tree.setRoot(rootNode);

          % set Expandfunction
          set(obj.tree, 'NodeExpandedCallback', @modelTree_expandFunction );

          % get Java Tree
          jtree = obj.tree.getTree;

          
          % add show Formula to menu
          if obj.showFormulaMenu
              obj=obj.addMenu('Show formula',@modelTree_showFormula);
          end
          
          % add show Description to menu
          if obj.showDescriptionMenu
              obj=obj.addMenu('Show description',@modelTree_showDescription);
          end
          
          % add search menu
          if obj.withSearchMenu
              obj=obj.addMenu('Search by string',@modelTree_searchParameter);
          end
          
          % Set the tree mouse-click callback
          if ~isempty(obj.menuItem(1))
              % Set the tree mouse-click callback
              % Note: MousePressedCallback is better than MouseClickedCallback
              %       since it fires immediately when mouse button is pressed,
              %       without waiting for its release, as MouseClickedCallback does
              warning('off','MATLAB:hg:g_object:TransformFcnNotSet');
              set(jtree, 'MousePressedCallback', {@modelTree_mousePressedCallback,obj.jmenu,obj.functionList,obj.menuIsVisible});
          end
          
          % place tree on figure
          jScrollPane = com.mathworks.mwswing.MJScrollPane(jtree);
          [~,hcontainer ] = javacomponent(jScrollPane,[20 20 20 20],obj.h_parent);
          set(hcontainer, 'units', 'normalized', 'position', obj.tree_pos);
          % if get(tree.getUIContainer,'Parent')==h_figure
          if ishghandle(handle(obj.h_parent), 'figure')
              set(obj.tree,'units', 'normalized', 'position', obj.tree_pos);
          else
              h_pos=get(obj.h_parent,'position');
              tre_pos_2(3)=obj.tree_pos(3)*h_pos(3)/2;
              tre_pos_2(4)=obj.tree_pos(4)*h_pos(4)/2;
              tre_pos_2(1)=h_pos(1)+obj.tree_pos(1)*h_pos(3)+1/10*tre_pos_2(3);
              tre_pos_2(2)=h_pos(2)+obj.tree_pos(2)*h_pos(4)+1/10*tre_pos_2(4);
              set(obj.tree,'units', 'normalized', 'position', tre_pos_2);
          end
          
          % set multipleSelection
          obj.tree.setMultipleSelectionEnabled(obj.multipleSelection);
          
          % set tree and corresponding info as appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
          rootNode.setUserObject(obj.handle_identifier);
          obj.tree.setRoot(rootNode);
          
          set(obj.tree.UIContainer,'Parent',obj.h_parent);
          
          %set selected Node
          if  rootNode.getChildCount>1
              obj.tree.setSelectedNode(rootNode.getChildAt(0))
          else
              obj.tree.setSelectedNode(rootNode);
          end
                      
      end
        
      
       %% create nonModel tree
      function [obj,rootNode]=generateTreeAsRootNode(obj)
          
          import javax.swing.*
          import javax.swing.tree.*;
                   
          rootNode = uitreenode('v0',0, obj.name, [], 0);
          
          
          % set treeModel
          treeModel = DefaultTreeModel( rootNode );
 
          % create the tree
          h_tmp=obj.h_parent;
          while ~ishghandle(handle(h_tmp), 'figure')
              h_tmp=get(h_tmp,'Parent');
          end
          obj.tree = uitree('v0','Parent',h_tmp);
          obj.tree.setModel( treeModel );
          set(obj.tree.UIContainer,'Parent',obj.h_parent);

          % rootNode.setParent(tree);
          obj.tree.setRoot(rootNode);

          % get Java Tree
          jtree = obj.tree.getTree;

          % Set the tree mouse-click callback
          if ~isempty(obj.menuItem)
              % Set the tree mouse-click callback
              % Note: MousePressedCallback is better than MouseClickedCallback
              %       since it fires immediately when mouse button is pressed,
              %       without waiting for its release, as MouseClickedCallback does
              set(jtree, 'MousePressedCallback', {@modelTree_mousePressedCallback,obj.jmenu,obj.functionList,obj.menuIsVisible});
          end
          
          % place tree on figure
          jScrollPane = com.mathworks.mwswing.MJScrollPane(jtree);
          [~,hcontainer ] = javacomponent(jScrollPane,[20 20 20 20],obj.h_parent);
          set(hcontainer, 'units', 'normalized', 'position', obj.tree_pos);
          % if get(tree.getUIContainer,'Parent')==h_figure    
          pnew=obj.h_parent;
          while ~ishghandle(handle(pnew), 'figure')
              pnew=get(pnew,'parent');
          end
           h_pos=get(pnew,'position');
           set(obj.tree,'units', 'normalized', 'position',h_pos);
% 
%           else
%               pnew=get(pnew,'parent')
%               h_pos=get(obj.h_parent,'position');
%               tre_pos_2(3)=obj.tree_pos(3)*h_pos(3)/2;
%               tre_pos_2(4)=obj.tree_pos(4)*h_pos(4)/2;
%               tre_pos_2(1)=h_pos(1)+obj.tree_pos(1)*h_pos(3)+1/10*tre_pos_2(3);
%               tre_pos_2(2)=h_pos(2)+obj.tree_pos(2)*h_pos(4)+1/10*tre_pos_2(4);
%               set(obj.tree,'units', 'normalized', 'position', tre_pos_2);
%           end
          
          % set multipleSelection
          obj.tree.setMultipleSelectionEnabled(obj.multipleSelection);
          
          % set tree and corresponding info as appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
          rootNode.setUserObject(obj.handle_identifier);
          obj.tree.setRoot(rootNode);
          
          set(obj.tree.UIContainer,'Parent',obj.h_parent);
          
          %set selected Node
          if  rootNode.getChildCount>1
              obj.tree.setSelectedNode(rootNode.getChildAt(0))
          else
              obj.tree.setSelectedNode(rootNode);
          end
                      
      end
        
      
      
      %% deletes all nodes  --------
      function [obj,rootNode]=resetTreeToRootNode(obj)

          rootNode=obj.tree.getRoot;
          rootNode.removeAllChildren();
      
          % update appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
      end
      %% deletes all nodes and creates new ones out of the branches --------
      function obj=resetTreeByBranches(obj)

          rootNode=obj.tree.getRoot;
          rootNode.removeAllChildren();
          
      % add nodes for branches
          for iB=1:length(obj.branches)
              node = uitreenode('v0',0, obj.branches(iB).name, '', false);
              node.setUserObject({iB,'*'});
              rootNode.add(node);
              
          end
          
          % rootNode.setParent(tree);
          obj.tree.setRoot(rootNode);
          
           %set selected Node
          if  rootNode.getChildCount>1
              obj.tree.setSelectedNode(rootNode.getChildAt(0))
          else
              obj.tree.setSelectedNode(rootNode);
          end
          
          % update appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
          
      end    
          
      function refreshNode(obj,node)
          
          obj.tree.reloadNode(node);
          obj.tree.repaint();
          
          % update appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
          
      end
      
      %% set selection call back
      function obj=addNodeSelectedCallback(obj,functionHandle)
          
          set(obj.tree, 'NodeSelectedCallback',functionHandle);
          % update appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
          
      end
       
       %% set drag and drop call back
      function obj=addDragAndDropCallback(obj,functionHandle)
          
          obj.tree.DndEnabled=true;
          set(obj.tree, 'NodeDroppedCallback',functionHandle);
          
          % update appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
          
      end
      
      %% Reload root Node
      function obj=reloadRootNode(obj,rootNode,selectedNode)
          
          % reload Root Node
          obj.tree.reloadNode(rootNode);

          drawnow;
                    
          % set first leaf as selected
          if ~exist('selectedNode','var')
              selectedNode=rootNode.getFirstLeaf();
          end
          obj.tree.setSelectedNode(selectedNode);


          % update appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
          
      end
      
      %% delete Node
      function deleteNode(obj,node)
          
          treeModel=obj.tree.Model;
          treeModel.removeNodeFromParent(node);
          obj.tree.repaint();
          
          % update appdata
          setappdata(obj.h_parent,obj.handle_identifier,obj);
    end
      %% add a new menu entry -----------------------------------------------
      function obj=addMenu(obj,displayName,functionHandle)
                    
          indx=length(obj.functionList)+1;
              
          obj.menuItem(indx) = javax.swing.JMenuItem(displayName);
          obj.menuItem(indx).setName(char(functionHandle)); 
          obj.jmenu.add(obj.menuItem(indx));
          obj.functionList{indx}=functionHandle;
          obj.menuIsVisible(indx)=true;
          
      end
      
      %% add a new menu entry -----------------------------------------------
      function obj=addMenuSeparator(obj)
                    
          obj.jmenu.addSeparator;
          
      end
      %%
      function [ID,type,simulationIndex,displaypath,iBranch]=getNodeProperties(obj,node)
          
          ID=node.getValue();
          usrObject=node.getUserObject();
          iBranch=0;
          
          if ID>0 %is leaf
              
              displaypath=char(usrObject(2));
              iBranch=usrObject(1);
              type=obj.branches(iBranch).type;
              
              if length(obj.branches(iBranch).simulationIndices)==1
                  simulationIndex=obj.branches(iBranch).simulationIndices(1);
              else
                  jj=strcmp(obj.branches(iBranch).displayPaths,displaypath);
                  simulationIndex=obj.branches(iBranch).simulationIndices(jj);
              end
          else 
              simulationIndex=nan;
              if length(usrObject)==2 % is branch node
                  iBranch=usrObject(1);
                  type=obj.branches(iBranch).type;                 
                  displaypath=char(usrObject(2));
              else % rootNode
                  displaypath=char(usrObject(1));
                  type='';
              end
          end
      end
      
      %% setNodeToSelectedByPathId
      function setNodeToSelectedByPathId(obj,path_id,type,simulationIndex)
          
          % set Default inputs
          if ~exist('simulationIndex','var')
              simulationIndex=1;
          end
          
          % get ID
          if isnumeric(path_id)
              ID=path_id;
          else
              switch type
                  case 'P'
                      ID=getParameter(path_id,simulationIndex,'property','ID');
                  case 'S'
                      ID=getSpeciesInitialValue(path_id,simulationIndex,'property','ID');
                  case 'O'
                      ID=getObserverFormula(path_id,simulationIndex,'property','ID');
              end
          end
          
          % get Branch and then display path
          iBR_list=find(strcmp({obj.branches(:).type},type));
          jj=false;
          for iBr=iBR_list
              if length(obj.branches(iBr).simulationIndices)==1 && ...
                  obj.branches(iBr).simulationIndices==simulationIndex
                      jj=[obj.branches(iBr).IDs]==ID ;
              else
                  jj=[obj.branches(iBr).IDs]==ID & [obj.branches(iBr).simulationIndices]==simulationIndex;
              end
              if any(jj)
                  displayPath=obj.branches(iBr).displayPaths(jj);
                  break
              end
          end
          
          if ~any(jj)
              return
          end
          
          % get nodes array
          nodes = getNodesByDisplayPaths(obj,iBr,displayPath);
          
          % set Nodes to selected
          for i=1:2 %this has to be done twice, if children were added. Why, i don't know
               obj.tree.repaint();
              pause(0.5);
              
              obj.tree.setSelectedNodes(nodes);
              pause(0.5);
              
              jtree=obj.tree.getTree();
              pt=jtree.getSelectionPath;
              jtree.scrollPathToVisible(pt(end));
          end
          
      end
      
      %% getNodesByDisplayPaths
      function nodes = getNodesByDisplayPaths(obj,iBr,displayPaths)

          rootNode=obj.tree.getRoot();
          nodes = javaArray('com.mathworks.hg.peer.UITreeNode', 1);
          if ~isempty(displayPaths)
              branchNode=rootNode.getChildAt(iBr-1);
              if branchNode.getChildCount()==0 && branchNode.getValue==0
                  branchNode=addChildrenToNode(obj,branchNode);
              end
              [nodes,displayPaths]=searchSelected(obj,displayPaths,branchNode); %#ok<NASGU>
          end
      end
      
      %% getNodesByDisplayPaths
      function node = getNodeByID(obj,ID,type)
          
          node = [];
          
          for iBr=1:length(obj.branches)
              if strcmp(obj.branches(iBr).type,type)
                  jj=obj.branches(iBr).IDs==ID;
                  if any(jj)
                      nodes = getNodesByDisplayPaths(obj,iBr,displayPaths(jj));
                      node=nodes(1);
                      break;
                  end
              end
          end
          
      end
      
      %%searchSelected
      function [nodes,displayPaths]=searchSelected(obj,displayPaths,pNode)

          nodes = javaArray('com.mathworks.hg.peer.UITreeNode', 1);

          for iC=1:pNode.getChildCount()
              node=pNode.getChildAt(iC-1);
              tmp=node.getUserObject();
              path_id=char(tmp(2));
              if node.getValue()>0
                  jj=strcmp(path_id,displayPaths);
                  if any(jj)
                      if isempty(nodes(1))
                          nodes(1)=node;
                      else
                          nodes(end+1)=node; %#ok<AGROW>
                      end
                      displayPaths=displayPaths(~jj);
                  end
              else
                  jj= strncmp(path_id,displayPaths,length(path_id));
                  if any(jj)
                      if node.getChildCount()==0
                          node=addChildrenToNode(obj,node);
                      end
                      [nodes_tmp,displayPaths_tmp]=searchSelected(obj,displayPaths(jj),node);
                      displayPaths= [displayPaths(~jj); displayPaths_tmp];
                      if isempty(nodes(1))
                          nodes=nodes_tmp;
                      else
                          nodes=[nodes nodes_tmp]; %#ok<AGROW>
                      end
                  end
              end
              if isempty(displayPaths)
                  break;
              end
          end

      end
      
      %%
      function node=addChildrenToNode(obj,node)

          [~,type,~,path_id,iBranch]=getNodeProperties(obj,node);
          path_id_reg=strrep(char(path_id),object_path_delimiter,['\' object_path_delimiter]); 
          % meta character
          path_id_reg=strrep(path_id_reg,')','\)');          
          path_id_reg=strrep(path_id_reg,']','\]');          
          path_id_reg=strrep(path_id_reg,'+','\+');          
          path_id_reg=strrep(path_id_reg,'?','\?');          
          p_path=obj.branches(iBranch).displayPaths;
          
          tmp=which('Icon_Cancel.png');
          iconPath=fileparts(tmp);

          
          if strcmp(path_id,'*')
              jj_all=true(1,length(p_path));
              x=regexp(p_path,['\' object_path_delimiter],'split','once');
          else
              jj_all=strncmp(path_id,p_path,length(path_id));
              p_path=p_path(jj_all);
              p_path=regexprep(p_path,path_id_reg,'');
              x=regexp(p_path, ['\' object_path_delimiter],'split','once');
          end

          if ~isempty(p_path)
              iNextChild=1;
          else
              iNextChild=[];
          end
          jj=false(length(x),1);
          while ~isempty(iNextChild)
              startPath=x{iNextChild}{1};
             
              jj_startPath=strcmp(startPath,p_path) & ~jj;
              isLeaf=any(jj_startPath);
%               jj_leaf=cellfun(@length,x(jj_startPath))==1;
              if isLeaf
                  ix_all=find(jj_all);
                  ix=ix_all(jj_startPath);
                  if length(ix) == 1 
                      p_leaf=p_path{jj_startPath};
                      if length(obj.branches(iBranch).simulationIndices)==1
                          simulationIndex=obj.branches(iBranch).simulationIndices;
                      else
                          simulationIndex=obj.branches(iBranch).simulationIndices(ix);
                      end
                      ID=obj.branches(iBranch).IDs(ix);
                      % get properties
                      switch type
                          case 'P'
                              value=getParameter(ID,simulationIndex);
                              isFormula=getParameter(ID,simulationIndex,'property','isFormula');
                              isTable=getParameter(ID,simulationIndex,'property','IsTable');
                              unit=getParameter(ID,simulationIndex,'property','Unit');
                          case 'S'
                              value=getSpeciesInitialValue(ID,simulationIndex);
                              isFormula=getSpeciesInitialValue(ID,simulationIndex,'property','isFormula');
                              unit=getSpeciesInitialValue(ID,simulationIndex,'property','Unit');
                              isTable=false;
                          case 'O'
                              value=nan;
                              isFormula=false;
                              unit=getObserverFormula(ID,simulationIndex,'property','Unit');
                              isTable=false;
                      end
                      % get displayName
                      if obj.displayWithValue && ~isnan(value)
                          value_txt=strtrim(sprintf('%.3g %s',value,unit));
                          displayName=sprintf('%s (%s)',p_leaf,value_txt);
                      else
                          displayName=p_leaf;
                      end

                      % addNode
                      if obj.showFormulaIcon && isFormula
                          newNode = uitreenode('v0',ID,displayName, ...
                              fullfile(matlabroot,'toolbox','matlab','icons','help_fx.png'), true);
                      elseif obj.showFormulaIcon && isTable
                          newNode = uitreenode('v0',ID,displayName, ...
                              [iconPath filesep 'Table.png'], true);
                      elseif ~isempty(obj.branches(iBranch).iconPaths)
                          newNode = uitreenode('v0',ID,displayName, ...
                              obj.branches(iBranch).iconPaths{ix}, true);
                      else
                          newNode = uitreenode('v0',ID,displayName,'', true);
                      end

                      % set user object
                      if ~strcmp(path_id,'*')
                          newpath_id=[char(path_id)  p_leaf];
                      else
                          newpath_id=[p_leaf];
                      end
                      newNode.setUserObject({iBranch,newpath_id});
                      node.add(newNode);
                  else
                      warning('There was a not unique path which has been ignored!');
                  end
              else
                  jj_startPath=strncmp([startPath object_path_delimiter],p_path,length(startPath)+1);
                  newNode = uitreenode('v0',0, startPath, '', false);
                  if ~strcmp(path_id,'*')
                      newNode.setUserObject({iBranch,[char(path_id)  startPath  object_path_delimiter]});
                  else
                      newNode.setUserObject({iBranch,[startPath object_path_delimiter]});
                  end
                  node.add(newNode);
              end
              
              jj=jj | jj_startPath;
              iNextChild=find(~jj,1);
          end
      end
      %% setSelectedMenusVisible
      function   setSelectedMenusVisible(obj,selMenuItemNames)
          
          for iM=1:length(obj.menuItem)              
              if any(strcmp(selMenuItemNames,get(obj.menuItem(iM),'Name')))
                  obj.menuIsVisible(iM)=true;
              else
                  obj.menuIsVisible(iM)=false;
              end
          end
          
          jtree = obj.tree.getTree;

          set(jtree, 'MousePressedCallback', {@modelTree_mousePressedCallback,obj.jmenu,obj.functionList,obj.menuIsVisible});
          
          
          setappdata(obj.h_parent,obj.handle_identifier,obj);
      end
   end
   
end
