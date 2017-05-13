function clustThreshold  = calcFDRclusterThreshold(shufClusterInstances,shufClusterVals,valRela,pVal)

% find threshold by area:
ncumsum = cumsum(shufClusterInstances);
% assign p value to each cluster size in real map
for i = 1:length(valRela)
    relIdx = find(valRela(i)<=shufClusterVals,1,'first');
    if isempty(relIdx) % this means that I had a cluster size in real data that is bigger than max cluster size in shuffeled data
        pValRealMap(i) = 1 / ncumsum(end);
    else
        pValRealMap(i) = (ncumsum(end) - ncumsum(relIdx)) / ncumsum(end);
    end
end
% perform FDR test for different pv values
[h,crit_p,adj_p] = fdr_bh(pValRealMap,pVal,'pdep','no');
if sum(h)>=1 % get the first place where h =1 (e.g. null hypothesis is rejected)
    idxFDR = find(h==1,1,'first');
    clustThreshold = valRela(idxFDR);
else
    fprintf('no clusters pass FDR threshold at p = %f\n',pVal);
    clustThreshold = [];
    return
end



end