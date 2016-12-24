function runGroupMaps()
[settings,params] = get_settings_params_replicability();
addpath(genpath(pwd));
%% This runs Allefeld style analyis on anatomical ROIs 
%% Of self-other data set 
for s = 1:length(params.subuse) % loop on subjects 
    for r = 1:length(params.roisuse) % loop on rois 
        fnlod = sprintf('sub_%d_roi_%.3d.mat',params.subuse(s), params.roisuse(r)); 
        fldrl = settings.resdir_group_prev_ruti; 
        load(fullfile(fldrl, fnlod),'pval','ansMat'); 
        ansMatAll(r,:,s) = ansMat; % roi x shuffels x subjects. 
    end
end
%% comput group maps 
nummapscreate = 2e4; 
[stlzerAnsMat, ~] = ...
 createStelzerPermutations(ansMatAll,nummapscreate,'median');
pvals = calcPvalVoxelWise(stlzerAnsMat); 
sigfdr = fdr_bh(pvals,0.05,'pdep','yes');
writeVMP_percents(sigfdr,'Group Prevelance');

end

