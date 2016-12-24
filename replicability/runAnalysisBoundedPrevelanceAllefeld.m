function prevelanceAllefeld = runAnalysisBoundedPrevelanceAllefeld()
[settings,params] = get_settings_params_replicability();
addpath(genpath(pwd));
%% This runs Allefeld style analyis on anatomical ROIs 
%% Of self-other data set 
for s = 1:length(params.subuse) % loop on subjects 
    for r = 1:length(params.roisuse) % loop on rois 
        fnlod = sprintf('sub_%d_roi_%.3d.mat',params.subuse(s), params.roisuse(r)); 
        fldrl = settings.resdir_group_prev_ruti; 
        load(fullfile(fldrl, fnlod),'pval','ansMat'); 
        ansMatAll(r,s,:) = ansMat; % roi x shuffels x subjects. 
        psPerSub(r,s) = calcPvalVoxelWise(ansMat); 
    end
end

% %% our inptertation: 
% maxTsAcrossSubs = max(ansMatAll,[],3); 
% pvals = calcPvalVoxelWise(maxTsAcrossSubs); 
% num_subs = 1/size(ansMatAll,3); 
% alpha = 0.5; 
% prevelanceAllefeld = (alpha ^ num_subs - pvals ) ./ (1- pvals);

%% allefeld code 
save('ansMatForAllefeld.mat','ansMatAll');
[results, paramsA] = prevalenceCore(ansMatAll, 1e6, 0.1);

% permutation-based prevalence inference using the minimum statistic, core
% implementation of the method proposed by Allefeld, Goergen and Haynes (2016)
%
% [results, params] = prevalenceCore(a, P2 = 1e6, alpha = 0.05)
%
% a:            three-dimensional array of test statistic values
%               (voxels x subjects x first-level permutations)


%% XXX since not working, return 1- pvals; 
prevelanceAllefeld = 1 - pvals; 
manhatanPlot(psPerSub); 

end