function roidata = getDataFromROI(data,labels,runslabel,roiidxs,roinum,settings, params)
switch params.roisuse
    case 'atlas'
        roidata = data(:,logical(roiidxs(:,roinum)));
    case 'searchlight'
        roidata = []; 
        roidata = data(:,roiidxs(roinum,:));
end

end