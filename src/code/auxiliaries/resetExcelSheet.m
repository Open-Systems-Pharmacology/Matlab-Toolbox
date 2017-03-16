function resetExcelSheet(xlsfile,sheet)
%RESETEXCELSHEET Support function: clear the excel sheet
% overwrite all existing cells with nan
%
%   resetExcelSheet(xlsfile,sheet)
%       - xlsfile (string) : path end filename of sheet
%       - sheet (string/ double) : sheet name or number
% Example Call:
% resetExcelSheet('test.xlsx','Table1')
% resetExcelSheet('test.xls',1)

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 6-Dec-2011


% exists the file ?
if ~exist(xlsfile,'file')
    return
end

% exists the sheet?
[~,desc]=xlsfinfo(xlsfile);
if isnumeric(sheet)
    if length(desc)<sheet
        return
    else
        sheet=desc{sheet};
    end
else
    jj=strcmp(sheet,desc);
    if ~any(jj)
        return
    end
end

% overwrite all existing cells with nan
[~,~,raw]=xlsread(xlsfile,sheet);
X=nan*ones(size(raw));
xlswrite(xlsfile,X,sheet);

    
return