function Warnings = GetSolverWarnings(simulationIndex)

    Warnings = {};

    global MOBI_SETTINGS;
    global DCI_INFO;

try

    Handle = DCI_INFO{simulationIndex}.Handle;
    warningsAsString = feval(MOBI_SETTINGS.MatlabInterface,'Invoke', Handle, 'GetSolverWarnings');

    while ~isempty(warningsAsString)
        [Warnings{end+1}, warningsAsString] = strtok(warningsAsString, '¦') ;
    end
    
    Warnings = Warnings';
catch exception
    warning(exception.message);
end
    