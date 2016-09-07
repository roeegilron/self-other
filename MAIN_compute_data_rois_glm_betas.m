function MAIN_compute_data_rois_glm_betas()
close all; clear all; path(pathdef); clc; addpath(genpath(pwd));
% extractData()
% assembleDataSelfOther()
% assembleDataWords()
% computeMultiT()
compSVM()
end

function extractData()
%% data preperation
addpath(genpath(GetFullPath( fullfile('..','..','..','Poldrack_RFX_Project','toolboxes','neuroeflf','neuroElf_v10_5153'))));
multiDir = fullfile('..','..','MRI_Data_self_other','subjects_3000_study','results_multi_smoothed');
multiDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';
data_location = fullfile('..','...','..','MRI_Data_self_other','subjects_3000_study');
data_location = 'H:\MRI_Data_self_other\subjects_3000_study';
roi_data_fold = fullfile('..','data','roi_data','raw');
glm = BVQXfile('H:\MRI_Data_self_other\subjects_3000_study\3000\functional\run1\sub3000_run1_sepbeta_with_motion.glm');
glm_search_str = 'sub%s_run%d_sepbeta_with_motion.glm'; % sub, run
%% transform VOI to be 3x3x3 (e.g. TAL resolution and not iso voxel
voi = BVQXfile(fullfile(multiDir,voifn));
% access to NeuroElf functions
n = neuroelf;
% copy VOI (from object in variable voi)
voic = voi.CopyObject;
% iterate over VOI indices
for vc = 1:numel(voi.VOI)
    
    % assuming the GLM is in variable glm
    voi_indices = n.bvcoordconv(voi.VOI(vc).Voxels, 'tal2bvx', glm.BoundingBox);
    
    % removing NaNs first (out-of-bounding-box voxels)
    voi_indices(isnan(voi_indices)) = [];
    
    % using unique, store into copy
    voi_indices = unique(voi_indices);
    voic.VOI(vc).Voxels = n.bvcoordconv(voi_indices, 'bvx2tal', glm.BoundingBox);
    voic.VOI(vc).NrOfVoxels = numel(voi_indices);
end
%%
%% extract data
subfolders = findFilesBVQX(data_location,'3*',struct('dirs',1,'depth',1));
runs = 2:4;
for voin = 1:numel(voi.VOI)
    for i = 1:length(subfolders)
        for j = 1:length(runs)
            [pn,substr] = fileparts(subfolders{i});
            run_dir = sprintf('run%d',runs(j));
            glmfn = sprintf(glm_search_str,substr,runs(j));
            glm_full_path = fullfile(data_location,substr,'functional',run_dir,glmfn);
            if exist(glm_full_path, 'file') == 2
                glm = BVQXfile(glm_full_path);
                [vb, vbv, vbi] = glm.VOIBetas(voic,struct('vl',voin));
                roi_data = cell2mat(vbv); % voxels x predictors.
                explstr = 'roi_data is voxels x predictors';
                for k = 1:glm.NrOfPredictors
                    predict_names{k} = glm.Predictor(k).Name2;
                end
                fntosave = sprintf('sub-%s_run-%d_roi-%s.mat',substr,runs(j),voi.VOINames{voin});
                fnms_fp  = fullfile(roi_data_fold,fntosave);
                save(fnms_fp,'roi_data','predict_names','explstr','voifn','multiDir');
                glm.ClearObject;
            end
        end
    end
end
end

function assembleDataSelfOther()
addpath(genpath(GetFullPath( fullfile('..','..','..','Poldrack_RFX_Project','toolboxes','neuroeflf','neuroElf_v10_5153'))));
roi_data_fold = fullfile('..','data','roi_data','raw');
roi_data_save_fold = fullfile('..','data','roi_data','self-other-roi');
mkdir(fullfile('..','data','roi_data','self-other-roi'));
roifns = findFilesBVQX(roi_data_fold,'*.mat');
multiDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';
voi = BVQXfile(fullfile(multiDir,voifn));

voinames = voi.VOINames;
runs = 2:4;
subjects = 3000:3022;
for i = 1:numel(voinames)
    for s = 1:length(subjects)
        data = [];
        labels = [];
        fold = [];
        for r = 1:length(runs)
            fnload = sprintf('sub-%d_run-%d_roi-%s.mat',...
                subjects(s),runs(r),voinames{i});
            if exist(fullfile(roi_data_fold,fnload),'file')==2
                load(fullfile(roi_data_fold,fnload));
                self_log = ~cellfun(@isempty,strfind(predict_names','self'));
                othr_log = ~cellfun(@isempty,strfind(predict_names','other'));
                roi_data = roi_data'; % to make it trials x voxels;
                data = [data ; [roi_data(self_log,:) ; roi_data(othr_log,:)]];
                lables_add = [ones(sum(self_log),1); ones(sum(othr_log),1)*2];
                labels = [labels ; lables_add];
                fold = [fold; ones(sum(self_log)+sum(othr_log),1)*runs(r)];
            end
        end
        save_fn = sprintf('data_sub-%d_voi-%s.mat',subjects(s),voinames{i});
        save(fullfile(roi_data_save_fold,save_fn),'data','labels','fold');
    end
end

end

function assembleDataWords()
addpath(genpath(GetFullPath( fullfile('..','..','..','Poldrack_RFX_Project','toolboxes','neuroeflf','neuroElf_v10_5153'))));
roi_data_fold = fullfile('..','data','roi_data','raw');
roi_data_save_fold = fullfile('..','data','roi_data','aronit-rashamkol-roi');
mkdir(roi_data_save_fold); 
%mkdir(fullfile('..','data','roi_data','self-other-roi'));
roifns = findFilesBVQX(roi_data_fold,'*.mat');
multiDir = 'H:\MRI_Data_self_other\subjects_3000_study\results_multi_smoothed';
voifn = 'vois_all_self_other_vs_rest_multi_smoothed_defined_from_run1_OnlyPeakRegions.voi';
voi = BVQXfile(fullfile(multiDir,voifn));

voinames = voi.VOINames;
runs = 2:4;
subjects = 3000:3022;
for i = 1:numel(voinames)
    for s = 1:length(subjects)
        data = [];
        labels = [];
        fold = [];
        for r = 1:length(runs)
            fnload = sprintf('sub-%d_run-%d_roi-%s.mat',...
                subjects(s),runs(r),voinames{i});
            if exist(fullfile(roi_data_fold,fnload),'file')==2
                load(fullfile(roi_data_fold,fnload));
                self_log = ~cellfun(@isempty,strfind(predict_names','Traklin'));
                othr_log = ~cellfun(@isempty,strfind(predict_names','rashamkol'));
                roi_data = roi_data'; % to make it trials x voxels;
                data = [data ; [roi_data(self_log,:) ; roi_data(othr_log,:)]];
                lables_add = [ones(sum(self_log),1); ones(sum(othr_log),1)*2];
                labels = [labels ; lables_add];
                fold = [fold; ones(sum(self_log)+sum(othr_log),1)*runs(r)];
            end
        end
        save_fn = sprintf('data_sub-%d_voi-%s_aronit-rashamkol.mat',subjects(s),voinames{i});
        save(fullfile(roi_data_save_fold,save_fn),'data','labels','fold');
    end
end

end

function computeMultiT()
%% run Multi T on ROIs
% This code run a non-direcitional analysis on ROI's.
% First it runs multi-t on single subject results
% It then averages results across subjects using stelzer permutation
% (shuffling with replament) to compute reults on the second level.
% code should work as is on other computers (relative directory walking)
% and multi-platform (unix/pc/osx);

%% get settings / params
[settings, params] = getparams_multit();

%% run multi T single subject - Non Directional
subjects = 3000:3022;
skipthis = 0;
if ~skipthis
    for i = 1:length(subjects)% loop on subs
        sub_src_str = sprintf('data_sub-%d*.mat',subjects(i));
        roifnms = findFilesBVQX(settings.datalocation,sub_src_str);
        for j = 1:length(roifnms) % loop on rois
            data = loadData(roifnms{j});
            start = tic;
            compMultiT(data,settings,params);
            fprintf('sub %s in roi %s in %f secs\n',...
                data.subnm,data.roinm,toc(start));
        end
    end
end

%% plot multi-t results single subject
plotsinglesubresults(settings,params)

%% compute multi-t second level results
computesecondlevelresults(settings,params)

%% plot second level results
plot_group_results(settings,params)
end

function compSVM()
%% run SVM on ROIs
% This code run a non-direcitional SVM on ROI's.
% First it runs svm on single subject results
% It then averages results across subjects using stelzer permutation
% (shuffling with replament) to compute reults on the second level.
% code should work as is on other computers (relative directory walking)
% and multi-platform (unix/pc/osx);

%% get settings / params
[settings, params] = getparams_svm();

%% run multi SVM single subject - Non Directional
subjects = 3000:3022;
skipthis = 0;
if ~skipthis
    for i = 1:length(subjects)% loop on subs
        sub_src_str = sprintf('data_sub-%d*.mat',subjects(i));
        roifnms = findFilesBVQX(settings.datalocation,sub_src_str);
        for j = 1:length(roifnms) % loop on rois
            data = loadData(roifnms{j});
            start = tic;
            computeSVM(data,settings,params);
            fprintf('sub %s in roi %s in %f secs\n',...
                data.subnm,data.roinm,toc(start));
        end
    end
end

%% plot multi-t results single subject
plotsinglesubresults(settings,params)

%% compute multi-t second level results
computesecondlevelresults(settings,params)

%% plot second level results
plot_group_results(settings,params)
end