% TEST
%
% Main function starts the test loop:
%   loop_BasisToolBox                        - automatical test basis Toolbox
%
%
% Function for use cases:
%   0) support functions
%   test_0_checkInputOptions                 - Test of Function checkInputOptions
%   test_0_checkInputSimulationIndex         - Test of Function checkInputOptions
%   test_0_findTableIndex                    - Test call of findTableIndex 
%
%
%   1) Initializing
%   test_1_MoBiSettings                      - Test of Function checkInputOptions
%   test_1_initSimulation_addFile            - Test call of initSimulation (check option addFile)
%   test_1_initSimulation_variableParameters - Test of Function checkInputOptions
%   test_1_initSimulation_xml                - Test call of initSimulation (check input variable XML)
%
%
%   2) Parameter Manipulation
%   test_2_existsParameter                   - Test of Function existsParameters and existsSpeciesInitialValues
%   test_2_getParameter                      - Test of Function getParameters and getSpeciesInitialValues
%   test_2_setAllParameters                  - Test of Function setParameters and setSpeciesInitialValues
%   test_2_setParameter                      - Test of Function setParameters and setSpeciesInitialValues
%   test_2_setRelativeParameter              - Test of Function setRelativeParameter and setSpeciesInitialValue
%
%   3) Observer
%   test_3_getObserverFormula                - Test of Function getObserverFormula
%
%   4) TimePattern
%   test_4_getSimulationTime                 - Test of Function checkInputOptions
%
%   5) ProcessSimulation
%   test_5_processSimulation                 - Test of Function checkInputOptions
%
%   6) Analysis Results
%   test_6_getPKParametersForConcentration   - Test of Function checkInputOptions
%   test_6_getSimulationResult               - Test of Function checkInputOptions
%
%   9) Additional useful functions
%   test_9_compareSimulations                - Test of Function compareSimulation
%   test_9_getNormFigure                     - Test of Function getNormFigure
%   test_9_setAxesScaling                    - Test of Function setAxesScaling
%
%   13) test_suuport functions
%   test_13_createTree                       - Test of Function setAxesScaling
%   test_13_treeGUI                          - MATLAB code for test_13_treeGUI.fig
%
% Support functions:
%   checkHelptextForDirectory                - Scan all functions of a directory and checks if a valid helptext exists
%   mergeErrorFlag                           - merges Array of ErrorMessages and error Flags to one resulting Flag and message
