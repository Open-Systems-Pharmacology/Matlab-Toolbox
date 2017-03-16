% #######################################################################
% MoBi® Basis Toolbox for Matlab®
% auxiliaries 
% functions which are called by other functions 
% and are used in more than one MoBi® Toolbox
% #######################################################################
%
% support function for MoBi Toolboxes
%   checkInputOptions                  - Support function: Checks options and returns option values
%   findTableIndex                     - Support function: Finds the row index of an input table for a parameter specified by path_id
%   checkInputSimulationIndex          - Support function: Checks if the simulation index is valid
%   clearSimulation                    - Support function: Deletes the Initialization of an XML file.
%   writeToLog                         - Support function: Writes text to logfile. Each entry starts with a time stamp
%   getApplicationMode                 - support function: %-- get the Mode of the application
%   getLicenseStructure                - support function: Returns the license object
%   object_path_delimiter              - Returns the path separator for XML files
%
% general support functions  
%   readtab                            - Support function: Read data from ascii files.
%   writetab                           - Support function: Write data to ascii files.
%   strBegins                          - Support function: Checks if string in a cell array begins with a string
%   strContains                        - Support function: Checks if a string in a cell array contains expr
%   strEnds                            - Support function: Checks if string in a cell array ends with a string
%   constructErrorMessageForExceptions - Support function: creates Error message for software crashes
%   getPercentilePotenzText            - Support function: Returns potenz text for percentiles depending on value
%   resetExcelSheet                    - Support function: clear the excel sheet
%
% Functions which calls DCI
%   PKSimCreateIndividual              - Creates physiology parameters of an mean individual 
%
% support functions for GUIS
%   guiCheckNumerical                  - GUI support function: Checks if the input of a GUI field is numerical
%   getHelpFile                        - GUI support function: returns the path of the helpfile corresponding to the calling GUI
%
% Functions to build and manage trees out of model parameters
%   ModelTree                          - Treeview to display the model parameters hierarchically
%   modelTree_showDescription          - Context menu action for tree generated with createTree
%   modelTree_searchParameter          - Context menu action for tree generated with createTree
%   modelTree_showFormula              - Context menu action for tree generated with createTree
%   modelTree_mousePressedCallback     - Set the mouse-press callback
%   modelTree_getModelInfo             - Get the corresponding ModelTree
%   modelTree_expandFunction           - Set the mouse-press callback
%   getDescriptionArrays               - Returns the description Arrays without model name
%   getOutputDescriptionArrays         - Returns the description Arrays without model name
%
% Unit conversion
%   UnitConverter                      - a GUI suited to add new units to the MoBi Toolboxes
%   iniUnitList                        - Returns all stored units and dimensions
%   generateUnitsOutOfXml              - 
%   getUnitFactor                      - Factor needed for transferring values from unit_source to unit_target
%   getUnitsForDimension               - Returns all stored units for this dimension
%   getDimensions                      - Returns all stored dimensions
%
% a GUI suited to add new filters an numeric vectors or cellarray of strings
%   createFilterCondition              - MATLAB code for createFilterCondition.fig
%
% Import of data sets
%   dataImport                         - MATLAB code for dataImport.fig
%
% Export to pdf
%   ps2pdf                             - Function to convert a PostScript file to PDF using Ghostscript
%   ps2pdf_MoBi                        - Calls the matlab function ps2pdf with the ghostview paths, save as user settings.
