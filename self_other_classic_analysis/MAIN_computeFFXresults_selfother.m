function MAIN_computeFFXresults_selfother()
ffxResFold = 'D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX\matlabCode\';
suboutdir = 'results_words_FFX_ND_norm_50shuf_SL27';
ffxResFold = fullfile(ffxResFold,suboutdir); % for self _ other 
subsToExtract = 3000:3011; % for self other 
fold = 1; 
computeStzler = 1;
% for seld other 
outDir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study\results_self_other_sub_beta';
suboutdir = 'words';
outDir = fullfile(outDir,suboutdir);
numMaps = 5e3;
% computeFFXresults_self_other(subsToExtract,fold,computeStzler,ffxResFold,outDir,numMaps)
computeFFXresults_self_other(subsToExtract,fold,computeStzler,ffxResFold,outDir,numMaps)
end