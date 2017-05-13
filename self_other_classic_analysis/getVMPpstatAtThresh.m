function vmp = getVMPpstatAtThresh(ansMat,pn,fn,locations,mask,cutOff,vmp, params)
%% get cluster, instances from real map
[valReal,instancesReal] = ...
    extractClustersFromMap(ansMat(:,1),mask,locations,cutOff);
%% get clusters, instances from each shuffeled label map
[shufClusterVals,shufClusterInstances] = ...
    extractClustersFromShufMaps(ansMat,mask,locations,cutOff);
%%

%% calc cluster threshold FDR
pVal = [0.05, 0.01, 0.1];
method = 'FDR';
for i = 1:length(pVal)
    clustThresh =  calcFDRclusterThreshold(...
        shufClusterInstances,shufClusterVals,valReal,pVal(i));
    if calcIfVMPhasClustersPassingThresh(valReal,clustThresh,pVal(i),cutOff,method);
        vmp = createVMPatThreshWithNeighbours(...
            ansMat,clustThresh,pn,fn,cutOff,locations,mask,pVal(i),method, params, vmp);
    end
end
%% calc threhsold Bonforni
pVal = [0.05, 0.01, 0.1];
method = 'bonforoni';
for i = 1:length(pVal)
    clustThresh =  calcBonfroniClusterThreshold(...
        shufClusterInstances,shufClusterVals,valReal,instancesReal,pVal(i));
    if calcIfVMPhasClustersPassingThresh(valReal,clustThresh,pVal(i),cutOff,method);
        vmp = createVMPatThreshWithNeighbours(...
            ansMat,clustThresh,pn,fn,cutOff,locations,mask,pVal(i),method, params, vmp);
    end
end

%% calc cluster threshold FWER
pVal = 1/(size(ansMat,2)-1);
method = 'fwer';
clustThresh =  calcFWERClusterThreshold(shufClusterVals);
if calcIfVMPhasClustersPassingThresh(valReal,clustThresh,pVal,cutOff,method);
    vmp = createVMPatThreshWithNeighbours(...
        ansMat,clustThresh,pn,fn,cutOff,locations,mask,pVal,method, params, vmp);
end

end
