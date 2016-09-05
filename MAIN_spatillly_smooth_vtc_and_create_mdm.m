function MAIN_spatillly_smooth_vtc_and_create_mdm()
clc
clear all
addpath(genpath(pwd));
rootDir = fullfile('..','..','subjects_3000_study');
rootDir = GetFullPath(rootDir);
% 
% p = genpath('D:\Roee_Main_Folder\1_AnalysisFiles\Poldrack_RFX');
% addpath(p);

skipsmoothin = 1;
if skipsmoothin
    subDirs = findFilesBVQX(rootDir,'3*',struct('dirs',1,'depth',1)) ;
    bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1');
    for i = 1:length(subDirs) % loop on subjects % XXX only smooth subjects not done yet. 
        vtcFiles = findFilesBVQX(fullfile(subDirs{i},'*3DMC*TAL.vtc'));
        vmrFiles = findFilesBVQX(fullfile(subDirs{i},'*SAG_IIHC_TAL*.vmr'));
        sdmFiles = findFilesBVQX(fullfile(subDirs{i},'*_with_motion_7_conds.sdm'));
        for k = 1:length(vtcFiles)
            bvqx.ShowLogTab;
            bvqx.PrintToLog('Preprocessing VTC files from Matlab...');
            doc = bvqx.ActiveDocument;
            if (isempty(doc))
                vmr = bvqx.OpenDocument(vmrFiles{1});
            end
            vtc = vmr.FileNameOfCurrentVTC;
            if (isempty(vtc))
                vmr.LinkVTC(vtcFiles{k});
            end
            % now smooth VTC with a large kernel of 10 mm:
            vmr.SpatialGaussianSmoothing(6, 'mm' ); % FWHM value and unit (’mm’ or ’vx’)
            bvqx.PrintToLog(['Name of spatially smoothed VTC file:' vmr.FileNameOfCurrentVTC]);
            vmr.Close();
        end
    end
end

%% create MDM for smoothed data
secleveldir = 'results_multi_smoothed';
mkdir(fullfile(rootDir,secleveldir));
subDirs = findFilesBVQX(rootDir,'3*',struct('dirs',1,'depth',1)) ;
for i = 1:length(subDirs) % loop on subjects
    vtcFiles = findFilesBVQX(fullfile(subDirs{i},'*3DMC*TAL_SD3DVSS6.00mm.vtc'));
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
    mkdir(fullfile(subDirs{i},'functional','results_smoothed'));
    mdm.SaveAs(fullfile(subDirs{i},'functional','results_smoothed',mdmfn));
    % compte the glm for this mdm:
    %glm = mdm.ComputeGLM();
end

%% creat second level mdm 
vtcFiles = findFilesBVQX(rootDir,'*3DMC*TAL_SD3DVSS6.00mm.vtc');
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