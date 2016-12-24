function ansMat = agregateResultsRuti()
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
psRuti = calc_ruti_prevelance(psForRuti,params.ucutoff); 
psRuti = calc_ruti_prevelance(psForRuti,0.2); 
sigfdr = fdr_bh(psRuti,0.05,'pdep','yes');
ansMat = psRuti; 

end 