function create_WM_CSF_GM_masks()
% This function creats the WM,CSF and GM masks in the MNI space. 
rootDir = 'F:\vocalDataSet\processedData\matFilesProcessedData\vocalDataSetResults\DirectionalVsNondirectionalFFX\maskExperiment';
gmMskFn = 'Only_GM_mask.msk'; % just GM has 1 
allBbxBlack  = 'All_Black_Areas_In_Brain.msk'; % all areas that are blac0k have 1
allBrainIncAll = 'All_Brain_Mask.msk'; % all the brain (wm + gm has 1); 
% load some masks files 
mskGm = BVQXfile(fullfile(rootDir,gmMskFn));
mskAb = BVQXfile(fullfile(rootDir,allBbxBlack));
mskBm = BVQXfile(fullfile(rootDir,allBrainIncAll));

% generate wm mask: 

end