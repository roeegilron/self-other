function [settings,params] = get_settings_params_self_other()

%% settings: 
settings.dataloc_group_prev_ruti = fullfile('..','..','data','raw_flat_beta_data_smoothed'); % 'raw_flat_vtc_data_not_smoothed'
settings.subformat               = 's%d_run%d_cond-%d-%s.mat'; % sub, run, cond (1-3 other, 4-6 self); 
settings.dataloc_inf_prev_ss     = fullfile('..','..','data','raw_flat_beta_data_smoothed'); % 'raw_flat_vtc_data_not_smoothed'
settings.resdir_root             = fullfile('..','..','results','Replicability'); % root dir for replicabiltiy 
settings.roifilename             = 'harvard_atlas_short.mat';
mkdir(settings.resdir_root); 
settings.resdir_group_prev_ruti  = fullfile('..','..','results','Replicability','group_prevelance_ruti'); %
mkdir(settings.resdir_group_prev_ruti); 
settings.resdir_inf_ss_prev      = fullfile('..','..','results','Replicability','ss_infinite_prevelance_v2'); %
mkdir(settings.resdir_inf_ss_prev);
settings.resdir_inf_ss_prev_cv   = fullfile('..','..','results','Replicability','ss_infinite_prevelance_v-cross_validate'); %
mkdir(settings.resdir_inf_ss_prev);
settings.resdir_ss_prev_cv   = fullfile('..','..','results','Replicability','ss_sl_v-cross_validate'); %
mkdir(settings.resdir_ss_prev_cv);






%% params 
% cond references  1-Ot, 2-Oa, 3-Or, 4-St, 5-Sa, 6-ra
params.cond1     = 4:6 ; %cond 1 is always subtracted first e.g. self - other 
params.cond1name = 'self';
params.cond2     = 1:3 ; 
params.cond2name = 'other';
params.suffices  = {'Ot','Oa','Or','St','Sa','Sr'};
params.runsuse   = [1:4]; 
params.conduse   = 1:6;
params.runident  = 'self-other'; 
params.subuse    = 3000:3022; 
params.conntype  = 'corr' ; % 'eucled' 'seuclidean'
params.roisuse   = 1:111; % rois, TAL atlas. 
params.prevjumps = 15; % for infinite prevelance 
params.intialval = 10; % number of trials needed to start analysis 
% get save variable name 
fnms = sprintf('ROI_mt_anylsis_%s_vs_%s_%s_smoothed.mat',...
    params.cond1name,...
    params.cond2name,...
    params.runident...
    );
params.fnms = fnms; 
params.ucutoff  = 0.5; % u cutoff for Ruti.
params.regionSize = 40; 
params.numshufs   = 100; 
end