function ret = useStandardFileDialog

    ret = ~isdeployed || isunix;
    