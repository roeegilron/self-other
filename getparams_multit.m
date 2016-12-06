function [settings, params] = getparams_multit()
%% settings - data location etc. 
settings.datalocation = fullfile('..','data','roi_data_beta_based','words-multit2013based-voi100peak-generlization'); 
%self-other-roi, traklin-rashamkol-roi, aronit-traklin-roi, aronit-rashamkol-roi
settings.subpref      = 'sub'; 
settings.subprefr     = '3'; 
settings.resfolder    = fullfile('..','results','words-roi-multipk100vx-generalization'); 
settings.figfolder    = fullfile('..','figures','words-roi-multipk100vx-generalization'); 
settings.grpfolder    = 'group';
%% params - how many shuffels to do, mean / median etc. 
params.numshufs       = 5e2; 
params.stlzrshuf      = 5e3;
params.avgtype        = 'median'; 
params.pvalcutoff     = 0.05; 



end