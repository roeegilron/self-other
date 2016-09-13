function [settings, params] = getparams_svm()
%% settings - data location etc. 
settings.datalocation = fullfile('..','data','roi_data_beta_based_unique_voi','self-other-roi'); 
%self-other-roi, traklin-rashamkol-roi, aronit-traklin-roi, aronit-rashamkol-roi
settings.subpref      = 'sub'; 
settings.subprefr     = '3'; 
settings.resfolder    = fullfile('..','results','self-other-unique-roi-svm'); 
settings.figfolder    = fullfile('..','figures','self-other-unique-roi-svm'); 
settings.grpfolder    = 'group';
%% params - how many shuffels to do, mean / median etc. 
params.numshufs       = 5e2; 
params.stlzrshuf      = 5e3;
params.avgtype        = 'median'; 
params.pvalcutoff     = 0.05; 

end