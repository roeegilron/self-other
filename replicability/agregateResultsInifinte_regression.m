function ansMat = agregateResultsInifinte_regression()
[settings,params] = get_settings_params_replicability();
for r = 1:length(params.roisuse) % loop on rois
    fnlod = sprintf('roi_%.3d_inf_prev.mat', params.roisuse(r));
    fldrl = settings.resdir_inf_ss_prev;
    if exist(fullfile(fldrl, fnlod), 'file');
        load(fullfile(fldrl, fnlod),'perc');
        percents(r) = perc;
        clear perc;
    else
        percents(r) = -1; 
    end
end

ansMat = percents;

end