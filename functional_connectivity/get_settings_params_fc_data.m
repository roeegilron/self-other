function [settings,params] = get_settings_params_fc_data()

%% settings: 
settings.dataloc = fullfile('..','..','data','raw_flat_vtc_data_smoothed'); % 'raw_flat_vtc_data_not_smoothed'
settings.resdir  = fullfile('..','..','results','Functional_Connectivity'); % 'raw_flat_vtc_data_not_smoothed'

%% params 
% cond references  1-Ot, 2-Oa, 3-Or, 4-St, 5-Sa, 6-ra
params.cond1     = 4:6 ; %cond 1 is always subtracted first e.g. self - other 
params.cond1name = 'self';
params.cond2     = 1:3 ; 
params.cond2name = 'other';
params.runsuse   = [1:2]; 
params.runident  = 'runs1-2'; 
params.subuse    = 3000:3022; 
params.conntype  = 'corr' ; % 'eucled' 'seuclidean'

% get save variable name 
fnms = sprintf('FC_%s_vs_%s_%s_contype-%s_smoothed.mat',...
    params.cond1name,...
    params.cond2name,...
    params.runident,...
    params.conntype);
params.fnms = fnms; 

end