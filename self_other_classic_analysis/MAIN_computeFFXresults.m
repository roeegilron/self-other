function MAIN_computeFFXresults()
% clc
close all
% for vocal data set 

rtdir = '/home/rack-hezi-01/home/roigilro/matscripts/';
rtdir = '/home/hezi/roee/ActivePassiveLH/';


ffxResFold = fullfile(rtdir,'/results_VocalDataSet_FFX_ND_norm_1000shuf_SL27_reg_perm_ar3/');
ffxResFold = fullfile(rtdir,'results_ActivePassiveLH_FFX_ND_norm_400shuf_SL9_reg_perm_sep_beta_BV');

% XXX old t analysis 
% ffxResFold = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\ffxNotZscoredVocalDataSet';

subsToExtract = subsUsedGet(150); % 150 / 20 for vocal data set 
subsToExtract = 2:18
fold = 1; 
computeStzler = 1;
% for vocal data set
%outDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\results_VocalDataSet_FFX_ND_norm_50shuf_SL27_NEWPERM';
outDir = ffxResFold;
numMaps = 1e3;
% computeFFXresults_self_other(subsToExtract,fold,computeStzler,ffxResFold,outDir,numMaps)
computeFFXresults(subsToExtract,fold,computeStzler,ffxResFold,outDir,numMaps)
% computeFFXresultsOld2008T(subsToExtract,fold,computeStzler,ffxResFold,outDir,numMaps)
end
