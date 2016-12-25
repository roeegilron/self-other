function correlateBehaviourToBrain(varargin)
[settings, params] = get_settings_params_encoding();
% get behav matrices 
behavmats = createBehavDifMatrices(); 

% get group map and locations 
[gmap, glocations] = getGroupMask(settings,params,[behavmats.subnum]); 

if ~isempty(varargin) % only run one subject for a parallel version
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
    writeVMPperSub(corrval,behavmats(s).subnum,settings,params,glocations,gmap)
    corrmats(:,s) = corrval'; 
    pvalmats(:,s) = corrpval'; 
end
avgGroupCorr = mean(corrmats,2); 
writeVMP_Group(avgGroupCorr,glocations,gmap,settings,params); 


end