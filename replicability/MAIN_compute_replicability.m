function MAIN_compute_replicability()
[settings,params] = get_settings_params_replicability();
%% This an anaotmical analysis. Getting data divided by ROI. 

%% create second level group maps ND FFX 

%% run analysis Ruti 
runAnalysisGroupPrevelance(settings,params);
writeVMP_percents(settings,params); 
%% run analysis Estimation / infinite trial length 
% runAnalysisInfinitePrevelance(settings,params);
% writeVMP_percents(settings,params); 
%% run analysis Alllefeld 
% runAnalysisAllefeldBoundedPrevelance(settings,params);
% writeVMP_percents(settings,params); 

end


