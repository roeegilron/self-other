function prevelanceNaive = runNaivePrevelance()
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
        psPerSub(r,s) = calcPvalVoxelWise(ansMat); 
    end
end
psBoolean = psPerSub <=0.05;
prevelanceNaive =  sum(psBoolean,2) / length(params.subuse).*100;

end