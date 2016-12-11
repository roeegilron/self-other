function ansMat = agregateResultsSolari_Jelle()
%% using equations 8 here"
% [1] Goeman, Jelle J., and Aldo Solari. ?Multiple Hypothesis Testing in Genomics.? Statistics in Medicine 33, no. 11 (2014): 1946?78. doi:10.1002/sim.6082.

[settings,params] = get_settings_params_replicability();
for s = 1:length(params.subuse) % loop on subjects 
    for r = 1:length(params.roisuse) % loop on rois 
        fnlod = sprintf('sub_%d_roi_%.3d.mat',params.subuse(s), params.roisuse(r)); 
        fldrl = settings.resdir_group_prev_ruti; 
        load(fullfile(fldrl, fnlod),'pval'); 
        psForRuti(r,s) = pval;  
        clear pval; 
    end
end
mzero = ( sum(psForRuti > 0.75,2) + 1 ) / (1-0.75);
percents = mzero / size(psForRuti,2);
end 