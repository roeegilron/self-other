function MAIN_compute_replicability()
%% This an anaotmical analysis. Getting data divided by ROI. 

%% run analysis Ruti 
runGroup(0) % 1 just write reults, 0 do heavy computation 
%% run analysis Estimation / infinite trial length 
runInfinite(1)  
%% run analysis Alllefeld 
% runAnalysisAllefeldBoundedPrevelance(settings,params);
% writeVMP_percents(settings,params); 

end

