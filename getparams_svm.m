function [settings, params] = getparams_svm()
%% settings - data location etc. 
settings.datalocation = fullfile('..','data','roi_data_beta_based','words-multit2013based-voi100peak-generlization'); 
% words-roi-FDR-generalization self-other-roi-FDR-generalization
%self-other-roi, traklin-rashamkol-roi, aronit-traklin-roi,
%aronit-rashamkol-roi 
%words-roi-bonforoni-generalization %self-other-roi-bonforoni-generalization
% raw_data_multit2013_voi % 
settings.subpref      = 'sub'; 
settings.subprefr     = '3'; 
settings.resfolder    = fullfile('..','results','words-roi-multipk100vx-generalization'); mkdir(settings.resfolder); 
settings.figfolder    = fullfile('..','figures','words-roi-multipk100vx-generalization'); mkdir(settings.figfolder); 
settings.grpfolder    = 'group';
%% params - how many shuffels to do, mean / median etc. 
params.numshufs       = 5e2; 
params.stlzrshuf      = 20e3;

params.avgtype        = 'mean'; 
params.pvalcutoff     = 0.05; 

end