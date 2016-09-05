function MAIN()
%% calc and display stuff related to self-other analysis 
%% add path to code base 
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode'); 
addpath(p); 
%% get setttings params 
[settings, params] = getparams();

%% open single subject glm maps in COM interface 
% open_single_subject_glm_maps_via_com(settings,params); 

%% plot individal subject raw beta values 
plot_raw_beta_vals_per_sub(settings,params); 

%% plot subject performance on junk trials 
plot_subject_performance_on_junk_trials(settings,params)

%% plot subject behav peroformance 
plot_subject_performance_on_post_experiment_behav_test(settings,params)

%% plot individual subjects pval 
plot_individ_pvals_per_sub(settings,params); 

%% compute stelzer perms (perhaps excluding some subjects (second level) 
compute_second_level(settings,params); 

%% create vmps of results second level 
create_vmp_from_second_level_files(settings,params); 

%% plot second level pvalues 
plot_pvals_from_all_second_level_tests(settings,params);

%% plot simes for this data set 

%% spatially smooth all vtc's 
spatially_smooth_all_vtcs(settings,params);

end