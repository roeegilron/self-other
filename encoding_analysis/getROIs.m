function [roiidx,nrofrois] = getROIs(subnum,settings, params)
roiidx = [];

load(settings.roifilename)
% roimask3d = labelsdata == roinum; %  get roi
for r = 1 % only need one run. just to get mask, locations  
    for c = params.conduse % only need one cond - just to get mask, locations 
        fnmload = sprintf(settings.subformat,subnum,r,c,params.suffices{c});
        fullfnm = fullfile(settings.dataloc,fnmload);
        if exist(fullfnm,'file')
            load(fullfnm,'map','locations');
            switch params.roisuse
                case 'atlas'
                    for rr = 1:length(ROI) 
                        roimask3d = labelsdata == rr; 
                        roiflat = reverseScoringToMatrix1rowAnsMat(roimask3d,locations);
                        roiidx(:,rr) = roiflat; 
                    end 
                    nrofrois = size(roiidx,2); % rerturns logical 
                case 'searchlight'
                    roiidx = knnsearch(locations, locations, 'K', params.srclightr); % find searchlight neighbours
                    nrofrois = size(roiidx,1); % returns indices (numbers) 
            end
            
        end
    end
end


end
    