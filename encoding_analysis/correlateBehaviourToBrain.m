function correlateBehaviourToBrain()
[settings, params] = get_settings_params_encoding();
% get behav matrices 
behavmats = createBehavDifMatrices(); 
% loop on subjects and get brain data for each subject 
for s = 1:length(behavmats)
    roiidxs = getROIs(behavmats(s));
    [data,locations,mask] = loadData(subnum); 
    for r = 1:size(roiidxs,2)
        roidata = getDataFromROI(data,locations,mask,roiidxs(r)); 
        corrval(r) = correlateData(roidata,behavmats(s),settings,params); 
    end
    corrmats(:,s) = corrval; 
    writeVMPcorr(corrmats,behavmats(s),settings,params); 
end
avgGroupCorr = averageCorrMats(corrmats,settings,params); 
writeVMPcorr(avgGroupCorr,[],settings,params); 


end