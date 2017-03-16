function isCanceled = loadPKSimMatlabDLL

    % get PK-Sim installation path
    [isCanceled,pathToPKSimInstallDir]=getPathToPKSimInstallDir(OSPSuiteVersion);

    if isCanceled
        return
    end

    %---- create new instance of PK-Sim interface
    if isempty(which('PKSim.Matlab.MoleculeOntogeny'))
        NET.addAssembly([pathToPKSimInstallDir '\PKSim.Matlab.dll']);
        NET.addAssembly('System.Core');
        NET.addAssembly([pathToPKSimInstallDir '\PKSim.Core.dll']);
    end
    
