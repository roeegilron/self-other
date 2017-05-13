function hasClusters = calcIfVMPhasClustersPassingThresh(valReal,clustThresh,pVal,cutOff,method)
%% check if the vmp has clusters that pass a certain threshold
if isempty(clustThresh)
    hasClusters = 0;
    fprintf('there are no clusters passing thresh at pVal %f at T cut off %f using method %s\n',...
        pVal,cutOff,method)
    return;
end

if sum(valReal > clustThresh) >=1
    hasClusters = 1;
    fprintf('there are %d clusters at pVal %f at T cut off %f using method %s\n',...
        sum(valReal > clustThresh),pVal,cutOff,method)
else
    hasClusters = 0;
    fprintf('there are no clusters passing thresh at pVal %f at T cut off %f using method %s\n',...
        pVal,cutOff,method)
end
end