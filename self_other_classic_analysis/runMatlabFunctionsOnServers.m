function runMatlabFunctionsOnServers()
%% This function reads a text file with calls to a matlab function
% each call is for a specific function with specific arguments.
% the calls are distributed across all 3 servers
% it distributed the commands in this text file across x servers
% you should only use this for functions that you know are very stable
% once you need to run them many times / employ mass parallelism
% also, for this to work you need to generate public keys so password is
% not required. see here:
% http://tinyurl.com/kuof5c

%% read txt file with commands to run
txtFileWithMatlabComds = fullfile(pwd,'matlabCommands.txt');
commandsToRun = importdata(txtFileWithMatlabComds);

%% ask user how many servers he wants to run on
serverNum = input('how many servers do you want to run on?');
for i = 1:serverNum
    serversToRunOn(i) = input(sprintf('choose rack number %d to run on: ',i));
end
serverOrder = distrbToServer(serversToRunOn,length(commandsToRun));
%% run jobs
for j = 1:length(commandsToRun);
        sshCommand = 'ssh -C';
        rackPrefix = 'rack-hezi-0';
        startMatlb = 'matlabr2014b -nodisplay -nosplash -r';
        cdToDir    = 'cd(''/home/rack-hezi-01/home/roigilro/dataForAnalysis/PoldrackRFX_Ttest/'')';
        commndToRn = commandsToRun{j};
        unix(sprintf('%s %s%d "%s \\"%s; %s; quit\\" \" &',...
            sshCommand,...
            rackPrefix,serverOrder(j),...
            startMatlb,...
            cdToDir,...
            commndToRn...
            ))
end


end

function  serverOrder = distrbToServer(serversToRunOn,NumCommands)
cnt = 1;
for i = 1:NumCommands
    serverOrder(i) = serversToRunOn(cnt);
    cnt = cnt + 1; 
    if cnt > length(serversToRunOn)
        cnt = 1;
    end
end
end