function open_single_subject_glm_maps_via_com(settings,params)
rootDir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study';
secleveldir = 'results_multi';
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX');
addpath(p);

subDirs = findFilesBVQX(rootDir,'3*',struct('dirs',1,'depth',1)) ;
bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1');
for i = 1:length(subDirs) % loop on subjects
    vtcFiles = findFilesBVQX(fullfile(subDirs{i},'*3DMC*TAL.vtc'));
    vmrFiles = findFilesBVQX(fullfile(subDirs{i},'*SAG_IIHC_TAL.vmr'));
    sdmFiles = findFilesBVQX(fullfile(subDirs{i},'*_with_motion_7_conds.sdm'));
    stropn = 'results_smoothed'; % 'results'
    glmFiles = findFilesBVQX(fullfile(subDirs{i},'functional',stropn),...
        '*ITHR-100.glm');
    vmr = bvqx.OpenDocument(vmrFiles{1});
    vmr.LoadGLM(glmFiles{1});
end




end