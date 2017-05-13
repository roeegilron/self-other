function runMatlabFunctionCommandLine(matfun,matfundir,valforfun)
%% This functin runs a matlab process with a function and a val for that function 
        sshCommand = 'ssh -C';
        rackPrefix = 'rack-hezi-0';
        startMatlb = 'matlabr2015b -nodisplay -nosplash -r';
        cdToDir    = sprintf('cd(''%s'')',matfundir);
        
        commandtorun = sprintf('"%s \\"%s; %s %d; quit\\" \" &',...
            startMatlb,...
            cdToDir,...
            matfun,...
            valforfun...
            );
        unix(commandtorun)



end