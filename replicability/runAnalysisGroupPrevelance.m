function runAnalysisGroupPrevelance()
[settings,params] = get_settings_params_replicability();
%% This runs Ruti style analyis on anatomical ROIs 
%% Of self-other data set 
for s = 1:length(params.subuse) % loop on subjects 
    for r = params.roisuse % loop on rois 
        startload = tic; 
        [data, labels] = getDataPerSub(params.subuse(s),r,settings,params);
        fprintf('sub %d roi %d loaded in \t %f secs\n',...
            params.subuse(s),r,toc(startload));
        startanly = tic; 
        [pval, ansMat] = run_MultiT2013_On_ROI(data,labels,settings,params); % for ruti 
        fprintf('sub %d roi %d analyzed in \t %f secs\n',...
            params.subuse(s),r,toc(startanly));
        strtsave = tic; 
        fnmsave = sprintf('sub_%d_roi_%.3d.mat',params.subuse(s),r); 
        fldrsve = settings.resdir_group_prev_ruti;
        save(fullfile(fldrsve,fnmsave),'pval','ansMat'); 
        fprintf('sub %d roi %d saved in \t %f secs\n',...
            params.subuse(s),r,toc(strtsave));
    end
    fprintf('\n\n');
end

end 