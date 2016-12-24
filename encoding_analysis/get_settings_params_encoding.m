function [settings,params] = get_settings_params_encoding()

%% settings: 
settings.subformat               = 's%d_run%d_cond-%d-%s.mat'; % sub, run, cond (1-3 other, 4-6 self); 
settings.dataloc                 = fullfile('..','..','data','raw_flat_beta_data_smoothed'); % 'raw_flat_vtc_data_not_smoothed'
settings.resdir_root             = fullfile('..','..','results','encoding'); % root dir for replicabiltiy 
settings.roifilename             = 'harvard_atlas_short.mat';
settings.behavdata               = fullfile('..','..','data','behav_data'); % 'raw_flat_vtc_data_not_smoothed'
settings.figbehavdata            = fullfile('..','..','figures','behav_data'); % 'raw_flat_vtc_data_not_smoothed'


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
params.roisuse   = 'atlas'; % 'atlas' = harvard cambridge 'searchlight'  = searchlight 
params.srclightr = 125; % searchlight radius 

end