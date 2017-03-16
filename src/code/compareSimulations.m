function compareSimulations(fileName1,fileName2,varargin)
%COMPARESIMULATIONS Compares two simulations for differences.
%        Comparison is done for:
%           parameter existence, value and formula, 
%           species initial value existence, value and formula, 
%           observer formula,
%           general and specific time pattern.
%
%   COMPARESIMULATIONS(fileName1,fileName2)
%       fileName1 (string): file name of the first simulation file
%       fileName2 (string): file name of the second simulation file
%
%   Options:
%
%   COMPARESIMULATIONS(fileName1,fileName2,'resolution',value_resolution)
%       value_resolution(double) (default 1e-8) relative deviation which is accepted as equal.
%
%   COMPARESIMULATIONS(fileName1,fileName2,'logfile',value_logfile)
%       value_logfile(string): name of log file. Differences are written to
%       this log file.
%
%   COMPARESIMULATIONS(fileName1,fileName2,'xlsfile',value_xlsfile)
%       value_xlsfile(string): name of xls file. Differences are written to
%       this xls file.
%
%   COMPARESIMULATIONS(fileName1,fileName2,'nonFormula',nonFormula_value)
%       nonFormula_value(boolean): true, only parameters which are non
%               formula in simulation 1 are compared to parameters of simulation 2
%
% Example Calls:
% compareSimulations('SimModel4_ExampleInput05.xml','SimModel4_ExampleInput06.xml');
% compareSimulations('SimModel4_ExampleInput05.xml','SimModel4_ExampleInput06.xml','resolution',0.1,'logfile','log.txt');

% Open Systems Pharmacology Suite;  support@systems-biology.com
% Date: 26-Nov-2010

%% Check input options

if ~exist(fileName1,'file')
    error('%s does not exist as file',fileName1);
end

if ~exist(fileName2,'file')
    error('%s does not exist as file',fileName2);
end

[resolution,logfile,xlsfile,nonFormula] = ...
    checkInputOptions(varargin,{...
    'resolution',nan,1e-8,...
    'logfile','','',... 
    'xlsfile','','',... 
    'nonFormula',[true false],false,...
    });

%% start Analysis
writeToLog(sprintf('Compare simulations:'),logfile,false,true);
writeToLog(sprintf('Simulation 1: %s :',fileName1),logfile);
writeToLog(sprintf('Simulation 2: %s :',fileName2),logfile);
writeToLog(' ',logfile);

% % initialize files
initSimulation(fileName1,'none','report','none');
initSimulation(fileName2,'none','report','none','addfile',true);

% Compare Parameter

writeToLog('Check Parameters:',logfile,true);

[ise,desc1]=existsParameter('*',1,'parameterType','readOnly');
if ise
    tmp=regexp(desc1{2,2},['\' object_path_delimiter],'split');
    model1=[tmp{1} object_path_delimiter];
else
    model1='';
end

[ise,desc2]=existsParameter('*',2,'parameterType','readOnly');
if ise
    tmp=regexp(desc2{2,2},['\' object_path_delimiter],'split');
    model2=[tmp{1} object_path_delimiter];
else
    model2='';
end

compareStructures('Parameter',desc1,model1,desc2,model2,resolution,logfile,xlsfile,nonFormula)

writeToLog(' ',logfile,true);

% % compare table parameters
% [ID, Time, Value] = getTableParameter('*',1,'parameterType','readonly');
% file1_TableP= [ID, Time, Value];
% [ID, Time, Value] = getTableParameter('*',2,'parameterType','readonly');
% file2_TableP= [ID, Time, Value];
% if ~all(all([file1_TableP==file1_TableP]')')
% if ~all(all([file1_TableP==file1_TableP]')')
%     writeToLog('Table Parameters are different:',logfile,true);    
% else
%     writeToLog('Table Parameters are equal:',logfile,true);    
% end
% Compare Parameter

writeToLog('Species Initial Values:',logfile,true);

[~,desc1]=existsSpeciesInitialValue('*',1,'parameterType','readOnly');
[~,desc2]=existsSpeciesInitialValue('*',2,'parameterType','readOnly');

compareStructures('Species Initial Value',desc1,model1,desc2,model2,resolution,logfile,xlsfile,nonFormula)

writeToLog(' ',logfile,true);

% Compare Observer

writeToLog('Observer Formula:',logfile,true);

[~,desc1]=existsObserver('*',1);
[~,desc2]=existsObserver('*',2);


compareStructures('Observer',desc1,model1,desc2,model2,resolution,logfile,xlsfile,nonFormula)

writeToLog(' ',logfile,true);

 % Compare Time Pattern
writeToLog('Time Pattern:',logfile,true);

file1=[];
[file1.time, file1.unit, file1.pattern]=getSimulationTime(1);
file2=[];
[file2.time, file2.unit, file2.pattern]=getSimulationTime(2);
compareTime(file1,file2,logfile,0);

return

%% compareTime
function compareTime(file1,file2,logfile,offset)

if length(file1.time)~=length(file2.time) || ~all(file1.time==file2.time)
    writeToLog(sprintf(' -Time Patterns are different:'),logfile,true);
    writeToLog(sprintf('  Simulation 1: '),logfile,true);
    if size(file1.pattern,1)==1
        writeToLog('    No specific Time Pattern defined',logfile,true);
    else
        for iPat=2:size(file1.pattern,1)
            writeToLog(sprintf('    StartTime %g  EndTime %g NoOfTimeSteps %d',...
                file1.pattern{iPat,1+offset},file1.pattern{iPat,2+offset},file1.pattern{iPat,4+offset}),logfile,true);
        end
    end
    writeToLog(sprintf('  Simulation 2:'),logfile,true);
    if size(file2.pattern,1)==1
        writeToLog('    No specific Time Pattern defined',logfile,true);
    else
        for iPat=2:size(file2.pattern,1)
            writeToLog(sprintf('    StartTime %g  EndTime %g NoOfTimeSteps %d',...
                file2.pattern{iPat,1+offset},file2.pattern{iPat,2+offset},file2.pattern{iPat,4+offset}),logfile,true);
        end
    end
end

return

%%
function compareStructures(ObjectType,desc1,model1,desc2,model2,resolution,logfile,xlsfile,nonFormula)

% get column numbers
jcolPath=strcmpi(desc1(1,:),'Path');
jcolValue=strcmpi(desc1(1,:),'Value') |  strcmpi(desc1(1,:),'InitialValue');
jcolUnit=strcmpi(desc1(1,:),'Unit');
jcolIsFormula=strcmpi(desc1(1,:),'isFormula');
jcolFormula=strcmpi(desc1(1,:),'Formula');
jcolScaleFactor=strcmpi(desc1(1,:),'ScaleFactor');

%get rid of headers
desc1=desc1(2:end,:);
desc2=desc2(2:end,:);

% get rid of modelname in path
jj_Model=strncmp(desc1(:,jcolPath),model1,length(model1)-1);
if (~isempty(desc1(:,jcolPath)))
    desc1(jj_Model,jcolPath)=regexprep(desc1(jj_Model,jcolPath),[model1(1:end-1) '\' object_path_delimiter],'','once');
end
jj_Model=strncmp(desc2(:,jcolPath),model2,length(model2)-1);
if (~isempty(desc2(:,jcolPath)))
    desc2(jj_Model,jcolPath)=regexprep(desc2(jj_Model,jcolPath),[model2(1:end-1) '\' object_path_delimiter],'','once');
end

% Initialize xlsfile
switch ObjectType
    case 'Parameter'
        xls_export{1,1}='For the import into MoBi Buildingblock "Parameter StartValues" use the 4 columns Container Path, Parameter Name, Value, Units. Be careful with formulas';
        xls_export(3,3:4)={'Simulation 1',model1(1:end-1)};
        xls_export(3,6:7)={'Simulation 2',model2(1:end-1)};
        xls_export(4,1:9)={'Container Path','Parameter Name','Value','Unit','Formula','Value ','Unit','Formula','Comment'};
    case 'Species Initial Value'
        xls_export{1,1}=['For the import into MoBi Buildingblock "Molecule StartValues" use the 6 columns Container Path, Parameter Name, is persent, Value, Units, ScaleDivisor;'...
            ' Be careful with formulas; Attention some parameters which are statevariables are also listed here, as matlab can not distinguish between molecules and such parameters.'];
        xls_export(3,3:4)={'Simulation 1',model1(1:end-1)};
        xls_export(3,8:9)={'Simulation 2',model2(1:end-1)};
        xls_export(4,1:13)={'Container Path','Parameter Name','Is Present','Value','Unit','ScaleDivisor','Formula',...
            'Is Present','Value','Unit','ScaleDivisor','Formula','Comment'};
    case 'Observer'
        xls_export{1,1}='Import to Mobi is not possible';
        xls_export(3,3:4)={'Simulation 1',model1(1:end-1)};
        xls_export(3,5:6)={'Simulation 2',model2(1:end-1)};
        xls_export(4,1:7)={'Container Path','Parameter Name','Formula','Unit','Formula','Unit','Comment'};
        

end

% loop on parameter of simulation 1
for iP=1:size(desc1);
 
    msg=[];
    msgxls=[];
    % check for formula
    goOnFormula=true;
    if nonFormula && any(jcolIsFormula)
        goOnFormula=~desc1{iP,jcolIsFormula};
    end
    if ~isempty(desc1{iP,jcolPath}) && goOnFormula

        % get current row for xls
        irowXLS=size(xls_export,1)+1;
        
        % split parameter name from path
        idelim=strfind(desc1{iP,jcolPath},'|');
        if isempty(idelim)
            xls_export{irowXLS,1}='';
            xls_export{irowXLS,2}=desc1{iP,jcolPath};
        else
            xls_export{irowXLS,1}=desc1{iP,jcolPath}(1:idelim(end)-1);
            xls_export{irowXLS,2}=desc1{iP,jcolPath}(idelim(end)+1:end);
        end
        switch ObjectType
            case 'Parameter'
                xls_export{irowXLS,3}=desc1{iP,jcolValue};
                xls_export{irowXLS,4}=desc1{iP,jcolUnit};
                xls_export{irowXLS,5}=desc1{iP,jcolFormula};
            case 'Species Initial Value'
                xls_export{irowXLS,3}=1;
                xls_export{irowXLS,4}=desc1{iP,jcolValue};
                xls_export{irowXLS,5}=desc1{iP,jcolUnit};
                xls_export{irowXLS,6}=desc1{iP,jcolScaleFactor};
                xls_export{irowXLS,7}=desc1{iP,jcolFormula};
                xls_export{irowXLS,8}=0;
            case 'Observer'
                xls_export{irowXLS,3}=desc1{iP,jcolFormula};
                xls_export{irowXLS,4}=desc1{iP,jcolUnit};
        end
        % get corresponding Parameter in simulation 2
        jj=strcmp(desc1{iP,jcolPath},desc2(:,jcolPath));
        if any(jj)
            switch ObjectType
                case 'Parameter'
                    xls_export{irowXLS,6}=desc2{jj,jcolValue};
                    xls_export{irowXLS,7}=desc2{jj,jcolUnit};
                    xls_export{irowXLS,8}=desc2{jj,jcolFormula};
                case 'Species Initial Value'
                    xls_export{irowXLS,8}=1;
                    xls_export{irowXLS,9}=desc2{jj,jcolValue};
                    xls_export{irowXLS,10}=desc2{jj,jcolScaleFactor};
                    xls_export{irowXLS,11}=desc2{jj,jcolFormula};
                case 'Observer'
                    xls_export{irowXLS,5}=desc2{jj,jcolFormula};
                    xls_export{irowXLS,6}=desc2{jj,jcolUnit};

            end
            if any(jcolValue)
                x1= desc1{iP,jcolValue};
                x2= desc2{jj,jcolValue};
                if x1==0
                    if x2 ~=0
                        msg{end+1}='    Values are different:';
                        msg{end+1}=sprintf('    Simulation 1: %g Simulation 2: %g',x1,x2); %#ok<*AGROW>
                        msgxls{end+1}='Values are different;';
                    end
                elseif abs((x1-x2)/x1)>resolution
                    msg{end+1}='    Values are different:';
                    msg{end+1}=sprintf('    Simulation 1: %g Simulation 2: %g  Ratio %g',x1,x2,x1/x2);
                    msgxls{end+1}='Values are different;';
                elseif any(isnan([x1,x2]))
                        msg{end+1}='    Parameter is corrupt:';
                        msg{end+1}=sprintf('    Simulation 1: %g Simulation 2: %g',x1,x2); %#ok<*AGROW>
                        msgxls{end+1}=' corrupt values;';                    
                end
            end
            if any(jcolIsFormula) && ~nonFormula
                if desc1{iP,jcolIsFormula} && ~desc2{jj,jcolIsFormula}
                    msg{end+1}=sprintf('    Simulation 1 is Formula %s but Simulation 2 is constant: %g',...
                        desc1{iP,jcolIsFormula},x2);
                    msgxls{end+1}='Simulation 1 is Formula %s but Simulation 2 is constant;';

                elseif ~desc1{iP,jcolIsFormula} && desc2{jj,jcolIsFormula}
                    msg{end+1}=sprintf('    Simulation 1 is constant %g but Simulation 2 is Formula: %s',...
                        x1,desc2{jj,jcolIsFormula});
                    msgxls{end+1}='Simulation 1 is constant %g but Simulation 2 is Formula;';
                elseif desc1{iP,jcolIsFormula} && desc2{jj,jcolIsFormula} && ...
                        ~strcmp(strrep(desc1{iP,jcolFormula},' ',''),strrep(desc2{jj,jcolFormula},' ',''))
                    msg{end+1}='    Formulas are different:';
                    msg{end+1}=sprintf('    Simulation 1 %s ',desc1{iP,jcolFormula});
                    msg{end+1}=sprintf('    Simulation 2 %s ',desc2{jj,jcolFormula});
                     msgxls{end+1}='Formulas are different;';
                end
            elseif any(jcolFormula) && ~nonFormula
                if ~strcmp(strrep( desc1{iP,jcolFormula},' ',''),strrep(desc2{jj,jcolFormula} ,' ',''))
                    msg{end+1}='    Formulas are different:';
                    msg{end+1}=sprintf('    Simulation 1 %s ', desc1{iP,jcolFormula});
                    msg{end+1}=sprintf('    Simulation 2 %s ',desc2{jj,jcolFormula} );
                     msgxls{end+1}='Formulas are different;';
                end
            end
        else
            msg{end+1}=sprintf('    is not defined in Simulation 2');
             msgxls{end+1}='is not defined in Simulation 2;';
        end
        if ~isempty(msg)
            writeToLog(sprintf(' -%s: %s',ObjectType,desc1{iP,jcolPath}),logfile,true);
            for iMs=1:length(msg)
                writeToLog(msg{iMs},logfile,true);
            end
            
             xls_export{irowXLS,end}=strjoin(msgxls,' ');
        else
            % no difference so do not take line
            irowXLS=irowXLS-1;
            xls_export=xls_export(1:irowXLS,:);            
        end
    end
end

% check for parameters which are existing in simulation2  but not in 1
% this i not done for non-formula, as this considers only constant and
% therefor existing parameters from 2
if ~nonFormula
    for iP=1:size(desc2);
        jj=strcmp(desc2{iP,jcolPath},desc1(:,jcolPath));
        if ~any(jj)
            writeToLog(sprintf(' -%s: %s',ObjectType,desc2{iP,jcolPath}),logfile,true);
            writeToLog(sprintf('    is not defined in Simulation 1'),logfile,true);

            % get current row for xls
            irowXLS=size(xls_export,1)+1;
            
            % split parameter name from path
            idelim=strfind(desc2{iP,jcolPath},'|');
            xls_export{irowXLS,1}=desc2{iP,jcolPath}(1:idelim(end)-1);
            xls_export{irowXLS,2}=desc2{iP,jcolPath}(idelim(end)+1:end);
            switch ObjectType
                case 'Parameter'
                    xls_export{irowXLS,6}=desc2{iP,jcolValue};
                    xls_export{irowXLS,7}=desc2{iP,jcolUnit};
                    xls_export{irowXLS,8}=desc2{iP,jcolFormula};
                case 'Species Initial Value'
                    xls_export{irowXLS,3}=0;
                    xls_export{irowXLS,8}=1;
                    xls_export{irowXLS,9}=desc2{iP,jcolValue};
                    xls_export{irowXLS,10}=desc2{iP,jcolScaleFactor};
                    xls_export{irowXLS,11}=desc2{iP,jcolFormula};
                case 'Observer'
                    xls_export{irowXLS,5}=desc2{iP,jcolFormula};
                    xls_export{irowXLS,6}=desc2{iP,jcolUnit};
            end
            xls_export{irowXLS,end}='is not defined in Simulation 1';
            
        end
    end
end

if ~isempty(xlsfile)
    xlswrite(xlsfile,xls_export,ObjectType);
end

return

