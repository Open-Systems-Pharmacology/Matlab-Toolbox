function msgOut = adjustErrorMessageForNet(msgIn)

msgOut = msgIn;

stringsToReplace = {'Error in Configure: ', 'Error in ProcessMetaData: ', 'Error in ProcessData: '};

for i=1:length(stringsToReplace)
    msgOut = strrep(msgOut, stringsToReplace{i}, '');
end
