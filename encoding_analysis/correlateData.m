function [r, pval] = correlateData(roidata,labelStrFromData,labels,runslabels,behavmatstruc,settings,params)
behavmatuse = behavmatstruc.(params.behavMatUs);
% label strings from data, not the same as behav mat order. 
% relable them properly. 
[~,idxlabBeh,idxlabDat] = intersect(behavmatstruc.labels',labelStrFromData','stable');
% idxlabDat is the correct order to use 
for c = 1:length(idxlabDat)
    dat(c).data       = roidata(labels == idxlabDat(c),:); 
    dat(c).labelBehav = behavmatstruc.labels{idxlabBeh(c)}; 
    dat(c).labelData  = labelStrFromData{idxlabDat(c)};
end
% trim data to find min amount of trials: 
for c = 1:length(dat)
    allsizes(c) = size(dat(c).data,1);
end
trimsize = min(allsizes); 
for c = 1:length(dat)
    dat(c).data = dat(c).data(randperm(size(dat(c).data,1),trimsize)',:);
end
% serialize / mean 
for c = 1:length(dat)
    tempdat = dat(c).data; 
    switch params.dataAvg
        case 'mean'
            datout(:,c) = mean(tempdat,1); 
        case 'serialize'
            datout(:,c) = tempdat(:); 
    end
end
% compute distnace of data matrix 
distdat = pdist(datout',params.distanceuse); 

%% correlate data 
[r, pval] = corr(behavmatuse',distdat');

end