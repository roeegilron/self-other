function clustThreshold  = calcBonfroniClusterThreshold(shufClusterInstances,shufClusterVals,valReal,instancesReal,pVal)
%% perform Bonforni test for different pv values
numClustersInRealMap = sum(instancesReal);
bonForoniCorrectPval = pVal / numClustersInRealMap;
% find threshold by area:
ncumsum = cumsum(shufClusterInstances);
idx = find(ncumsum > (ncumsum(end)*(1-bonForoniCorrectPval)),1,'first');
clustThreshold = shufClusterVals(idx);

end