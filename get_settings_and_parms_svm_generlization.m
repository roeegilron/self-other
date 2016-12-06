function [settings, params ] = get_settings_and_parms_svm_generlization()
settings.vmpdir        = fullfile('..','data','voi_files');
%% vmp fn set 
settings.vmpfn         = 'vois_all_s-o_vs_rest_multi_smoothed_defined_from_run1_RFX_FDR0001_150_thresh_with_names.vmp';
settings.vmpfn         = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_Bonforoni_005.vmp';
settings.vmpfn         = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_Bonforoni_005.vmp';
settings.vmpfn         = 'vois_all_self_vs_other_multi_smoothed_defined_using_t2013.vmp';
settings.subuse        = 3000:3022;
settings.runuse        = [1:4];
settings.data_vtc_sm   = fullfile('..','data','raw_flat_vtc_data_smoothed'); % vtc smoothed
settings.data_vtc_nsm  = fullfile('..','data','raw_flat_vtc_data_not_smoothed'); % vtc non smoothed
settings.data_beta_sm  = fullfile('..','data','raw_flat_beta_data_smoothed'); % beta smoothed
settings.resdir        = fullfile('..','results','generlization_so_100voxels'); % beta smoothed
settings.figdir        = fullfile('..','figures','generlization_so_100voxels'); % beta smoothed
% set params
params.inputuse        = 'beta_sm'; % 'vtc_sm' , 'vtc_nsm', 'beta_sm';
params.filestr         = 's%d_run%d_cond-%d*.mat'; % subnum, runnun, condnum
params.conds           = {'Ot','Oa','Or','St','Sa','Sr'};
params.pointvtc        = 3; % point used in vtc data selection.
params.voisize         = 100; % sphere size used for voi.
params.compuse         = 'difference'; % type of computation to use for simlariy.
params.getAllVOI       = 0; % if true, get full voi, if false, get only area around voisize
params.avgDistnace     = 1; % if true, compute distance each subject, then average, if false, average data then compute distances 
end