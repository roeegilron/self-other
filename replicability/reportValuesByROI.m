function reportValuesByROI(sigfdr)
%% this function reports ROI labels for debugging 

load('harvard_atlas_short.mat');
idxreport = find(sigfdr==1); 
for r = 1:length(idxreport)
    fprintf('roi # is %.3d, with %d vxls. ROI is %s\t labels ROI_BY_REGIONS is %s\t\n',...
        idxreport(r),...
        sum(idxreport(r)==labelsdata(:)),...
        ROI{idxreport(r)},...
        ROI_BY_REGIONS{idxreport(r)});
end
        
end
