function [isCanceled,pathToPKSimInstallDir]=getPathToPKSimInstallDir(PKSimVersion)

	global MOBI_SETTINGS;

	isCanceled=false;

	if isempty(MOBI_SETTINGS)
		MoBiSettings;
	end

	if isfield(MOBI_SETTINGS,'pathToPKSimInstallDir')
		pathToPKSimInstallDir=MOBI_SETTINGS.pathToPKSimInstallDir;
	else

		pathToPKSimInstallDir = getpathToPKSimInstallDirFromRegistry(PKSimVersion);
		
		if isempty(pathToPKSimInstallDir)
			[isCanceled,pathToPKSimInstallDir] = getpathToPKSimInstallDirFromFileSystem(PKSimVersion);
			
			if isCanceled
                pathToPKSimInstallDir='';
				return
			end
		end
			
		MOBI_SETTINGS.pathToPKSimInstallDir=pathToPKSimInstallDir;
	end

	return

function pathToPKSimInstallDir = getpathToPKSimInstallDirFromRegistry(PKSimVersion)
	
	pathToPKSimInstallDir = '';
	
	try
		if isnumeric(PKSimVersion)
			PKSimVersion=sprintf('%.1f',PKSimVersion);
		end
		
		pathToPKSimInstallDir = winqueryreg('HKEY_LOCAL_MACHINE',sprintf('SOFTWARE\\Open Systems Pharmacology\\PK-Sim\\%s',PKSimVersion), 'InstallDir');
    catch
        pathToPKSimInstallDir = '';
	end
%
function [isCanceled,pathToPKSimInstallDir]=getpathToPKSimInstallDirFromFileSystem(PKSimVersion)

	global MOBI_SETTINGS;

	isCanceled=false;
	pathToPKSimInstallDir='';
	        
	PKSimSubFolder = [filesep SuiteInstallationSubfolder filesep 'PK-Sim*'];
	
	% try program files first (32 bit system)
	ProgramFiles=getenv('ProgramFiles');
	
	PKSimDirs=dir([ProgramFiles PKSimSubFolder]);
	if isempty(PKSimDirs)
		 % try program files x64 (64 bit system)
		ProgramFiles=getenv('ProgramFiles(x86)');
		PKSimDirs=dir([ProgramFiles PKSimSubFolder]);
	end
	
	if isempty(PKSimDirs)
		[isCanceled,pathToPKSimInstallDir] = getpathToPKSimInstallDirViaGui(ProgramFiles, 'Select the PK Sim Install directory:');
	elseif length( PKSimDirs) >1
		[isCanceled,pathToPKSimInstallDir] = getpathToPKSimInstallDirViaGui([ProgramFiles filesep SuiteInstallationSubfolder],...
			'Select the corresponding PK Sim Install directory:');
	else
		pathToPKSimInstallDir=([ProgramFiles filesep SuiteInstallationSubfolder filesep PKSimDirs(1).name]);
		if ~exist([pathToPKSimInstallDir filesep 'PKSim.Matlab.dll'], 'file')
			[isCanceled,pathToPKSimInstallDir] = getpathToPKSimInstallDirViaGui(ProgramFiles, 'Select the PK Sim Install directory:');
		end
	end
	
	if isCanceled
		return
	end
    
function [isCanceled,pathToPKSimInstallDir]=getpathToPKSimInstallDirViaGui(basePath, promptMessage)
    isCanceled=false;
	pathToPKSimInstallDir='';
    
    pathToPKSimInstallDir = uigetdir(basePath, promptMessage);
    
    if isnumeric(pathToPKSimInstallDir)
        isCanceled=true;
        return
    end

    if ~exist([pathToPKSimInstallDir filesep 'PKSim.Matlab.dll'], 'file')
        msgbox('Invalid PK-Sim installation directory selected', 'Error', 'error', 'modal');
        isCanceled=true;
        return
    end
