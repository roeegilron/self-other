function [settings, params] = getparams()
%% settings 
settings.datadir         = fullfile('..','data'); 
settings.experconds      = {'other_other','self_other','words'}; 
settings.resfold         = fullfile('..','results'); 
settings.resfileprefix   = 'mt';
settings.datafileprefix  = 'data';
settings.behavdatafold   = 'behavdata';
settings.figfold         = 'figures';
settings.subsToUse       = [3000:3023];%[3000:3004 3006:3007 3011];
settings.incomsubsflag   = 0; 
settings.computeStzler   = 1; % use stelzer perms or not 
settings.seclevelprefix  = 'ND_FFX_';
settings.nameOfTempVMP   = 'blank_vmp_tal_3x3res.vmp';
settings.rawdataloca     = 'H:\MRI_Data_self_other\subjects_3000_study';
%% params 
params.numstlzermap      = 1e4;
params.avgmode           = 'mean'; 

end