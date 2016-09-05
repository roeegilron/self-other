function MAIN_create_MDM_and_multi_GLM_for_EachSubject()
rootDir = 'D:\Roee_Main_Folder\1_AnalysisFiles\MRI_Data_self_otherv3\MRI_data\SubjectsData\subjects_3000_study';
secleveldir = 'results_multi';
p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX');
addpath(p);
subDirs = findFilesBVQX(rootDir,'3*',struct('dirs',1,'depth',1)) ;
for i = 1:length(subDirs) % loop on subjects
    vtcFiles = findFilesBVQX(fullfile(subDirs{i},'*3DMC*TAL.vtc'));
    sdmFiles = findFilesBVQX(fullfile(subDirs{i},'*_with_motion_7_conds.sdm'));
    mdm = xff('mdm'); % open an MDM for each subjects
    for j = 1:length(vtcFiles)
        mdm.XTC_RTC{j,1} = vtcFiles{j};
        mdm.XTC_RTC{j,2} = sdmFiles{j};
    end
    mdm.NrOfStudies = size(mdm.XTC_RTC,1);
    mdm.SeparatePredictors = 2; % concatenate predictors across runs but not across subjects
    mdm.zTransformation = 1;
    mdm.PSCTransformation = 0;
    mdm.RFX_GLM = 0; % perform FFX at first
    [pn, subdir] = fileparts(subDirs{i});
    mdmfn = sprintf('%s_multi_7_conds.mdm',subdir);
    mdm.SaveAs(fullfile(subDirs{i},'functional','results',mdmfn));
    % compte the glm for this mdm:
    %glm = mdm.ComputeGLM();
end

%% creat second level mdm 
vtcFiles = findFilesBVQX(rootDir,'*3DMC*TAL.vtc');
sdmFiles = findFilesBVQX(rootDir,'*_with_motion_7_conds.sdm');
mdm = xff('mdm'); % open an MDM for each subjects
for j = 1:length(vtcFiles)
    mdm.XTC_RTC{j,1} = vtcFiles{j};
    mdm.XTC_RTC{j,2} = sdmFiles{j};
end
mdm.NrOfStudies = size(mdm.XTC_RTC,1);
mdm.SeparatePredictors = 2; % concatenate predictors across runs but not across subjects
mdm.zTransformation = 1;
mdm.PSCTransformation = 0;
mdm.RFX_GLM = 0; % perform FFX at first
mdmfn = sprintf('%s_multi_7_conds.mdm','all_subs');
mdm.SaveAs(fullfile(rootDir,secleveldir,mdmfn));
end

