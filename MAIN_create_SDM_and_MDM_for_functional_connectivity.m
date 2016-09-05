function MAIN_create_SDM_and_MDM_for_functional_connectivity()
%% This function creats a custom SDM and MDM for functional connectivity analysis
%% Analysis uses VOI defined from first run, and computes SDM based on second run.
%% Finally it produces an MDM that can be run in BrainVoyager.
clc; clear all; close all;
[settings, params ] = get_settings_and_parms();
subDirs = findFilesBVQX(settings.rootdir,'3*',struct('dirs',1,'depth',1)) ;
%% create sdm's
skipthis = 1;
if ~skipthis
    for i = 1:length(subDirs) % loop on subjects
        [runDirs, settings.substr] = getRuns(subDirs{i});
        for j = 1:length(runDirs) % loop on runs
            start = tic;
            settings.rundir  = j;
            settings.savedir = runDirs{j};
            voi = load_voi(settings);  % load voi (reload same each run bcs clearing objects);
            prt     = load_prt(settings,runDirs{j});  % load prt
            vtc     = load_vtc(settings,runDirs{j});  % load vtc
            sdm_raw = load_raw_sdm(settings,runDirs{j});  % load raw sdm
            voitc   = load_voi_tc(settings,vtc,voi); % extract voitc
            sdm_fnc = make_sdm_fcc(settings,vtc,voi,voitc,prt,sdm_raw);  % make functional connectivity SDM
            save_sdm_fnc(sdm_fnc,settings); % save functional connectivity SDM
            % create PPI SDM
            % conames = prt.ConditionNames;
            % sdm_ppi =  sdm_raw.PPI(voitc, conames(2:7),settings.voinm);
            xff(0,'clearallobjects'); % clera objects after I am done.
            fprintf('sub %s run %d done in %f\n',...
                settings.substr,settings.rundir,toc(start));
        end
    end
    %% create single subject functional connectvitiy mdm's
    %% create multi subject functional connectivity mdm's
    vtcFiles = findFilesBVQX(settings.rootdir,settings.vtcsrcprefix);
    sdmFiles = findFilesBVQX(settings.rootdir,settings.sdmprefix);
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
    mdmfn = sprintf('%s_functional_connectivity_7_conds.mdm','all_subs');
    mdm.SaveAs(fullfile(settings.rootdir,settings.seclevdir,mdmfn));
end
%% compute glm
mdmfn = sprintf('%s_functional_connectivity_7_conds.mdm','all_subs');
mdm = BVQXfile(fullfile(settings.rootdir,settings.seclevdir,mdmfn));
mdm_trimed = trim_mdm(mdm,settings); 
compute_GLM(mdm_trimed,settings);

end

function [settings, params ] = get_settings_and_parms()
settings.rootdir       = fullfile('..','..','subjects_3000_study');
settings.vtcsrcprefix  = '*TAL_SD3DVSS6.00mm.vtc';
settings.prtprefix     = '*7conds_mar_2016*.prt';
settings.sdmrawprefix  = '*with_motion_7_conds.sdm';
settings.voi_use       = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';
settings.resultsdir    = fullfile('..','..','subjects_3000_study','results_multi_smoothed');
settings.voinm         = 'SPL-R';
settings.tr            = 2500;
settings.sdmprefix     = 'sub*functional_connectivity_with_motion.sdm';
settings.seclevdir     = 'results_multi_smoothed';
settings.subsuse       = [3000:3005, 3007:3011, 3013:3014 3016:3022];
settings.runuse        = [2:4];
% 'visaul_R'    'visual_L'    'premotor_L'
% 'premotor_R'    'SMA-bilateral'    'visual-R-posterior'
% 'visual-L-posterior'    'SPL-L'    'SPL-R'
params = [];
end

function voi = load_voi(settings)
fnmload = fullfile(settings.resultsdir,settings.voi_use);
voi = BVQXfile(fnmload);
end

function sdm_raw = load_raw_sdm(settings,rundir)
sdmfn = findFilesBVQX(rundir,settings.sdmrawprefix);
sdm_raw = BVQXfile(sdmfn{1});
end

function vtc = load_vtc(settings,rundir)
vtcfn = findFilesBVQX(rundir,settings.vtcsrcprefix);
vtc = BVQXfile(vtcfn{1});
end

function prt = load_prt(settings,rundir)
prtfn = findFilesBVQX(rundir,settings.prtprefix);
prt = BVQXfile(prtfn{1});
end

function [runDirs, substr] = getRuns(subdir)
runDirs = findFilesBVQX(fullfile(subdir,'functional'),'run*',struct('depth',1,'dirs',1));
[pn,substr] = fileparts(subdir);
end

function voitc = load_voi_tc(settings,vtc,voi)
voitc = [] ;
[voitc, voin] = vtc.VOITimeCourse(voi,...
    struct('weight',0,...
    'voisel',settings.voinm));
end

function sdm_fnc = make_sdm_fcc(settings,vtc,voi,voitc,prt,sdm_raw)
prtvol = prt.ConvertToVol(settings.tr);
sdm_fnc = sdm_raw;
sdm_raw_mat = sdm_fnc.SDMMatrix;
onsets_matrx = prtvol.OnOffsets;
for i = 3:size(prtvol.ConditionNames,1) % rel condition name starts at 3
    idxs = onsets_matrx(onsets_matrx(:,1)==i,2:3);
    rawidxs = [];
    for j = 1:size(idxs,1)
        rawidxs = [rawidxs, idxs(j,1):1:idxs(j,2)'];
    end
    tmp = zeros(size(sdm_raw_mat,1),1);
    tmp(:) = mean(voitc(rawidxs));
    tmp(rawidxs) = voitc(rawidxs);
    tmp = zscore(tmp);
    sdm_raw_mat(:,i-1) = tmp;
end
sdm_fnc.SDMMatrix = sdm_raw_mat;
end

function save_sdm_fnc(sdm_fnc,settings)
%sub3015_run3_sepbeta_with_motion
dirsave = settings.savedir;
fnmsv = sprintf('sub%s_run%d_functional_connectivity_with_motion.sdm',...
    settings.substr,settings.rundir);
flfnmnsv = fullfile(dirsave,fnmsv);
sdm_fnc.SaveAs(flfnmnsv);

end

function mdm_trimed = trim_mdm(mdm,settings)
xtcrtc = mdm.XTC_RTC;
cnt = 1; 
for i = 1:length(settings.subsuse)
    for j = 1:length(settings.runuse)
        srcstr = sprintf('%d_run%d_',...
            settings.subsuse(i),settings.runuse(j));
        idxuse = find(~cellfun(@isempty,strfind(xtcrtc(:,1),srcstr))==1);
        xtc_new{cnt,1} = xtcrtc{idxuse,1};
        xtc_new{cnt,2} = xtcrtc{idxuse,2};
        cnt = cnt +1; 
    end
end

mdm_trimed = xff('mdm'); % open an MDM for each subjects
mdm_trimed.XTC_RTC  = xtc_new; 
mdm_trimed.NrOfStudies = size(mdm_trimed.XTC_RTC,1);
mdm_trimed.SeparatePredictors = 2; % concatenate predictors across runs but not across subjects
mdm_trimed.zTransformation = 1;
mdm_trimed.PSCTransformation = 0;
mdm_trimed.RFX_GLM = 1; % perform FFX at first
mdmfn = 'some_subs_functional_connectivity_7_conds_RFX.mdm';
mdm_trimed.SaveAs(fullfile(settings.rootdir,settings.seclevdir,mdmfn));
end

function compute_GLM(mdm,settings)
glm = mdm.ComputeGLM();
glmfn =  'some_subs_functional_connectivity_7_conds_RFX.glm';
glm.SaveAs(fullfile(settings.rootdir,settings.seclevdir,glmfn))
end

