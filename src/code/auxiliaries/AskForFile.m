function [FileName,PathName,FilterIndex] = AskForFile(FilterSpec,DialogTitle, InitialDirectory, DefaultName)

    %to be conform with uigetfile: file and path are set to 0 if cancelled
    FileName = 0; 
    PathName = 0;
    FilterIndex = 0;
    
    if ~exist('InitialDirectory','var') 
        InitialDirectory='';
    end
    
    if ~exist('DefaultName','var') 
        DefaultName='';
    end
    
    if ~exist('DialogTitle','var') 
        DialogTitle='Select a file';
    end
    
    NET.addAssembly('System.Windows.Forms');
    
    fileOpenDlg = System.Windows.Forms.OpenFileDialog;
    
    fileOpenDlg.Filter = FilterSpec;
    fileOpenDlg.Title = DialogTitle;
    
    if ~isempty(InitialDirectory)
        fileOpenDlg.InitialDirectory = InitialDirectory;
    end

    if ~isempty(DefaultName)
        fileOpenDlg.DefaultName = DefaultName;
    end

    dlgResult = fileOpenDlg.ShowDialog;
    
    if dlgResult ~= System.Windows.Forms.DialogResult.OK
        %cancelled by user
        return;
    end
    
    [PathName, FileName, ext] = fileparts(char(fileOpenDlg.FileName));
    PathName = [PathName filesep];
    FileName = [FileName ext];
    
    FilterIndex = fileOpenDlg.FilterIndex;
    
   