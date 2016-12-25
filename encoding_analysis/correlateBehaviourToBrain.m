function correlateBehaviourToBrain(varargin)
[settings, params] = get_settings_params_encoding();
% get behav matrices 
behavmats = createBehavDifMatrices(); 
if ~isempty(varargin)
    behavmats = behavmats(varargin{1}); 
end
% loop on subjects and get brain data for each subject 
for s = 1:length(behavmats)
    [roiidxs,numofrois] = getROIs(behavmats(s).subnum, settings, params);
    [data,labels,runslabel,labelStrFromData,locations,map] = loadData(behavmats(s).subnum,settings, params); 
    for r = 1:numofrois
        roinum = r; 
        roidata = getDataFromROI(data,labels,runslabel,roiidxs,roinum,settings, params); 
        [corrval(r),corrpval(r)]  = correlateData(roidata,labelStrFromData,labels,runslabel,behavmats(s),settings, params); 
    end
    writeVMPperSub(corrval,behavmats(s).subnum,settings,params,locations,map)
    corrmats(:,s) = corrval'; 
    pvalmats(:,s) = corrpval'; 
end
avgGroupCorr = mean(corrmats,2); 
writeVMP_Group(avgGroupCorr,settings,params); 


end